
--
-- The faq applet for dotLRN
-- copyright 2001, OpenForce
-- distributed under GPL v2.0
--
--
-- ben,arjun@openforce.net
--
-- 10/05/2001
--


declare
	foo integer;
begin
	-- create the implementation
	foo := acs_sc_impl.new (
		'dotlrn_applet',
		'dotlrn_faq',
		'dotlrn_faq'
	);

	-- add all the hooks

	-- GetPrettyName
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'GetPrettyName',
	       'dotlrn_faq::get_pretty_name',
	       'TCL'
	);

	-- AddApplet
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'AddApplet',
	       'dotlrn_faq::add_applet',
	       'TCL'
	);

	-- RemoveApplet
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'RemoveApplet',
	       'dotlrn_faq::remove_applet',
	       'TCL'
	);

	-- AddUser
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'AddUser',
	       'dotlrn_faq::add_user',
	       'TCL'
	);

	-- RemoveUser
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'RemoveUser',
	       'dotlrn_faq::remove_user',
	       'TCL'
	);

	-- Add the binding
	foo := acs_sc_binding.new (
	    contract_name => 'dotlrn_applet'
	    impl_name => 'dotlrn_faq'
	);
end;
/
show errors
