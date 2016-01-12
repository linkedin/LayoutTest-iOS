#!/usr/bin/env sh

cd `dirname $0`/../
rm -rf source/sphinx_rtd_theme
git clone https://github.com/snide/sphinx_rtd_theme.git temp
mv temp/sphinx_rtd_theme sphinx_rtd_theme
rm -rf temp 
echo "Theme updated"

