function _simple_render_lang
    test -n "$_simple_cached_lang"; or return

    set -l out
    for line in $_simple_cached_lang
        set -l kv (string split -m1 = -- $line)
        test (count $kv) -lt 2; and continue
        set -l key (string lower (string replace 'LANG_' '' $kv[1]))
        set -l val $kv[2]
        test -z "$val"; and continue
        set -a out (set_color brcyan)$key(set_color normal)" $val"
    end
    echo -n (string join ' ' $out)
end
