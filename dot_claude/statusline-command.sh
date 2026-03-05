#!/usr/bin/env bash
# Claude Code status line — clean, pipe-separated format
# Shows: username | dir | git branch | model | time | context usage

input=$(cat)

# --- data from Claude Code ---
cwd=$(echo "$input"   | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input"  | jq -r '.context_window.used_percentage // empty')

# --- username ---
user_part=$(whoami)

# --- current directory: last component only ---
if [ -n "$cwd" ]; then
  dir_name=$(basename "$cwd")
else
  dir_name=$(basename "$(pwd)")
fi

# --- git branch info (skip optional locks so we never stall) ---
git_part=""
if git -C "${cwd:-$(pwd)}" rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  branch=$(git -C "${cwd:-$(pwd)}" symbolic-ref --short HEAD 2>/dev/null \
           || git -C "${cwd:-$(pwd)}" rev-parse --short HEAD 2>/dev/null)

  if [ -n "$branch" ]; then
    raw=$(git -C "${cwd:-$(pwd)}" status --porcelain=v1 2>/dev/null)
    flags=""
    echo "$raw" | grep -q '^[MADRC]' && flags="${flags}+"   # staged
    echo "$raw" | grep -q '^ [MD]'   && flags="${flags}!"   # modified
    echo "$raw" | grep -q '^?'       && flags="${flags}?"   # untracked

    ab=$(git -C "${cwd:-$(pwd)}" rev-list --left-right --count "@{upstream}...HEAD" 2>/dev/null)
    if [ -n "$ab" ]; then
      behind=$(echo "$ab" | awk '{print $1}')
      ahead=$(echo  "$ab" | awk '{print $2}')
      [ "$ahead"  -gt 0 ] 2>/dev/null && flags="${flags}↑${ahead}"
      [ "$behind" -gt 0 ] 2>/dev/null && flags="${flags}↓${behind}"
    fi

    git_part="${branch}"
    [ -n "$flags" ] && git_part="${git_part} ${flags}"
  fi
fi

# --- model ---
model_part=""
[ -n "$model" ] && model_part="${model}"

# --- current time ---
time_part=$(date +%H:%M:%S)

# --- context window usage ---
ctx_part=""
if [ -n "$used" ]; then
  used_int=${used%.*}
  ctx_part="${used_int}% ctx"
fi

# --- assemble single output line (pipe-separated) ---
parts=()
[ -n "$user_part"  ] && parts+=("$user_part")
[ -n "$dir_name"   ] && parts+=("$dir_name")
[ -n "$git_part"   ] && parts+=("git:${git_part}")
[ -n "$model_part" ] && parts+=("$model_part")
[ -n "$time_part"  ] && parts+=("$time_part")
[ -n "$ctx_part"   ] && parts+=("$ctx_part")

output=""
for part in "${parts[@]}"; do
  if [ -z "$output" ]; then
    output="$part"
  else
    output="${output} | ${part}"
  fi
done

printf "%s" "$output"
