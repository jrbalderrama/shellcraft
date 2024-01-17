#!/bin/bash

OAUTH2_DIR=${HOME}/.2fa

_candidates() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    candidates=$(find ${OAUTH2_DIR} \
                      -type f \
                      -name "[a-z]*.asc" \
                      -printf "%P\n" \
                     | sed "s/.asc//g")
    COMPREPLY=( $(compgen -W "$candidates" -- $cur) )
}

_silent_background() {
    { 2>&3 "$@"& } 3>&2 2>/dev/null
    disown &>/dev/null  # Prevent whine if job has already completed
}

totp() {
    local wtime="${2:-10}"
    # show to stout as well: | tee >(wl-copy)
    gpg --batch -q -d ${OAUTH2_DIR}/${1}.asc \
        | xargs -I {} oathtool -b --totp=SHA1 "{}" \
        | wl-copy -n --
    # we cannot use xdotool type because is not X11 anymore
    # check it again on the next (?) relase of ubuntu lts.

    # clear the clipboard after 10 seconds just in case,
    # to do that run wl-copy again with the option '--clear'
    # in background to preserve a clean stdout:
    # https://stackoverflow.com/questions/7686989
    #
    # actually that is the reason why i want to use xdotool
    # instead of copying just type the result and better  if
    # i can use a keyboard shortcut or a tool like a hk for
    # that see:
    # github.com/ltratt/hk
    # tratt.net/laurie/blog/2023/debugging_a_failing_hotkey.html
    { sleep ${wtime} && wl-copy --clear & disown; } 2> /dev/null
}

otp-hex2base32() {
    xxd -r -p <<< ${@} | base32
}

otp-keyuri() {
    echo "otpauth://totp/${1}?secret=${2}&issuer=${1}&algorithm=SHA1&digits=6&period=30" \
         | tee >(wl-copy)
}

export -f totp
export -f otp-hex2base32
export -f otp-keyuri
complete -F _candidates totp
