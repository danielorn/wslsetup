#!/usr/bin/env bash

function indent()
{
	[[ $# -gt 0 ]] && echo -E "${@}" | indent && return

	local line
	while IFS= read -r line; do
		printf "  %s\n" "${line}"
	done
}

function h1() {
	printf "\n################################################################################\n"
		printf " $1\n"
	printf "################################################################################\n"
}

function h2() {
	printf "\n## $1 ##\n"
}

function clear_guard()
{
	sed -i "\&$1&,\&$2&d" $3
}

append_config() {
	start_guard="####STARTWSLSETUP_$1_$2"
	end_guard="####ENDWSLSETUP_$1_$2"
	clear_guard $start_guard $end_guard $3
	sed -i "\&$start_guard&,\&$end_guard&d" $3
	echo -e "$start_guard" >> $3
	sudo cat $2 >> $3
	echo -e "\n$end_guard" >> $3
}

function runmodule() {
	module_name=$(basename $1)
	h1 "Running module $module_name in $1"

	if [ -d "$1/scripts" ]; then
		while IFS='' read filespec; do
			h2 "Running script ${filespec}" | indent
			(${filespec}) | indent | indent
		done < <(find "$1/scripts" -type f -name '*.sh' | sort)
	fi

	if [ -d "$1/bash_config" ]; then
		while IFS='' read filespec; do
			mkdir -p $HOME/.bash_config
			h2 "Copying bash_config" | indent
			echo "${filespec} > $HOME/.bash_config/${module_name}_$(basename ${filespec})" | indent | indent
			cp ${filespec} $HOME/.bash_config/${module_name}_$(basename ${filespec})
		done < <(find "$1/bash_config" -type f | sort)
	fi

	if [ -d "$1/bin" ]; then
		while IFS='' read filespec; do
			h2 "Copy binaries" | indent
			echo "${filespec} > $HOME/bin/$(basename ${filespec})" | indent | indent
			cp ${filespec} $HOME/bin/
			chmod +x $HOME/bin/$(basename ${filespec})
		done < <(find "$1/bin" -type f | sort)
	fi

	if [ -d "$1/ssh" ]; then
		mkdir -p $HOME/.ssh
		touch $HOME/.ssh/config
		chmod 600 $HOME/.ssh/config
		while IFS='' read filespec; do
			h2 "Appending config to .ssh/config" | indent
			echo "${filespec} >> $HOME/.ssh/config" | indent | indent
			append_config $(basename $1) ${filespec} $HOME/.ssh/config
		done < <(find "$1/ssh" -type f | sort)
	fi

	if [ -d "$1/hosts" ]; then
		while IFS='' read filespec; do
			h2 "Appending config to /c/Windows/System32/drivers/etc/hosts" | indent
			append_config $(basename $1) ${filespec} /c/Windows/System32/drivers/etc/hosts
		done < <(find "$1/hosts" -type f | sort)
	fi

}

function runall() {

	h1 "Copying dotfiles to home dir"
	if [ -d "dotfiles" ]; then
		while IFS='' read filespec; do
			echo "${filespec} > $HOME/$(basename ${filespec})" | indent
			cp ${filespec} $HOME/
		done < <(find "dotfiles/" -type f | sort)
	fi

	start_guard="####STARTWSLSETUP"
	end_guard="####ENDWSLSETUP"
	
	h1 "Clearing previus settings"

	h2 "Clearing /c/Windows/System32/drivers/etc/hosts" | indent
	clear_guard $start_guard $end_guard /c/Windows/System32/drivers/etc/hosts 2>&1 | indent | indent

	h2 "Clearing .ssh/config" | indent
	clear_guard $start_guard $end_guard $HOME/.ssh/config | indent | indent

	h2 "Removing $HOME/.bash_config" | indent
	while IFS='' read filespec; do
		echo "Removing ${filespec}" | indent | indent
		rm ${filespec}
	done < <(find "$HOME/.bash_config" -type f | sort)

	while IFS='' read filespec; do
		runmodule $filespec
	done < <(find "modules/" -maxdepth 1 ! -path modules/  -type d| sort)
}

function printinfo() {
	h1 "System Information" 
	echo "uname -a: $(uname -a)" | indent | indent
	echo "lsb_release -cs: $(lsb_release -cs)" | indent | indent
	h1 Environment | indent
	env | indent | indent
	(
		cd $(dirname "$0") | indent
		h1 Git | indent
		git show | indent | indent
		git status | indent | indent
	)
}

function backup() {
	files=($(find "dotfiles/" -type f | sed "s#dotfiles#$HOME#g") /c/Windows/System32/drivers/etc/hosts)
	folders=($HOME/.ssh $HOME/.bash_config $HOME/bin)

	backup_folder=$HOME/.wslbackup/$(date '+%Y%m%d%H%M%S')
	mkdir -p $backup_folder

	for file in "${files[@]}"; do
		filename=$(basename $file)
		h2 "Backing up $file to $backup_folder/$filename"
		cp $file $backup_folder/$filename
	done

	for folder in "${folders[@]}"; do
		foldername=$(basename $folder)
		h2 "Backing up $folder to $backup_folder/$foldername"
		cp -R $folder $backup_folder/
	done
}

mkdir -p logs
(
	printinfo

	h1 "Backing up"
	backup | indent

	if [ ${#@} -eq 0 ]; then
		runall
	else 
		for var in "$@"; do
			runmodule $var
		done
	fi
) | tee logs/log_$(date +%s).log