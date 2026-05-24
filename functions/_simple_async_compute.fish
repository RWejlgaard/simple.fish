function _simple_async_compute --argument-names dir out_file
    # cd is scoped to the backgrounded `begin ... end &` in _simple_async_dispatch
    # (fish forks for that). Don't move this out of that context — it would
    # change the caller's PWD. Use `builtin cd` so a user `cd` function override
    # can't surprise us.
    builtin cd $dir 2>/dev/null; or return

    set -l tmp "$out_file.tmp.$fish_pid"
    begin
        _simple_compute_git
        _simple_compute_lang
        _simple_compute_cloud
    end > $tmp 2>/dev/null
    command mv -f $tmp $out_file 2>/dev/null
end
