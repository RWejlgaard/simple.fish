function _simple_duration
    test -z "$CMD_DURATION"; and return
    test "$CMD_DURATION" -lt "$simple_duration_threshold" 2>/dev/null; and return

    set -l ms $CMD_DURATION
    set -l s (math --scale=0 "$ms / 1000")
    set -l out
    if test $s -ge 3600
        set out (math --scale=0 "$s / 3600")"h"(math --scale=0 "($s % 3600) / 60")"m"
    else if test $s -ge 60
        set out (math --scale=0 "$s / 60")"m"(math --scale=0 "$s % 60")"s"
    else
        set out "$s"s
    end
    echo -n (set_color yellow)$out(set_color normal)
end
