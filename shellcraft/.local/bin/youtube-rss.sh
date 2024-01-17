#!/usr/bin/env bash

# Inspired by:
# https://gist.github.com/tjluoma/fdbc63ceb78a2aecd3d638fd18b6ec6e

#NAME=$(basename $BASH_SOURCE)

yt-rss() {
    local CURL_FLAGS="--fail --silent --location --show-error"
    # htmlq is installed with 'cargo'
    LINK_RSS=$(curl $CURL_FLAGS ${1} \
                   | htmlq 'link[type="application/rss+xml"]' -a href)

    if [[ -z $LINK_RSS ]];	then
        CHANNEL_ID=$(curl $CURL_FLAGS ${1} \
                         | grep -Po '(?<=("channelId":")).*?(?=")' \
                         | head -1)

        if [[ -n $CHANNEL_ID ]]; then
            LINK_RSS="https://www.youtube.com/feeds/videos.xml?channel_id=$CHANNEL_ID"
        else
            echo "$NAME: 'CHANNEL_ID' and 'LINK_RSS' are both empty for '${1}'." >&2
            exit 1
        fi
    fi

    # copy URL to clipboard
    echo ${LINK_RSS} | tee >(wl-copy)
}

export -f yt-rss
