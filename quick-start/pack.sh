#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

reset=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)

echo "${green}
██╗   ██╗ █████╗ ███╗   ███╗██████╗     ██████╗  █████╗  ██████╗██╗  ██╗███████╗██████╗
██║   ██║██╔══██╗████╗ ████║██╔══██╗    ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
██║   ██║███████║██╔████╔██║██████╔╝    ██████╔╝███████║██║     █████╔╝ █████╗  ██████╔╝
╚██╗ ██╔╝██╔══██║██║╚██╔╝██║██╔═══╝     ██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
 ╚████╔╝ ██║  ██║██║ ╚═╝ ██║██║         ██║     ██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
  ╚═══╝  ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝         ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
                                                                          by magnetic.io
${reset}"

target=${dir}/../target
rm -Rf ${target} && mkdir ${target} && cd ${target}

echo "${green}Cloning Vamp UI...${reset}"
[[ -n "$VAMP_BUILD_UI_BRANCH" ]] \
  && git clone --depth=200 --branch="$VAMP_BUILD_UI_BRANCH" https://github.com/magneticio/vamp-ui.git \
  || git clone --depth=200 https://github.com/magneticio/vamp-ui.git
cd ${target}/vamp-ui
echo "${green}Packing Vamp UI...${reset}"
npm install "gulpjs/gulp#4.0" bower \
  && npm install \
  && ./node_modules/.bin/bower --allow-root install \
  && ./environment.sh \
  && ./node_modules/.bin/gulp build \
  || exit 1
make pack

cd ${target}
echo "${green}Cloning Vamp to ${target}...${reset}"
[[ -n "$VAMP_BUILD_BRANCH" ]] \
  && git clone --depth=200 --branch="$VAMP_BUILD_BRANCH" https://github.com/magneticio/vamp.git \
  || git clone --depth=200 https://github.com/magneticio/vamp.git
cd ${target}/vamp
echo "${green}Packing Vamp...${reset}"
make clean test pack

cd ${target}
echo "${green}Cloning Vamp Artifacts to ${target}...${reset}"
git clone https://github.com/magneticio/vamp-artifacts.git
cd ${target}/vamp-artifacts
echo "${green}Packing Vamp Artifacts...${reset}"
make