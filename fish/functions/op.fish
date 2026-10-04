function op
    if test (count $argv) -eq 0
        echo "Usage: op <file>"
        return 1
    end

    for f in $argv
        if not test -e $f
            echo "File not found: $f"
            continue
        end

        set ext (string lower (string match -r '\.[^\.]+$' $f))

        switch $ext
            case ".pdf"
                setsid okular $f >/dev/null 2>&1 &
            case ".doc" ".docx" ".xls" ".xlsx" ".ppt" ".pptx"
                setsid onlyoffice-desktopeditors $f >/dev/null 2>&1 &
            case ".mp4" ".mkv" ".avi" ".mov"
                setsid mpv $f >/dev/null 2>&1 &
            case ".png" ".jpg" ".jpeg" ".gif" ".bmp"
                setsid feh $f >/dev/null 2>&1 &
            case ".txt" ".md" ".log" ".json" ".csv"
                setsid nvim $f >/dev/null 2>&1 &
            case ".zip" ".7z" ".tar" ".tar.gz" ".tgz" ".tar.bz2" ".rar"
                echo -n "Enter path to extract '$f' [default: .]: "
                read extract_path
                if test -z "$extract_path"
                    set extract_path "."
                end
                mkdir -p $extract_path
                switch $ext
                    case ".zip"
                        unzip -q $f -d $extract_path
                    case ".7z"
                        7z x $f -o$extract_path >/dev/null
                    case ".tar"
                        tar xf $f -C $extract_path
                    case ".tar.gz" ".tgz"
                        tar xzf $f -C $extract_path
                    case ".tar.bz2"
                        tar xjf $f -C $extract_path
                    case ".rar"
                        unrar x -inul $f $extract_path
                end
                echo "Extracted '$f' to $extract_path"
            case "*"
                setsid xdg-open $f >/dev/null 2>&1 &
        end
    end
end
