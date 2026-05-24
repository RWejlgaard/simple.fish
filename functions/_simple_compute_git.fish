function _simple_compute_git
    type -q git; or return
    # Bail early if not in a repo
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return

    set -l root (command git rev-parse --show-toplevel 2>/dev/null)
    test -n "$root"; and echo "GIT_ROOT=$root"

    set -l branch (command git symbolic-ref --short HEAD 2>/dev/null)
    if test -z "$branch"
        set branch (command git describe --tags --exact-match HEAD 2>/dev/null)
    end
    if test -z "$branch"
        set -l sha (command git rev-parse --short HEAD 2>/dev/null)
        test -n "$sha"; and set branch "$sha"
    end
    test -z "$branch"; and return

    set -l untracked 0; set -l modified 0; set -l deleted 0
    set -l staged 0; set -l conflicts 0

    for line in (command git status --porcelain=v1 2>/dev/null)
        set -l x (string sub -s 1 -l 1 -- $line)
        set -l y (string sub -s 2 -l 1 -- $line)
        if test "$x" = U; or test "$y" = U; or test "$x$y" = AA; or test "$x$y" = DD
            set conflicts (math $conflicts + 1)
            continue
        end
        if test "$x" = '?'
            set untracked (math $untracked + 1)
            continue
        end
        if test "$x" != ' '; and test -n "$x"
            set staged (math $staged + 1)
        end
        switch $y
            case M
                set modified (math $modified + 1)
            case D
                set deleted (math $deleted + 1)
        end
    end

    set -l stashed (command git rev-list --count refs/stash 2>/dev/null)
    test -z "$stashed"; and set stashed 0

    set -l ahead 0; set -l behind 0
    set -l upstream (command git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)
    if test -n "$upstream"
        set -l counts (command git rev-list --left-right --count 'HEAD...@{upstream}' 2>/dev/null)
        if test -n "$counts"
            set -l p (string split \t -- $counts)
            if test (count $p) -ge 2
                set ahead $p[1]
                set behind $p[2]
            end
        end
    else
        # No upstream — count commits not present on any remote (unpushed)
        set -l n (command git rev-list --count HEAD --not --remotes 2>/dev/null)
        test -n "$n"; and set ahead $n
    end

    printf "GIT=%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
        $branch $untracked $modified $deleted $staged $conflicts $stashed $ahead $behind
end
