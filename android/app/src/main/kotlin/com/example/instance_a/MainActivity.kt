package com.example.instance_a // Adjust to your package

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "sync/native_storage"
        private const val FOLDER_NAME = "SyncStore"
        private const val TAG = "SyncStore"
    }

    /**
     * Configures the Flutter engine to handle method calls from Dart code.
     * Sets up a communication channel for creating a synchronization folder.
     */
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "createSyncFolder" -> {
                    val path = createSyncFolder()
                    if (path != null) {
                        result.success(path)
                    } else {
                        result.error("FOLDER_ERROR", "Could not create folder", null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    /**
     * Creates a dedicated synchronization folder in the Downloads directory.
     * @return Absolute path of the created folder or null on failure
     */
    private fun createSyncFolder(): String? {
        return try {
            // Create folder in public Downloads directory
            val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
            val syncFolder = File(downloadsDir, FOLDER_NAME)

            // Create folder if it doesn't exist
            if (!syncFolder.exists()) {
                syncFolder.mkdirs()
            }

            // Return absolute path
            syncFolder.absolutePath
        } catch (e: Exception) {
            Log.e(TAG, "Failed to create synchronization folder", e)
            null
        }
    }
}
