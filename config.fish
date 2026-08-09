source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

alias pacman='sudo pacman'
alias mi='micro'
alias amogus='echo ඞ'
alias exe='chmod a+x'
alias pc='btop'
alias ff='fastfetch'

function run
    command $argv &
    disown
end

zoxide init fish | source

# pnpm
set -gx PNPM_HOME "/home/user/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end

fnm env --use-on-cd | source

starship init fish | source
# oh-my-posh init fish | source

