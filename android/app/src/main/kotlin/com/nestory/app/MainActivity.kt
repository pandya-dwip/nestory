package com.nestory.app

import android.content.Context
import android.content.Intent
import android.os.Bundle
import com.nestory.app.widget.NestoryWidgetProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.nestory.app/widget"
    private val PREFS_NAME = "nestory_widget_prefs"
    private val KEY_SNAPSHOT = "widget_snapshot_v1"

    private var methodChannel: MethodChannel? = null
    private var pendingWidgetAction: String? = null
    private var pendingWidgetDate: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleWidgetIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleWidgetIntent(intent)
    }

    private fun handleWidgetIntent(intent: Intent?) {
        val action = intent?.getStringExtra("widget_action") ?: return
        val date = intent.getStringExtra("date")
        if (action == "open_app") return

        if (methodChannel != null) {
            methodChannel?.invokeMethod("onWidgetAction", mapOf("action" to action, "date" to date))
        } else {
            pendingWidgetAction = action
            pendingWidgetDate = date
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "updateWidgetSnapshot" -> {
                        val snapshotJson = call.argument<String>("snapshotJson")
                        if (snapshotJson != null) {
                            val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                            prefs.edit().putString(KEY_SNAPSHOT, snapshotJson).apply()
                            NestoryWidgetProvider.updateAllWidgets(applicationContext)
                            result.success(true)
                        } else {
                            result.error("INVALID_ARGUMENT", "Snapshot JSON was null", null)
                        }
                    }
                    "getInitialWidgetAction" -> {
                        if (pendingWidgetAction != null) {
                            val data = mapOf("action" to pendingWidgetAction, "date" to pendingWidgetDate)
                            pendingWidgetAction = null
                            pendingWidgetDate = null
                            result.success(data)
                        } else {
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        }

        // If an action was pending prior to engine configuration, deliver it now
        if (pendingWidgetAction != null) {
            methodChannel?.invokeMethod(
                "onWidgetAction",
                mapOf("action" to pendingWidgetAction, "date" to pendingWidgetDate)
            )
            pendingWidgetAction = null
            pendingWidgetDate = null
        }
    }
}
