#!/bin/bash

run() {
	echo -e "\033[1;34m--- INSTALLATION ---\033[0m"
	if [ -x /usr/local/bin/k3d ] && \
		[ -x /usr/local/bin/kubectl ] && \
		[ -x /usr/bin/docker ]
	then
		echo "Everything seem to be already installed, skipping installation."
	else
		bash scripts/installation.sh
	fi

	echo -e "\033[1;34m--- SETUP ---\033[0m"
	if [ -x /usr/local/bin/k3d ] && \
		[ -x /usr/local/bin/kubectl ] && \
		[ -x /usr/bin/docker ]
	then
		echo "Everything seem to be already installed, skipping installation."
	else
		bash scripts/installation.sh
	fi
}

stop() {
	k3d cluster delete bonus
	rm argoCD.password
	rm gitlab.password
}

clean() {
	apt-get remove -y docker-ce docker-ce-cli containerd.io \
		docker-buildx-plugin docker-compose-plugin
	
}

if [ -z "$1" ]
then
	select option in run stop clean
	do
		case $lng in
			"run")
				run;;
			"stop")
				stop;;
			"clean")
				echo test;;
			*)
			echo "Choose from: run/stop/clean";;
		esac
	done
else
	case $1 in
		"run")
			run;;
		"stop")
			stop;;
		"clean")
			echo test;;
		*)
		echo "Choose from: run/stop/clean"; exit 1;
	esac
fi