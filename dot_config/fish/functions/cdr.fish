function cdr --description "cd to the root of the current git repository"
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$root"
        echo "cdr: not inside a git repository" >&2
        return 1
    end
    cd $root
end
