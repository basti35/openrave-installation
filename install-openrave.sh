#!/bin/bash
#
# Authors:
#   Francisco Suarez <fsuarez6.github.io>
#
# Description:
#   OpenRAVE Installation Script

source `dirname "$0"`/include-me.sh

REPO_FOLDER=$HOME/Documenti/proj/mix/repos
REPO_DEPS=${REPO_FOLDER}/deps
REPO_INCLUDE=${REPO_DEPS}/include
REPO_LIB=${REPO_DEPS}/lib
REPO_LIB64=${REPO_DEPS}/lib64
export PATH=${PATH}:${REPO_FOLDER}/deps
export OSGDIR=${REPO_FOLDER}/deps

# Check ubuntu version
UBUNTU_VER=$(lsb_release -sr)
if [ ${UBUNTU_VER} != '14.04' ] && [ ${UBUNTU_VER} != '16.04' ] && [ ${UBUNTU_VER} != '18.04' ] \
  && [ ${UBUNTU_VER} != '20.04' ]; then
    echo "ERROR: Unsupported Ubuntu version: ${UBUNTU_VER}"
    echo "  Supported versions are: 14.04, 16.04, 18.04, and 20.04"
    exit 1
fi

# Sympy version 0.7.1
echo ""
echo "Downgrading sympy to version 0.7.1..."
echo ""
pip install --upgrade --user sympy==0.7.1

# OpenRAVE
if [ ${UBUNTU_VER} = '14.04' ] || [ ${UBUNTU_VER} = '16.04' ]; then
	RAVE_COMMIT=7c5f5e27eec2b2ef10aa63fbc519a998c276f908
	echo ""
	echo "Installing OpenRAVE 0.9 from source (Commit ${RAVE_COMMIT})..."
	echo ""
	mkdir -p ${REPO_FOLDER}; cd ${REPO_FOLDER}
	git clone https://github.com/rdiankov/openrave.git
elif [ ${UBUNTU_VER} = '18.04' ] || [ ${UBUNTU_VER} = '20.04' ]; then
	RAVE_COMMIT=2024b03554c8dd0e82ec1c48ae1eb6ed37d0aa6e
	echo ""
	echo "Installing OpenRAVE 0.53.1 from source (Commit ${RAVE_COMMIT})..."
	echo ""
	mkdir -p ${REPO_FOLDER}; cd ${REPO_FOLDER}
	git clone -b production https://github.com/rdiankov/openrave.git
fi
cd openrave; git reset --hard ${RAVE_COMMIT}
mkdir build; cd build
if [ ${UBUNTU_VER} = '14.04' ] || [ ${UBUNTU_VER} = '16.04' ]; then
  	cmake -DODE_USE_MULTITHREAD=ON -DOSG_DIR=/usr/local/lib64/ ..
elif [ ${UBUNTU_VER} = '18.04' ] || [ ${UBUNTU_VER} = '20.04' ]; then
    cmake -DODE_USE_MULTITHREAD=ON -DUSE_PYBIND11_PYTHON_BINDINGS:BOOL=TRUE -DBoost_NO_BOOST_CMAKE=1 -DRAPIDJSON_ROOT_DIR=${REPO_FOLDER}/deps -DOSG_DIR=${REPO_FOLDER}/deps -DCMAKE_INSTALL_PREFIX=${REPO_FOLDER}/deps -Wno-dev -DOpenSceneGraph_DEBUG=TRUE -DOSG_ROOT=${REPO_FOLDER}/deps\
    -DOSGDB_INCLUDE_DIR=${REPO_INCLUDE} -DOSGDB_LIBRARY=${REPO_LIB64} \
    ..
fi
exit
make -j `nproc`
#sudo make install
