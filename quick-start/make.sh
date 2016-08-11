#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

reset=`tput sgr0`
green=`tput setaf 2`

target=$1
mkdir -p ${target} && cd ${target}

echo "${green}Cloning Vamp UI to ${target}...${reset}"
git clone --depth=1 https://github.com/magneticio/vamp-ui.git
cd ${target}/vamp-ui
echo "${green}Building Vamp UI...${reset}"
npm install -g "gulpjs/gulp#4.0" && npm install && bower install && ./setEnvironment.sh && gulp build
mv dist ui && tar -cvjSf ui.tar.bz2 ui
cd ${target}

echo "${green}Cloning Vamp to ${target}...${reset}"
git clone --depth=200 https://github.com/magneticio/vamp.git
cd ${target}/vamp
git reset --hard 1d8809f779557ade561da8057e618ae39c57de32
echo "${green}Building Vamp...${reset}"
sbt test assembly

echo "${green}Copying files...${reset}"
cp $(find "${target}/vamp/bootstrap/target/scala-2.11" -name 'vamp-assembly-*.jar' | sort | tail -1) ${target}/vamp.jar
cp -f ${target}/vamp-ui/ui.tar.bz2 ${target}/ui.tar.bz2

rm -Rf ${target}/vamp && rm -Rf ${target}/vamp-ui

cp -f ${dir}/Dockerfile ${target}/Dockerfile
cp -fR ${dir}/logback.xml ${dir}/application.conf ${target}/
cp -f ${dir}/vamp.sh ${target}/
cp -fR ${dir}/supervisord.conf ${target}/
