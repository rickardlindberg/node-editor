#!/bin/sh

Xvfb :2 -screen 0 800x600x16 &
xvfb_pid=$!

ghc --make Main.hs
DISPLAY=:2 ./Main &
program_pid=$!
sleep 1

xwd -display :2 -silent -root -out image.xwd
convert image.xwd image.png
rm image.xwd

kill -9 $program_pid
kill -9 $xvfb_pid
