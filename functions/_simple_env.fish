function _simple_env
    set -l out

    set -q IN_NIX_SHELL;          and set -a out (set_color blue)nix(set_color normal)
    set -q DIRENV_DIR;            and set -a out (set_color yellow)env(set_color normal)
    set -q DISTROBOX_ENTER_PATH;  and set -a out (set_color magenta)box(set_color normal)
    set -q TOOLBOX_PATH;          and set -a out (set_color magenta)tbx(set_color normal)
    set -q CONTAINER_ID;          and set -a out (set_color magenta)ctr(set_color normal)

    if set -q fish_private_mode; and test "$fish_private_mode" = 1
        set -a out (set_color red)priv(set_color normal)
    end

    set -l _simple_shlvl_base (set -q TMUX; and echo 2; or echo 1)
    if test "$simple_show_shlvl" = 1; and set -q SHLVL; and test "$SHLVL" -gt $_simple_shlvl_base 2>/dev/null
        set -a out (set_color brblack)"lvl:$SHLVL"(set_color normal)
    end

    if test "$simple_show_jobs" = 1; and jobs -q
        set -l c (jobs -p | count)
        set -a out (set_color cyan)"jobs:$c"(set_color normal)
    end

    echo -n (string join ' ' $out)
end
