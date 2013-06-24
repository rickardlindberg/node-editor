#!/bin/sh

# Start virtual screen
Xvfb :2 -screen 0 800x600x16 > /dev/null 2>&1 &
xvfb_pid=$!

# Run our program
ghc --make Main.hs || exit
DISPLAY=:2 ./Main > /dev/null 2>&1 &
program_pid=$!
sleep 1

# Take the screenshot
xwd -display :2 -silent -root -out image.xwd
convert image.xwd tests/actual_screenshot.png
rm image.xwd

# Diff
pdiff tests/actual_screenshot.png tests/approved_screenshot.png -output tests/screenshot_diff.ppm && rm -f tests/screenshot_diff.ppm tests/actual_screenshot.png

# Kill processes
kill -9 $program_pid
kill -9 $xvfb_pid
