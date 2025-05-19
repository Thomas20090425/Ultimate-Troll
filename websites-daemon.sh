

#!/usr/bin/env bash
# Ensure script runs under bash
if [ -z "$BASH_VERSION" ]; then
  exec bash "$0" "$@"
fi

# List of websites
urls=(
  "http://www.hqhole.com"
  "http://www.hdsexdino.com"
  "http://pornbigvideo.com"
  "http://www.sweetshow.com"
  "http://mylust.com"
  "https://www.sleazyneasy.com"
  "http://www.sexpulse.tv"
  "http://www.sexmole.com"
  "http://www.spankbang.com"
  "http://spankbang.com"
  "http://spankbang.com/74qv/video/faketaxi+vic+summers"
  "http://spankbang.com/new_videos/2"
  "http://freeadultmedia.com"
  "http://www.freeadultmedia.com"
  "http://bangbrosteenporn.com"
  "http://www.bangbrosteenporn.com"
  "http://porn8.com"
  "http://collectionofbestporn.com"
  "http://collectionofbestporn.com/video/ashlyn-rae-loves-her-sweet-pussy-fucked.html"
  "http://hqporner.com/studio/wow-girls"
  "http://freeviewmovies.com"
  "http://www.freeviewmovies.com"
  "https://fr.youporn.com"
  "http://fooxy.com"
  "http://cartoontube.com"
  "http://porn.hu"
  "http://bobiporn.com"
  "http://stileproject.com"
  "http://whataporn.com"
  "http://sunporno.com"
  "http://xxxonxxx.com"
  "http://orgasm.com"
  "http://freefuckvidz.com"
  "http://xxx.com"
  "http://porn.org"
  "http://theporn1.com"
  "http://rawtube.com"
  "http://madthumbs.com"
  "http://hotpornshow.com"
  "http://pornvideos.com"
  "http://bangyoulater.com"
  "http://youngpornvideos.com"
  "http://spankwire.com"
  "http://freeporn.com"
  "http://porn.xxx"
  "http://porn.com"
  "http://youporn.com"
  "http://pornhub.com"
  "http://007angels.com"
  "http://00webcams.com"
  "http://1.hot-dances.com"
  "http://100200film.com"
  "http://100amateurvideos.com"
  "http://101sexsecret.com"
  "http://110percentnatural.com"
  "https://pornhub.com"
  "https://18conmics.org"
  "https://jerkmate.com"
)

# Run indefinitely
while true; do
  # Pick random URL
  idx=$((RANDOM % ${#urls[@]}))
  url="${urls[$idx]}"

  # Open in Safari
  open -a Safari "$url"

  # Sleep random 2-4 hours
  MIN=7200   # 2 hours
  MAX=14400  # 4 hours
  interval=$(( RANDOM % (MAX - MIN + 1) + MIN ))
  echo "Next open in ${interval}s ($(printf '%d:%02d' $((interval/3600)) $(((interval%3600)/60))))"
  sleep "$interval"
done