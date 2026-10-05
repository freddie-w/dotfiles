# Window switching (yabai, see Brewfile and README)

# Enter takes the row under the cursor as well as a Tab-marked one (fzf's
# default is just the marked ones). Number keys pick rows 1-9 while the search
# box is empty, and type as normal once it isn't.
_fw_fzf_opts=(--height=50% --layout=reverse --border --delimiter=$'\t'
  --bind=enter:select+accept)
() {
  local i
  for (( i = 1; i <= 9; i++ )); do
    _fw_fzf_opts+=(--bind="${i}:transform:[[ -n \$FZF_QUERY ]] && echo 'put($i)' || echo 'pos($i)+select+accept'")
  done
}

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

# Pick up to $2 tabs from the _fw_chrome_tabs list in $1, with optional header
# text $3. Prints "window id<TAB>tab index<TAB>title" per pick.
_fw_pick_chrome_tabs() {
  local -a multi header
  (( $2 > 1 )) && multi=(--multi=$2) header=(--header='Tab: pick two to split · 1-9: pick')
  # With a header (splitting with another window), Tab marks the one tab too
  [[ -n $3 ]] && multi=(--multi=$2) header=(--header="$3")
  # Shown as "number  [window] title  url", with the url dimmed
  awk -F'\t' 'NF { printf "%s\t%s\t%s\t%s\t[%s] %s  \033[2m%s\033[0m\n",
    $1, $2, $4, (++n <= 9 ? n : " "), $3, $4, $5 }' <<<"$1" |
    fzf "${_fw_fzf_opts[@]}" --with-nth=4.. --nth=2.. --ansi "${multi[@]}" "${header[@]}" --prompt='tab> ' |
    cut -f1-3
}

# Print Chrome window $1's bounds and active tab title, so it can be found in
# yabai, then switch it to tab $2 if given. Switching raises the window, so
# it's left until the last step.
_fw_chrome_window() {
  osascript - "$@" <<'APPLESCRIPT'
on run argv
  tell application "Google Chrome"
    set w to window id ((item 1 of argv) as integer)
    set b to bounds of w
    set t to title of active tab of w
    if (count of argv) > 1 then set active tab index of w to ((item 2 of argv) as integer)
  end tell
  return (item 1 of b as text) & tab & (item 2 of b as text) & tab & (item 3 of b as text) & tab & (item 4 of b as text) & tab & t
end run
APPLESCRIPT
}

# Print Chrome window $2's yabai id, from the yabai windows JSON in $1.
# Chrome's window ids aren't yabai's, so match on position, then on the active
# tab title, since windows can share a position (e.g. stacked in the same half).
_fw_chrome_yabai_id() {
  local -a f=("${(@ps:\t:)$(_fw_chrome_window "$2")}")
  jq -r --arg c "Google Chrome" --arg t "${f[5]}" \
    --argjson x1 "${f[1]}" --argjson y1 "${f[2]}" \
    --argjson x2 "${f[3]}" --argjson y2 "${f[4]}" '
    [.[] | select(.app == $c and .frame.x == $x1 and .frame.y == $y1
      and .frame.x + .frame.w == $x2 and .frame.y + .frame.h == $y2)]
    | (map(select(.title | startswith($t))) | .[0].id) // .[0].id // empty' <<<"$1"
}

# Switch Chrome windows to tabs, from "window id, tab index" pairs
_fw_switch_tabs() {
  local w t
  for w t in "$@"; do _fw_chrome_window $w $t >/dev/null; done
}

