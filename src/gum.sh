_patch_help() { 
    $@ --help | \
    sed \
        -e 's/">\s\?"/<value>/' \
        -e '/^\s*-/ s/="\([^"]\+\)"/=<\1>/' \
        -e '/^\s*-/ s/=""/=<value>/' \

}
