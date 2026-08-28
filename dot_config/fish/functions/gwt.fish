function gwt --description "List git worktrees, or add one for a branch and cd into it"
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "gwt: not inside a git repository" >&2
        return 1
    end

    # Bare `gwt` lists existing worktrees.
    if test (count $argv) -eq 0
        git worktree list
        return
    end

    set -l branch $argv[1]
    set -l root (git rev-parse --show-toplevel)
    set -l repo (basename $root)
    set -l path (dirname $root)/$repo-(string replace -a '/' '-' -- $branch)

    if test -e "$path"
        echo "gwt: '$path' already exists" >&2
        return 1
    end

    if git show-ref --verify --quiet refs/heads/$branch
        git worktree add $path $branch; or return 1
    else
        git worktree add -b $branch $path; or return 1
    end

    cd $path
    echo "Worktree '$branch' at $path"
end
