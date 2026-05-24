function fish_prompt
    set -l last_status $status

    set -l key
    if test -n "$_simple_hash_cmd"
        set key (echo -n -- $PWD | command $_simple_hash_cmd 2>/dev/null | string sub -l 12)
    end
    test -z "$key"; and set key (string escape --style=url -- $PWD)
    set -g _simple_cache "$_simple_cache_dir/data.$fish_pid.$key"

    # Only dispatch async work when state could have changed
    if test "$_simple_dirty" = 1
        set -g _simple_dirty 0
        _simple_async_dispatch $PWD $_simple_cache
    end

    _simple_load_cache

    set -l pieces

    set -l ctx (_simple_context)
    test -n "$ctx"; and set -a pieces $ctx

    set -a pieces (_simple_pwd)

    set -l git (_simple_render_git)
    test -n "$git"; and set -a pieces $git

    set -l env (_simple_env)
    test -n "$env"; and set -a pieces $env

    echo -n (string join ' ' $pieces)' '(_simple_char $last_status)' '
end
