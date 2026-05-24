function _simple_render_git
    test -n "$_simple_cached_git"; or return

    set -l p (string split \t -- $_simple_cached_git)
    test (count $p) -lt 9; and return

    set -l branch    $p[1]
    set -l untracked $p[2]
    set -l modified  $p[3]
    set -l deleted   $p[4]
    set -l staged    $p[5]
    set -l conflicts $p[6]
    set -l stashed   $p[7]
    set -l ahead     $p[8]
    set -l behind    $p[9]

    set -l dirty 0
    for n in $untracked $modified $deleted $staged
        if test "$n" -gt 0 2>/dev/null
            set dirty 1
            break
        end
    end

    set -l col (set_color green)
    test $dirty -eq 1; and set col (set_color yellow)
    test "$conflicts" -gt 0 2>/dev/null; and set col (set_color red)

    set -l out "$col$branch"(set_color normal)

    test "$ahead"  -gt 0 2>/dev/null; and set out "$out"(set_color cyan)" $simple_char_ahead$ahead"(set_color normal)
    test "$behind" -gt 0 2>/dev/null; and set out "$out"(set_color cyan)" $simple_char_behind$behind"(set_color normal)

    test "$staged"    -gt 0 2>/dev/null; and set out "$out"(set_color green)" $simple_char_staged$staged"(set_color normal)
    test "$modified"  -gt 0 2>/dev/null; and set out "$out"(set_color yellow)" $simple_char_modified$modified"(set_color normal)
    test "$deleted"   -gt 0 2>/dev/null; and set out "$out"(set_color red)" $simple_char_deleted$deleted"(set_color normal)
    test "$untracked" -gt 0 2>/dev/null; and set out "$out"(set_color blue)" $simple_char_untracked$untracked"(set_color normal)
    test "$conflicts" -gt 0 2>/dev/null; and set out "$out"(set_color red)" $simple_char_conflicts$conflicts"(set_color normal)
    test "$stashed"   -gt 0 2>/dev/null; and set out "$out"(set_color brmagenta)" $simple_char_stashed$stashed"(set_color normal)

    echo -n $out
end
