import json
import subprocess
import sys
from urllib import parse


def json_parse(url):
    result = subprocess.run(
        ["yt-dlp", "-j", url],
        capture_output=True,
        encoding="UTF-8",
    )

    return json.loads(result.stdout)


get_audio_details = lambda c: {
    str(i): (f["format_id"], f["format_note"], f.get("language"))
    for i, f in enumerate(
        filter(
            lambda l: l["resolution"] == "audio only",
            c["formats"],
        ),
        1,
    )
}


def pformat(audio_details, source):
    write_format = (
        "\t\033[1m{k}.\033[0m [{v[2]}] {v[1]:<33} {v[0]}"
        if "arte.tv" in source
        else "\t\033[1m{k}.\033[0m {v[1]:<33} {v[0]}"
    )

    return (
        # display format changes according to source
        write_format.format(k=key, v=value)
        for key, value in audio_details.items()
    )


def download(url, audio):
    selection = "bestvideo+" + audio
    subprocess.run(["yt-dlp", "-v", "-f", selection, url])


def main(url):
    uri = parse.urlparse(url)
    contents = json_parse(url)
    audio_details = get_audio_details(contents)
    print("\n".join(pformat(audio_details, uri.netloc)))
    try:
        option = input("Select a number: ")
        audio = audio_details[option][0]
        download(url, audio)
    except KeyboardInterrupt:
        print("\n\nKeyboard interrupt!", file=sys.stderr)
        sys.exit(0)

if __name__ == "__main__":
    main(sys.argv[1])
