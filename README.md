# 🔓📱 Android-HID-Bruteforce

Unlock an Android phone (or device) by bruteforcing the lockscreen PIN.

Turn your Kali Nethunter phone into a bruteforce PIN cracker for Android devices! This uses a USB OTG cable to emulate a keyboard, automatically try PINs, and wait after trying too many wrong guesses.

⏱ This takes a bit over 16.6 hours to try all possible 4 digit PINs, but with the optimised PIN list it should take you much less time.

My original motivation to develop this was to unlock a Samsung S5 Android phone. It had belonged to someone who had passed away, and their family needed access to the data on it. As I didn't have a USB Rubber Ducky or any other hardware handy, I tried using a variety of methods, and eventually realised I had to develop something new.


## 📱 How it works

This method uses the USB HID interface to provide keyboard input to the locked phone.
The USB HID Gadget driver provides emulation of USB Human Interface Devices (HID). 


[Nethunter phone] ---[USB cable emulates keyboard]--->  [Locked Android phone]

### 📱 ⛓ 📲 You will need

- A locked Android phone
- A Nethunter phone (or any rooted Android with HID kernel support)
- USB OTG (On The Go) cable/adapter (USB male Micro-B to female USB A), and a standard charging cable (USB male Micro-B to male A).
- That's all!

## 🌟 Benefits

- You can use a Nethunter phone
- You don't need to buy a Rubber Ducky or expensive forensic hardware
- You can easily modify the backoff time to crack other types of devices
- It works!

## ⭐ Features

- Log file
- Detects when the phone is unplugged or powered off, and waits while retrying every 5 seconds
- Configurable delays of N seconds after every X PIN attempts
- Optimised PIN list
- Bypasses phone pop-ups including the Low Power warning

## Installation

TBC


## Usage

TBC


## Supported Android Phones/Devices

It has been tested with these devices:
- Samsung S5 with Android 6.0.1


## 🎳 PIN Lists

### Optimised PIN list

`pinlist.txt` is an optimised list of all possible 4 digit PINs, sorted by order of likelihood.
pinlist.txt is from https://github.com/mandatoryprogrammer/droidbrute

This list is used with permission from Justin Engler & Paul Vines from Senior Security Engineer, iSEC Partners,
and was used in their Defcon talk, [Electromechanical PIN Cracking with Robotic Reconfigurable Button Basher (and C3BO).](https://www.defcon.org/html/defcon-21/dc-21-speakers.html#Engler)

### Bruteforce

0000..9999 

To be implemented.


## 🚀 Roadmap

- [DONE] works
- [DONE] detects USB HID failures
- Improve Usage and commandline options/config files
- Add progress bar
- Add bruteforce for n digit PINs
- ASCII art
- Nicer GUI for NetHunter
- Find/test more devices to bruteforce
- Try to detect when phone is unlocked
- Crack PIN list in reverse (to find which recent PIN unlocked the device)
- Crack Android Patterns (try common patterns first)


## 🔧 Troubleshooting

If you receive this message when the USB cable is plugged in then try taking the battery out of the locked Android phone and power cycling it.

[FAIL] HID USB device not ready. Return code from /system/xbin/hid-keyboard was 5.


## 💣 Known Issues

- This cannot detect when it unlocks


## 🛰 Technical Details

Keys are sent using `/system/xbin/hid-keyboard`.
To test this and send the key 1 you can use `echo 1 | /system/xbin/hid-keyboard dev/hidg0 keyboard`

Before each PIN, we send the escape and enter keys. This is to keep the Android responsive and dismiss any popups about the number of incorrect PIN attempts or a low battery warning.


## 🙋 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## 😎 Authors and acknowledgment

Developed by Andrew Horton (urbanadventurer).

The optimised PIN list is from Justin Engler (@justinengler) & Paul Vines from Senior Security Engineer, iSEC Partners
and was used in their Defcon talk, [Electromechanical PIN Cracking with Robotic Reconfigurable Button Basher (and C3BO).](https://www.defcon.org/html/defcon-21/dc-21-speakers.html#Engler).

The Top 20 PINs is from [DataGenetics PIN analysis](https://datagenetics.com/blog/september32012/index.html) 


## 📚 Related Projects & Futher Reading

NetHunter HID Keyboard Attacks
https://www.kali.org/docs/nethunter/nethunter-hid-attacks/

Hak5: USB Rubber Ducky
https://shop.hak5.org/products/usb-rubber-ducky-deluxe

Teensy
https://www.pjrc.com/teensy/

Droidbrute: An Android PIN cracking USB rubber ducky payload made efficient with a statistically generated wordlist.
https://github.com/mandatoryprogrammer/droidbrute

hak5 12x17: Hack Any 4-digit Android PIN in 16 hours with a USB Rubber Ducky 
https://archive.org/details/hak5_12x17

Discussion forum about the hak5 episode, and Android Brute Force 4-digit pin
https://forums.hak5.org/topic/28165-payload-android-brute-force-4-digit-pin/

[Android][Guide]Hacking And Bypassing Android Password/Pattern/Face/PI
https://forum.xda-developers.com/showthread.php?t=2620456

PATCtech Digital Forensics: Getting Past the Android Passcode
http://patc.com/online/a/Portals/965/Android%20Passcode.pdf

Electromechanical PIN Cracking with Robotic Reconfigurable Button Basher (and C3BO)
https://www.defcon.org/html/defcon-21/dc-21-speakers.html#Engler

Human Interface Devices (HID)
https://www.kernel.org/doc/html/latest/hid/index.html#

Linux USB HID gadget driver
https://www.kernel.org/doc/html/latest/usb/gadget_hid.html

XPIN Clip
https://xpinclip.com/

DataGenetics PIN analysis https://datagenetics.com/blog/september32012/index.html

Automated brute force attack against the Mac EFI PIN (Using a Teensy)
https://orvtech.com/atacar-efi-pin-macbook-pro-en.html
https://hackaday.io/project/2196-efi-bruteforcer

Android BruteForce using ADB & Shell Scripting
https://github.com/Gh005t/Android-BruteForce

AndroidPINCrack - bruteforce the Android Passcode given the hash and salt (requires root on the phone)
https://github.com/PentesterES/AndroidPINCrack

Android Pattern Lock Cracker - bruteforce the Android Pattern given an SHA1 hash (requires root on the phone)
https://github.com/sch3m4/androidpatternlock

