# termcap
# ks       make the keypad send commands
# ke       make the keypad send digits
# vb       emit visual bell
# mb       start blink
# md       start bold
# me       turn off bold, blink and underline
# so       start standout (reverse video)
# se       stop standout
# us       start underline
# ue       stop underline

# https://github.com/jedsoft/most/issues/9#issuecomment-2558517596
function man() {
        env \
                MANROFFOPT=-c \
                LESS_TERMCAP_md=$(tput bold; tput setaf 4) \
                LESS_TERMCAP_me=$(tput sgr0) \
                LESS_TERMCAP_mb=$(tput blink) \
                LESS_TERMCAP_us=$(tput setaf 2) \
                LESS_TERMCAP_ue=$(tput sgr0) \
                LESS_TERMCAP_so=$(tput smso) \
                LESS_TERMCAP_se=$(tput rmso) \
                PAGER="${commands[less]:-$PAGER}" \
                man "$@"
}
