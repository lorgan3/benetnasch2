#!/bin/bash

source='
 src/blib.cpp
 src/rendering/drawspeedometer.cpp
 src/bengine.cpp
 src/components.cpp
 src/entity.cpp
 src/input.cpp
 src/maps.cpp
 src/benetnasch.cpp
 src/physics.cpp
 src/rendering.cpp
 src/components/backgrounddrawable.cpp
 src/components/boxdrawable.cpp
 src/components/bullet.cpp
 src/components/character.cpp
 src/components/primitives.cpp
 src/components/rotatingtextureddrawable.cpp
 src/components/textureddrawable.cpp
 src/components/componentlists.cpp
 src/physics/characters.cpp
 src/physics/bullets.cpp
 src/physics/subroutines.cpp
 src/rendering/drawbackground.cpp
 src/rendering/drawboxes.cpp
 src/rendering/drawbullets.cpp
 src/rendering/drawcharacterdebug.cpp
 src/rendering/drawrotatetextured.cpp
 src/rendering/drawscreentext.cpp
 src/rendering/drawtextured.cpp'
forceinclude="`sdl2-config --prefix`"
sdliflags='`sdl2-config --cflags`'
sdllflags='`sdl2-config --static-libs` -lSDL2_image -static'
cflags="-std=c++11 -Wall -pedantic -Iinclude $sdliflags -I${forceinclude}/include"

if hash sdl2-config; then
    cat /dev/null;
else
    echo "Could not find sdl2-config. Is SDL2 installed correctly? Aborting."
    exit 1
fi

echo ""
echo "Checking sdl2-config --prefix: ${forceinclude}"
if [ ! -f "${forceinclude}/lib/libSDL2.a" ]; then
    echo "sdl2-config prefix does not seem to be valid: edit sdl2-config."
    echo "Aborting."
    exit 1;
fi
echo "Looks okay."
echo "Also, if you get an 'XCClinker' error, remove that flag from sdl2_config."
echo ""

dflags='-O0 -g -ggdb -mconsole'

fflags='-O3'
mflags='-O3 -msse -msse2' # modern x86 optimizations
iflags='-O3 -msse -msse2 -mssse3 -msse4.1' # aggressive intel x86 optimizations
aflags='-O3 -msse -msse2 -msse2avx' # aggressive amd x86 optimizations

tflags='-D TESTS=1'
pflags='-O3 -D B_FRAMELIMIT_DISABLE -D B_DEBUG_FRAMESONLY -D B_DEBUG_COREFRAMES '
sflags='-O3 -D B_FRAMELIMIT_DISABLE -D B_DEBUG_NORENDER '

linker="-L /usr/lib -static-libstdc++ -static-libgcc $sdllflags"

cmd="g++ $source $cflags $linker"

if [ "$1" == "-d" ]; then
    cmd="$cmd $dflags"
elif [ "$1" == "-f" ]; then
    cmd="$cmd $fflags"
elif [ "$1" == "-m" ]; then
    cmd="$cmd $mflags"
elif [ "$1" == "-i" ]; then
    cmd="$cmd $iflags"
elif [ "$1" == "-a" ]; then
    cmd="$cmd $aflags"
elif [ "$1" == "-p" ]; then
    cmd="$cmd $pflags"
elif [ "$1" == "-t" ]; then
    cmd="$cmd $tflags"
elif [ "$1" == "-s" ]; then
    cmd="$cmd $sflags"
elif [ "$1" == "-c" ]; then
    cmd="$cmd ${@:2}";
fi

echo $cmd

run='./a.exe'

eval $cmd
if [ "$1" == "-t" ]; then    
    eval $run
fi

