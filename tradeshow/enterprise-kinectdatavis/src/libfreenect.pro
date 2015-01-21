cmake_args = -DBUILD_EXAMPLES=OFF -DBUILD_CPP=OFF -DBUILD_FAKENECT=OFF -DBUILD_C_SYNC=OFF
cross_compile {
    cmake_args += -DCMAKE_SYSTEM_NAME=Linux
    cmake_args += -DCMAKE_SYSTEM_PROCESSOR=arm
    cmake_args += -DCMAKE_CXX_COMPILER=$$QMAKE_CXX
    cmake_args += -DCMAKE_C_COMPILER=$$QMAKE_CC
    cmake_args += -DCMAKE_FIND_ROOT_PATH=$$[QT_SYSROOT]
    cmake_args += -DCMAKE_CXX_FLAGS="--sysroot=$$[QT_SYSROOT]"
    cmake_args += -DCMAKE_C_FLAGS="--sysroot=$$[QT_SYSROOT]"
}

!exists("$$PWD/libfreenect/CMakeLists.txt"): {
    warning("You forgot to update the git submodule, I'll do that for you...")
    system("git submodule update --init")
    system("cd libfreenect && git apply ../../patches/0*")
}

system("cd libfreenect && cmake . $$cmake_args")

build_pass|!debug_and_release {
    make.target = invoke_make
    # Build only the static lib to avoid linking to the shared one later on.
    make.commands = make -C libfreenect freenectstatic
    QMAKE_EXTRA_TARGETS += make

    build_pass:build_all: default_target.target = all
    else: default_target.target = first
    default_target.depends = make

    QMAKE_EXTRA_TARGETS += default_target
}
