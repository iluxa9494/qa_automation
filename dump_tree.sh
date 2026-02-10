#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"

OUT="/Users/ilia/IdeaProjects/pet_projects/qa_automation/project_dump.txt"
OUT_BASENAME="$(basename "$OUT")"

# Очищаем / создаём файл
: > "$OUT"

find "$ROOT" \
  \( \
    -path '*/.git/*' -o \
    -path '*/.idea/*' -o \
    -path '*/.vscode/*' -o \
    -path '*/target/*' -o \
    -path '*/reports/*' -o \
    -path '*/Screenshots/*' -o \
    -path '*/pagedump*/*' -o \
    -path '*/node_modules/*' \
  \) -prune -o \
  -type f \
  ! -name "$OUT_BASENAME" \
  ! -name 'dump_tree.sh' \
  ! -name '*.iml' \
  ! -name '*.class' \
  ! -name '*.jar' \
  ! -name '*.war' \
  ! -name '*.zip' \
  ! -name '*.png' ! -name '*.jpg' ! -name '*.jpeg' ! -name '*.gif' ! -name '*.webp' \
  ! -name '*.mp3' ! -name '*.mov' ! -name '*.mp4' \
  ! -name '*.pdf' \
  ! -name '*.log' \
  ! -name '*.ico' ! -name '*.svg' \
  ! -name '*.min.js' ! -name '*.min.css' \
  ! -name '.DS_Store' \
  -print0 \
| while IFS= read -r -d '' f; do
    if file -b --mime "$f" | grep -q '^text/'; then
      {
        echo "//${f#./}//"
        cat "$f"
        echo
      } >> "$OUT"
    fi
  done