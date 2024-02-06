#!/bin/bash

if [ $(whoami) != root ]; then
	exit $(sudo bash "$0" $@)
fi

run() {
	echo -e "\033[1;34m--- INSTALLATION ---\033[0m"
	if which k3d && which kubectl &&
		which docker && which helm && which gitlab; then
		echo "Everything seem to be already installed, skipping installation."
	else
		bash scripts/installation.sh
	fi

	echo -e "\033[1;34m--- SETUP ---\033[0m"
	bash scripts/setup.sh
	echo 'OK'
}

stop() {
	k3d cluster delete bonus
	rm argoCD.password
	rm gitlab.password
	echo 'OK'
}

clean() {
	stop
	rm $(which helm)
	rm -rf ~/.config/helm
	rm -rf ~/.cache/helm
	rm -rf ~/.local/share/helm
	k3d cluster delete -a
	rm $(which k3d)
	rm $(which kubectl)
	rm -rf ~/.kube
	apt-get remove -y docker-ce docker-ce-cli containerd.io \
		docker-buildx-plugin docker-compose-plugin
	apt autoremove -y
}

if [ -z "$1" ]; then
	PS3="> "
	select option in run port stop clean; do
		echo $option
		case $option in
		"run")
			run
			exit
			;;
		"port")
			bash scripts/port-forwarding.sh
			exit
			;;
		"stop")
			stop
			exit
			;;
		"clean")
			clean
			exit
			;;
		*)
			echo -e 'Choose from:\nrun (1)\nport (2)\nstop (3)\nclean (4)'
			;;
		esac
	done
else
	case $1 in
	"run")
		run
		exit
		;;
	"port")
		bash scripts/port-forwarding.sh
		exit
		;;
	"stop")
		stop
		exit
		;;
	"clean")
		clean
		exit
		;;
	*)
		echo "Choose from: run/port/stop/clean"
		exit 1
		;;
	esac
fi
