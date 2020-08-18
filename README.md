# Android-HID-Bruteforce

Unlock an Android phone (or any device) by bruteforcing the lockscreen PIN.

This software is for Android devices locked with a PIN. 

Nethunter Android 


## How it works

This method uses the USB HID interface to provide keyboard input to the locked phone.
The USB HID Gadget driver provides emulation of USB Human Interface Devices (HID). 

### Requirements:

- Attacking Android phone
- Locked Android phone (Android )
- USB OTG (On The Go) cable/adapter


Tested with : 

- Samsung S5 with Android 6.0.1
- Oneplusone with Kali Nethunter on LineageOS

### Benefits

- You don't need a USB Rubber Ducky
- You can use a Nethunter phone
- You can easily modify the backoff time
- It works!


## Roadmap

- progress bar
- colour
- brute n digit PINs

## Known Issues

- battery is low, on screen popup. does not receive enter/keys. 
- can't detect when it unlocks


## Comparioson of methods to unlock a locked Android phone

### Regular phone users

- Use an SMS lock-screen bypass app (requires app install before phone is locked)
- Use Samsung Find My Mobile (requires you set it up before phone is locked)
- Crash the Lock Screen UI (Android 5.0 and 5.1)
- Use the Google Forgot pattern, Forgot PIN, or Forgot password (Android 4.4 KitKat and earlier)
- Factory Reset (you lose all your data)

### Users who replace their Android ROM

- Flash the `Pattern Password Disable` ZIP using a custom recovery (Requires TWRP, CMW, Xrec, etc.)
- Delete /data/system/gesture.key and password.key (requires root and adb on locked device)
- Crack /data/system/gesture.key and password.key (requires root and adb on locked device)
- Update sqlite3 settings.db (requires root and adb on locked device)

### Forensic Investigators

This requires expensive hardware and sofware, or a dedicated forensic lab.

- Physical Extraction using Cellebrite UFED
- Oxygen Forensic Suite (Requires USB debugging enabled)
- JTAG extraction
- Chip Off

### USB HID Keyboard Bruteforce

Finally if these methods do not work for you use USB HID keyboard brute-force.

- RubberDucky and Darren Kitchen's hak5 script (great)
- NetHunter HID Attacks (didn't work with a very long script, such as 10,0000 PINs)
- XPIN Clip


# PIN Lists

## Optimised PIN list

`pinlist.txt` is an optimised list of all possible 4 digit PINs, sorted by order of likelihood.
pinlist.txt is from https://github.com/mandatoryprogrammer/droidbrute

This list originally comes from Justin Engler & Paul Vines from Senior Security Engineer, iSEC Partners
and was used in their Defcon talk, [Electromechanical PIN Cracking with Robotic Reconfigurable Button Basher (and C3BO).][https://www.defcon.org/html/defcon-21/dc-21-speakers.html#Engler]

## Generated Bruteforce

0000..9999 

To be implemented


## Top 20 PINs

If you have a limited number of PIN attempts, try this top 20 PINs list from DataGenetics.

- 1234
- 1111
- 0000
- 1212
- 7777
- 1004
- 2000
- 4444
- 2222
- 6969
- 9999
- 3333
- 5555
- 6666
- 1122
- 1313
- 8888
- 4321
- 2001
- 1010

Source: https://datagenetics.com/blog/september32012/index.html


# Related Projects & Futher Reading

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

Human Interface Devices (HID)
https://www.kernel.org/doc/html/latest/hid/index.html#

Linux USB HID gadget driver
https://www.kernel.org/doc/html/latest/usb/gadget_hid.html

XPIN Clip
https://xpinclip.com/
