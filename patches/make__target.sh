__choice_target() {
    if [[ -f Makefile ]]; then
        cat Makefile | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'
    fi
}