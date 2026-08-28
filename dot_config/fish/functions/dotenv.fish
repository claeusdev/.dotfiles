function dotenv --description "Load a .env file into the current shell (fish cannot source one)"
    set -l file $argv[1]
    test -z "$file"; and set file .env

    if not test -f "$file"
        echo "dotenv: no such file: $file" >&2
        return 1
    end

    set -l names
    set -l lineno 0

    while read -l line
        set lineno (math $lineno + 1)

        # Skip blanks and comments.
        set -l trimmed (string trim -- $line)
        test -z "$trimmed"; and continue
        string match -q '#*' -- $trimmed; and continue

        # Tolerate a leading `export `.
        set trimmed (string replace -r '^export\s+' '' -- $trimmed)

        # Split on the FIRST = only, so values may contain =.
        set -l parts (string split -m 1 '=' -- $trimmed)
        if test (count $parts) -ne 2
            echo "dotenv: skipping malformed line $lineno" >&2
            continue
        end

        set -l key (string trim -- $parts[1])
        set -l val $parts[2]

        if not string match -qr '^[A-Za-z_][A-Za-z0-9_]*$' -- $key
            echo "dotenv: skipping invalid key on line $lineno" >&2
            continue
        end

        # Strip one matched pair of surrounding quotes.
        if string match -qr '^".*"$' -- $val
            set val (string sub -s 2 -e -1 -- $val)
        else if string match -qr "^'.*'\$" -- $val
            set val (string sub -s 2 -e -1 -- $val)
        else
            set val (string trim -- $val)
        end

        set -gx $key $val
        set -a names $key
    end < "$file"

    if test (count $names) -eq 0
        echo "dotenv: nothing to load from $file"
        return 0
    end

    # Names only. Never echo values - these are secrets.
    echo "Loaded "(count $names)" vars from $file: $names"
end
