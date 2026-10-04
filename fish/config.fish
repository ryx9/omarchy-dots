# kitty @ set-colors --all ~/.config/kitty/current-theme.conf

# ===== Git over Tailscale VPS =====
set -g GIT_SERVER shoom
set -g GIT_BASE git

function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end

function gnew
    set repo $argv[1]

    # ensure repo exists
    if not test -d .git
        git init
    end

    git checkout -B main

    git add .

    # ONLY commit if there is something
    if not git diff --cached --quiet
        git commit -m init
    end

    # 🚨 IMPORTANT: prevent push if no commits exist
    if not git log -1 >/dev/null 2>&1
        echo "No commits yet — add files first"
        return
    end

    ssh shoom "mkdir -p git/$repo.git && git init --bare git/$repo.git"

    git remote remove origin 2>/dev/null
    git remote add origin shoom:git/$repo.git

    git push -u origin main
end

function gclone
    git clone $GIT_SERVER:$GIT_BASE/$argv[1]
end

############################
# PUSH (AUTO SAFE)
############################
function gpush
    if not git remote get-url origin >/dev/null 2>&1
        git remote add origin $GIT_SERVER:$GIT_BASE/(basename (pwd)).git
    end

    git push -u origin main
end

############################
# QUICK INIT (NO SERVER CREATE)
############################
function ginit
    git init -b main
    git add .

    if git diff --cached --quiet
        echo "Nothing to commit"
        return
    end

    git commit -m init
    git remote add origin $GIT_SERVER:$GIT_BASE/$argv[1].git
    git push -u origin main
end

function zit
    set outfile archive

    if test (count $argv) -ge 1
        set outfile $argv[1]
    end

    zip -r "$outfile.zip" . \
        -x "*.git/*" \
        "*.venv/*" \
        "venv/*" \
        "node_modules/*" \
        "__pycache__/*" \
        ".next/*" \
        "*.pyc" \
        ".DS_Store"
end

############################
# Prompt
############################
function fish_prompt -d "Write out the prompt"
    printf '%s@%s %s%s%s > ' \
        $USER \
        $hostname \
        (set_color $fish_color_cwd) \
        (prompt_pwd) \
        (set_color normal)
end

function clip
    tee /dev/tty | wl-copy
end

############################
# Interactive session only
############################
if status is-interactive

    # No greeting
    set -g fish_greeting ""

    # Clear screen properly
    clear

    # System fetch

    ############################
    # Oh My Posh
    ############################
    # Load vsharp OMP theme

    ############################
    # Starship prompt (optional, overrides fish_prompt if enabled)
    ############################
    # starship init fish | source   # Uncomment if you want Starship instead of OMP

    ############################
    # Quickshell terminal sequences (if present)
    ############################

    ############################
    # Aliases — Core
    ############################
    alias refresh="~/.local/bin/aether-cycle.sh"
    alias catch="helix ~/notes/inbox.md"
    alias shoom="ssh -p 8022 u0_211@100.78.128.63"
    alias music="mocp ~/Music"
    alias y="yazi"
    alias hx="helix ."
    alias h="helix"
    alias pamcan="sudo pacman"
    alias v="nvim"
    alias py="python"
    alias m="make"
    alias dk="sudo docker"
    alias rd="ripdrag -a -r"
    alias l="lfcd"
    alias nmt="nmtui"
    alias nmc="nmcli"
    alias p="sudo pacman"
    alias cd='z'
    alias lg='lazygit'
    alias tw="~/.local/bin/tmux-workspace"
    ############################
    # uv / Python
    ############################
    alias uvr="uv run"
    alias uvm="uv run manage.py"
    alias usync="uv sync"
    alias usyncf="uv sync --frozen"
    alias venv="uv venv"
    alias upip="uv pip"
    alias pytest="uv run pytest"
    alias t='flatpak run --command=io.github.alainm23.planify.quick-add io.github.alainm23.planify'
    alias agenda='gcalcli agenda'

    ############################
    # Git
    ############################
    alias g="git"
    alias gs="git status"
    alias gss="git status -s"
    alias ga="git add"
    alias gaa="git add ."
    alias gc="git commit"
    alias gcm="git commit -m"
    alias gca="git commit --amend"
    alias gco="git checkout"
    alias gb="git branch"
    alias gbd="git branch -d"
    alias gl="git log --oneline --graph --decorate"
    alias gp="git push"
    alias gpf="git push --force-with-lease"
    alias gpl="git pull"
    alias gst="git stash"
    alias gsta="git stash apply"
    alias gcl="git clone"
    alias gitls="git config --list | grep alias"

    ############################
    # Pacman / Arch
    ############################
    alias pi="sudo pacman -S"
    alias pu="sudo pacman -Syu"
    alias pr="sudo pacman -Rns"
    alias ps="pacman -Ss"
    alias qi="pacman -Qi"
    alias qs="pacman -Qs"
    alias qu="pacman -Qu"
    alias pl="pacman -Ql"

    # AUR (if yay installed)
    alias ys="yay -Ss"
    alias yi="yay -S"
    alias yu="yay -Syu"
    alias yr="yay -Rns"

    ############################
    # Files & navigation
    ############################
    alias ls="eza --icons --group-directories-first"
    alias ll="eza -lh --icons"
    alias la="eza -lha --icons"
    alias tree="tree -C"
    alias ..="cd .."
    alias ...="cd ../.."
    alias ....="cd ../../.."
    alias md="mkdir -p"
    alias qa="qalc"
    ############################
    # Builtins / QoL
    ############################
    alias c="clear"
    alias clera="clear"
    alias clear="printf '\033[2J\033[3J\033[1;1H'"
    alias q="exit"
    alias quit="exit"
    alias qquit="exit"
    alias reload="exec fish"

    ############################
    # Networking
    ############################
    alias ip="ip -c a"
    alias ports="ss -tulpn"
    alias wifi="nmcli device wifi list"
    alias pingg="ping google.com"

    ############################
    # sudo docker
    ############################
    alias dpa="sudo docker ps -a"
    alias di="sudo docker images"
    alias drm="sudo docker rm"
    alias drmi="sudo docker rmi"
    alias dex="sudo docker exec -it"
    alias dlog="sudo docker logs"
    alias dcu="sudo docker compose up -d"
    alias dcd="sudo docker compose down"
    ############################
    # System info
    ############################
    alias top="htop"
    alias mem="free -h"
    alias cpu="lscpu"
    alias disks="lsblk -f"
    alias dfh="df -h"
    alias duh="du -h"
    alias now="date '+%Y-%m-%d %H:%M:%S'"
    alias pkg="pacman -Q | wc -l"

    ############################
    # Flatpak
    ############################
    alias stream="flatpak run com.stremio.Stremio"

    alias reboot="echo \"lakh di lanat\" "

    ############################
    # Functions
    ############################
    function pubip
        curl ipinfo.io
        echo
    end

    function bt
        upower -i /org/freedesktop/UPower/devices/battery_BAT0 \
            | grep percentage \
            | awk '{print $2}'
    end

end
function brightness --description "Set screen brightness percentage"
    if test (count $argv) -ne 1
        echo "Usage: brightness <0-100>"
        return 1
    end

    if not string match -qr '^[0-9]+$' -- $argv[1]
        echo "Brightness must be a number."
        return 1
    end

    set level $argv[1]

    if test $level -lt 0 -o $level -gt 100
        echo "Brightness must be between 0 and 100."
        return 1
    end

    brightnessctl set "$level%"
end
zoxide init fish | source

thefuck --alias | source
oh-my-posh init fish --config ~/.config/omp/dracula.omp.json | source
