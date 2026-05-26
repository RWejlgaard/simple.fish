function _simple_char --argument-names last_status
    if _simple_is_root
        echo -n (set_color red)$simple_char_root(set_color normal)
        return
    end
    if test "$last_status" -ne 0 2>/dev/null
        echo -n (set_color red)$simple_char_prompt(set_color normal)
    else
        echo -n (set_color green)$simple_char_prompt(set_color normal)
    end
end
