# 🐇 Bunny, the better worse version of Rabbit R1

https://github.com/user-attachments/assets/e6b2628c-8d9d-4dc6-a3c9-ba707303ffb7

I recently came across https://news.ycombinator.com/item?id=40346995 this HN post showing off a Raspberry Pi running both llama.cpp and whisper.cpp with a few python scripts in the middle.

Inspired, I wanted to make my own spinoff of this creation, making it portable ! I want to have a local AI assisstant that could be in my pocket but that doesn't send my data to OpenAI nor needs an internet connection to work successfully.

I whipped out a Oneplus 6T that was recently softbricked. My goal was to:

- [x] Install linux on the phone (I didn't want to keep Android bloat)
- [x] Set up a script that would do Speech-to-Text, Inference and Text-to-Speech.

Things I would improve with more time / incentive:

- [ ] Cute animation to make it more interactive
- [ ] Learn C to avoid scripts an make this an "all in one" to make it smoother and more efficient
- [ ] Make whisper.cpp and llama.cpp be a background service to avoid startup times during the execution of the script.

## Installing linux on the phone

#### First attempt: Installing [Ubuntu touch](https://devices.ubuntu-touch.io/device/fajita/#installerDownload). 
Unfortunately after some fiddling around I was unable to downgrade easily the phone to the required Android version to then install it. 

#### Second attempt: Postmarket OS, inspired by [Junk Drawer Phone as a Music Streaming Server](https://davidhampgonsalves.com/junk-drawer-phone-as-a-music-streaming-server/).

After trail and error, I manage to install the necessary libraries. The wiki is great and contains all necessary information to enter the bootloader mode and flash any image onto the phone.

I initially installed the [none/console](https://wiki.postmarketos.org/wiki/Category:Interface) interface. This meant then using SSH to install the required libraries to:

1. Connect to internet by installing iwd for interface management and openresolv for DNS.

2. Install nano, and g++ that is necessary for the compilation of both whisper.cpp and llama.cpp

3. Compile both llama and whisper

4. Write a script that combines everything

## Installation

How to install this on Oneplus 6T:

    Enter fastboot with https://wiki.postmarketos.org/wiki/OnePlus_6T_(oneplus-fajita)

    Install pmbootstrap from the site.

    Init and flash the image on your device.

    Install iwd, iwd-openrc, nano, openresolv, acpi, espeak and g++

    Copy footer.txt, header.txt, assist.sh, and boop.wav to your home directory.

    Copy button_handler.sh to /etc/acpi/ dir. Then modify the events subdir to call button_handler.sh (Don't forget to chmod so that the script is executable).

    Change the paths in the scripts to you own !

    Add to rc-service and rc-update acpid so that it can run the script on startup.

    Install whisper.cpp and llama.cpp on your device and build the binaries.

    Place ristretto-start in /etc/init.d/ and chmod it, then add it to the rc-service

Normally, it should work ! 

Feel free to contact me if you're experiencing issues in the installation process.


## Issues I ran into

- I spent HOURS trying to get ALSA, the Audio interface of linux to behave correctly and let me simply record and play back audio but it seems that it's stronger than me :/ Even using PulseAudio on top didn't correctly work when recording audio.

- I resolved this by installing the [Xfce4](https://wiki.postmarketos.org/wiki/Category:Interface) interface instead which included PulseAudio and `arecord` seemed to correctly work from there.

- I can't find a good way to launch scripts based on button inputs -> You would expect that [linux events](https://en.wikipedia.org/wiki/Evdev) would be the solution but it only shows a button press not release which doesn't work for me.

- I'm using [ACPI](https://wiki.archlinux.org/title/ACPI_modules) instead that seems to work OK.

- The scripts necessary to run and stop the recording weren't working because I was executing one line as $USER and another as the script user.

- A lot of issues finding the right template to get the LLM prompts working correctly without spitting out nonsense. (New lines matter !)
