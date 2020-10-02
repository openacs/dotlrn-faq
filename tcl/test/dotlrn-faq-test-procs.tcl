ad_library {

        Automated tests for the dotlrn-faq package.

        @author Héctor Romojaro <hector.romojaro@gmail.com>
        @creation-date 2019-09-10

}

aa_register_case \
    -cats {api smoke production_safe} \
    -procs {
        dotlrn_faq::package_key
        dotlrn_faq::my_package_key
        dotlrn_faq::applet_key
    } \
    dotlrn_faq__keys {

        Simple test for the various dotlrn_faq::..._key procs.

        @author Héctor Romojaro <hector.romojaro@gmail.com>
        @creation-date 2019-09-10
} {
    aa_equals "Package key" "[dotlrn_faq::package_key]" "faq"
    aa_equals "My Package key" "[dotlrn_faq::my_package_key]" "dotlrn-faq"
    aa_equals "Applet key" "[dotlrn_faq::applet_key]" "dotlrn_faq"
}

aa_register_case -procs {
        dotlrn_faq::get_pretty_name
    } -cats {
        api
        production_safe
    } dotlrn_faq_pretty_name {
        Test get_pretty_name.
} {
    aa_equals "dotlrn-faq pretty name" "[dotlrn_faq::get_pretty_name]" "#faq.pretty_name#"
}

aa_register_case -procs {
        dotlrn_faq::add_applet
        dotlrn_faq::add_portlet
        dotlrn_faq::add_portlet_helper
        dotlrn_faq::remove_portlet
        dotlrn_faq::remove_applet
    } -cats {
        api
    } dotlrn_faq__applet_portlet {
        Test add/remove applet/portlet procs.
} {
    #
    # Helper proc to check portal elements
    #
    proc portal_elements {portal_id} {
        return [db_string elements {
            select count(1)
            from portal_element_map pem,
                 portal_pages pp
           where pp.portal_id = :portal_id
             and pp.page_id = pem.page_id
        }]
    }
    #
    # Start the tests
    #
    aa_run_with_teardown -rollback -test_code {
        #
        # Create test user
        #
        # As this is running in a transaction, it should be cleaned up
        # automatically.
        #
        set portal_user_id [db_nextval acs_object_id_seq]
        set user_info [acs::test::user::create -user_id $portal_user_id]
        #
        # Create portal
        #
        set portal_id [portal::create $portal_user_id]
        set portal_exists_p [db_0or1row foo {
            select * from portals where portal_id=:portal_id
        }]
        if {$portal_exists_p} {
            aa_log "Portal created (portal_id: $portal_id)"
            set applet_key [dotlrn_faq::applet_key]
            if {[dotlrn_applet::get_applet_id_from_key -applet_key $applet_key] ne ""} {
                #
                # Remove the applet in advance, if it already exists
                #
                dotlrn_faq::remove_applet
                aa_log "Removed existing applet"
            }
            #
            # Add applet
            #
            dotlrn_faq::add_applet
            aa_true "Add applet" "[expr {[dotlrn_applet::get_applet_id_from_key -applet_key $applet_key] ne ""}]"
            #
            # Add portlet to portal
            #
            dotlrn_faq::add_portlet $portal_id
            aa_equals "Number of portal elements after addition" "[portal_elements $portal_id]" "1"
            #
            # Remove portlet from portal
            #
            set args [ns_set create]
            ns_set put $args package_id 0
            dotlrn_faq::remove_portlet $portal_id $args
            aa_equals "Number of portal elements after removal" "[portal_elements $portal_id]" "0"
            #
            # Add portlet to portal using directly the helper
            #
            dotlrn_faq::add_portlet_helper $portal_id $args
            aa_equals "Number of portal elements after addition" "[portal_elements $portal_id]" "1"
            #
            # Remove applet
            #
            dotlrn_faq::remove_applet
            aa_equals "Remove applet" "[dotlrn_applet::get_applet_id_from_key -applet_key $applet_key]" ""
        } else {
            aa_error "Portal creation failed"
        }
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
