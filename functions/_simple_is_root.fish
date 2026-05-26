function _simple_is_root
    if test "$simple_force_user" = 1
        return 1
    end
    fish_is_root_user
end
