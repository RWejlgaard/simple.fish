#!/usr/bin/env fish
# Minimal test runner for simple.fish's pure/side-effect-contained helpers.
# Run from repo root: fish tests/run.fish

set -g _t_failed 0

function _t_eq --argument-names desc expected actual
    if test "$expected" = "$actual"
        echo "ok - $desc"
    else
        echo "not ok - $desc"
        echo "    expected: $expected"
        echo "    actual:   $actual"
        set -g _t_failed (math $_t_failed + 1)
    end
end

set -l repo_root (path dirname (path dirname (status filename)))
for f in $repo_root/functions/*.fish
    source $f
end

# --- _simple_shorten ---------------------------------------------------
begin
    set -l tmp (mktemp -d)
    touch $tmp/alpha $tmp/abba $tmp/beta
    _t_eq "shorten: unique prefix among siblings" al (_simple_shorten $tmp alpha)
    _t_eq "shorten: single-char prefix already unique" b (_simple_shorten $tmp beta)
    _t_eq "shorten: 1-char name returned as-is" x (_simple_shorten $tmp x)
    command rm -rf $tmp
end

# --- _simple_has_up ------------------------------------------------------
begin
    set -l orig $PWD
    set -l tmp (mktemp -d)
    command mkdir -p $tmp/a/b/c
    touch $tmp/a/marker.txt
    cd $tmp/a/b/c
    _simple_has_up marker.txt
    _t_eq "has_up: finds marker in an ancestor dir" 0 $status
    _simple_has_up nope.txt
    _t_eq "has_up: reports missing marker" 1 $status
    cd $orig
    command rm -rf $tmp
end

# --- _simple_signal_name -------------------------------------------------
_t_eq "signal_name: 2 is INT" INT (_simple_signal_name 2)
_t_eq "signal_name: 9 is KILL" KILL (_simple_signal_name 9)

# --- _simple_compute_git --------------------------------------------------
begin
    set -l orig $PWD
    set -l tmp (mktemp -d)
    cd $tmp
    command git init -q -b main
    command git config user.email test@test.com
    command git config user.name test
    echo hi > a.txt
    command git add a.txt
    command git commit -qm init
    echo more >> a.txt
    echo new > untracked.txt
    echo x > staged.txt
    command git add staged.txt

    set -l out (_simple_compute_git)
    set -l git_line
    for line in $out
        string match -q 'GIT=*' -- $line; and set git_line $line
    end
    set -l fields (string split \t -- (string sub -s 5 -- $git_line))
    # branch untracked modified deleted staged conflicts stashed ahead behind
    _t_eq "compute_git: branch" main $fields[1]
    _t_eq "compute_git: untracked count" 1 $fields[2]
    _t_eq "compute_git: modified count" 1 $fields[3]
    _t_eq "compute_git: deleted count" 0 $fields[4]
    _t_eq "compute_git: staged count" 1 $fields[5]
    _t_eq "compute_git: conflicts count" 0 $fields[6]
    _t_eq "compute_git: stashed count" 0 $fields[7]
    _t_eq "compute_git: ahead count (no remote)" 1 $fields[8]
    _t_eq "compute_git: behind count" 0 $fields[9]

    cd $orig
    command rm -rf $tmp
end

if test $_t_failed -gt 0
    echo
    echo "$_t_failed test(s) failed"
    exit 1
end
echo
echo "all tests passed"
