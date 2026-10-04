function clip
    set -l tmpfile (mktemp)

    # capture input safely (handles pipes + interactive)
    if isatty 0
        # interactive mode: allow typing
        set input (command cat)
        printf "%s" "$input" >$tmpfile
    else
        # piped mode
        cat >$tmpfile
    end

    # avoid empty clipboard overwrite (optional safety)
    if test ! -s $tmpfile
        rm -f $tmpfile
        return 1
    end

    # copy to clipboard
    cat $tmpfile | wl-copy

    # also show what was copied (clean preview)
    cat $tmpfile

    # cleanup
    rm -f $tmpfile
end

function pubip
    curl ipinfo.io
    echo
end

function bt
    upower -i /org/freedesktop/UPower/devices/battery_BAT0 \
        | grep percentage \
        | awk '{print $2}'
end

function loc
    set -l dir "."
    if test (count $argv) -gt 0
        set dir $argv[1]
    end

    git -C $dir ls-files --cached --others --exclude-standard -z | xargs -0 wc -l
end
