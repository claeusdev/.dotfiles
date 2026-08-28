function clone --description "git clone a repository and cd into it"
    set -l url $argv[1]
    if test -z "$url"
        echo "Usage: clone <url> [dir]" >&2
        return 1
    end

    set -l dir $argv[2]
    if test -z "$dir"
        # Strip a trailing slash, take the basename, drop a trailing .git
        set dir (string replace -r '/$' '' -- $url | string split '/' | tail -1 | string replace -r '\.git$' '')
    end

    if test -z "$dir"
        echo "clone: could not determine a target directory from '$url'" >&2
        return 1
    end

    git clone $url $dir; or return 1
    cd $dir
end
