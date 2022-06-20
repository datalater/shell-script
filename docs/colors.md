# Colors

```sh
# reset
nocolor='\033[0m'       # text reset

# regular colors
black='\033[0;30m'        # black
red='\033[0;31m'          # red
green='\033[0;32m'        # green
yellow='\033[0;33m'       # yellow
blue='\033[0;34m'         # blue
purple='\033[0;35m'       # purple
cyan='\033[0;36m'         # cyan
white='\033[0;37m'        # white

# bold
bblack='\033[1;30m'       # black
bred='\033[1;31m'         # red
bgreen='\033[1;32m'       # green
byellow='\033[1;33m'      # yellow
bblue='\033[1;34m'        # blue
bpurple='\033[1;35m'      # purple
bcyan='\033[1;36m'        # cyan
bwhite='\033[1;37m'       # white

# underline
ublack='\033[4;30m'       # black
ured='\033[4;31m'         # red
ugreen='\033[4;32m'       # green
uyellow='\033[4;33m'      # yellow
ublue='\033[4;34m'        # blue
upurple='\033[4;35m'      # purple
ucyan='\033[4;36m'        # cyan
uwhite='\033[4;37m'       # white

# background
onblack='\033[40m'       # black
onred='\033[41m'         # red
ongreen='\033[42m'       # green
onyellow='\033[43m'      # yellow
onblue='\033[44m'        # blue
onpurple='\033[45m'      # purple
oncyan='\033[46m'        # cyan
onwhite='\033[47m'       # white

# high intensity
iblack='\033[0;90m'       # black
ired='\033[0;91m'         # red
igreen='\033[0;92m'       # green
iyellow='\033[0;93m'      # yellow
iblue='\033[0;94m'        # blue
ipurple='\033[0;95m'      # purple
icyan='\033[0;96m'        # cyan
iwhite='\033[0;97m'       # white

# bold high intensity
biblack='\033[1;90m'      # black
bired='\033[1;91m'        # red
bigreen='\033[1;92m'      # green
biyellow='\033[1;93m'     # yellow
biblue='\033[1;94m'       # blue
bipurple='\033[1;95m'     # purple
bicyan='\033[1;96m'       # cyan
biwhite='\033[1;97m'      # white

# high intensity backgrounds
oniblack='\033[0;100m'   # black
onired='\033[0;101m'     # red
onigreen='\033[0;102m'   # green
oniyellow='\033[0;103m'  # yellow
oniblue='\033[0;104m'    # blue
onipurple='\033[0;105m'  # purple
onicyan='\033[0;106m'    # cyan
oniwhite='\033[0;107m'   # white

# export
export NC="$nocolor"
export BLACK="$black"
export RED="$red"
export GREEN="$green"
export YELLOW="$yellow"
export BLUE="$blue"
export PURPLE="$purple"
export CYAN="$cyan"
export WHITE="$white"

export BBLACK="$bblack"
export BRED="$bred"
export BGREEN="$bgreen"
export BYELLOW="$byellow"
export BBLUE="$bblue"
export BPURPLE="$bpurple"
export BCYAN="$bcyan"
export BWHITE="$bwhite"

export UBLACK="$ublack"
export URED="$ured"
export UGREEN="$ugreen"
export UYELLOW="$uyellow"
export UBLUE="$ublue"
export UPURPLE="$upurple"
export UCYAN="$ucyan"
export UWHITE="$uwhite"

export ONBLACK="$onblack"
export ONRED="$onred"
export ONGREEN="$ongreen"
export ONYELLOW="$onyellow"
export ONBLUE="$onblue"
export ONPURPLE="$onpurple"
export ONCYAN="$oncyan"
export ONWHITE="$onwhite"

<<usage
#!/bin/bash

source ./colors.sh

# inline
echo "${PURPLE}Added files:${NC}"

# function
echo_bred() {
  echo "${BRED}$1${NC}"
}

echo_red "No argument supplied"
usage

```

## 📚 함께 읽기

- https://stackoverflow.com/a/38781253: how to load and use color variables from another script
- https://stackoverflow.com/a/28938235: color values in bash
