#!/bin/zsh

# Ensure that the user wants to make the changes to their device that this script will do.
CONTINUE=false

echo ""
echo "You are about to download, compile, and install stuff on your computer."
echo "Please read through the source script to know what is being done."
echo "Do you want to continue? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  # Bail if response is not yes
  echo "Exiting..."
  exit
fi

# Xcode Command Line Tools
echo "Checking if Xcode command line tools are installed..."
xcode-select -p
if [[ $? != 0 ]]; then
	xcode-select --install
fi

# Detect if homebrew is installed
echo "Checking if homebrew is installed and up-to-date..."
command -v brew
if [[ $? != 0 ]] ; then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	brew update
fi

# Build Variables
export TARGET=i686-elf
export PREFIX="$HOME/opt"
export PATH="$PREFIX/bin:$PATH"

# Create Our Directories
mkdir -p $HOME/src
mkdir -p $PREFIX

# Install Dependencies with Homebrew
brew install gmp mpfr libmpc autoconf automake

# binutils
echo ""
echo "Installing \`binutils\`"
echo ""
cd $HOME/src

if [ ! -d "binutils-2.25" ]; then
  curl http://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz > binutils-2.25.tar.gz
  tar xfz binutils-2.25.tar.gz

  rm binutils-2.25.tar.gz
  mkdir -p build-binutils
  cd build-binutils
  ../binutils-2.25/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
  make
  make install
fi

# gcc
cd $HOME/src

if [ ! -d "gcc-11.4.0" ]; then
  curl https://ftp.gnu.org/gnu/gcc/gcc-11.4.0/gcc-11.4.0.tar.xz > gcc-11.4.0.tar.gz
  tar xfz gcc-11.4.0.tar.gz

  rm gcc-11.4.0.tar.gz
  mkdir -p build-gcc
  cd build-gcc
  ../gcc-11.4.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --with-gmp=/opt/homebrew/Cellar/gmp/6.2.1_1 --with-mpfr=/opt/homebrew/Cellar/mpfr/4.2.0-p9 --with-mpc=/opt/homebrew/Cellar/libmpc/1.3.1
  make all-gcc
  make all-target-libgcc
  make install-gcc
  make install-target-libgcc
fi

# objconv

cd $HOME/src

if [ ! -d "objconv.zip" ]; then
  curl http://www.agner.org/optimize/objconv.zip > objconv.zip
  mkdir -p build-objconv
  unzip objconv.zip -d build-objconv

  cd build-objconv
  unzip source.zip -d src
  g++ -o objconv -O2 src/*.cpp --prefix="$PREFIX"
  cp objconv $PREFIX/bin
fi

# grub

cd $HOME/src

if [ ! -d "grub" ]; then
  git clone --depth 1 git://git.savannah.gnu.org/grub.git

  cd grub
  sh bootstrap
  sh autogen.sh
  mkdir -p build-grub
  cd build-grub
  ../configure --disable-werror TARGET_CC=$TARGET-gcc TARGET_OBJCOPY=$TARGET-objcopy \
    TARGET_STRIP=$TARGET-strip TARGET_NM=$TARGET-nm TARGET_RANLIB=$TARGET-ranlib --target=$TARGET --prefix=$PREFIX
  make
  make install
fi
