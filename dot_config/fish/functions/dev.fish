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
    tmux split-window -h -p 40 -t "$session:0" -c $cwd

    # Split left pane into top/bottom for two vim panes
    tmux split-window -v -t "$session:0.0" -c $cwd

    # pane 0.0 = top-left, 0.1 = right (claude), 0.2 = bottom-left
    tmux send-keys -t "$session:0.0" "nvim" Enter
    tmux send-keys -t "$session:0.2" "nvim" Enter
    tmux send-keys -t "$session:0.1" "claude" Enter

    # Focus top-left
    tmux select-pane -t "$session:0.0"

    if test -n "$TMUX"
        tmux switch-client -t $session
    else
        tmux attach-session -t $session
    end
end
