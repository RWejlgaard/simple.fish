function _simple_signal_name --argument-names n
    test -z "$n"; and return 1
    # Ask the system for the canonical name — signal numbers differ
    # between Linux and BSD/macOS (e.g. USR1 is 10 on Linux, 30 on macOS).
    set -l name (command kill -l $n 2>/dev/null | string trim)
    test -z "$name"; and return 1
    string replace -ri '^sig' '' -- $name
end
