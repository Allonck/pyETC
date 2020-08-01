#!/bin/bash
#
# Install pyETC and dependencies using Conda

# install miniconda
if ! which conda 1> /dev/null; then
    if test ! -f ${HOME}/miniconda/etc/profile.d/conda.sh; then
        # install conda
        #[ "$(uname)" == "Darwin" ] && MC_OSNAME="MacOSX" || MC_OSNAME="Linux" || MC_OSNAME="Windows"
	echo "$TRAVIS_OS_NAME";
	if "$TRAVIS_OS_NAME" == "windows"; then
		MC_OSNAME="Windows"
	elif "$TRAVIS_OS_NAME" == "linux"; then
                MC_OSNAME="Linux"
	elif "$TRAVIS_OS_NAME" == "osx"; then
                MC_OSNAME="MacOSX"
        fi
	echo "$MC_OSNAME";

        MINICONDA="Miniconda${PYTHON_VERSION%%.*}-latest-${MC_OSNAME}-x86_64.sh"
        curl -L https://repo.continuum.io/miniconda/${MINICONDA} -o miniconda.sh
        #bash miniconda.sh -b -u -p ${HOME}/miniconda
	if $MC_OSNAME="Windows"; then
	    start /wait "" Miniconda3-latest-Windows-x86_64.exe /InstallationType=JustMe /RegisterPython=0 /S /D=C:\Users\Administrator\miniconda3
	else
            bash miniconda.sh -b -p ${HOME}/miniconda
	fi
    fi
    source "$HOME/miniconda/etc/profile.d/conda.sh"
fi
hash -r

# get CONDA base path
CONDA_PATH=$(conda info --base)

# configure miniconda
conda config --set always_yes yes --set changeps1 no
conda config --add channels conda-forge
conda update --quiet --yes conda
conda info --all

# create environment for tests (if needed)
if [ ! -f ${CONDA_PATH}/envs/pyETC/conda-meta/history ]; then
    conda create --name pyETC python=${PYTHON_VERSION} pip setuptools
fi

# install conda dependencies (based on pip requirements file)
conda run --name pyETC \
conda install --name pyETC --quiet --yes --file requirements_dev.txt --update-all

# install other conda packages that aren't represented in the requirements file
#conda install --name gwpyci --quiet --yes \
#    "python-framel>=8.40.1" \
#    "python-lal" \
#    "python-lalframe" \
#    "python-lalsimulation" \
#    "python-ldas-tools-framecpp" \
#    "python-nds2-client" \
#    "root>=6.20" \
#    "root_numpy" \
#;

# activate the environment
. ${CONDA_PATH}/etc/profile.d/conda.sh
conda activate pyETC
