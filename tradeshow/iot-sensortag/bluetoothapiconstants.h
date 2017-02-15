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
#ifndef BLUETOOTHAPICONSTANTS_H
#define BLUETOOTHAPICONSTANTS_H

// NOTE! This file should only contain defines, no implementation

// These service UUIDs come from the Texas Intruments SensorTag Bluetooth LE API specification
#define IRTEMPERATURESENSOR_SERVICE_UUID "f000aa00-0451-4000-b000-000000000000"
#define BAROMETER_SERVICE_UUID "f000aa40-0451-4000-b000-000000000000"
#define HUMIDITYSENSOR_SERVICE_UUID "f000aa20-0451-4000-b000-000000000000"
#define LIGHTSENSOR_SERVICE_UUID "f000aa70-0451-4000-b000-000000000000"
#define MOTIONSENSOR_SERVICE_UUID "f000aa80-0451-4000-b000-000000000000"

/* Timeouts (values between 100ms and 2500ms allowed by API specification.
 * API values are passed in hex as strings and multiplied by 10 in SensorTag.
 * These values can be modifed as needed by performance.
 * Keep defines and strings in sync!
 */
#define SENSORTAG_SLOW_TIMER_TIMEOUT_MS                    1000   /* 1 second */
#define SENSORTAG_SLOW_TIMER_TIMEOUT_STR                   "64"   /* 64hex -> 100 -> 1000ms */
#define SENSORTAG_MEDIUM_TIMER_TIMEOUT_MS                  500    /* 500ms */
#define SENSORTAG_MEDIUM_TIMER_TIMEOUT_STR                 "32"   /* 32hex -> 50 -> 500ms */
#define SENSORTAG_RAPID_TIMER_TIMEOUT_MS                   100    /* 100ms */
#define SENSORTAG_RAPID_TIMER_TIMEOUT_STR                  "0A"   /* A(hex) -> 10 -> 100ms */

// These modifiers come from the Texas Intruments SensorTag Bluetooth LE API specification
#define GYROSCOPE_API_READING_MULTIPLIER      (500.0 / 65536.0)
#define ACCELOMETER_API_READING_MULTIPLIER    (8.0 / 32768.0)
#define HUMIDITY_API_READING_MULTIPLIER       (100.0 / 65536.0)
#define IR_TEMPERATURE_API_READING_DIVIDER    128.0
#define BAROMETER_API_READING_DIVIDER         100

// These are parameters from the Texas Intruments SensorTag Bluetooth LE API specification
#define START_MEASUREMENT_STR                    "01"   /* 01 start, 00 stop */
#define DISABLE_NOTIF_STR                        "0000" /* 0100 enable, 0000 disable */
#define ENABLE_NOTIF_STR                         "0100" /* 0100 enable, 0000 disable */
#define MOVEMENT_ENABLE_SENSORS_BITMASK_VALUE    "7F02" /* see below */
//Enable motion axis: 0b0000_0010_0111_1111 = 0x7F 0x02  (all sensors, 8G, no wake on motion)
//bits of first byte:
//MPU9250_GYROSCOPE      = 0b0000_0111 all 3 xyz axes, 1 bit per axis
//MPU9250_ACCELEROMETER  = 0b0011_1000 all 3 xyz axes, 1 bit per axis
//MPU9250_MAGNETOMETER   = 0b0100_0000 all 3 xyz axes with one bit
//MPU9250_WAKEONMOTION   = 0b1000_0000 enables wake on motion
//bits of second byte (only 2 bits used) Accelerometer range in G
//MPU9250_ACCELEROMETER_RANGE_0       =0b0000_0000    =  2 G
//MPU9250_ACCELEROMETER_RANGE_1       =0b0000_0001    =  4 G
//MPU9250_ACCELEROMETER_RANGE_2       =0b0000_0010    =  8 G (default)
//MPU9250_ACCELEROMETER_RANGE_3       =0b0000_0011    = 16 G

#endif // BLUETOOTHAPICONSTANTS_H
