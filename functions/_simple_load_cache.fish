function _simple_load_cache
    set -e _simple_cached_git
    set -e _simple_cached_git_root
    set -e _simple_cached_lang
    set -e _simple_cached_cloud

    test -f "$_simple_cache"; or return

    while read -l line
        switch $line
            case 'GIT_ROOT=*'
                set -g _simple_cached_git_root (string sub -s 10 -- $line)
            case 'GIT=*'
                set -g _simple_cached_git (string sub -s 5 -- $line)
            case 'LANG_*'
                set -ga _simple_cached_lang $line
            case 'CLOUD_*'
                set -ga _simple_cached_cloud $line
        end
    end < $_simple_cache
end
