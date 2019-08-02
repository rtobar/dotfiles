#!/bin/bash

cdl() {

   dir="."
   if [ $# == 1 ]; then
      dir="$1"
   fi

   lastdir="$(find "$dir" -mindepth 1 -maxdepth 1 -type d -printf '%C@\0%f\n' | sort -t'\0' -n | tail --lines 1 | awk -F'\0' '{print $2}')"
   pushd "$dir/$lastdir"
}

#
# Virtual environment management
#

load_virtualenv() {
	if [ -z "${_VENVS_ROOT}" ]; then
		echo '_VENVS_ROOT not defined; edit your ~/.bash_env file and try again'
		return 1
	fi
	if [ -z "${_SCM_ROOT}" ]; then
		echo '_SCM_ROOT not defined; edit your ~/.bash_env file and try again'
		return 1
	fi
	source "${_VENVS_ROOT}/$1/bin/activate"
	if [ $# -lt 2 ]; then return; fi
	cd "${_SCM_ROOT}/$2"
	if [ $# -lt 3 ]; then return; fi
	export LD_LIBRARY_PATH="$VIRTUAL_ENV/lib:$LD_LIBRARY_PATH"
}

loadWIC() {
	load_virtualenv wic git/wic
}

loadNgas() {
	load_virtualenv ngas_devel3 git/ngas
}

loadNgas2() {
	load_virtualenv ngas_devel git/ngas
}

loadNgas3.7() {
	load_virtualenv ngas_devel3.7 git/ngas
}

loadARL() {
	load_virtualenv arl git/algorithm-reference-library
}

loadDlg2() {
	load_virtualenv dlg2 git/daliuge yes
}

loadDlg3.5() {
	load_virtualenv dlg3.5 git/daliuge yes
}

loadDlg3.7() {
	load_virtualenv dlg3.7 git/daliuge yes
}

loadDlg() {
	load_virtualenv dlg3 git/daliuge yes
}

loadDlgPbc() {
	load_virtualenv dlg_pbc git/daliuge-pbc
}

loadEagle() {
	load_virtualenv eagle git/EAGLE
}

loadPips() {
	load_virtualenv dlg-pips git/daliuge-pips
}

loadMWA() {
	load_virtualenv mwa_workshop
}

loadChiles02() {
	load_virtualenv aws-chiles02 git/aws-chiles02
}

loadSpead() {
	load_virtualenv spead git/spead2
}

loadIntegratedPrototype() {
	load_virtualenv integrated-prototype git/integration-prototype
}

loadPyprofit() {
	load_virtualenv profit git/pyprofit yes
}

loadPyprofit3() {
	load_virtualenv pyprofit3 git/pyprofit
}

loadAsap() {
	load_virtualenv asap git/asap
}

loadOskar() {
	load_virtualenv oskar git/OSKAR
}

loadJacal() {
	loadDlg
	cd ../jacal/apps/askap
}

loadShark() {
	load_virtualenv shark git/shark
}

loadAskapsoft() {
	cd ${_SCM_ROOT}/git/askapsoft/
	source initaskap.sh
}

loadPLAsTiCC() {
	load_virtualenv plasticc_2018 git/plasticc-kit
}

loadIjson() {
	load_virtualenv ijson git/ijson
}

#
# NGAS utilities: running/inspecting tests, counting LOCs, etc
#

_allNgasTests() {
	pip install -U pytest && \
	./build.sh -c -d && \
	files='-o python_files=\"*Test.py test_*.py\"'
	if [ -f 'test/__init__.py' ]; then cd 'test'; else cd src/ngamsTest/ngamsTest; fi && \
	if grep "def _to_abs" ngamsTestLib.py > /dev/null; then cd '..'; files=test; fi && \
	pytest --durations 0 $files --cov 2>&1 | tee ${_NGAS_TESTS_LOGS_DIR}/allTests-$(date +%Y%m%d-%H%M%S)-$(git rev-parse --abbrev-ref HEAD).log
}

allNgasTests() {
	loadNgas && _allNgasTests
}

allNgasTests2() {
	loadNgas2 && _allNgasTests
}

allNgasTests3.7() {
	loadNgas3.7 && _allNgasTests
}

lastNgasTest() {
	less ${_NGAS_TESTS_LOGS_DIR}/$(ls -atr --group-directories-first ~/icrar/ngas-tests/ | tail --lines 1)
}

_clocNgas() {
	loadNgas
	if [ "$1" = "yes" ]
	then
		plugins=src/ngamsPlugIns
	else
		plugins='src/ngamsPlugIns/ngamsPlugIns/*.py'
	fi
	shift

	lang_filter="--include-lang=Python,XML,SQL,C,C++,C/C++ Header,Bourne Again Shell"
	cloc "$lang_filter" --exclude-dir build "$@" src/ngamsCore/ src/ngamsPClient/ src/ngamsServer/ src/ngamsCClient $plugins
}

clocNgas() {
	_clocNgas no "$@"
}

clocAllNgas() {
	_clocNgas yes "$@"
}

grepNgas() {
	cd ${_SCM_ROOT}/git/ngas
	the_dirs="src"
	if [ -d 'test' ]; then the_dirs="$the_dirs test"; fi
	grep -RIin "$1" --exclude-dir build --include '*.py' --include '*.xml' $the_dirs
}

#
# Misc
#

build_and_check_r_package() {
	pkg=${1:-.}
	R CMD build $pkg
	fname=$(ls -atr *.tar.gz | tail --lines 1)
	R CMD check $fname --as-cran --no-manual
}

shark_evolved_galaxies_totals() {
	echo 'scale=4; '`sed -r -n 's/.*Evolved galaxies in ([0-9\.]+).* \[s\]/\1/p; s/.*Evolved galaxies in ([0-9\.]+).* \[ms\]/(\1. \/ 1000)/p' $1 | paste -s -d +` | bc
}

profit_docker() {
	cd ${_SCM_ROOT}/git/libprofit
	cp ~/icrar/profit/Dockerfile ~/icrar/profit/cmake-3.1.3-Linux-x86_64.sh ~/icrar/profit/do.sh .
	version=`cat VERSION`
	docker build -t icrar/libprofit:$version .
	rm Dockerfile cmake-3.1.3-Linux-x86_64.sh do.sh
}

appveyor_delete_cache() {
	project=$1
	if [ -z "$project" ]; then
		echo "Give me a project slug"
		return
	fi
	curl \
	    -H "Authorization: Bearer $APPVEYOR_TOKEN" \
	    -H "Content-Type: application/json" \
	    -X DELETE \
	    https://ci.appveyor.com/api/projects/rtobar/${project}/buildcache
}
