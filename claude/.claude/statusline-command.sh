#!/usr/bin/env bash
# Claude Code status line — mirrors Starship style (directory + git + claude info)

input=$(cat)

# --- Directory ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')

# Show only the current folder name
truncated_dir=$(basename "$cwd")

# --- Git branch & status ---
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

  modified=$(git -C "$cwd" status --porcelain 2>/dev/null | grep -c '^.M')
  untracked=$(git -C "$cwd" status --porcelain 2>/dev/null | grep -c '^??')
  staged=$(git -C "$cwd" status --porcelain 2>/dev/null | grep -c '^[MADRC]')

  status_str=""
  [ "$staged" -gt 0 ]    && status_str="${status_str}+${staged}"
  [ "$modified" -gt 0 ]  && status_str="${status_str}!${modified}"
  [ "$untracked" -gt 0 ] && status_str="${status_str}?${untracked}"

  ahead=$(git -C "$cwd" rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
  behind=$(git -C "$cwd" rev-list --count HEAD..@{u} 2>/dev/null || echo 0)
  [ "$ahead" -gt 0 ]  && status_str="${status_str}⇡${ahead}"
  [ "$behind" -gt 0 ] && status_str="${status_str}⇣${behind}"

  if [ -n "$status_str" ]; then
    git_info=" ${branch} [${status_str}]"
  else
    git_info=" ${branch}"
  fi
fi

# --- Claude info ---
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

claude_info=""
[ -n "$model" ] && claude_info="$model"

# Token count (human-readable, e.g. "36k")
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
total_tokens=$((total_in + total_out))
if [ "$total_tokens" -ge 1000000 ]; then
  token_label="$(awk "BEGIN{printf \"%.1f\", $total_tokens/1000000}")M"
elif [ "$total_tokens" -ge 1000 ]; then
  token_label="$(awk "BEGIN{printf \"%.0f\", $total_tokens/1000}")k"
else
  token_label="${total_tokens}"
fi

if [ -n "$used_pct" ]; then
  used_int=${used_pct%.*}
  if [ "$used_int" -ge 80 ]; then
    ctx_label="${token_label} · ctx:${used_int}%(!)"
  else
    ctx_label="${token_label} · ctx:${used_int}%"
  fi
  [ -n "$claude_info" ] && claude_info="${claude_info} | ${ctx_label}" || claude_info="$ctx_label"
fi

# --- Cost ---
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
cost_label="$(awk "BEGIN{printf \"$%.2f\", $cost_usd}")"

# --- Session timer ---
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
duration_s=$((duration_ms / 1000))
if [ "$duration_s" -ge 3600 ]; then
  hours=$((duration_s / 3600))
  mins=$(( (duration_s % 3600) / 60 ))
  time_label="${hours}h${mins}m"
elif [ "$duration_s" -ge 60 ]; then
  mins=$((duration_s / 60))
  time_label="${mins}m"
else
  time_label="${duration_s}s"
fi

# --- Lines changed ---
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
lines_label="+${lines_added} -${lines_removed}"

# --- Compose ---
printf "%s%s  %s | %s · %s | %s" "$truncated_dir" "$git_info" "$claude_info" "$cost_label" "$time_label" "$lines_label"
