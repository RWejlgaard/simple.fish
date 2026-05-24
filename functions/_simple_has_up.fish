function _simple_has_up --argument-names file
    set -l d $PWD
    while test -n "$d"; and test "$d" != "/"
        test -e "$d/$file"; and return 0
        # Don't walk above $HOME for paths inside it — no project files live there
        if test -n "$HOME"; and test "$d" = "$HOME"
            return 1
        end
        set d (path dirname -- $d)
    end
    test -e "/$file"
end
