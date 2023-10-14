---
title: scripts
layout: post
parent: system
---

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# coding environment quick rebuild

> AUTHOR : WANGYULONG / ERON

## How To Start

**Just run `sudo init.sh` script, press `ENTER` and wait for complete ~**

**Relax and go for a cup of TEA !**

## Basic Tools

1. command line tools

- `jq`, which is a `json parse` shell tool, the offical site : [JQ - A JSON SHELL TOOL](https://stedolan.github.io/jq/)
- `panda`, a VPN tool to browse World, need pay for that
- `repo` script, google muti git repositories manager script, can clone a bundle git repos

2. custome python script

- `mailTool.py`, writen by python, a mail client to send email, can run as a command line tool or python directly
- ...

3. shell script

- `serviceManager.sh`, writen by shell script, want to manage service on ubuntu, such as mysql run/stop/status, redis, zookeeper, kafka and so on ..., to be continue
- ...

4. vim essential files

totally for vim config, should update for vim 8.0, never need vundle

- basic config file
- vim color schema config
- vundle download ad colors schema file download ...

## About `init.sh` Script

- [ ] git, python, java, gradle, maven, ant ...
- [ ] development compiler and runtime / deploy applications
- [ ] for automatic generate configuration and essential tools download
- [ ] ...

## About Future

Let life be beautiful like summer flowers And death like autumn leaves

# shells

## linux init env script

```shell
#! /bin/bash -x 

# AUTHOR WangYuLong/ERON 

CUR_DIR=$(realpath ./) 
echo "current dir is ${CUR_DIR}, please confirm running dir !" 

TMP_DIR="${HOME}/init_builder_tmp" 
CUSTOME_BIN_DIR="${HOME}/bin" 
CUSTOME_OTHER_ENV_DIR="${CUSTOME_BIN_DIR}/env" 

BASHRC_FILE="${HOME}/.bashrc" 
PROFILE_FILE="${HOME}/.profile" 
BASH_ALIASES_FILE="${HOME}/.bash_aliases" 

# all the first thing is install python3 pip3 git java8 java11/java17 environment 
# Obsidian-0.12.15 
# pandas 
# balenaEtcher-1.7.0-x64 

basic_tools_check () {

    # required dev env packages 
    sudo apt install -y build-essential net-tools 

    rsync --version 
    if [ $? -eq 0 ]; then 
        echo "rsync is Installed, usage : rsync -P source target ..." 
    else 
        echo "rsync is not installed ! installing..." 
        sudo apt install -y rsync 
    fi 

    wget --version 
    if [ $? -eq 0 ]; then 
        echo "wget is Installed, usage : wget -O filename url ..." 
    else 
        echo "wget is not installed ! installing..." 
        sudo apt install -y wget # wget2 install later 
    fi 

    tar --version 
    if [ $? -eq 0 ]; then 
        echo "tar is Installed, usage : tar --help for example -> \ntar -cf archive.tar foo bar | tar -xf archive.tar ..." 
    else 
        echo "tar is not installed ! installing..." 
        sudo apt install -y tar 
    fi 

    zip --version 
    if [ $? -eq 0 ]; then 
        echo "zip is installed, next must check unzip !!!" 
    else 
        echo "zip is not installed ! installing..." 
        sudo apt install -y zip 
    fi 

    unzip --version 
    if [ $? -eq 0 ]; then 
        echo "unzip is installed !" 
    else 
        echo "unzip is not installed ! installing..." 
        sudo apt install -y unzip 
    fi 

}

# repo and others dirs, just copy files and put it right position 
files_copy_and_check () { 

    echo "Folders check and creating ..." 
    # check folder is exists 
    if [ ! -d "${CUSTOME_BIN_DIR}" ]; then 
        echo "~/bin for bin tools, ~/bin/env for other dev bins, creating ..." 
        mkdir -p "${CUSTOME_OTHER_ENV_DIR}" 
    fi 

    # create tmp folder for download files 
    if [ ! -f "${TMP_DIR}" ]; then 
        echo "create a tmp folder for env builder ......" 

        mkdir -p "${TMP_DIR}" 
    fi 
    
    # ============================================================================

    echo "Copy Files ..." 
    # google repo config, jq(json query tool) and pandas vpn 
    # rsync -P cmdTools/* "${CUSTOME_BIN_DIR}" 
    # rsync -P shellScript/* "${CUSTOME_BIN_DIR}" 
    
    # create bash_aliases 
    if [ ! -f "${BASH_ALIASES_FILE}" ]; then 
        touch "${BASH_ALIASES_FILE}" 
    fi 

    # .bashrc 
    if [ ! -f "${BASHRC_FILE}" ]; then 
        touch "${BASHRC_FILE}" 
    fi 

    # .profile 
    if [ ! -f "${PROFILE_FILE}" ]; then 
        touch "${PROFILE_FILE}" 
    fi 

}

# git config 
git_config () {
    # https://git-scm.com/ for windows 

    git --version 
    if [ $? -eq 0 ]; then 
        echo "Git is Installed ~" 
    else 
        echo "Git is not installed ! installing..." 
        sudo apt install -y git 
    fi 

}

# vim config 
vim_config () { 
    
    if [ ! -d "~/.vim" ]; then 
        echo "~/.vim for vim editor configs, creating ..." 
        mkdir -p ~/.vim 
        mkdir -p ~/.vim/colors 
        mkdir -p ~/.vim/bundle  # not must 
    fi 

    # check vim is installed ? 
    vim --version 
    if [ $? -eq 0 ]; then 
        echo "Vim is Installed ~" 
    else 
        echo "Vim is not installed ! installing..." 
        sudo apt install -y vim 
        # or install neovim with command : sudo apt install -y neovim 
    fi 

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim 
    # mkdir ~/.vim/colors 
    rsync -P vim/molokai.vim ~/.vim/colors/ 
    rsync -P vim/.vimrc ~/.vimrc 

}

java_config () {
    # java basic configuration 
    java --version 
    if [ $? -eq 0 ]; then 
        echo "Java is Installed ~" 
    else 
        echo "Java is not installed ! installing..." 

        read -p "Please input Java version 8? 17? or other jdk version ?\n" jdk_version 
        jdk_version="${jdk_version:-17}" 
        sudo apt install -y "openjdk-${jdk_version}-jdk openjdk-${jdk_version}-source openjdk-${jdk_version}-doc" 
    fi 

}

ant_config () {
    # ant java build tool https://ant.apache.org/ 
    ant -version 
    if [ $? -eq 0 ]; then 
        echo "apache ant is installed !" 
    else 
        echo "can not found ant, downloading and into bin PATH..." 

        apache_ant_file="apache_ant_bin_1.10.12.tar.gz" 
        wget -O "${TMP_DIR}/${apache_ant_file}" https://dlcdn.apache.org//ant/binaries/apache-ant-1.10.12-bin.tar.gz 

        tar -xf "${TMP_DIR}/${apache_ant_file}" -C "${CUSTOME_BIN_DIR}" 

        # may be should config Path 
        # export PATH="${CUSTOME_BIN_DIR}/ant_bin_xxx/bin:${PATH}" 
        # issue : can not get the real folder name and director structure/tree 

    fi 

}

maven_config () {

    mvn --version 
    if [ $? -eq 0 ]; then 
        echo "maven dev env ok, skip..." 
    else 
        echo "mvn path not config, downloading and config PATH ..." 

        # maven compile tool install process 
        maven_bin_file="maven_385_bin.tar.gz" 

        wget -O "${TMP_DIR}/${maven_bin_file}" https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz 
        # untar to bin folder 
        tar -xf "${TMP_DIR}/${maven_bin_file}" -C "${CUSTOME_BIN_DIR}" 

        # maven bin -> PATH 
    fi 

}

gradle_config () {

    gradle --version 
    if [ $? -eq 0 ]; then 
        echo "gradle dev env OK, skip --" 
    else 

        echo "gradle env not found, will download gradle bin and put it in ${CUSTOME_BIN_DIR}, please config PATH ..." 

        # gradle configuration 
        gradle_version="7.4.2" 
        read -p "Please input Gradle version (default = 7.4.2) ?\n" gradle_version 
        gradle_version="${gradle_version:-7.4.2}"

        gradle_bin_file="gradle_742_bin.zip" 
        wget -O "${TMP_DIR}/${gradle_bin_file}" https://services.gradle.org/distributions/gradle-${gradle_version}-bin.zip 

        unzip "${TMP_DIR}/${gradle_bin_file}" -d "${CUSTOME_BIN_DIR}" 

        # gradle bin -> PATH 
    fi 

}

go_config () {

    go version 
    if [ $? -eq 0 ]; then 
        echo "we had go ! nothing to do --" 
    else 
        echo "go env not atached, will download go bin and config ~"

        # go program language env 
        golang_bin_file="golang_1.18_bin.tar.gz" 
        wget -O "${TMP_DIR}/${golang_bin_file}" https://golang.google.cn/dl/go1.18.linux-amd64.tar.gz 

        tar -xf "${TMP_DIR}/${golang_bin_file}" -C "${CUSTOME_BIN_DIR}" 
    fi 

}

kotlin_config () {
    # kotlin compile tools config 
    # kotlin github page => kotlin tools for commandline compile 
    kotlinc-native -version 
    if [ $? -eq 0 ]; then 
        echo "kotlin compiler in PATH, all right." 
    else 
        echo "kotlin compiler tools will put it in ${CUSTOME_BIN_DIR}, please check later..." 

        kotlin_compile_bin_file="kotlinc_bin_1.6.20.tar.gz" 
        wget -O "${TMP_DIR}/${kotlin_compile_bin_file}" https://github.com/JetBrains/kotlin/releases/download/v1.6.20/kotlin-native-linux-x86_64-1.6.20.tar.gz 

        tar -xf "${TMP_DIR}/${kotlin_compile_bin_file}" -C "${CUSTOME_BIN_DIR}" 

    fi 


}

kotlin_interactive_config () {
    # kotlin interactive tools config 
    echo "dont't install ki now, if need, get it from https://github.com/Kotlin/kotlin-interactive-shell ..." 
}

julia_config () {
    # julia, a new program language env, for  science 
    julia --version 
    if [ $? -eq 0 ]; then 
        echo "julia exist ! do nothing--" 
    else 
        echo "will download julia bin and get julia env..." 

        julia_bin_file="julia_bin_1.6.6.tar.gz" 
        wget -O "${TMP_DIR}/${julia_bin_file}" https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.6-linux-x86_64.tar.gz 

        tar -xf "${TMP_DIR}/${julia_bin_file}" -C "${CUSTOME_BIN_DIR}" 
    fi 



}

rust_config () {
    # https://www.rust-lang.org/  rust 
    # cargo -> rust pacage manager 

    rustc --version  # or cargo --version 
    if [ $? -eq 0 ]; then 
        echo "Rust is Installed ~" 
    else 
        echo "Rust is not installed ! installing..." 

        # should in home folder !!!!!!!!!!!!!!!!!!!
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh 
    fi 

    # check rustc  and more usage tutorials 
    # https://www.rust-lang.org/learn/get-started 

}

lua_config () {
    # lua program env 

    lua -v 
    if [ $? -eq 0 ]; then 
        echo "found lua installed ! " 
    else 
        echo "download lua and config PATH ..." 

        lua_bin_file="lua_bin_5.4.4.tar.gz" 
        wget -O "${TMP_DIR}/${lua_bin_file}" http://www.lua.org/ftp/lua-5.4.4.tar.gz 
        
        tar -xf "${TMP_DIR}/${lua_bin_file}" -C "${CUSTOME_BIN_DIR}" 

        # need config PATH 
    fi 

}

nodejs_config () {
    # nodejs 
    node --version 
    if [ $? -eq 0 ]; then 
        echo "nodejs hadget echo : $?" 
    else 
        echo "nodejs shold download and config PATH, nodejs used for js server ~~~" 

        node_bin_file="node_bin_16.14.2.tar.xz" 
        wget -O "${TMP_DIR}/${node_bin_file}" https://nodejs.org/dist/v16.14.2/node-v16.14.2-linux-x64.tar.xz 

        tar -xf "${TMP_DIR}/${node_bin_file}" -C "${CUSTOME_BIN_DIR}" 
    fi 

}

mysql_config () {
    # mysql database config 
    mysql --version 
    if [ $? -eq 0 ]; then 
        echo "mysql is installed !"
    else 

        # mysql or mariadb ? https://mariadb.org/ 
        read -p "are u really want install mysql ? y/n\n" is_want_mysql 
        is_want_mysql="${is_want_mysql:-n}" # default no 
        echo "recheck input, is want have mysql ? ${is_want_mysql}" 

        if [ "${is_want_mysql}" == "y" ]; then 
            echo "mysql canbe installed, installing..." 
            sudo apt install -y mysql-server 
        else 
            echo "mysql skiped, install later/manually......" 
            echo "maybe mariadb is better choise ? !" 
        fi 

    fi 
    
}

postgresql_config () {
    # postgresql database install and config 
    psql --version 
    if [ $? -eq 0 ]; then 
        echo "postgresql had installed" 
    else 
        echo "posgresql not found, install postgresql..." 
        sudo apt install postgresql postgresql-contrib 
    fi 

}

redis_config () {
    # redis config 
    
    # here install direct from package manager 
    # other way is installed from source : https://redis.io/docs/getting-started/installation/install-redis-from-source/ 
    redis-server --version 
    if [ $? -eq 0 ]; then 
        echo "redis server exist already !" 
    then 

        read -p "build from source or install directly (select source need u install manually~) ? y=source/n=directly\n" from_source 
        from_source="${from_source:-n}" # default no 
        echo "recheck input, is want have mysql ? ${from_source}" 

        if [ "${from_source}" == "y" ]; then 
            echo "please reference : https://redis.io/docs/getting-started/installation/install-redis-from-source/" 
            
            redis_source_file="redis_bin_stable.tar.gz" 
            whet -O "${TMP_DIR}/${redis_source_file}" https://download.redis.io/redis-stable.tar.gz 
            tar -xf "${TMP_DIR}/${redis_source_file}" -C "${CUSTOME_OTHER_ENV_DIR}" 
        else 
            echo "redis not found ! installing..." 
            sudo apt install redis 
        fi 

    fi 

}

activeMQ_config () {
    # message queue activeMQ install and config 
    echo "skip active Message Queue install process... \nor if u want, please download from [https://activemq.apache.org/] !" 
}

zookeeper_config () {
    # zookeeper basic config  https://zookeeper.apache.org/ 

    zookeeper_bin_file="zookeeper_bin_3.8.0.tar.gz" 
    wget -O "${TMP_DIR}/${zookeeper_bin_file}" https://dlcdn.apache.org/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz 

    tar -xf "${TMP_DIR}/${zookeeper_bin_file}" -C "${CUSTOME_OTHER_ENV_DIR}" 

    # usage offical doc : https://zookeeper.apache.org/doc/current/index.html 
}

kafka_config () {
    # kafka config  https://kafka.apache.org/ 
    kafka_bin_file="kafka_bin_2.12_310.tgz" 
    wget -O "${TMP_DIR}/${kafka_bin_file}" https://dlcdn.apache.org/kafka/3.1.0/kafka_2.12-3.1.0.tgz 

    tar -xf "${TMP_DIR}/${kafka_bin_file}" -C "${CUSTOME_OTHER_ENV_DIR}" 

}

nginx_config () {
    # if necessary, install nginx by apt-get 
    echo "skiped nginx install procedure... not must" 
}

main () { 
    basic_tools_check 
    files_copy_and_check 

    git_config 
    vim_config 
    java_config 
    ant_config 
    maven_config 
    gradle_config 
    go_config 
    kotlin_config 
    kotlin_interactive_config 
    julia_config 
    lua_config 
    nodejs_config 
    mysql_config 
    postgresql_config 
    redis_config 
    activeMQ_config 
    zookeeper_config 
    kafka_config 
    nginx_config 
    
}

main 

```

## service manager script

> 服务一键启动, 多服务环境运行脚本, 待优化  

```shell
#! /bin/bash  -x 

# lua ruby 
# mysql nginx redis  postgresql 
# zookeeper  activemq  kafka 

MYSQL=mysql.service  #  sudo mysql |  mysql -h localhost -u wangyulong -P 3306 -p'wang510510,' 
POSTGRE=postgresql.service   # sudo -u -i postgres psql 
REDIS=redis-server.service  # sudo redis-cli 
NGINX=nginx.service  # sudo nginx 

mysql_client() {
    echo "connect mysql cient. 1 check mysql service, 2 start mysql client"
    if [[ $(is_active ${MYSQL}) ]]; then 
        echo "mysql is running..."
    else 
        start_service ${MYSQL}
    fi 

    mysql -h localhost -u wangyulong -P 3306 -p'wang510510,'
}

postgre_client() {
    echo "connect to postgresql service" 
    sudo -u -i postgres psql 
}

service_pid() { # running pid   判断是否正在运行, 运行中会有运行中的pid = process id
    pgrep -f ${1} # 2> /dev/null
}

running() {
    rpid "$1" &> /dev/null
}

rpid() {
    pgrep -f "$1" 2> /dev/null
}

is_active() {
    # for test function 
    echo $(service_pid ${1} )
    echo $(running ${1} )
    echo $(rpid ${1} )
    echo "======================================="

    active_status=$(systemctl is-active ${1}) 
    status=1 
    #  active   inactive 
    case ${active_status} in 
        active)
            echo "the ${1} is active"
            status=0
            ;;
        inactive)
            echo "the ${1} is not active"
            status=1
            ;;
        *)
            echo "ERROR : ${active_status}" 
            exit 1 
    esac
    return ${status} 
}

start_service() { # start_service <service_name>

    echo "prog name : ${1}"

    check_active=$(is_active ${1})    

    if [[ ${check_active} ]]; then 
        echo "service is running, do nothing"
        return 
    else 
        echo "prepare start service ${1}"
        systemctl start ${1} 
    fi 
}

stop_service() { # stop_service <service_name>

    check_active=$(is_active ${1})

    if [[ ${check_active} ]]; then 
        systemctl stop ${1} 
        return 
    else 
        echo "service ${1} is not running, do nothing" 
        return 
    fi 
}

status_service() {  # status_service <service_name>
    test=$(is_active ${1})

    if [[ ${test} ]]; then 
        printf "is active"
    else 
        printf "is not active, inactive"
    fi 

    status_message=$(sudo systemctl status ${1}) 
    echo "service ${1} running message..."
    echo "${status_message}" 
}

usage() {
    printf "this is service manager tool, please use it like : serviceManager <service_name> <[start | stop | status]>\n" 
    return 
}

service_manager() { 
    echo "base prog path : ${0}"

    if [[ $# -lt 2 ]]; then 
        echo "please use right command" 
        usage 
        exit 1 
    fi 

    echo "params : $*"

    local service_name=${MYSQL}
    
    case ${1} in 
        mysql)
            service_name=${MYSQL}
            ;;
        postgre*)
            service_name=${POSTGRE}
            ;;
        redis)
            service_name=${REDIS}
            ;;
        nginx)
            service_name=${NGINX}
            ;;
        *)
            echo "program name is invalid !!! please select [mysql | postgre | redis | nginx]" 
            echo "service name : ${1}, and service command : ${2}" 

            usage 
            exit 1 
            ;;
    esac 
    
    case ${2} in 
        start)
            start_service ${service_name} ${2} 
            ;;
        stop)
            stop_service ${service_name} ${2} 
            ;;
        status)
            status_service ${service_name} ${2}  
            ;;
        *)
            echo "ERROR : invalid command !" 
            echo "service name : ${1}, and service command : ${2}" 

            usage 
            exit 1 
            ;;
    esac 
}

service_manager $@ 

```

## vim configurations 

> vim 基础配置

```shell
" about molokai theme  
" colorscheme molokai 
" let g:molokai_original = 1 
" let g:molokai_original = 1 

let g:rehash256 = 1 

let g:rainbow_active = 1 

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible
" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on
" Enable plugins and load plugin for the detected file type.
filetype plugin on
" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on 
" Add numbers to each line on the left-hand side.
set number 
" Highlight cursor line underneath the cursor horizontally.
set cursorline
" Highlight cursor line underneath the cursor vertically.
set cursorcolumn
" Set shift width to 4 spaces.
set shiftwidth=4
" Set tab width to 4 columns.
set tabstop=4
" Use space characters instead of tabs.
set expandtab
" Do not save backup files.
set nobackup
" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10
" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap
" While searching though a file incrementally highlight matching characters as you type.
set incsearch
" Ignore capital letters during search.
set ignorecase
" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase
" Show partial command you type in the last line of the screen.
set showcmd
" Show the mode you are on the last line.
set showmode
" Show matching words during a search.
set showmatch
" Use highlighting when doing a search.
set hlsearch
" Set the commands to save in history default number is 20.
set history=1000 
" Enable auto completion menu after pressing TAB.
set wildmenu
" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest
" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx 


" STATUS LINE ------------------------------------------------------------
" Clear status line when vimrc is reloaded.
set statusline=
" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R
" Use a divider to separate the left side from the right side.
set statusline+=%=
" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%
" Show the status on the second to last line.
set laststatus=2

```

## python mail script

```python
#! /usr/bin/env python3 
# -*- coding: utf-8 -*-

# This little project is hosted at: <https://gist.github.com/1455741>
# Copyright 2011-2020 Álvaro Justen [alvarojusten at gmail dot com]
# License: GPL <http://www.gnu.org/copyleft/gpl.html>

import os 
import datetime 
import smtplib 
from email.mime.multipart import MIMEMultipart 
from email.mime.base import MIMEBase 
from email.mime.text import MIMEText 
from email.header import Header 
from email import encoders  
from mimetypes import guess_type 
import argparse 

class Email(object):
    def __init__(self, from_, to, subject, 
                message, message_type='plain', message_encoding='utf-8', 
                cc=None, attachments=None ):
        self.email = MIMEMultipart()
        self.email['From'] = self.get_email(from_)  # formated  name:<email_addr>
        self.email['To'] = self.get_email(to)  # formated   name:<email_addr>
        self.email['Subject'] = Header(subject, message_encoding)
        if cc is not None : 
            self.email['Cc'] = self.get_email(cc)
        text = MIMEText(message, message_type, message_encoding)
        self.email.attach(text)
        if attachments is not None:
            for filename in attachments:
                mimetype, file_encoding = guess_type(filename) 
                if mimetype == None : 
                    mimetype = "text/plain" 
                mimetype = mimetype.split('/', 1)
                fp = open(filename, 'rb')
                attachment = MIMEBase(mimetype[0], mimetype[1])
                attachment.set_payload(fp.read())
                fp.close()
                encoders.encode_base64(attachment)
                attachment.add_header('Content-Disposition', 'attachment',
                                      filename=os.path.basename(filename))
                self.email.attach(attachment)

    def get_email(self, email):
        if '<' in email:
            data = email.split('<')
            email = data[1].split('>')[0].strip()
        return email.strip()
    
    def __str__(self):
        return self.email.as_string()

class EmailConnection(object):
    def __init__(self, server, username, password):
        if ':' in server:
            data = server.split(':')
            self.server = data[0]
            self.port = int(data[1])
        else:
            self.server = server
            self.port = 25
        self.username = username
        self.password = password
        self.connect()

    def connect(self):
        self.connection = smtplib.SMTP(self.server, self.port)
        self.connection.ehlo()
        self.connection.starttls()
        self.connection.ehlo()
        self.connection.login(self.username, self.password)

    def send(self, email_obj):
        from_ = email_obj.email['From']   # if param is Email class obj, always run to here 
        print("from email address : ", from_)  
        if 'Cc' not in email_obj.email : 
            email_obj.email['Cc'] = ''
        to_emails = email_obj.email['To'].split(',') + email_obj.email['Cc'].split(',')  # function equals a_list.append(b_list) 
        print("email To : ", email_obj.email['To'].split(','))
        print("email Cc : ", email_obj.email['Cc'].split(','))
        print("to mail address combine : ", to_emails)
        to = [x_mail for x_mail in to_emails]
        message = str(email_obj)

        return self.connection.sendmail(from_, to, message)

    def close(self):
        self.connection.close()

if __name__ == "__main__" : 

    parser = argparse.ArgumentParser( 
                description="send email with custome parameters", 
                prog="email sender", 
                formatter_class=argparse.ArgumentDefaultsHelpFormatter 
            ) 
    parser.add_argument("-fn", "--sender_name", dest="arg_from_name", help="set sender user name", default="wangyulong") 
    parser.add_argument("-fa", "--from_mail_address", dest="arg_from_mail_addr", help="set sender mail address, must and just one", required=True) 
    parser.add_argument("-fp", "--from_mail_password", dest="arg_from_mail_pwd", help="set sender mail password", required=True) 
    parser.add_argument("-sn", "--mail_server", dest="arg_mail_server", help="set mail service server name", default="mail.xiaomi.com") 
    parser.add_argument("-sp", "--mail_server_port", dest="arg_mail_server_port", type=int, help="set mail service server port", default=25) 
    parser.add_argument("-rn", "--reciver_name", dest="arg_to_name", help="set reciver user name", default="wangyulong") 
    parser.add_argument("-ta", "--to_mail_address", dest="arg_to_mail_addr", help="set reciver mail address, can separated by comma", required=True)
    parser.add_argument("-tc", "--to_mail_cc_address", dest="arg_cc_mail_addr", help="set mail carbon copy address, can separated by comma", default="") 
    parser.add_argument("-ms", "--email_subject", dest="arg_mail_subject", help="set email subject", default="None") 
    parser.add_argument("-mc", "--email_content", dest="arg_mail_content", help="set email content", default="None") 
    parser.add_argument("-x", "--attachements", dest="arg_atach_files", nargs="+", help="set email attachements file path, separated by semicolon, please use absolute file path !") 
    args = parser.parse_args() 

    if args.arg_from_name is not None : 
        from_name = args.arg_from_name 
    if args.arg_mail_server is not None : 
        mail_server = args.arg_mail_server 
    from_mail_addr = args.arg_from_mail_addr 
    from_mail_pwd = args.arg_from_mail_pwd 
    if args.arg_mail_server_port is not None : 
        server_port = args.arg_mail_server_port 
    if args.arg_to_name is not None : 
        to_name = args.arg_to_name 
    to_mail_addr = args.arg_to_mail_addr 
    if args.arg_cc_mail_addr is not None : 
        cc_email = args.arg_cc_mail_addr 
    if args.arg_mail_subject is not None : 
        mail_subject = args.arg_mail_subject 
    if args.arg_mail_content is not None : 
        mail_content = args.arg_mail_content 
    attachments = []
    if args.arg_atach_files is not None :   # nargs can set multi params
        for x in args.arg_atach_files : 
            attachments.append(x) 
    
    print("files combine result : ", attachments) 

    print('Connecting to server...')
    server = EmailConnection(server=mail_server, username=from_mail_addr, password=from_mail_pwd)
    print('Preparing the email...')
    email = Email(from_='%s:<%s>' % (from_name, from_mail_addr), to='%s:<%s>' % (to_name, to_mail_addr),
                cc=cc_email, subject=mail_subject, message=mail_content, attachments=attachments )
    print('Sending...')
    server.send(email_obj=email)
    print('Disconnecting...')
    server.close()
    print('Done!')

```
