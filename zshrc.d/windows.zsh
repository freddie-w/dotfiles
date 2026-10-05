# Window switching (yabai, see Brewfile and README)

# Every Chrome tab as "window id<TAB>tab index<TAB>window number<TAB>title<TAB>url".
# Fetches each property for all tabs in one Apple event, which keeps it fast.
_fw_chrome_tabs() {
  osascript <<'APPLESCRIPT'
tell application "Google Chrome"
  set ids to id of every window
  set titles to title of every tab of every window
  set urls to URL of every tab of every window
end tell
set out to ""
repeat with i from 1 to count of ids
  set ts to item i of titles
  set us to item i of urls
  repeat with j from 1 to count of ts
    set out to out & (item i of ids as text) & tab & (j as text) & tab & (i as text) & tab & (item j of ts) & tab & (item j of us) & linefeed
  end repeat
end repeat
return out
APPLESCRIPT
}

# Switch a Chrome window to a tab, without raising anything. Prints the window's
# bounds and its previous active tab title, so fw can find it in yabai.
_fw_set_chrome_tab() {
  osascript - "$1" "$2" <<'APPLESCRIPT'
on run argv
  tell application "Google Chrome"
    set w to window id ((item 1 of argv) as integer)
    set b to bounds of w
    set t to title of active tab of w
    set active tab index of w to ((item 2 of argv) as integer)
  end tell
  return (item 1 of b as text) & tab & (item 2 of b as text) & tab & (item 3 of b as text) & tab & (item 4 of b as text) & tab & t
end run
APPLESCRIPT
}

# focus an open window. Chrome windows are merged into one entry (every
# profile shares one process) that opens a picker of all its tabs.
fw() {
  local chrome="Google Chrome" windows tabs="" choice
  local -a fzf_opts=(--height=50% --layout=reverse --border --delimiter=$'\t')
  windows=$(yabai -m query --windows) || return

  # Only ask Chrome for tabs if it has windows; telling a closed Chrome
  # anything would launch it.
  if jq -e --arg c "$chrome" 'any(.[]; .app == $c)' <<<"$windows" >/dev/null; then
    tabs=$(_fw_chrome_tabs)
  fi

  choice=$(
    {
      jq -r --arg c "$chrome" '
        def pad: if length < 20 then . + " " * (20 - length) else .[:20] end;
        .[] | select(.app != $c and .subrole == "AXStandardWindow")
        | "\(.id)\t\(.app | pad)\t\(.title)"' <<<"$windows"
      [[ -n $tabs ]] && awk -F'\t' -v c="$chrome" 'NF { n++; w[$1] = 1 } END {
        printf "chrome\t%-20s\t(%d windows, %d tabs)\n", c, length(w), n }' <<<"$tabs"
    } | fzf "${fzf_opts[@]}" --with-nth=2.. --prompt='window> '
  ) || return 0

  if [[ ${choice%%$'\t'*} != chrome ]]; then
    yabai -m window --focus "${choice%%$'\t'*}"
    return
  fi

  # Tabs shown as "[window] title  url", with the url dimmed
  choice=$(awk -F'\t' 'NF { printf "%s\t%s\t[%s] %s  \033[2m%s\033[0m\n", $1, $2, $3, $4, $5 }' <<<"$tabs" |
    fzf "${fzf_opts[@]}" --with-nth=3.. --ansi --prompt='tab> ') || return 0
  local -a fields=("${(@ps:\t:)choice}")
  fields=("${(@ps:\t:)$(_fw_set_chrome_tab "${fields[1]}" "${fields[2]}")}")

  # Focus just that window with yabai; activating Chrome would raise all of its
  # windows. Match on position, then on the title yabai saw before the switch,
  # since windows can share a position (e.g. stacked in the same half).
  local id
  id=$(jq -r --arg c "$chrome" --arg t "${fields[5]}" \
    --argjson x1 "${fields[1]}" --argjson y1 "${fields[2]}" \
    --argjson x2 "${fields[3]}" --argjson y2 "${fields[4]}" '
    [.[] | select(.app == $c and .frame.x == $x1 and .frame.y == $y1
      and .frame.x + .frame.w == $x2 and .frame.y + .frame.h == $y2)]
    | (map(select(.title | startswith($t))) | .[0].id) // .[0].id // empty' <<<"$windows")
  if [[ -n $id ]]; then
    yabai -m window --focus "$id"
  else
    osascript -e 'tell application "Google Chrome" to activate'
  fi
}
