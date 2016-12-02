/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.7
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import SensorTag.DataProvider 1.0

Entity {
    id: sceneRoot

    Camera {
        id: camera
        projectionType: CameraLens.PerspectiveProjection
        fieldOfView: 45
        aspectRatio: 16/9
        nearPlane : 0.1
        farPlane : 1000.0
        position: Qt.vector3d( 1.0, 1.0, 1.0 )
        upVector: Qt.vector3d( 1.0, -1.0, 1.0 )
        viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
    }

    OrbitCameraController {
        camera: camera
    }

    components: [
        RenderSettings {
            activeFrameGraph: ForwardRenderer {
                clearColor: Qt.rgba(0, 0, 0, 1)
                camera: camera
            }
        },
        InputSettings { }
    ]

    Mesh {
        id: innerTorusMesh
        source: "3dModel/innerRing.obj"
    }

//    PhongMaterial {
//        id: temperatureLightMaterial
//        ambient: sensor ? sensor.lightIntensityColor : Qt.rgba(0, 0, 0)
//        diffuse: sensor ? sensor.temperatureColor : Qt.rgba(0, 0, 0)
//    }

//    TorusMesh {
//        id: innerTorusMesh
//        radius: 5
//        minorRadius: 1
//        rings: 40
//        slices: 10
//    }

    Transform {
        id: innerTorusTransform
        rotationX: sensor ? sensor.gyroscopeX_degPerSec : 0
        scale3D: Qt.vector3d(1, 1, 1)
//        Behavior on rotationX {
//            NumberAnimation {
//                easing.type: Easing.Linear
//                duration: 1000
//            }
//        }
    }

    SimpleMaterial {
        id: temperatureLightMaterial

        diffuse: "texture/gyroscopeSmall.jpg"
    }

//    DiffuseMapMaterial {
//        id: temperatureLightMaterial

//        diffuse: "qrc:/resources/base/texture/gyroscope.png"
//        ambient: Qt.rgba(1, 1, 1)
//        //diffuse: Qt.rgba(1, 1, 1)
//    }

//    Entity {
//        id: innerTorusEntity

//        components: [ innerTorusMesh, temperatureLightMaterial, innerTorusTransform ]
//    }


    Mesh {
        id: middleTorusMesh
        source: "3dModel/centerRing.obj"
    }

//    TorusMesh {
//        id: middleTorusMesh
//        radius: 8
//        minorRadius: 1
//        rings: 40
//        slices: 10
//    }

    Transform {
        id: middleTorusTransform
        rotationY: sensor ? sensor.gyroscopeY_degPerSec : 0
        scale3D: Qt.vector3d(1, 1, 1)
//        Behavior on rotationY {
//            NumberAnimation {
//                easing.type: Easing.Linear
//                duration: 1000
//            }
//        }
    }

//    Entity {
//        id: middleTorusEntity

//        components: [ middleTorusMesh,temperatureLightMaterial, middleTorusTransform ]
//    }

    Mesh {
        id: outerTorusMesh
        source: "3dModel/outerRing.obj"
    }

//    TorusMesh {
//        id: outerTorusMesh
//        radius: 11
//        minorRadius: 1
//        rings: 40
//        slices: 10
//    }

    Transform {
        id: outerTorusTransform
        /* First rotate on X axis, 90-degree rotation over Y will end up with the result we wish to have. */
        rotationX: sensor ? sensor.gyroscopeZ_degPerSec : 0
        rotationY: 90
        scale3D: Qt.vector3d(1, 1, 1)
//        Behavior on rotationX {
//            NumberAnimation {
//                easing.type: Easing.Linear
//                duration: 1000
//            }
//        }
    }

    Entity {
        id: outerTorusEntity

        components: [ outerTorusMesh, temperatureLightMaterial, outerTorusTransform ]

        Entity {
            id: middleTorusEntity

            components: [ middleTorusMesh,temperatureLightMaterial, middleTorusTransform ]

            Entity {
                id: innerTorusEntity

                components: [ innerTorusMesh, temperatureLightMaterial, innerTorusTransform ]
            }
        }
    }

//    TorusMesh {
//        id: scaleDiskMesh
//        radius: 16
//        minorRadius: 2
//        rings: 40
//        slices: 6
//    }

    Mesh {
        id: scaleDiskMesh

        source: "3dModel/center.obj"
    }

    Transform {
        id: scaleDiskTrasform
        /* First rotate on X axis, 90-degree rotation over Y will end up with the result we wish to have. */
        rotationY: 70
        //scale3D: Qt.vector3d(1, 1, 0.1)
    }

//    PhongMaterial {
//        id: scaleDiskMaterial
//        ambient: Qt.rgba(0.2, 0.2, 0.2, 1)
//        diffuse: Qt.rgba(1, 1, 1, 1)
//        shininess: 0.2
//    }

//    SimpleMaterial {
//        id: temperatureLightMaterial

//        diffuse: "texture/gyroscope.png"
//    }

    Entity {
        id: scaleDiskEntity
        components: [ scaleDiskMesh, temperatureLightMaterial, scaleDiskTrasform ]
    }
}
