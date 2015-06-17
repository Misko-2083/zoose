#!/bin/bash
file="$@"

PERM="$(stat --printf=%a%A "$file")"
USER_="${PERM:0:1}"

if [[ $USER_ = 7 ]]; then TF1="TRUE"; TF2="TRUE"; TF3="TRUE"
  fi
if [[ $USER_ = 6 ]]; then  TF1="TRUE"; TF2="TRUE"; TF3="FALSE"
  fi
if [[ $USER_ = 5 ]]; then TF1="TRUE"; TF2="FALSE"; TF3="TRUE"
  fi
if [[ $USER_ = 4 ]]; then TF1="TRUE"; TF2="FALSE"; TF3="FALSE"
  fi
if [[ $USER_ = 3 ]]; then TF1="FALSE"; TF2="TRUE"; TF3="TRUE"
  fi
if [[ $USER_ = 2 ]]; then TF1="FALSE"; TF2="TRUE"; TF3="FALSE"
  fi
if [[ $USER_ = 1 ]]; then TF1="FALSE"; TF2="FALSE"; TF3="TRUE"
  fi
if [[ $USER_ = 0 ]]; then TF1="FALSE"; TF2="FALSE"; TF3="FALSE"
  fi

GRP_="${PERM:1:1}"
if [[ $GRP_ = 7 ]]; then TF4="TRUE"; TF5="TRUE"; TF6="TRUE"
  fi
if [[ $GRP_ = 6 ]]; then  TF4="TRUE"; TF5="TRUE"; TF6="FALSE"
  fi
if [[ $GRP_ = 5 ]]; then TF4="TRUE"; TF5="FALSE"; TF6="TRUE"
  fi
if [[ $GRP_ = 4 ]]; then TF4="TRUE"; TF5="FALSE"; TF6="FALSE"
  fi
if [[ $GRP_ = 3 ]]; then TF4="FALSE"; TF5="TRUE"; TF6="TRUE"
  fi
if [[ $GRP_ = 2 ]]; then TF4="FALSE"; TF5="TRUE"; TF6="FALSE"
  fi
if [[ $GRP_ = 1 ]]; then TF4="FALSE"; TF5="FALSE"; TF6="TRUE"
  fi
if [[ $GRP_ = 0 ]]; then TF4="FALSE"; TF5="FALSE"; TF6="FALSE"
  fi

ALL_="${PERM:2:1}"
if [[ $ALL_ = 7 ]]; then TF7="TRUE"; TF8="TRUE"; TF9="TRUE"
  fi
if [[ $ALL_ = 6 ]]; then  TF7="TRUE"; TF8="TRUE"; TF9="FALSE"
  fi
if [[ $ALL_ = 5 ]]; then TF7="TRUE"; TF8="FALSE"; TF9="TRUE"
  fi
if [[ $ALL_ = 4 ]]; then TF7="TRUE"; TF8="FALSE"; TF9="FALSE"
  fi
if [[ $ALL_ = 3 ]]; then TF7="FALSE"; TF8="TRUE"; TF9="TRUE"
  fi
if [[ $ALL_ = 2 ]]; then TF7="FALSE"; TF8="TRUE"; TF9="FALSE"
  fi
if [[ $ALL_ = 1 ]]; then TF7="FALSE"; TF8="FALSE"; TF9="TRUE"
  fi
if [[ $ALL_ = 0 ]]; then TF7="FALSE"; TF8="FALSE"; TF9="FALSE"
  fi

STAT_="${PERM:3:13}"
ans=$(zenity  --height=450 --width=350 --list  --text "File:\n<b>${file##*/}</b>\nPermissions:\n<b>${STAT_}</b>\nchange files permissions" --checklist  --column "pick" --column "options" \
"$TF1" "user-read" "$TF2" "user-write" "$TF3" "user-exec" "$TF4" "group-read" "$TF5" "group-write" "$TF6" "group-exec" "$TF7" "all-read" "$TF8" "all-write" "$TF9" "all-exec" --separator=":")
if [ "$ans" != "" ]; then
    searchuserread="user-read"
    searchuserwrite="user-write"
    searchuserexec="user-exec"
    user1="0"
    user2="0"
    user3="0"
    searchgroupread="group-read"
    searchgroupwrite="group-write"
    searchgroupexec="group-exec"
    group1="0"
    group2="0"
    group3="0"
    searchallread="all-read"
    searchallwrite="all-write"
    searchallexec="all-exec"
    all1="0"
    all2="0"
    all3="0"

    case $ans in  *"$searchuserread"*)
        user1="4" ;;
    esac

    case $ans in  *"$searchuserwrite"*)
        user2="2" ;;
    esac

    case $ans in  *"$searchuserexec"*)
        user3="1" ;;
    esac

    case $ans in  *"$searchgroupread"*)
        group1="4" ;;
    esac

    case $ans in  *"$searchgroupwrite"*)
        group2="2" ;;
    esac

    case $ans in  *"$searchgroupexec"*)
        group3="1" ;;
    esac

    case $ans in  *"$searchallread"*)
        all1="4" ;;
    esac

    case $ans in  *"$searchallwrite"*)
        all2="2" ;;
    esac

    case $ans in  *"$searchallexec"*)
        all3="1" ;;
    esac

    u=$(($user1 + $user2 + $user3))
    g=$(($group1 + $group2 + $group3))
    a=$(($all1 + $all2 + $all3))
    result="$u$g$a"
    chmod $result "$file" || { zenity --error --text="An error occurred!\ncheck if you are allowed\nto change permissions\nof the selected file"; }
fi
