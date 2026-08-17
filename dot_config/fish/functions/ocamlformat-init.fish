function ocamlformat-init --description "Stamp the global ocamlformat config into this project"
    if test -e .ocamlformat
        echo ".ocamlformat already exists; not overwriting" >&2
        return 1
    end
    if not command -q ocamlformat
        echo "ocamlformat not on PATH (opam install ocamlformat)" >&2
        return 1
    end
    set -l ver (ocamlformat --version)
    echo "version = $ver" >.ocamlformat
    grep -v '^#' ~/.config/ocamlformat | string trim | string match -rv '^$' >>.ocamlformat
    echo "Wrote .ocamlformat (pinned to ocamlformat $ver)"
end
