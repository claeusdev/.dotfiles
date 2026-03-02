function dev --description "Open dev workspace: two vim panes on left, claude on right"
    set -l session (basename (pwd))
    set -l cwd (pwd)

    # Reattach if session already exists
    if tmux has-session -t $session 2>/dev/null
        if test -n "$TMUX"
            tmux switch-client -t $session
        else
            tmux attach-session -t $session
        end
        return
    end

    # Create detached session
    tmux new-session -d -s $session -c $cwd

    # Split right for claude (~40% width), left gets ~60%
    tmux split-window -v -p 40 -t "$session:1" -c $cwd

    # Split left pane into top/bottom for two vim panes
    tmux split-window -h -t "$session:1.1" -c $cwd

    # pane 1.1 = top-left, 1.2 = right (claude), 1.3 = bottom-left
    tmux send-keys -t "$session:1.1" "nvim" Enter
    tmux send-keys -t "$session:1.3" "nvim" Enter
    tmux send-keys -t "$session:1.2" "claude" Enter

    # Focus top-left
    tmux select-pane -t "$session:1.1"

    if test -n "$TMUX"
        tmux switch-client -t "$session:1.1"
    else
        tmux attach-session -t "$session:1.1"
    end
end
