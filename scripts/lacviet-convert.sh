#!/bin/bash
set -e

lv_version=v1.1.0
dictutil_version=v0.3.2

echo Installing dependencies
sudo apt install dictzip python-dev-is-python3 python-is-python3 p7zip-full
python -m pip install marisa-trie lxml
git clone https://github.com/pettarin/penelope.git
cd penelope
mkdir -p ./dict
wget https://github.com/pgaskin/dictutil/releases/download/$dictutil_version/dictutil-linux-64bit -O dictutil
chmod +x dictutil

lang_name() {
    case $1 in
    vi)
        echo -n Vietnamese
        ;;
    en)
        echo -n English
        ;;
    fr)
        echo -n French
        ;;
    ko)
        echo -n Korean
        ;;
    ja)
        echo -n Japanese
        ;;
    zh)
        echo -n Chinese
        ;;
    *)
        echo -n unknown language
        exit 1
        ;;
    esac
}

convert() {
    from=$1
    to=$2
    echo -n Converting $from-$to

    path="$(lang_name $from)-$(lang_name $to)"
    if [ $from = zh ] || [ $to = zh ]; then
        path+="_Simplified-Character"
    fi
    # Downloading LacViet dictionary
    wget https://github.com/Meigyoku-Thmn/LacVietExtract/releases/download/$lv_version/LacViet_$path.7z -O temp.7z
    7z e temp.7z -otemp

    # Convert to Kobo dicthtml
    zip -j temp.zip temp/*
    python -m penelope -i temp.zip -f $from -t $to -j stardict -p kobo -o dicthtml

    # Remove color property but keep transparent
    sed -i 's/color: *transparent;/🔒;/g;/^ *color: *.\+;/d;s/🔒;/color: transparent;/g' temp/style.css
    # Minify
    tr -d '\r\n ' <temp/style.css >style.min.css
    sed -i 's/[^{}]\+{ *}//g' style.min.css

    # Fix: no headword found
    ./dictutil unpack dicthtml-$from-$to.zip
    # https://sed.js.org/?gist=909b87ca4fa1c7dffcd1bb757bde62fc
    grep -rl '<a name=".*".*"/>' ./dicthtml-$from-$to | xargs sed -i 's@\(<a name="\)"\?\([^"]\+\)"\(\([^"]\+\)"\?\)\?\(\([^"]\+\)"\?\)\?\(\([^"]\+\)"\?\)\?\("/>\)@\1\2\4\6\8\9@g'
    # Add style to dictfiles
    grep -rl '<link rel="stylesheet" href="style.css"/>' ./dicthtml-$from-$to | xargs sed -i 's@<link rel="stylesheet" href="style.css"\/>@🔒@;s@<link rel="stylesheet" href="style.css"\/>@@g;s@🔒@'"<style>$(cat style.min.css)<\/style>"'@'
    ./dictutil pack dicthtml-$from-$to -o ./dict/dicthtml-$from-$to.zip

    # Cleanup
    rm -rf temp.7z temp.zip temp dicthtml-$from-$to.zip dicthtml-$from-$to style.min.css
}

echo Start
convert en vi
convert vi en
# convert fr vi
# convert vi fr
# convert ko vi
# convert vi ko
# convert ja vi
# convert vi ja
# convert zh vi
# convert vi zh
echo Done
