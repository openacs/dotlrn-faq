#
#  Copyright (C) 2001, 2002 OpenForce, Inc.
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
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
        dotlrn_applet::add_applet_to_dotlrn -applet_key [applet_key]
    }

    ad_proc -public remove_applet {
        community_id
        package_id
    } {
        remove the applet
    } {
    }

    ad_proc -public add_applet_to_community {
        community_id
    } {
        Add the faq applet to a specifc community
    } {
        set portal_id [dotlrn_community::get_portal_id -community_id $community_id]

        # set up the DS for the portal template
        if {[dotlrn_community::dummy_comm_p -community_id $community_id]} {
            faq_portlet::add_self_to_page $portal_id 0
            return
        }

        # create the faq package instance (all in one, I've mounted it)
        set package_id [dotlrn::instantiate_and_mount $community_id [package_key]]

        faq_portlet::add_self_to_page $portal_id $package_id

        # set up the DS for the admin page
        set admin_portal_id [dotlrn_community::get_admin_portal_id -community_id $community_id]
        faq_admin_portlet::add_self_to_page $admin_portal_id $package_id

        # return the package_id
        return $package_id
    }

    ad_proc -public remove_applet_from_community {
        comminuty_id
    } {
        Drops the faq applet from the given community
    } {
        # remove the faq admin portlet from the comm's admin page
        set admin_portal_id \
                [dotlrn_community::get_admin_portal_id -community_id $community_id]
        set admin_element_id [portal::get_element_ids_by_ds \
                $admin_portal_id \
                [faq_admin_portlet::get_my_name]
        ] 

        portal::remove_element $admin_element_id 

        # remove the faq portlet from the comm's portal
        set portal_id \
                [dotlrn_community::get_portal_id -community_id $community_id]

        portal::remove_element [portal::get_element_ids_by_ds \
                $portal_id \
                [faq_portlet::get_my_name]
        ]


    }

    ad_proc -public add_user {
        user_id
    } {
        For one time user-specfic init
    } {
    }

    ad_proc -public remove_user {
        user_id
    } {
    } {
    }

    ad_proc -public add_user_to_community {
        community_id
        user_id
    } {
        Called when a user is added to a specific dotlrn community
    } {
        set package_id [dotlrn_community::get_applet_package_id $community_id [applet_key]]
        set portal_id [dotlrn::get_workspace_portal_id $user_id]

        faq_portlet::add_self_to_page $portal_id $package_id
    }

    ad_proc -public remove_user_from_community {
        community_id
        user_id
    } {
        Remove a user from a community
    } {
        set package_id [dotlrn_community::get_applet_package_id $community_id [applet_key]]
        set portal_id [dotlrn::get_workspace_portal_id $user_id]

        faq_portlet::remove_self_from_page $portal_id $package_id
    }

    ad_proc -public add_portlet {
        args
    } {
        A helper proc to add the underlying portlet to the given portal. 
        
        @param args a list-ified array of args defined in add_applet_to_community
    } {
        ns_log notice "** Error in [get_pretty_name]: 'add_portlet' not implemented!"
        ad_return_complaint 1  "Please notifiy the administrator of this error:
        ** Error in [get_pretty_name]: 'add_portlet' not implemented!"
    }

    ad_proc -public remove_portlet {
        args
    } {
        A helper proc to remove the underlying portlet from the given portal. 
        
        @param args a list-ified array of args defined in remove_applet_from_community
    } {
        ns_log notice "** Error in [get_pretty_name]: 'remove_portlet' not implemented!"
        ad_return_complaint 1  "Please notifiy the administrator of this error:
        ** Error in [get_pretty_name]: 'remove_portlet' not implemented!"
    }

    ad_proc -public clone {
        old_community_id
        new_community_id
    } {
        Clone this applet's content from the old community to the new one
    } {
        ns_log notice "** Error in [get_pretty_name] 'clone' not implemented!"
        ad_return_complaint 1  "Please notifiy the administrator of this error:
        ** Error in [get_pretty_name]: 'clone' not implemented!"
    }

}
