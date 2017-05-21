#!/bin/bash

set -ef -o pipefail

echo BUILDING GAP2SEQ bldvar 1
echo uname is:
uname -a
echo env is:
env
echo ======================================== end of env =================================

if [ -z "$CPPFLAGS" ]; then export CPPFLAGS=""; fi
if [ -z "$LDFLAGS" ]; then export LDFLAGS=""; fi

export CPPFLAGS="$CPPFLAGS -I${PREFIX}/include"
export LDFLAGS="$LDFLAGS -L${PREFIX}/lib"

mkdir -p build
pushd build

mkdir -p $PREFIX/bin

if [ "$(uname)" == "Darwin" ]; then
    # c++11 compatibility

		if [ -z "$CXXFLAGS" ]; then export CXXFLAGS=""; fi
		if [ -z "${CXX_FLAGS}" ]; then export CXX_FLAGS=""; fi
		if [ -z "${CMAKE_CXX_FLAGS}" ]; then export CMAKE_CXX_FLAGS=""; fi
		if [ -z "${LDFLAGS}" ]; then export LDFLAGS=""; fi
		if [ -z "${LD_FLAGS}" ]; then export LD_FLAGS=""; fi
		if [ -z "${CMAKE_LD_FLAGS}" ]; then export CMAKE_LD_FLAGS=""; fi

		CXXFLAGS="$CXXFLAGS";
		LDFLAGS="$LDFLAGS -Wl,-rpath ${PREFIX}/lib";

    export CXXFLAGS="$CXXFLAGS -stdlib=libc++ -std=c++11 -I${PREFIX}/include "
    export CXX_FLAGS="${CXX_FLAGS} -stdlib=libc++ -std=c++11 -I${PREFIX}/include "
    export CMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -stdlib=libc++ -std=c++11 -I${PREFIX}/include "
    export LDFLAGS="$LDFLAGS -stdlib=libc++"
    export LD_FLAGS="${LD_FLAGS} -stdlib=libc++"
    export CMAKE_LDFLAGS="${CMAKE_LDFLAGS} -stdlib=libc++"

    export CXX=clang++
    export CC=clang
fi


cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DBoost_NO_BOOST_CMAKE=TRUE -DBoost_NO_SYSTEM_PATHS=TRUE -DBOOST_ROOT:PATHNAME=$PREFIX -DBoost_LIBRARY_DIRS:FILEPATH=${PREFIX}/lib ${SRC_DIR}
make Gap2Seq GapCutter GapMerger
chmod u+x Gap2Seq.sh
echo copying files: Gap2Seq.sh Gap2Seq GapCutter GapMerger $PREFIX/bin
cp Gap2Seq.sh Gap2Seq GapCutter GapMerger $PREFIX/bin
popd
