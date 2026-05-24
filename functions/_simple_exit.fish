function _simple_exit --argument-names s
    test "$s" -eq 0 2>/dev/null; and return
    test -z "$s"; and return

    set -l label "$s"
    if test $s -gt 128
        set -l sig (math "$s - 128")
        set -l name (_simple_signal_name $sig)
        test -n "$name"; and set label "SIG$name"
    end
    echo -n (set_color red)$label(set_color normal)
end
