

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
	return "Frequently Asked Questions"
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
	community_id
    } {
	Add the faq applet
    } {
	# Callback to get node_id from community
	# REVISIT this (ben)
	set node_id [site_node_id [ad_conn url]]

	# create the faq package instance (all in one, I've mounted it)
	set package_key [package_key]
	set package_id [site_node_mount_application -return package_id $node_id $package_key $package_key $package_key]

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
	community_id
	user_id
    } {
	Add a user to a community
    } {
	# Get the page_id by callback
	set page_id [dotlrn_community::get_page_id $community_id $user_id]
	
	# Get the faq applet's package_id by callback
	set package_id [dotlrn_community::get_applet_package_id $community_id dotlrn_faq]

	# Allow user to see the faq forums
	# nothing for now

	# Call the portal element to be added correctly
	faq_portlet::add_self_to_page $page_id $package_id
    }

    ad_proc -public remove_user {
	community_id
	user_id
    } {
	Remove a user from a community
    } {
	# Get the page_id
	set page_id [dotlrn_community::get_page_id $community_id $user_id]
	
	# Get the package_id by callback
	set package_id [dotlrn_community::get_package_id $community_id]

	# Remove the portal element
	faq_portlet::remove_self_from_page $page_id $package_id

	# remove user permissions to see faqs
	# nothing to do here
    }
	
}
