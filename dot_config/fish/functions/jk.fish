function jk --description "Register current uv venv as a Jupyter kernel"
    set -l name (basename $PWD)
    if not test -d .venv
        echo "No .venv found. Run 'uv sync' first."
        return 1
    end
    uv add --dev ipykernel
    uv run python -m ipykernel install --user --name $name --display-name $name
    echo "Kernel '$name' registered."
end
