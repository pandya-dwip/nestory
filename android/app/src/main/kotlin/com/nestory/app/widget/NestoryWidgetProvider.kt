package com.nestory.app.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import com.nestory.app.MainActivity
import com.nestory.app.R
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

class NestoryWidgetProvider : AppWidgetProvider() {

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        val action = intent.action ?: return
        val appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID)
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

        when (action) {
            ACTION_SELECT_DATE -> {
                val year = intent.getIntExtra(EXTRA_YEAR, 0)
                val month = intent.getIntExtra(EXTRA_MONTH, 0)
                val day = intent.getIntExtra(EXTRA_DAY, 0)
                if (year > 0 && month > 0 && day > 0 && appWidgetId != AppWidgetManager.INVALID_APPWIDGET_ID) {
                    prefs.edit()
                        .putInt("selected_year_$appWidgetId", year)
                        .putInt("selected_month_$appWidgetId", month)
                        .putInt("selected_day_$appWidgetId", day)
                        .apply()
                    val mgr = AppWidgetManager.getInstance(context) ?: return
                    updateWidget(context, mgr, appWidgetId, null)
                }
            }
            ACTION_PREV_MONTH -> {
                if (appWidgetId != AppWidgetManager.INVALID_APPWIDGET_ID) {
                    val cal = Calendar.getInstance()
                    val currYear = prefs.getInt("displayed_year_$appWidgetId", cal.get(Calendar.YEAR))
                    val currMonth = prefs.getInt("displayed_month_$appWidgetId", cal.get(Calendar.MONTH) + 1)
                    val (newYear, newMonth) = if (currMonth == 1) {
                        Pair(currYear - 1, 12)
                    } else {
                        Pair(currYear, currMonth - 1)
                    }
                    prefs.edit()
                        .putInt("displayed_year_$appWidgetId", newYear)
                        .putInt("displayed_month_$appWidgetId", newMonth)
                        .apply()
                    val mgr = AppWidgetManager.getInstance(context) ?: return
                    updateWidget(context, mgr, appWidgetId, null)
                }
            }
            ACTION_NEXT_MONTH -> {
                if (appWidgetId != AppWidgetManager.INVALID_APPWIDGET_ID) {
                    val cal = Calendar.getInstance()
                    val currYear = prefs.getInt("displayed_year_$appWidgetId", cal.get(Calendar.YEAR))
                    val currMonth = prefs.getInt("displayed_month_$appWidgetId", cal.get(Calendar.MONTH) + 1)
                    val (newYear, newMonth) = if (currMonth == 12) {
                        Pair(currYear + 1, 1)
                    } else {
                        Pair(currYear, currMonth + 1)
                    }
                    prefs.edit()
                        .putInt("displayed_year_$appWidgetId", newYear)
                        .putInt("displayed_month_$appWidgetId", newMonth)
                        .apply()
                    val mgr = AppWidgetManager.getInstance(context) ?: return
                    updateWidget(context, mgr, appWidgetId, null)
                }
            }
            ACTION_RESET_TODAY -> {
                if (appWidgetId != AppWidgetManager.INVALID_APPWIDGET_ID) {
                    val cal = Calendar.getInstance()
                    prefs.edit()
                        .putInt("displayed_year_$appWidgetId", cal.get(Calendar.YEAR))
                        .putInt("displayed_month_$appWidgetId", cal.get(Calendar.MONTH) + 1)
                        .putInt("selected_year_$appWidgetId", cal.get(Calendar.YEAR))
                        .putInt("selected_month_$appWidgetId", cal.get(Calendar.MONTH) + 1)
                        .putInt("selected_day_$appWidgetId", cal.get(Calendar.DAY_OF_MONTH))
                        .apply()
                    val mgr = AppWidgetManager.getInstance(context) ?: return
                    updateWidget(context, mgr, appWidgetId, null)
                }
            }
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId, null)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle?
    ) {
        updateWidget(context, appWidgetManager, appWidgetId, newOptions)
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
    }

    companion object {
        const val PREFS_NAME = "nestory_widget_prefs"
        const val KEY_SNAPSHOT = "widget_snapshot_v1"

        const val ACTION_SELECT_DATE = "com.nestory.app.widget.ACTION_SELECT_DATE"
        const val ACTION_PREV_MONTH = "com.nestory.app.widget.ACTION_PREV_MONTH"
        const val ACTION_NEXT_MONTH = "com.nestory.app.widget.ACTION_NEXT_MONTH"
        const val ACTION_RESET_TODAY = "com.nestory.app.widget.ACTION_RESET_TODAY"

        const val EXTRA_YEAR = "extra_year"
        const val EXTRA_MONTH = "extra_month"
        const val EXTRA_DAY = "extra_day"

        private val MONTH_NAMES = arrayOf(
            "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE",
            "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"
        )

        fun updateAllWidgets(context: Context) {
            val appWidgetManager = AppWidgetManager.getInstance(context) ?: return
            val componentName = ComponentName(context, NestoryWidgetProvider::class.java)
            val ids = appWidgetManager.getAppWidgetIds(componentName)
            for (id in ids) {
                updateWidget(context, appWidgetManager, id, null)
            }
        }

        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            options: Bundle?
        ) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout)
            val opts = options ?: appWidgetManager.getAppWidgetOptions(appWidgetId)
            val minWidth = opts?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0) ?: 0
            val isCompact = minWidth in 1..150

            // Responsive layout: hide mini-calendar only if exceptionally narrow
            if (isCompact) {
                views.setViewVisibility(R.id.widget_calendar_container, View.GONE)
                views.setViewVisibility(R.id.widget_divider, View.GONE)
            } else {
                views.setViewVisibility(R.id.widget_calendar_container, View.VISIBLE)
                views.setViewVisibility(R.id.widget_divider, View.VISIBLE)
            }

            // Retrieve snapshot from SharedPreferences
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val snapshotJsonStr = prefs.getString(KEY_SNAPSHOT, null)
            val snapshot = snapshotJsonStr?.let {
                try {
                    JSONObject(it)
                } catch (e: Exception) {
                    null
                }
            }

            // System today fallback
            val cal = Calendar.getInstance()
            val todayYear = snapshot?.optJSONObject("currentDate")?.optInt("year") ?: cal.get(Calendar.YEAR)
            val todayMonth = snapshot?.optJSONObject("currentDate")?.optInt("month") ?: (cal.get(Calendar.MONTH) + 1)
            val todayDay = snapshot?.optJSONObject("currentDate")?.optInt("day") ?: cal.get(Calendar.DAY_OF_MONTH)

            // Widget-specific displayed month/year
            val displayedYear = prefs.getInt("displayed_year_$appWidgetId", todayYear)
            val displayedMonth = prefs.getInt("displayed_month_$appWidgetId", todayMonth)

            // Widget-specific selected date
            val selectedYear = prefs.getInt("selected_year_$appWidgetId", todayYear)
            val selectedMonth = prefs.getInt("selected_month_$appWidgetId", todayMonth)
            val selectedDay = prefs.getInt("selected_day_$appWidgetId", todayDay)

            // Month navigation header title
            val monthIndex = (displayedMonth - 1).coerceIn(0, 11)
            val monthTitle = "${MONTH_NAMES[monthIndex]} $displayedYear"
            views.setTextViewText(R.id.widget_month_title, monthTitle)

            // Month navigation PendingIntents
            val prevMonthIntent = Intent(context, NestoryWidgetProvider::class.java).apply {
                action = ACTION_PREV_MONTH
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            val prevPending = PendingIntent.getBroadcast(
                context,
                100 + appWidgetId,
                prevMonthIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_btn_prev_month, prevPending)

            val nextMonthIntent = Intent(context, NestoryWidgetProvider::class.java).apply {
                action = ACTION_NEXT_MONTH
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            val nextPending = PendingIntent.getBroadcast(
                context,
                200 + appWidgetId,
                nextMonthIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_btn_next_month, nextPending)

            val resetMonthIntent = Intent(context, NestoryWidgetProvider::class.java).apply {
                action = ACTION_RESET_TODAY
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            val resetPending = PendingIntent.getBroadcast(
                context,
                300 + appWidgetId,
                resetMonthIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_month_title, resetPending)

            // Date math for the 6x7 Month Grid
            val monthCal = Calendar.getInstance().apply {
                set(Calendar.YEAR, displayedYear)
                set(Calendar.MONTH, displayedMonth - 1)
                set(Calendar.DAY_OF_MONTH, 1)
            }
            val daysInMonth = monthCal.getActualMaximum(Calendar.DAY_OF_MONTH)
            val firstDayOfWeek = (monthCal.get(Calendar.DAY_OF_WEEK) - 1) // Sunday = 0

            val eventsByDate = snapshot?.optJSONObject("eventsByDate")
            val memoriesByDate = snapshot?.optJSONObject("memoriesByDate")

            // Populate the 6x7 Month Grid
            var dayCounter = 1
            for (row in 0 until 6) {
                for (col in 0 until 7) {
                    val cellIndex = row * 7 + col
                    val resId = context.resources.getIdentifier(
                        "day_${row}_${col}",
                        "id",
                        context.packageName
                    )
                    if (resId == 0) continue

                    if (cellIndex >= firstDayOfWeek && dayCounter <= daysInMonth) {
                        val currentCellDay = dayCounter
                        views.setTextViewText(resId, currentCellDay.toString())

                        val dateKey = String.format(Locale.US, "%04d-%02d-%02d", displayedYear, displayedMonth, currentCellDay)
                        val hasEvents = eventsByDate?.has(dateKey) == true
                        val isToday = (displayedYear == todayYear && displayedMonth == todayMonth && currentCellDay == todayDay)
                        val isSelected = (displayedYear == selectedYear && displayedMonth == selectedMonth && currentCellDay == selectedDay)

                        if (isToday && isSelected) {
                            views.setInt(resId, "setBackgroundResource", R.drawable.widget_today_bg)
                            views.setTextColor(resId, Color.BLACK)
                        } else if (isSelected) {
                            views.setInt(resId, "setBackgroundResource", R.drawable.widget_selected_bg)
                            views.setTextColor(resId, Color.WHITE)
                        } else if (isToday) {
                            views.setInt(resId, "setBackgroundResource", R.drawable.widget_today_outline_bg)
                            views.setTextColor(resId, Color.WHITE)
                        } else if (hasEvents) {
                            views.setInt(resId, "setBackgroundResource", R.drawable.widget_event_day_bg)
                            views.setTextColor(resId, Color.parseColor("#FFFFFF"))
                        } else {
                            views.setInt(resId, "setBackgroundResource", 0)
                            views.setTextColor(resId, Color.parseColor("#EDEDED"))
                        }

                        // Broadcast intent to select this day
                        val selectIntent = Intent(context, NestoryWidgetProvider::class.java).apply {
                            action = ACTION_SELECT_DATE
                            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                            putExtra(EXTRA_YEAR, displayedYear)
                            putExtra(EXTRA_MONTH, displayedMonth)
                            putExtra(EXTRA_DAY, currentCellDay)
                        }
                        val selectPending = PendingIntent.getBroadcast(
                            context,
                            2000 + (appWidgetId * 100) + cellIndex,
                            selectIntent,
                            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                        )
                        views.setOnClickPendingIntent(resId, selectPending)

                        dayCounter++
                    } else {
                        // Empty cell outside month bounds
                        views.setTextViewText(resId, "")
                        views.setInt(resId, "setBackgroundResource", 0)
                        views.setOnClickPendingIntent(resId, null)
                    }
                }
            }

            // Selected Date formatting for the Agenda Header
            val selectedCal = Calendar.getInstance().apply {
                set(Calendar.YEAR, selectedYear)
                set(Calendar.MONTH, selectedMonth - 1)
                set(Calendar.DAY_OF_MONTH, selectedDay)
            }
            val df = SimpleDateFormat("d MMM.", Locale.getDefault())
            val formattedSelectedDate = df.format(selectedCal.time).uppercase(Locale.getDefault())
            views.setTextViewText(R.id.widget_date_title, formattedSelectedDate)

            val selectedDateStr = String.format(Locale.US, "%04d-%02d-%02d", selectedYear, selectedMonth, selectedDay)
            val todayDateStr = String.format(Locale.US, "%04d-%02d-%02d", todayYear, todayMonth, todayDay)

            // Deep link on Date Title: View Day in Flutter app
            val dayIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("widget_action", "view_day")
                putExtra("date", selectedDateStr)
            }
            val dayPending = PendingIntent.getActivity(
                context,
                600 + appWidgetId,
                dayIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_date_title, dayPending)

            // Action Button 1: Add Event for Selected Date
            val addEventIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("widget_action", "create_event")
                putExtra("date", selectedDateStr)
            }
            val addEventPending = PendingIntent.getActivity(
                context,
                400 + appWidgetId,
                addEventIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_btn_add_event, addEventPending)

            // Action Button 2: Add Memory for Selected Date
            val addMemoryIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("widget_action", "create_memory")
                putExtra("date", selectedDateStr)
            }
            val addMemoryPending = PendingIntent.getActivity(
                context,
                500 + appWidgetId,
                addMemoryIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_btn_add_memory, addMemoryPending)

            // Background container click -> open app
            val launchIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("widget_action", "open_app")
            }
            val mainPending = PendingIntent.getActivity(
                context,
                700 + appWidgetId,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, mainPending)

            // Populate Events & Memory for Selected Date (TOP ALIGNED)
            val selectedEvents = eventsByDate?.optJSONArray(selectedDateStr)
                ?: if (selectedDateStr == todayDateStr) snapshot?.optJSONArray("upcomingEvents") else null
            val hasEvents = selectedEvents != null && selectedEvents.length() > 0

            val memory = memoriesByDate?.optJSONObject(selectedDateStr)
                ?: if (selectedDateStr == todayDateStr) snapshot?.optJSONObject("todayMemory") else null
            val memoryTitle = memory?.optString("title")?.takeIf { it.isNotBlank() }

            if (hasEvents) {
                views.setViewVisibility(R.id.widget_events_view, View.VISIBLE)
                views.setViewVisibility(R.id.widget_empty_view, View.GONE)

                val eventRows = arrayOf(R.id.event_1_row, R.id.event_2_row, R.id.event_3_row, R.id.event_4_row)
                val timeViews = arrayOf(R.id.event_1_time, R.id.event_2_time, R.id.event_3_time, R.id.event_4_time)
                val titleViews = arrayOf(R.id.event_1_title, R.id.event_2_title, R.id.event_3_title, R.id.event_4_title)

                val maxEvents = minOf(selectedEvents!!.length(), 4)
                for (i in 0 until 4) {
                    if (i < maxEvents) {
                        val evt = selectedEvents.getJSONObject(i)
                        val timeStr = evt.optString("timeFormatted", "All day")
                        val titleStr = evt.optString("title", "(No title)")

                        views.setViewVisibility(eventRows[i], View.VISIBLE)
                        views.setTextViewText(timeViews[i], timeStr)
                        views.setTextViewText(titleViews[i], titleStr)
                    } else {
                        views.setViewVisibility(eventRows[i], View.GONE)
                    }
                }

                if (memoryTitle != null) {
                    views.setViewVisibility(R.id.widget_memory_row, View.VISIBLE)
                    views.setTextViewText(R.id.widget_memory_title, "✦ $memoryTitle")
                } else {
                    views.setViewVisibility(R.id.widget_memory_row, View.GONE)
                }
            } else {
                views.setViewVisibility(R.id.widget_events_view, View.GONE)
                views.setViewVisibility(R.id.widget_empty_view, View.VISIBLE)

                if (memoryTitle != null) {
                    views.setViewVisibility(R.id.widget_empty_memory_row, View.VISIBLE)
                    views.setTextViewText(R.id.widget_empty_memory_title, "✦ $memoryTitle")
                } else {
                    views.setViewVisibility(R.id.widget_empty_memory_row, View.GONE)
                }
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
