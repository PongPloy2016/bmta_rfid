package com.example.zebra123

import java.util.ArrayList;
import java.util.HashMap;



interface ZebraDevice {
    fun connect()
    fun disconnect()
    fun dispose()
    fun scan(request: Requests?)
    fun track(request: Requests?, tags: ArrayList<String?>?)
    fun write(epc: String?, newEpc: String?, password: String?, newPassword: String?, data: String?)
    fun setMode(mode: Modes?)

    enum class Interfaces {
        rfidapi3,
        datawedge,
        unknown
    }

    enum class Methods {
        track,
        scan,
        write,
        mode,
        unknown,
        startScan
    }

    enum class Requests {
        start,
        stop,
        unknown
    }

    enum class Modes {
        barcode,
        rfid,
        mixed
    }

    enum class Events {
        readRfid,
        readBarcode,
        error,
        connectionStatus,
        support,
        startRead,
        stopRead,
        writeFail,
        writeSuccess,
        unknown
    }

    enum class ZebraConnectionStatus {
        disconnected,
        connected,
        error,
        unknown
    }

    companion object {
        @JvmStatic
        fun toError(source: String?, exception: Exception): HashMap<String, Any?> {
            val map = HashMap<String, Any?>()
            map["source"] = source
            map["message"] = exception.message
            map["trace"] = exception.stackTrace.toString()
            return map
        }
    }
}