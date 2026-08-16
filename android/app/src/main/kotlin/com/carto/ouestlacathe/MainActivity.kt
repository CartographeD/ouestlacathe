package com.carto.ouestlacathe

import android.hardware.GeomagneticField
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.hardware.display.DisplayManager
import android.os.Bundle
import android.util.Log
import android.view.Display
import android.view.Surface

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

import kotlin.math.PI

class MainActivity : FlutterActivity(), SensorEventListener {

    private val compassChannel = "ouestlacathe/compass"
    private val compassStream = "ouestlacathe/compass_stream"

    private lateinit var sensorManager: SensorManager
    private lateinit var displayManager: DisplayManager

    private var rotationSensor: Sensor? = null
    private var compassEvents: EventChannel.EventSink? = null

    private val rotationMatrix = FloatArray(9)
    private val remappedMatrix = FloatArray(9)
    private val orientation = FloatArray(3)

    private var magneticDeclination = 0.0

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        sensorManager =
            getSystemService(SENSOR_SERVICE) as SensorManager

        displayManager =
            getSystemService(DISPLAY_SERVICE) as DisplayManager

        rotationSensor =
            sensorManager.getDefaultSensor(
                Sensor.TYPE_ROTATION_VECTOR
            )

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            compassStream
        ).setStreamHandler(
            object : EventChannel.StreamHandler {

                override fun onListen(
                    arguments: Any?,
                    events: EventChannel.EventSink?
                ) {
                    compassEvents = events

                    rotationSensor?.let {
                        sensorManager.registerListener(
                            this@MainActivity,
                            it,
                            SensorManager.SENSOR_DELAY_GAME
                        )
                    }
                }

                override fun onCancel(arguments: Any?) {
                    compassEvents = null
                    sensorManager.unregisterListener(
                        this@MainActivity
                    )
                }
            }
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            compassChannel
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "setLocation" -> {

                    val latitude =
                        call.argument<Double>("latitude")

                    val longitude =
                        call.argument<Double>("longitude")

                    if (latitude != null && longitude != null) {

                        val field = GeomagneticField(
                            latitude.toFloat(),
                            longitude.toFloat(),
                            0f,
                            System.currentTimeMillis()
                        )

                        magneticDeclination =
                            field.declination.toDouble()

                        Log.d(
                            "COMPASS",
                            "DECLINATION: $magneticDeclination"
                        )
                    }

                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onSensorChanged(event: SensorEvent) {

        if (event.sensor.type != Sensor.TYPE_ROTATION_VECTOR) {
            return
        }

        // Rotation Vector → matrice de rotation
        SensorManager.getRotationMatrixFromVector(
            rotationMatrix,
            event.values
        )

        // Rotation actuelle de l'écran
        val display =
            displayManager.getDisplay(Display.DEFAULT_DISPLAY)

        val rotation =
            display?.rotation ?: Surface.ROTATION_0

        // Adaptation du système de coordonnées à l'écran
        val remapped = when (rotation) {

            Surface.ROTATION_0 -> {
                SensorManager.remapCoordinateSystem(
                    rotationMatrix,
                    SensorManager.AXIS_X,
                    SensorManager.AXIS_Y,
                    remappedMatrix
                )
            }

            Surface.ROTATION_90 -> {
                SensorManager.remapCoordinateSystem(
                    rotationMatrix,
                    SensorManager.AXIS_Y,
                    SensorManager.AXIS_MINUS_X,
                    remappedMatrix
                )
            }

            Surface.ROTATION_180 -> {
                SensorManager.remapCoordinateSystem(
                    rotationMatrix,
                    SensorManager.AXIS_MINUS_X,
                    SensorManager.AXIS_MINUS_Y,
                    remappedMatrix
                )
            }

            Surface.ROTATION_270 -> {
                SensorManager.remapCoordinateSystem(
                    rotationMatrix,
                    SensorManager.AXIS_MINUS_Y,
                    SensorManager.AXIS_X,
                    remappedMatrix
                )
            }

            else -> false
        }

        if (!remapped) {
            return
        }

        // Matrice → orientation
        SensorManager.getOrientation(
            remappedMatrix,
            orientation
        )

        // Azimut en radians → degrés
        var heading =
            orientation[0].toDouble() * 180.0 / PI

        // Conversion -180..180 → 0..360
        heading = (heading + 360.0) % 360.0

        // Nord magnétique → nord géographique
        heading += magneticDeclination
        heading = (heading + 360.0) % 360.0

        Log.d(
            "COMPASS",
            "HEADING: $heading | ROTATION: $rotation"
        )

        compassEvents?.success(heading)
    }

    override fun onAccuracyChanged(
        sensor: Sensor?,
        accuracy: Int
    ) {
        Log.d(
            "COMPASS",
            "ACCURACY: $accuracy"
        )
    }

    override fun onDestroy() {
        sensorManager.unregisterListener(this)
        super.onDestroy()
    }
}