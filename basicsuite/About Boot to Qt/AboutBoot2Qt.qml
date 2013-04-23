import QtQuick 2.0

Column {

    id: root

    width: parent.width

    spacing: engine.smallFontSize()

    Title {
        id: title
        text: "Boot to Qt"
    }

    ContentText {
        id: brief
        width: parent.width
        text: '<p align="justify">Boot to Qt is the working name for a light-weight UI stack for embedded linux,
               based on the Qt Framework by Digia. Boot to Qt places Qt on top of an Android
               kernel/baselayer and offers an elegant means of developing beautiful and
               performant embedded devices.

               <p align="justify">Boot to Qt is a commercial-only SDK offering which includes a ready-made stack
               with full Qt Creator integration. The SDK allows building and running on device
               with just a button. Embedded development has never been this easy!'
    }

    Column {
        id: diagram
        spacing: 1
        width: parent.width * 0.5
        anchors.horizontalCenter: parent.horizontalCenter
        Box { text: "Application"; accentColor: "coral" }
        Box { text: "Qt Framework"; accentColor: Qt.rgba(0.64, 0.82, 0.15) }
        Box { text: "Android Baselayer"; accentColor: "steelblue" }
        Box { text: "Embedded Hardware"; accentColor: "steelblue"}
    }

    ContentText {
        id: description

        width: parent.width

        text: '<p align="justify">Boot to Qt runs on top of Android 4.0 based kernels and has been tested and verified on
               a number of different hardware configurations, including:
               <ul>
                 <li>Google Nexus 7 - NVIDIA Tegra3 Quad Core, 1 GB RAM</li>
                 <li>Beagle Board xM - ARM Coretex A8 1GHz, 512 MB RAM, PowerVR SGX 530</li>
                 <li>Freescale i.MX 6 - ARM Cortex A9 1.2GHz, 1 GB RAM, Vivante GC2000</li>
               </ul>
               Rough minimal requirements for running Boot to Qt are:
               <ul>
                 <li>256Mb of RAM</li>
                 <li>500Mhz CPU, 1Ghz preferred for 60 FPS velvet UIs</li>
                 <li>OpenGL ES 2.0 support</li>
                 <li>Android 4.0+ compatible hardware</li>
               </ul>
              '
    }
}
