function ff
    set mode $argv[1]
    set query $argv[2]

    if test -z "$mode"
        set mode file
    end

    # Centralized ignore parameters for fd
    set ignore_dirs \
        --exclude .git \
        --exclude node_modules \
        --exclude venv \
        --exclude .venv \
        --exclude __pycache__ \
        --exclude .mypy_cache \
        --exclude .pytest_cache

    # Centralized ignore parameters for ripgrep
    set rg_ignores \
        --glob '!node_modules/**' \
        --glob '!.git/**' \
        --glob '!venv/**' \
        --glob '!.venv/**' \
        --glob '!__pycache__/**' \
        --glob '!.mypy_cache/**' \
        --glob '!.pytest_cache/**'

    set chosen_file ""
    set chosen_line ""

    # --------------------------------------------------------
    # 1. MODES
    # --------------------------------------------------------
    switch $mode

        # ---------------- FILE SEARCH ----------------
        case file
            set file (fd --type f --hidden --no-ignore-vcs $ignore_dirs \
                | fzf --query="$query" \
                --preview "bat --style=numbers --color=always --theme=ansi {} 2>/dev/null || cat {}" \
                --height 75% --border --reverse)

            if test -n "$file"
                set chosen_file "$file"
            end

            # ---------------- GIT SEARCH ----------------
        case git
            if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
                echo "Error: Not a git repository."
                return 1
            end

            set file (git ls-files \
                | fzf --query="$query" \
                --preview "bat --style=numbers --color=always --theme=ansi {} 2>/dev/null || cat {}" \
                --height 75% --border --reverse)

            if test -n "$file"
                set chosen_file "$file"
            end

            # ---------------- GREP SEARCH ----------------
        case grep
            if test -z "$query"
                read -P "⚡ Search Text: " query
            end
            if test -z "$query"
                return
            end

            set match (rg --line-number \
                --column \
                --no-heading \
                --color=never \
                --smart-case "$query" \
                $rg_ignores \
                2>/dev/null \
                | fzf --ansi \
                    --delimiter : \
                    --preview 'bat --color=always --style=numbers --theme=ansi --highlight-line {2} {1}' \
                    --height 75% \
                    --border \
                    --reverse)

            if test -n "$match"
                set chosen_file (echo "$match" | cut -d: -f1)
                set chosen_line (echo "$match" | cut -d: -f2)
            end

            # ---------------- DIRECTORY ----------------
        case dir
            set dir (fd --type d --hidden --no-ignore-vcs $ignore_dirs \
                | fzf --query="$query" \
                --preview "ls -la {}" \
                --height 75% --border --reverse)

            if test -n "$dir"
                cd "$dir"
                commandline -f repaint
            end

            # ---------------- COUNT ----------------
        case count
            echo "File type extension (e.g. py, js, ts, or Enter for all):"
            read -P "> " type

            if test -z "$type"
                set files (fd --type f --hidden --no-ignore-vcs $ignore_dirs)
            else
                set files (fd --type f --hidden --no-ignore-vcs $ignore_dirs --extension $type)
            end

            set total_files (count $files)
            if test $total_files -gt 0
                set total_loc (string join0 $files | xargs -0 wc -l 2>/dev/null | awk 'END {print $1}')
                echo "📁 Total Files: $total_files"
                echo "💻 Total LOC:   $total_loc"
            else
                echo "No matching files found."
            end
    end

    # --------------------------------------------------------
    # 2. OPEN RESULT IN nvim
    # --------------------------------------------------------
    # Make sure we actually have a string AND it points to a real file
    if test -n "$chosen_file" -a -f "$chosen_file"
        set chosen_file (realpath "$chosen_file")

        if test -n "$chosen_line"
            nvim "+$chosen_line" "$chosen_file"
        else
            nvim "$chosen_file"
        end
    end
end