# Place windows $2 and $3 side by side, with a preset picked from a numbered
# list that names both orientations ($4 and $5 are their labels). Uses the
# display fw was run from; $1 is the yabai windows JSON. Any further args are
# Chrome tabs to switch to once a layout is picked (see _fw_switch_tabs).
_fw_split() {
  local windows=$1 a=$2 b=$3 choice display id grid l r ln rn name lg rg n=0 i
  local -a rows binds
  local -a presets=(
    '50 / 50' 1:2:0:0:1:1 1:2:1:0:1:1
    '70 / 30' 1:10:0:0:7:1 1:10:7:0:3:1
    '30 / 70' 1:10:0:0:3:1 1:10:3:0:7:1
  )
  # Rows are "ids and grids<TAB>shown text<TAB>message once done"
  for l r ln rn in $a $b "$4" "$5" $b $a "$5" "$4"; do
    for name lg rg in "${presets[@]}"; do
      rows+=("$l $r $lg $rg"$'\t'"$(( ++n ))  $name   $ln | $rn"$'\t'"split $name: $ln | $rn")
    done
  done
  rows+=("keep"$'\t'"$(( ++n ))  Keep current (bring both to front)"$'\t'"brought $4 and $5 to the front")

  # Number keys pick a row straight away; there's no search box to type into
  for (( i = 1; i <= 9; i++ )); do
    if (( i <= n )); then binds+=(--bind "${i}:pos($i)+accept"); else binds+=(--bind "${i}:ignore"); fi
  done
  choice=$(print -rl -- $rows |
    fzf "${_fw_fzf_opts[@]}" --with-nth=2 --no-input "${binds[@]}" \
      --header="1-$n: pick a layout (or arrows and Enter)") || return 0

  if [[ ${choice%%$'\t'*} != keep ]]; then
    local -a spec=(${=choice%%$'\t'*})
    display=$(jq '.[] | select(.["has-focus"]) | .display' <<<"$windows")
    for id grid in $spec[1] $spec[3] $spec[2] $spec[4]; do
      if [[ -n $display && $(jq --argjson i $id '.[] | select(.id == $i) | .display' <<<"$windows") != $display ]]; then
        yabai -m window $id --display $display
      fi
      yabai -m window $id --grid $grid
    done
  fi
  _fw_switch_tabs "${@:6}"
  yabai -m window --focus $b
  yabai -m window --focus $a
  print -r -- "fw: ${choice##*$'\t'}"
}

# focus an open window, or Tab-select two to split them side by side. Chrome
# windows are merged into one entry (every profile shares one process) that
# opens a picker of all its tabs.
fw() {
  local chrome="Google Chrome" windows tabs="" choice pick line id
  local -a picks ids names titles f tabswitch
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
    } | awk -F'\t' -v OFS='\t' '{ $1 = $1 OFS (NR <= 9 ? NR : " "); print }' |
      fzf "${_fw_fzf_opts[@]}" --with-nth=2.. --nth=2.. --multi=2 \
        --header='Tab: pick two to split · 1-9: pick' --prompt='window> '
  ) || return 0
  [[ -n $choice ]] || return 0

  # Turn picks into yabai ids. Chrome opens the tab picker; if Chrome is the
  # only pick, two tabs can be chosen (two Chrome windows side by side).
  picks=("${(@f)choice}")

  # Splitting Chrome with another window: say which one is already picked
  local header="" other
  if (( $#picks == 2 )); then
    other=${${picks:#chrome$'\t'*}[1]%%$'\t'*}
    header=$(jq -r --argjson i "$other" '.[] | select(.id == $i)
      | "Selected 1/2: \(.app) (\(.title[:40]))\nTab: pick a Chrome tab for 2/2 · 1-9: pick"' <<<"$windows")
  fi

  for pick in $picks; do
    if [[ ${pick%%$'\t'*} == chrome ]]; then
      choice=$(_fw_pick_chrome_tabs "$tabs" $(( 3 - $#picks )) "$header")
      [[ -n $choice ]] || return 0
      for line in "${(@f)choice}"; do
        f=("${(@ps:\t:)line}")
        ids+=("$(_fw_chrome_yabai_id "$windows" "$f[1]")")
        tabswitch+=("$f[1]" "$f[2]")
        names+=(Chrome)
        titles+=("$f[3]")
      done
    else
      id=${pick%%$'\t'*}
      ids+=($id)
      names+=("$(jq -r --argjson i $id '.[] | select(.id == $i) | .app' <<<"$windows")")
      titles+=("$(jq -r --argjson i $id '.[] | select(.id == $i) | .title' <<<"$windows")")
    fi
  done

  if (( $#ids == 1 )); then
    _fw_switch_tabs $tabswitch
    # Focus just that window; activating Chrome (the fallback if it couldn't
    # be matched) would raise all of its windows.
    if [[ -n $ids[1] ]]; then
      yabai -m window --focus $ids[1]
      print -r -- "fw: focused $names[1] (${titles[1][1,50]})"
    else
      osascript -e 'tell application "Google Chrome" to activate'
      print -r -- "fw: activated Chrome (couldn't match the window)"
    fi
    return
  fi

  if [[ -z $ids[1] || -z $ids[2] ]]; then
    print -u2 "fw: couldn't find the Chrome window in yabai"
    return 1
  elif [[ $ids[1] == $ids[2] ]]; then
    print -u2 "fw: both tabs are in the same Chrome window"
    return 1
  fi
  # Same app on both sides: label them by window title instead
  [[ $names[1] == $names[2] ]] && names=("${titles[1][1,30]}" "${titles[2][1,30]}")
  _fw_split "$windows" $ids[1] $ids[2] "$names[1]" "$names[2]" $tabswitch
}
