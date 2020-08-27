# 🔓📱 Android-HID-Bruteforce

Unlock an Android phone (or device) by bruteforcing the lockscreen PIN.

Turn your Kali Nethunter phone into a bruteforce PIN cracker for Android devices! 

## 📱 How it works

It uses a USB OTG cable to connect the locked phone to the Nethunter device. It emulates a keyboard, automatically tries PINs, and waits after trying too many wrong guesses.

[Nethunter phone] <--> [USB OTG adaptor] <--> [USB cable] <--> [Locked Android phone]

The USB HID Gadget driver provides emulation of USB Human Interface Devices (HID). This enables an Android Nethunter device to emulate keyboard input to the locked phone. It's just like plugging a keyboard into the locked phone and pressing keys.

⏱ This takes a bit over 16.6 hours to try all possible 4 digit PINs, but with the optimised PIN list it should take you much less time.

### 📱 ⛓ 📲 You will need

- A locked Android phone
- A Nethunter phone (or any rooted Android with HID kernel support)
- USB OTG (On The Go) cable/adapter (USB male Micro-B to female USB A), and a standard charging cable (USB male Micro-B to male A).
- That's all!

## 🌟 Benefits

- Turn your NetHunter phone into an Android PIN cracking machine
- Unlike other methods, you do not need ADB or USB debugging enabled on the locked phone
- You don't need to buy special hardware, e.g. Rubber Ducky, Teensy, Cellebrite, XPIN Clip, etc.
- You can easily modify the backoff time to crack other types of devices
- It works!

## ⭐ Features

- Optimised PIN list
- Bypasses phone pop-ups including the Low Power warning
- Detects when the phone is unplugged or powered off, and waits while retrying every 5 seconds
- Configurable delays of N seconds after every X PIN attempts
- Log file

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
and was used in their Defcon talk, [Electromechanical PIN Cracking with Robotic Reconfigurable Button Basher (and C3BO)](https://www.defcon.org/html/defcon-21/dc-21-speakers.html#Engler)

### Bruteforce

0000..9999 

To be implemented.


## 🚀 Roadmap

- [DONE] Works
- [DONE] Detects USB HID failures
- [DONE] Improve Usage and commandline options/config files
- Add progress bar
- Add bruteforce for n digit PINs
- ASCII art
- Nicer GUI for NetHunter
- Find/test more devices to bruteforce
- Try to detect when phone is unlocked
- Crack PIN list in reverse (to find which recent PIN unlocked the device)
- Crack Android Patterns (try common patterns first)
- Mask for known digits


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

### Motivation

My original motivation to develop this was to unlock a Samsung S5 Android phone. It had belonged to someone who had passed away, and their family needed access to the data on it. As I didn't have a USB Rubber Ducky or any other hardware handy, I tried using a variety of methods, and eventually realised I had to develop something new.

### Credit

The optimised PIN list is from Justin Engler (@justinengler) & Paul Vines from Senior Security Engineer, iSEC Partners
and was used in their Defcon talk, [Electromechanical PIN Cracking with Robotic Reconfigurable Button Basher (and C3BO).](https://www.defcon.org/html/defcon-21/dc-21-speakers.html#Engler).


## 🗿 Comparison of methods to unlock a locked Android phone

### 😭 Regular phone users

- Try the top 20 PINs from the [DataGenetics PIN analysis](https://datagenetics.com/blog/september32012/index.html) that apparently unlocks 26.83% of phones.
- Use an SMS lock-screen bypass app (requires app install before phone is locked)
- Use Samsung Find My Mobile (requires you set it up before phone is locked)
- Crash the Lock Screen UI (Android 5.0 and 5.1)
- Use the Google Forgot pattern, Forgot PIN, or Forgot password (Android 4.4 KitKat and earlier)
- Factory Reset (you lose all your data)

### 🤖 Users who have already replaced their Android ROM

If the phone already has been rooted, has USB debugging enabled, or has adb enabled.

- Flash the `Pattern Password Disable` ZIP using a custom recovery (Requires TWRP, CMW, Xrec, etc.)
- Delete `/data/system/gesture.key` or `password.key` (requires root and adb on locked device)
- Crack `/data/system/gesture.key` and `password.key` (requires root and adb on locked device)
- Update sqlite3 database `settings.db` (requires root and adb on locked device)

### 🔬 Forensic Investigators

These methods can be expensive and are usually only used by specialised phone forensic investigators.

- Physical Extraction using Cellebrite UFED
- XPIN Clip
- Oxygen Forensic Suite (Requires USB debugging enabled)
- JTAG extraction
- Chip Off

### 🕵 USB HID Keyboard Bruteforce

- A RubberDucky and Darren Kitchen's Hak5 brute-force script
- A Teensy device and base it on @orvtech's code
- Duck Hunter HID attacks in NetHunter (it didn't work with a brute-force PIN attack)
- Or you can use this with your NetHunter phone!



## 📚 Related Projects & Futher Reading

Note: organise this list more

### USB HID Hardware without NetHunter

hak5 12x17: Hack Any 4-digit Android PIN in 16 hours with a USB Rubber Ducky 
https://archive.org/details/hak5_12x17

Hak5: USB Rubber Ducky
https://shop.hak5.org/products/usb-rubber-ducky-deluxe

USB-Rubber-Ducky Payloads
https://github.com/hak5darren/USB-Rubber-Ducky/wiki/Payloads

Teensy
https://www.pjrc.com/teensy/

Automated brute force attack against the Mac EFI PIN (Using a Teensy)
https://orvtech.com/atacar-efi-pin-macbook-pro-en.html
https://hackaday.io/project/2196-efi-bruteforcer

Droidbrute: An Android PIN cracking USB rubber ducky payload made efficient with a statistically generated wordlist.
https://github.com/mandatoryprogrammer/droidbrute

Discussion forum about the hak5 episode, and Android Brute Force 4-digit pin
https://forums.hak5.org/topic/28165-payload-android-brute-force-4-digit-pin/

### NetHunter HID keyboard attacks

NetHunter HID Keyboard Attacks
https://www.kali.org/docs/nethunter/nethunter-hid-attacks/

### Linux Kernel HID support

Human Interface Devices (HID)
https://www.kernel.org/doc/html/latest/hid/index.html#

Linux USB HID gadget driver
https://www.kernel.org/doc/html/latest/usb/gadget_hid.html

### Cracking Android PIN and Pattern files

AndroidPINCrack - bruteforce the Android Passcode given the hash and salt (requires root on the phone)
https://github.com/PentesterES/AndroidPINCrack

Android Pattern Lock Cracker - bruteforce the Android Pattern given an SHA1 hash (requires root on the phone)
https://github.com/sch3m4/androidpatternlock

### General Recovery Methods

[Android][Guide]Hacking And Bypassing Android Password/Pattern/Face/PI
https://forum.xda-developers.com/showthread.php?t=2620456

Android BruteForce using ADB & Shell Scripting
https://github.com/Gh005t/Android-BruteForce

### Forensic Methods and Hardware

PATCtech Digital Forensics: Getting Past the Android Passcode
http://patc.com/online/a/Portals/965/Android%20Passcode.pdf

XPIN Clip
https://xpinclip.com/

Cellebrite UFED
https://www.cellebrite.com/en/ufed/

### PIN Analysis

Electromechanical PIN Cracking with Robotic Reconfigurable Button Basher (and C3BO)
https://www.defcon.org/html/defcon-21/dc-21-speakers.html#Engler

DataGenetics PIN analysis https://datagenetics.com/blog/september32012/index.html


