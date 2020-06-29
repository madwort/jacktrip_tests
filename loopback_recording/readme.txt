# Loopback Recording


# dependencies


sudo apt install mpg123
sudo apt install jack-delay
sudo apt install jack-capture


# move executable file and your own test mp3 to RPi home folder


scp _loopback_recording.sh pi@raspberry-jam.local:~/
scp test.mp3 pi@raspberry-jam.local:~/


# set the server to desired test settings
# -p = frames per second, -n = channels, -d = audio device ref, -c = internet connection ref, -s = server queue ref
# on the RPi in ~/ run


bash _loopback_recording.sh -a 10.0.0.4 -p 256 -n 1 -d dummy -c adsl -s 4


# from your laptop, copy recorded the output folder off the RPi


scp -r pi@raspberry-jam.local:~/[_NAME_OF_FOLDER] ~/
