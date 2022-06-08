
# print ascii art
ascii_art() {
  cat <<- 'ART'
                             ____
                     __,-~~/~    `---.
                   _/_,---(      ,    )
               __ /        <    /   )  \___
- ------===;;;'====------------------===;;;===----- -  -
                  \/  ~"~"~"~"~"~\~"~)~"/
                  (_ (   \  (     >    \)
                   \_( _ <         >_>'
                      ~ `-i' ::>|--"
                          I;|.|.|
                         <|i::|i|`.
                        (` ^'"`-' ")

        __   __     __  __     __  __     ______
       /\ "-.\ \   /\ \/\ \   /\ \/ /    /\  ___\
       \ \ \-.  \  \ \ \_\ \  \ \  _"-.  \ \  __\
        \ \_\\"\_\  \ \_____\  \ \_\ \_\  \ \_____\
         \/_/ \/_/   \/_____/   \/_/\/_/   \/_____/

ART
}

# prompt user for input
prompt(){
  # prompt user
  echo -n "$1"
}

# get input from user
get_response(){
  # get user input
  local response
  read response

  # determine action
  case $response in
    $2)
      # execute function
      $1
      ;;
    *)
      # do nothing
      :
      ;;
  esac

  # optional return
  if $3; then
    echo "$response"
  fi
}

# nuke your storage disk to completely wipe it of data
nuke(){
  # check args
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Function requires both the drive file path and drive type." && exit
  fi

  # Detect the platform
  # (ref: https://megamorf.gitlab.io/2021/05/08/detect-operating-system-in-shell-script/)
  local OS="`uname`"
  case $OS in
    'Linux')
      # TODO
      echo "Not currently implemented >:("
      ;;
    'Darwin')
      if [[ "$2" == "SSD" ]]; then
        # encrypt ssd followed by erase
        diskutil coreStorage encryptVolume "${1}" && diskutil eraseDisk "${1}"
      else
        # do a single pass of zeros to wipe data, then random ones to hide wipe
        diskutil secureErase 0 "${1}" && diskutil secureErase 1 "${1}"
      fi
      ;;
    *)
      # do nothing
      :
      ;;
  esac
}

# barrage user with questions as precaution
questionnaire(){
  # local vars
  local drive_path
  local drive_type

  # inform user of
  echo "Before your drive can be NUKED we need to know a few things ..."

  # ask for drive name
  prompt "What is the file path of the drive? [/dev/*]: "
  drive_path=$(get_response)

  # ask for drive type
  prompt "Solid State/Flash Drive (SSD) or Hard Disk Drive (HDD)? [SSD/HDD]: "
  drive_type=$(get_response)

  # inform user what will happen
  if [[ "${drive_type}" == "SSD" ]]; then
    echo "Your ${drive_type} at ${drive_path} will be encrypted, then deleted."
  elif [[ "${drive_type}" == "HDD" ]]; then
    echo "Your ${drive_type} at ${drive_path} will be zeroed, then randomized."
  else
    echo "Drive type (${drive_type}) not recognized. Please try again." && exit
  fi

  # give user one last cahnce
  local continue
  prompt "Last chance, are you sure you want to continue? [Y/N]: "
  continue=$(get_response)

  # to nuke or not to nuke, that is the question
  if [[ "${continue}" == "Y" ]]; then
    nuke "${drive_path}" "${drive_type}"
  elif [[ "${continue}" == "N" ]]; then
    echo "Nuclear launch ABORTED. Exiting program now. Have a nice day :)"
  else
    echo "Response \"${continue}\" not understood. Please try again." && exit
  fi
}


# print out ascii art
ascii_art

# get disk info from user
questionnaire
