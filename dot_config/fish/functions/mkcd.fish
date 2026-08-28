function mkcd --description "Create a directory (including parents) and cd into it"
    set -l dir $argv[1]
    if test -z "$dir"
        echo "Usage: mkcd <dir>" >&2
        return 1
    end
    if test -e "$dir"; and not test -d "$dir"
        echo "mkcd: '$dir' exists and is not a directory" >&2
        return 1
    end
    mkdir -p "$dir"; or return 1
    cd "$dir"
end
