function bak --description "Make a timestamped backup copy of a file or directory"
    set -l target $argv[1]
    if test -z "$target"
        echo "Usage: bak <file-or-dir>" >&2
        return 1
    end
    if not test -e "$target"
        echo "bak: no such file or directory: $target" >&2
        return 1
    end

    # Strip a trailing slash so directories don't produce a doubled path.
    set target (string replace -r '/$' '' -- $target)
    set -l dest "$target."(date +%Y-%m-%dT%H%M)".bak"

    if test -e "$dest"
        echo "bak: '$dest' already exists; not overwriting" >&2
        return 1
    end

    if test -d "$target"
        cp -Rp "$target" "$dest"; or return 1
    else
        cp -p "$target" "$dest"; or return 1
    end

    echo "Backed up to $dest"
end
