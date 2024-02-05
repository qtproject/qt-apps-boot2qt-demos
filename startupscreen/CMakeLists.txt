cmake_minimum_required(VERSION 3.16)

project(startupscreen LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# From build settings -> cmake -> variables -> set "QSR_BUILD = ON" to enable QSR Screen
option(QSR_BUILD "Build with QSR" OFF)

if(QSR_BUILD)
    add_definitions(-DQSR)
endif()

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick QuickControls2 REQUIRED)

add_executable(startupscreen
    main.cpp
    settingsmanager.cpp
    qtbuttonimageprovider.cpp
    qml.qrc
)

if(QSR_BUILD)
    set_source_files_properties("QSR_MainView.qml"
        PROPERTIES QT_RESOURCE_ALIAS "MainView.qml"
    )
    # Use QSR_MainView in QSR builds
    set(QML_FILES "QSR_MainView.qml")
else()
    # For non-QSR builds, use the original MainView.qml
    set(QML_FILES "MainView.qml")
endif()

# Add resources to the project
qt_add_resources(startupscreen "mainview"
    PREFIX "/"
    FILES ${QML_FILES}
)

target_compile_definitions(startupscreen
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(startupscreen
    PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick)

install(TARGETS startupscreen
    DESTINATION "/usr/bin"
)
