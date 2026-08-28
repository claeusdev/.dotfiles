function extract --description "Extract any common archive format"
    set -l file $argv[1]
    if test -z "$file"
        echo "Usage: extract <archive>" >&2
        return 1
    end
    if not test -f "$file"
        echo "extract: no such file: $file" >&2
        return 1
    end

    switch (string lower -- $file)
        case '*.tar.gz' '*.tgz'
            tar -xzf $file
        case '*.tar.bz2' '*.tbz2' '*.tbz'
            tar -xjf $file
        case '*.tar.xz' '*.txz'
            tar -xJf $file
        case '*.tar.zst' '*.tzst'
            tar --zstd -xf $file
        case '*.tar'
            tar -xf $file
        case '*.zip'
            unzip -q $file
        case '*.gz'
            gunzip -k $file
        case '*.bz2'
            bunzip2 -k $file
        case '*.xz'
            unxz -k $file
        case '*.zst'
            zstd -d $file
        case '*.7z'
            echo "extract: .7z needs p7zip (brew install p7zip)" >&2
            return 1
        case '*.rar'
            echo "extract: .rar needs unar (brew install unar)" >&2
            return 1
        case '*'
            echo "extract: don't know how to extract '$file'" >&2
            return 1
    end
    or return 1

    echo "Extracted $file"
end
