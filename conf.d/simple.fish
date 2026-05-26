# simple.fish — minimal async prompt for fish

# Cache dir
if set -q XDG_RUNTIME_DIR
    set -g _simple_cache_dir $XDG_RUNTIME_DIR/simple.fish
else
    set -g _simple_cache_dir /tmp/simple.fish-$USER
end
command mkdir -p $_simple_cache_dir 2>/dev/null

# Hash command for per-PWD cache keys — pick whatever's around.
# If none, fish_prompt falls back to string escape (always works, longer keys).
set -g _simple_hash_cmd ''
command -q shasum; and set -g _simple_hash_cmd shasum
test -z "$_simple_hash_cmd"; and command -q sha1sum; and set -g _simple_hash_cmd sha1sum
test -z "$_simple_hash_cmd"; and command -q md5sum; and set -g _simple_hash_cmd md5sum

# User-overridable settings
set -q simple_duration_threshold; or set -g simple_duration_threshold 3000
set -q simple_show_time;          or set -g simple_show_time 1
set -q simple_time_format;        or set -g simple_time_format "+%H:%M:%S"
set -q simple_show_jobs;          or set -g simple_show_jobs 1
set -q simple_show_shlvl;         or set -g simple_show_shlvl 1
set -q simple_show_context;       or set -g simple_show_context auto
set -q simple_force_user;         or set -g simple_force_user 0

# Symbols — plain ASCII; override if you want flair
set -q simple_char_prompt;        or set -g simple_char_prompt '>'
set -q simple_char_root;          or set -g simple_char_root '#'
set -q simple_char_ahead;         or set -g simple_char_ahead '^'
set -q simple_char_behind;        or set -g simple_char_behind 'v'
set -q simple_char_staged;        or set -g simple_char_staged '+'
set -q simple_char_modified;      or set -g simple_char_modified '*'
set -q simple_char_untracked;     or set -g simple_char_untracked '?'
set -q simple_char_deleted;       or set -g simple_char_deleted '-'
set -q simple_char_stashed;       or set -g simple_char_stashed '$'
set -q simple_char_conflicts;     or set -g simple_char_conflicts '!'

# Dirty flag — set on cd or after a command, cleared after prompt dispatches
set -g _simple_dirty 1

function _simple_dirty_pwd --on-variable PWD
    set -g _simple_dirty 1
end

function _simple_dirty_exec --on-event fish_postexec
    set -g _simple_dirty 1
end

# Wipe stale cache on shell exit
function _simple_cleanup --on-event fish_exit
    command find $_simple_cache_dir -maxdepth 1 -name "*.$fish_pid.*" -delete 2>/dev/null
end

# Async repaint trigger
function _simple_repaint --on-signal SIGUSR1
    commandline -f repaint 2>/dev/null
end
