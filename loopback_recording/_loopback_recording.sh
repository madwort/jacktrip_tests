#!/bin/bash

while getopts ":a:p:n:d:c:s:" opt; do
  case $opt in
    a) a=$OPTARG; echo "IP a: $OPTARG" >&2
    ;;
    p) p=$OPTARG; echo "Frame rate: $OPTARG" >&2
    ;;
    n) n=$OPTARG; echo "No. of channels: $OPTARG" >&2
    ;;
    d) d=$OPTARG; echo "Device: $OPTARG" >&2
    ;;
    c) c=$OPTARG; echo "Connection type: $OPTARG" >&2
    ;;
    s) s=$OPTARG; echo "Server -queue setting: $OPTARG" >&2
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

qArray=(4 6 8 10 12 14)

if test "$p" -eq 128; then
    unset qArray
    qArray=(4 8 12 16 20 24)
fi

if test "$p" -eq 64; then
    unset qArray
    qArray=(4 12 20 28 36 44)
fi

printf "\nTesting client -q values: ${qArray[*]}\n\n"

sleep 2

if test "$d" == "dummy"
then
    jackd -R -P89 -d dummy -p $p &
else
    jackd -R -P89 -t2000 -d alsa -p $p -n2 -s -S &
fi

sleep 1

mpg123-jack --loop -1 test.mp3 &

sleep 1

for q in "${qArray[@]}"
do
    jacktrip -C ${a} -n${n} -q${q} -z &
    sleep 2
    sudo iptraf-ng -B -L ./_${d}_${p}_q${q}_n${n}_${c}_server_q${s}_logs.txt -d eth0 &
    jack_connect mpg123:1 ${a}:send_1
    jack_connect mpg123:2 ${a}:send_2
    sleep 1
    jack_capture -d 6 --port ${a}:receive_* _${d}_${p}_q${q}_n${n}_${c}_server_q${s}.wav
    echo recorded:_${d}_${p}_q${q}_n${n}_${c}_server_q${s}.wav
    jack_delay -I ${a}:receive_1 -O ${a}:send_1 > _${d}_${p}_q${q}_n${n}_${c}_server_q${s}_latency.txt &
    sleep 3
    sudo killall -USR2 iptraf-ng
    killall jack_delay
    killall jacktrip
    sleep 1
done

jack_connect mpg123:1 system:playback_1
jack_capture -d 10 --port system:playback_1 _system_comparison_${p}.wav

sudo killall mpg123.bin
sudo killall jacktrip
sudo killall jackd
mkdir _server_p${p}_q${s}
mv *.wav _server_p${p}_q${s}
mv *_latency.txt _server_p${p}_q${s}
mv *_logs.txt _server_p${p}_q${s}
