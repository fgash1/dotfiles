set fish_greeting

# Aliases
alias cl clear
alias op open
alias md mkdir
alias rd rmdir
alias t touch
alias fv 'nvim $(fzf)'
alias ll 'eza --header --long --extended --group-directories-first --no-user --no-permissions --icons=auto'
alias v nvim
alias gs 'git status'
alias ga 'git add'
alias gc 'git commit -m'
alias gps 'git push'
alias gp 'git pull'
alias gm 'git mv'
alias gr 'git rm'

starship init fish | source

fish_add_path ~/.local/bin ~/.cargo/bin

if test (uname) = Linux
    alias s startx
end
