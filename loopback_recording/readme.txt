# Loopback Recording

This script will open a series of jacktrip connections to the designated loopback server at different -q values, make audio recordings of the return signal and take latency and network measurements.

# dependencies

sudo apt install mpg123
sudo apt install jack-delay
sudo apt install jack-capture
sudo apt install iptraf-ng

# start the server

jacktrip -S -n [CHANNELS] -z -p 1 -q [SERVER -q VALUE]
jackd -d dummy -p [PERIOD]

# place a test.mp3 file in the script folder

# run the script (needs sudo to start iptraf-ng)

sudo bash _loopback_recording.sh -a [IP ADDRESS] -d [DRIVER] -p [PERIOD] -n [CHANNELS] -c [INTERNET CONNECTION] -s [SERVER QUEUE VALUE] -m [SERVER MODE]

-a : server ip address
-d : uses jackd dummy driver if set to "dummy" else uses alsa with default audio driver
-p : number of frames between JACK process() calls, must be the same between server and client
-n : number of channels
-c : type of internet connection (just for reference)
-s : value of -q on the server jacktrip instance (just for reference)
-m : the server mode, set to "hub" if in Hub mode [-S] otherwise defaults to peer [-s]

# output folder will contain audio recordings and test measurements
