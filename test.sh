#!/bin/sh

Xnest :2 -ac -geometry 400x200 &
xnest_pid=$!
sleep 1

DISPLAY=:2 runhaskell Main.hs &
sleep 1
program_pid=$!

#DISPLAY=:2 scrot foo.png
sleep 1

kill -9 $program_pid
kill -9 $xnest_pid
