function fish_right_prompt
    set -l last_status $status

    set -l pieces

    set -l lang (_simple_render_lang)
    test -n "$lang"; and set -a pieces $lang

    set -l cloud (_simple_render_cloud)
    test -n "$cloud"; and set -a pieces $cloud

    set -l dur (_simple_duration)
    test -n "$dur"; and set -a pieces $dur

    set -l ec (_simple_exit $last_status)
    test -n "$ec"; and set -a pieces $ec

    if test "$simple_show_time" = 1
        set -a pieces (set_color brblack)(command date $simple_time_format)(set_color normal)
    end

    echo -n (string join ' ' $pieces)
end
