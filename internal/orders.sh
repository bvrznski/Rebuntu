#!/bin/bash
#──────────────────────────────────────────────────────────────────────────────────────────────────
# /INTERNAL/ORDERS.SH
#──────────────────────────────────────────────────────────────────────────────────────────────────
#
# INFO:
#
# ROLE:
#
# REALM:
#
# DOMAIN:
#
# LIST:
#
# DONE: ✓

#---------------------------------------

orders()
{
# Syntax:
#		 orders --imported
#
			___;

			if [ "${1}" = "--imported" ]
			then
				echo True
			fi
}

#---------------------------------------

acquire()
{
# Syntax: acquire --url <LINK> <DESTINATION>
#
		if [ "${1}" = "--url" ]
		then
			shift 1
			for url in $1;
			do
				for dst in $2;
				do
					if [ -d ${dst} ];
		    		then
						wget $url -O f.tar.xz;
		        		tar -xf f.tar.xz -C ${dst};
		        		rm -f f.tar.xz;
		    		else
						mkdir -p ${dst};
				        wget $url -O f.tar.xz;
				        tar -xf f.tar.xz -C ${dst};
				        rm -f f.tar.xz;
				    fi;
				done;
			done;
		fi
}

install()
{
# Syntax:
#		 install --file <FILE PATH>
#		 install --apt <PACKAGE>
#		 install --snap <PACKAGE>
#		 install --pip <PACKAGE>
#		 install --git <REPOSITORY>
#
		if [ "${1}" = "--from-file" ]
		then
			local FILE="${1##*/}"

			if [ "${FILE}" =  "apt" ]
			then
				while read line
				do
					install --apt "${line}"
				done < ${1}
			elif [ "${FILE}" =  "snap" ]
			then
				while read line
				do
					install --snap "${line}"
				done < ${1}
			elif [ "${FILE}" =  "ppa" ]
			then
				while read line
				do
					install --ppa "${line}"
				done < ${1}
			elif [ "${FILE}" =  "pip" ]
			then
				while read line
				do
					install --pip "${line}"
				done < ${1}
			elif [ "${FILE}" =  "git" ]
			then
				while read line
				do
					install --git "${line}"
				done < ${1}
			fi

		elif [ "${1}" = "--ppa" ]
		then
			shift 1
			for i in $@
			do
				sudo add-apt-repository -y ppa:${i};
				sudo apt-get update
			done;

		elif [ "${1}" = "--apt" ]
		then
			shift 1
			for i in $@
			do
				sudo apt-get build-dep -y ${i};
		        sudo apt-get install -y ${i};
			done;

		elif [ "${1}" = "--snap" ]
		then
			shift 1
			for i in $@;
			do
				sudo snap install ${i};
				if snap list | grep -qo "${i}"
				then
					true
				else
					sudo snap install ${i} --classic;
				fi
			done;

		elif [ "${1}" = "--pip" ]
		then
			shift 1
			for i in $@;
			do
				sudo pip3 install ${i};
			done;

		elif [ "${1}" = "--git" ]
		then
			shift 1
			for i in $@;
			do
				if [ -n ${GIT} ]
				then
					cd ${GIT}

					git clone ${2}

					local DIR="$(pwd)$(ls -tp | grep -v /$ | head -1)"

					cd ${DIR}

					if [ "$(pwd)" = "${DIR}" ]
					then
						if [ -e ./install.sh ]
						then
							sudo bash install.sh
						elif [ -e ./setup.py ]
						then
							sudo python3 setup.py install
						elif [ -e ./CMakeLists.txt ]
						then
						    mkdir build
						    cd build
						    cmake ..
						    make
						    sudo make install
						elif [ -e ./Makefile ]
						then
							sudo make
							sudo make install
						fi
					fi
				fi
			done
		fi
}

uninstall()
{
# Syntax:
#
#
		for i in $@
		do
			if apt list --installed | grep "${i}/" > /dev/null 2>&1;
	        then
				sudo apt-get purge -y ${i}
	        elif pip3 list | grep "${i}" > /dev/null 2>&1;
	        then
				sudo pip3 uninstall ${i};
	        elif snap list --all | grep "${i}"
	        then
				sudo snap remove $(snap list --all | grep "${i}" | awk '{print $1;}');
	        elif npm list -g --depth=0 | grep "${i}";
	        then
				npm uninstall ${i};
			fi
		done
}

#-------------------------------------------------------------------------------------------------#
############|                                                                      |              #
########|   |                                                                  	   |              #
#           #######################################################################|              #
#-------------------------------------------------------------------------------------------------#
