## ShellCraft

A bunch of scripts for daily use.

### Install
First, install with the package manager `oathtool` and `wl-copy`.
Some sripts run Python code. They would also need:

```
$ pip install yt-dlp
$ cargo install htmlq
```

Then to install the scripts use `stow`:

``` bash
$ stow -t ~ -R -v shellcraft
```

### Scripts

ShelllCraft provides:

- `totp`: Temporal OTP tokens generation (supports autocomplete)

   ``` bash
   $ totp github
   ```

- `otp-hex2base32`: Transform a OTP key from hex to base32 format

   ``` bash
   $ otp-hex2base32 4LLC YBIJ V4D2 6G1T 3LII R6AG DA6E PCGF
   ```

- `otp-keyuri`: Generate a standard OTP URI using issuer and key

   ``` bash
   $ otp-keyuri github DPBBSAXYAAEUDAS2
   ```

- `yt-dlpi`: Interactive `yt-dlp` to choose source language

   ``` bash
   $ yt-dlpi https://www.arte.tv/fr/videos/114583-010-A
   ```

- `yt-rss`: Get the RSS URL of any youtube channel or video

   ``` bash
   $ yt-rss https://www.youtube.com/@GitHub
  ```

### TODO

Add documentation of each script and their parameters

