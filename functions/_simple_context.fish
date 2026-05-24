function _simple_context
    set -l ssh 0
    if set -q SSH_CONNECTION; or set -q SSH_CLIENT; or set -q SSH_TTY
        set ssh 1
    end

    if test "$simple_show_context" = never
        return
    end
    if test "$simple_show_context" = auto
        if test $ssh -eq 0; and not fish_is_root_user
            return
        end
    end

    set -l user $USER
    test -z "$user"; and set user (command id -un 2>/dev/null)
    set -l host (prompt_hostname)

    set -l out (set_color brblack)
    if fish_is_root_user
        set out "$out"(set_color red)"$user"(set_color brblack)
    else
        set out "$out$user"
    end
    set out "$out@$host"(set_color normal)
    echo -n $out
end
