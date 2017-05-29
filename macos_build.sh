#!/bin/sh
DEPS_DIR=/tmp/OpenSubdiv/deps
mkdir -p $DEPS_DIR/src
pushd $DEPS_DIR/src

#--- CMake ---
echo 'Fetching CMake'
curl -o cmake-3.8.0.tar.gz -L -C - https://cmake.org/files/v3.8/cmake-3.8.0.tar.gz
tar zxf cmake-3.8.0.tar.gz
pushd cmake-3.8.0
./configure --prefix=$DEPS_DIR
make -j8
make install
popd #cmake-3.8.0

CMAKE=$DEPS_DIR/bin/cmake

#--- GLFW ---
echo 'Fetching GLFW'
curl -o glfw.zip -L -C - https://github.com/glfw/glfw/releases/download/3.2.1/glfw-3.2.1.zip
unzip -u glfw.zip
rm temp.zip
pushd glfw-3.2.1
mkdir -p build
pushd build
$CMAKE ..
make DESTDIR=$DEPS_DIR -j8 install
popd #build
popd #glfw-3.2.1

popd #$DEPS_DIR/src
echo 'Building OSD'
mkdir -p build
pushd build
$DEPS_DIR/bin/cmake -D CMAKE_INSTALL_PREFIX="`pwd`" -D NO_PTEX=1 -D NO_DOC=1 -D NO_OMP=1 -D NO_TBB=1 -D NO_CUDA=1 -D NO_OPENCL=0 -D NO_CLEW=1 -D GLFW_LOCATION=$DEPS_DIR/usr/local -D GLFW_INCLUDE_DIR=$DEPS_DIR/usr/local/include ..
make
make install
popd #build

