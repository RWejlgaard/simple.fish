function _simple_async_dispatch --argument-names dir out_file
    set -l lock "$out_file.lock"
    # mkdir is atomic on POSIX filesystems — use as lock primitive to avoid TOCTOU.
    # Treat locks older than 30s as stale — worker likely died (kill -9, crash).
    if not command mkdir -- $lock 2>/dev/null
        set -l mtime (command stat -f %m -- $lock 2>/dev/null)
        test -z "$mtime"; and set mtime (command stat -c %Y -- $lock 2>/dev/null)
        if test -z "$mtime"
            return
        end
        test (math (command date +%s) - $mtime) -lt 30; and return
        command rm -rf -- $lock 2>/dev/null
        command mkdir -- $lock 2>/dev/null; or return
    end

    set -l ppid $fish_pid

    begin
        _simple_async_compute $dir $out_file
        command kill -USR1 $ppid 2>/dev/null
        command rm -rf -- $lock
    end >/dev/null 2>&1 &
    disown 2>/dev/null
end
