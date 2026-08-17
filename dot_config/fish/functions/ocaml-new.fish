function ocaml-new --description "Bootstrap a new OCaml project with dune"
    set -l name $argv[1]
    if test -z "$name"
        echo "Usage: ocaml-new <project-name>"
        return 1
    end
    dune init proj $name
    and cd $name
    and ocamlformat-init
    and echo "OCaml project '$name' ready!"
end
