function up --description "Go up N directories, or to the nearest ancestor with a given name"
    set -l arg $argv[1]

    # Bare `up` -> one level.
    if test -z "$arg"
        cd ..
        return
    end

    # Numeric -> that many levels.
    if string match -qr '^[0-9]+$' -- $arg
        if test $arg -lt 1
            echo "up: count must be 1 or greater" >&2
            return 1
        end
        set -l target
        for i in (seq $arg)
            set target "$target../"
        end
        cd $target
        return
    end

    # Name -> nearest ancestor directory with that name.
    set -l dir (dirname $PWD)
    while test "$dir" != /
        if test (basename $dir) = "$arg"
            cd $dir
            return
        end
        set dir (dirname $dir)
    end
    echo "up: no ancestor directory named '$arg'" >&2
    return 1
end
