function _simple_compute_lang
    # Node
    if _simple_has_up package.json
        if type -q node
            set -l v (command node -v 2>/dev/null | string trim | string replace -r '^v' '')
            test -n "$v"; and echo "LANG_NODE=$v"
        end
    end

    # Python
    if _simple_has_up pyproject.toml; or _simple_has_up requirements.txt; or _simple_has_up Pipfile; or _simple_has_up .python-version; or _simple_has_up setup.py; or set -q VIRTUAL_ENV
        set -l py
        type -q python3; and set py python3
        test -z "$py"; and type -q python; and set py python
        if test -n "$py"
            set -l v (command $py --version 2>&1 | string split ' ')[2]
            test -n "$v"; and echo "LANG_PYTHON=$v"
        end
    end

    # Ruby
    if _simple_has_up Gemfile; or _simple_has_up .ruby-version
        if type -q ruby
            set -l v (command ruby -v 2>/dev/null | string split ' ')[2]
            test -n "$v"; and echo "LANG_RUBY=$v"
        end
    end

    # Go
    if _simple_has_up go.mod
        if type -q go
            set -l line (command go version 2>/dev/null)
            set -l v (string match -r 'go(\S+)' -- $line)[2]
            test -n "$v"; and echo "LANG_GO=$v"
        end
    end

    # Rust
    if _simple_has_up Cargo.toml
        if type -q rustc
            set -l v (command rustc --version 2>/dev/null | string split ' ')[2]
            test -n "$v"; and echo "LANG_RUST=$v"
        end
    end

    # Java
    if _simple_has_up pom.xml; or _simple_has_up build.gradle; or _simple_has_up build.gradle.kts
        if type -q java
            set -l v (command java -version 2>&1 | command head -n1 | string match -r '"([^"]+)"')[2]
            test -n "$v"; and echo "LANG_JAVA=$v"
        end
    end

    # PHP
    if _simple_has_up composer.json
        if type -q php
            set -l v (command php -v 2>/dev/null | command head -n1 | string split ' ')[2]
            test -n "$v"; and echo "LANG_PHP=$v"
        end
    end
end
