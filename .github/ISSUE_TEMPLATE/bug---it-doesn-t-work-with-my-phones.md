---
name: Bug - It doesn't work with my phones
about: Create a report to help us improve
title: 'Locked phone: XXX, Nethunter phone: XXX - Bug description'
labels: ''
assignees: ''

---

# Describe the bug
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

## My phones
- The make and model of my NetHunter Android phone : 
- The make and model of my locked Android phone :

## Can I send any keys
- Are your cables correctly connected?
- Is your NetHunter Android phone capable of emulating a keyboard?
- Does your OTG cable work?
- Does the script correctly send keys to a text editor in Windows/Linux/MacOS?
- Can you send keys to Windows/Linux/Macos from the command line?
- Can you send keys to the locked phone from the command line?
- Does the phone accept keyboard input when it is locked?
- Did you try a different locked phone?

## Sending the correct keys
- What keys will bring up the PIN prompt?
- What keys should be sent after the PIN is entered?

## Troubleshooting
- Did you try rebooting both phones?
- Did you try unplugging and replugging the cables?
- Did you try new cables including the OTG cable?

- The output of the diag command
```
<paste output here
```

# Troubleshooting Instructions Section

## Can I send any keys?

### Are your cables correctly connected?

The Nethunter phone should have a regular USB cable attached.
The OTG cable should be connected to the locked Android phone.

Refer to the graphic in the README on how to connect the phones.

### Is your NetHunter Android phone capable of emulating a keyboard?

- Check that the `/dev/hidg0` device is present
- Check that the `/system/xbin/hid-keyboard` binary is present

The diag command will check that these files are present.
`bash ./android-pin-bruteforce diag`

If these files are present but the script doesn't work, try using another Android app to emulate a keyboard such as https://store.nethunter.com/en/packages/remote.hid.keyboard.client/

### Does your OTG cable work?

Connect a keyboard or mouse to any phone using the OTG cable. Confirm that the cable works with a different phone and any device.
Try using a different OTG cable. Even if it works, perhaps it does not fit well with your locked phone.

### Does the script correctly send keys to a text editor in Windows/Linux/MacOS?

- Connect your NetHunter phone to your laptop.
- Open a text editor such as Notepad
- Run the script
- Confirm that keys are sent to your laptop

### Can you send keys to Windows/Linux/Macos from the command line?

Try testing sending keys  from the NetHunter command line.

`echo "enter" | /system/xbin/hid-keyboard /dev/hidg0 keyboard`
`echo "a b c" | /system/xbin/hid-keyboard /dev/hidg0 keyboard`

### Can you send keys to the locked phone from the command line?

Same as above.

### Does the phone accept keyboard input when it is locked?

Connect a USB keyboard through the OTG cable to the locked phone. This technique requires emulating a keyboard, so if the phone does not accept USB keyboard input while it is locked, this attack will not work.

Note that some devices will not permit you to use a new or unknown USB device while it is locked.

### Did you try a different locked phone?

Same as above but with a different locked phone.

## Sending the correct keys

### What keys will bring up the PIN prompt?

Using a keyboard, try keys and combinations of keys including:
- CTRL + ESCAPE
- ESCAPE
- SPACE

### What keys should be sent after the PIN is entered?

Usually this is `enter` but you might need to send other keys.

## Troubleshooting

- Reboot the phones.
- Unplug and replug the cables.
- Try new cables including the OTG cable
- Paste the output of the diag command, `bash ./android-pin-bruteforce diag`
