function scratch --description "cd into a dated throwaway directory under ~/scratch"
    set -l name $argv[1]
    set -l dir $HOME/scratch/(date +%Y-%m-%d)
    test -n "$name"; and set dir "$dir-$name"

    mkdir -p "$dir"; or return 1
    cd "$dir"
end
