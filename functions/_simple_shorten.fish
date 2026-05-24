function _simple_shorten --argument-names parent name
    set -l len (string length -- $name)
    if test $len -le 1
        echo $name
        return
    end

    # ls -A reads dir entries in one syscall — faster than glob expansion for wide dirs
    set -l siblings (command ls -A -- $parent 2>/dev/null)

    # Hidden files: keep leading '.', try prefixes from .X upward
    set -l prefix_start 1
    if string match -q -- '.*' $name
        set prefix_start 2
    end

    for try_len in (seq $prefix_start (math $len - 1))
        set -l prefix (string sub -l $try_len -- $name)
        set -l matches 0
        for s in $siblings
            if string match -q -- "$prefix*" $s
                set matches (math $matches + 1)
                test $matches -gt 1; and break
            end
        end
        if test $matches -le 1
            echo $prefix
            return
        end
    end
    echo $name
end
