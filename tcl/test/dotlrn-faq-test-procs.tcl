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

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
