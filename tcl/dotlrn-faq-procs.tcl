

#
# Procs for DOTLRN Faq Applet
# Copyright 2001 OpenForce, inc.
# Distributed under the GNU GPL v2
#
# October 5th, 2001
#

ad_library {
    
    Procs to set up the dotLRN Faq applet
    
    @author ben@openforce.net,arjun@openforce.net
    @creation-date 2001-10-05
    
}

namespace eval dotlrn_faq {
    
    ad_proc -public get_pretty_name {
    } {
	get the pretty name
    } {
	return "dotLRN Frequently Asked Questions"
    }

    ad_proc -public applet_key {} {
        return "dotlrn_faq"
    }

    ad_proc -public package_key {
    } {
	get the package_key this applet deals with
    } {
	return "faq"
    }

    ad_proc portal_element_key {
    } {
	return the portal element key
    } {
	return "faq-portlet"
    }

    ad_proc -public add_applet {
    } {
	Add the faq applet to dotlrn - one time init - must be repeatable!
    } {
        dotlrn_community::add_applet_to_dotlrn -applet_key [applet_key]
    }

    ad_proc -public add_applet_to_community {
	community_id
    } {
	Add the faq applet to a specifc community
    } {
	# create the calendar package instance (all in one, I've mounted it)
	set package_key [package_key]
	set package_id [dotlrn::instantiate_and_mount $community_id $package_key]

	# portal template stuff
	# get the portal_template_id by callback
	set pt_id [dotlrn_community::get_portal_template_id $community_id]

	# set up the DS for the portal template
	faq_portlet::make_self_available $pt_id
	faq_portlet::add_self_to_page $pt_id $package_id

	# set up the DS for the admin page
        set admin_portal_id [dotlrn_community::get_community_admin_portal_id $community_id]
	faq_admin_portlet::make_self_available $admin_portal_id
	faq_admin_portlet::add_self_to_page $admin_portal_id $package_id

	# Set up some permissions
	# for FAQ, it's all good as is

	# return the package_id
	return $package_id
    }

    ad_proc -public remove_applet {
	community_id
	package_id
    } {
	remove the applet from the community
    } {
	# Remove all instances of the faq portlet! (this is some serious stuff!)

	# Dropping all messages, forums

	# Killing the package
    
    }

    ad_proc -public add_user {
	user_id
    } {
	For one time user-specfic init 
    } {
	return 
    }

    ad_proc -public add_user_to_community {
	community_id
	user_id
    } {
	Called when a user is added to a specific dotlrn community
    } {
	# Get the portal_id by callback
	set portal_id [dotlrn_community::get_portal_id $community_id $user_id]
	
	# Get the faq applet's package_id by callback
	set package_id [dotlrn_community::get_applet_package_id $community_id dotlrn_faq]

	# Allow user to see the faq forums
	# nothing for now

	# Make faq DS available to this page
	faq_portlet::make_self_available $portal_id

	# Call the portal element to be added correctly
	faq_portlet::add_self_to_page $portal_id $package_id

	# Now for the user workspace
	set workspace_portal_id [dotlrn::get_workspace_portal_id $user_id]

	# Add the portlet here
	if { $workspace_portal_id != "" } {
            faq_portlet::add_self_to_page $workspace_portal_id $package_id
        }
    }

    ad_proc -public remove_user {
	community_id
	user_id
    } {
	Remove a user from a community
    } {
	# Get the portal_id
	set portal_id [dotlrn_community::get_portal_id $community_id $user_id]
	
	# Get the package_id by callback
	set package_id [dotlrn_community::get_applet_package_id $community_id [applet_key]]

	# Remove the portal element
	faq_portlet::remove_self_from_page $portal_id $package_id

	# Buh Bye.
	faq_portlet::make_self_unavailable $portal_id
        
        # Remove from main workspace
        set workspace_portal_id [dotlrn::get_workspace_portal_id $user_id]

        # Remove the portlet
        if {![empty_string_p $workspace_portal_id]} {
            faq_portlet::remove_self_from_page $workspace_portal_id $package_id
        }
    }
	
}
