#!/bin/sh
case "$1:$2:$3:$4" in

button/volumedown:*:*:*)
    touch /home/tugdual/pouet
    if [ ! -f /home/tugdual/recording.pid ]; then
        aplay /home/tugdual/boop.wav >> /home/tugdual/aplay.log
        echo "Recording start" >> /home/tugdual/aplay.log
        ristretto --display=:0 -f /home/tugdual/0.jpg &
        arecord -r 16000 -f S16_LE /home/tugdual/recording.wav &
        echo $! | tee /home/tugdual/recording.pid > /dev/null
       	bash -c 'echo "Recording started." >> /home/tugdual/aplay.log'
    fi
;;
button/volumeup:*:*:*)
    # Stop recording
    if [ -f /home/tugdual/recording.pid ]; then
        kill -2 $(cat /home/tugdual/recording.pid) >> /home/tugdual/aplay.log 2>> /home/tugdual/aplay_error.log
        rm /home/tugdual/recording.pid
        /home/tugdual/assist.sh
        bash -c 'echo "Recording stopped." >> /home/tugdual/aplay.log'
    fi
;;
esac

exit 0