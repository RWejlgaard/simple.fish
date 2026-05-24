function _simple_render_cloud
    test -n "$_simple_cached_cloud"; or return

    set -l out
    for line in $_simple_cached_cloud
        set -l kv (string split -m1 = -- $line)
        test (count $kv) -lt 2; and continue
        set -l val $kv[2]
        test -z "$val"; and continue
        set -a out (set_color brmagenta)$val(set_color normal)
    end
    echo -n (string join ' ' $out)
end
