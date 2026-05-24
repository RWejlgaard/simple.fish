function _simple_pwd
    set -l git_root $_simple_cached_git_root
    set -l key "$PWD|$git_root"
    if test "$_simple_pwd_cache_key" = "$key"
        echo -n -- $_simple_pwd_cache
        return
    end

    set -l p $PWD
    set -l home_replaced 0
    if test -n "$HOME"; and test "$p" = "$HOME"
        set p ''
        set home_replaced 1
    else if test -n "$HOME"; and string match -q -- "$HOME/*" $p
        set p (string replace -- "$HOME/" '' $p)
        set home_replaced 1
    end

    set -l segs
    for s in (string split / -- $p)
        test -n "$s"; and set -a segs $s
    end
    set -l n (count $segs)

    set -l out ""
    set -l acc ""
    if test $home_replaced -eq 1
        set acc $HOME
        set out (set_color --bold)'~'(set_color normal)
    end

    if test $n -eq 0
        if test $home_replaced -eq 0
            set out '/'
        end
    else
        for i in (seq $n)
            set -l seg $segs[$i]
            set -l parent
            if test -z "$acc"
                set parent /
            else
                set parent $acc
            end

            set -l full
            if test -z "$acc"
                set full "/$seg"
            else
                set full "$acc/$seg"
            end

            set -l preserve 0
            test $i -eq $n; and set preserve 1
            test -n "$git_root"; and test "$full" = "$git_root"; and set preserve 1

            set -l display $seg
            test $preserve -eq 0; and set display (_simple_shorten $parent $seg)

            set out "$out/"
            if test $preserve -eq 1
                set out "$out"(set_color --bold)$display(set_color normal)
            else
                set out "$out$display"
            end
            set acc $full
        end
    end

    set -g _simple_pwd_cache $out
    set -g _simple_pwd_cache_key $key
    echo -n -- $out
end
