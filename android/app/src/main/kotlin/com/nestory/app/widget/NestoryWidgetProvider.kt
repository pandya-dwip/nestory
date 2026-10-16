package com.nestory.app.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.PorterDuffXfermode
import android.graphics.Rect
import android.graphics.RectF
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import com.nestory.app.MainActivity
import com.nestory.app.R
import org.json.JSONObject
import java.io.File
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
            ACTION_TOGGLE_PANEL -> {
                if (appWidgetId != AppWidgetManager.INVALID_APPWIDGET_ID) {
                    val currentExpanded = prefs.getBoolean("is_panel_expanded_$appWidgetId", false)
                    prefs.edit()
                        .putBoolean("is_panel_expanded_$appWidgetId", !currentExpanded)
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
        const val ACTION_TOGGLE_PANEL = "com.nestory.app.widget.ACTION_TOGGLE_PANEL"
        const val ACTION_PREV_MONTH = "com.nestory.app.widget.ACTION_PREV_MONTH"
        const val ACTION_NEXT_MONTH = "com.nestory.app.widget.ACTION_NEXT_MONTH"
        const val ACTION_RESET_TODAY = "com.nestory.app.widget.ACTION_RESET_TODAY"

        const val EXTRA_YEAR = "extra_year"
        const val EXTRA_MONTH = "extra_month"
        const val EXTRA_DAY = "extra_day"

        private val MONTH_NAMES = arrayOf(
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        )

        private val MONTH_ABBRS = arrayOf(
            "Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
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
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val isPanelExpanded = prefs.getBoolean("is_panel_expanded_$appWidgetId", false)

            val views = RemoteViews(context.packageName, R.layout.widget_layout)

            // Dynamic panel expand/collapse handling
            if (isPanelExpanded) {
                views.setViewVisibility(R.id.widget_divider, View.VISIBLE)
                views.setViewVisibility(R.id.widget_agenda_container, View.VISIBLE)
                views.setViewVisibility(R.id.widget_header_actions, View.GONE)
            } else {
                views.setViewVisibility(R.id.widget_divider, View.GONE)
                views.setViewVisibility(R.id.widget_agenda_container, View.GONE)
                views.setViewVisibility(R.id.widget_header_actions, View.VISIBLE)
            }

            // Retrieve snapshot from SharedPreferences
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
            val monthTitle = if (isPanelExpanded) {
                "${MONTH_ABBRS[monthIndex]} $displayedYear"
            } else {
                "${MONTH_NAMES[monthIndex]} $displayedYear"
            }
            views.setTextViewText(R.id.widget_month_title, monthTitle)

            // Month navigation PendingIntents
            val prevMonthIntent = Intent(context, NestoryWidgetProvider::class.java).apply {
                action = ACTION_PREV_MONTH
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            views.setOnClickPendingIntent(
                R.id.widget_btn_prev_month,
                PendingIntent.getBroadcast(context, 100 + appWidgetId, prevMonthIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            )

            val nextMonthIntent = Intent(context, NestoryWidgetProvider::class.java).apply {
                action = ACTION_NEXT_MONTH
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            views.setOnClickPendingIntent(
                R.id.widget_btn_next_month,
                PendingIntent.getBroadcast(context, 200 + appWidgetId, nextMonthIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            )

            val resetMonthIntent = Intent(context, NestoryWidgetProvider::class.java).apply {
                action = ACTION_RESET_TODAY
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            views.setOnClickPendingIntent(
                R.id.widget_month_title,
                PendingIntent.getBroadcast(context, 300 + appWidgetId, resetMonthIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            )

            // Toggle Panel PendingIntents
            val toggleIntent = Intent(context, NestoryWidgetProvider::class.java).apply {
                action = ACTION_TOGGLE_PANEL
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            val togglePending = PendingIntent.getBroadcast(
                context,
                800 + appWidgetId,
                toggleIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_btn_toggle_panel, togglePending)
            views.setOnClickPendingIntent(R.id.widget_btn_collapse_panel, togglePending)

            // Date math for the 6x7 Month Grid with leading & trailing dates
            val monthCal = Calendar.getInstance().apply {
                set(Calendar.YEAR, displayedYear)
                set(Calendar.MONTH, displayedMonth - 1)
                set(Calendar.DAY_OF_MONTH, 1)
            }
            val daysInCurrentMonth = monthCal.getActualMaximum(Calendar.DAY_OF_MONTH)
            val firstDayOfWeek = (monthCal.get(Calendar.DAY_OF_WEEK) - 1) // Sunday = 0

            val totalCellsNeeded = firstDayOfWeek + daysInCurrentMonth
            val rowsNeeded = if (totalCellsNeeded > 35) 6 else 5

            // Dynamically hide Row 5 when month finishes in 5 weeks (e.g. Oct 2026 ends on Sat Oct 31)
            // This gives 20% more vertical space to all remaining cells!
            if (rowsNeeded <= 5) {
                views.setViewVisibility(R.id.row_5, View.GONE)
            } else {
                views.setViewVisibility(R.id.row_5, View.VISIBLE)
            }

            // Days in previous month
            val prevMonthCal = Calendar.getInstance().apply {
                set(Calendar.YEAR, if (displayedMonth == 1) displayedYear - 1 else displayedYear)
                set(Calendar.MONTH, if (displayedMonth == 1) 11 else displayedMonth - 2)
                set(Calendar.DAY_OF_MONTH, 1)
            }
            val daysInPrevMonth = prevMonthCal.getActualMaximum(Calendar.DAY_OF_MONTH)
            val prevYear = prevMonthCal.get(Calendar.YEAR)
            val prevMonth = prevMonthCal.get(Calendar.MONTH) + 1

            // Next month
            val nextYear = if (displayedMonth == 12) displayedYear + 1 else displayedYear
            val nextMonth = if (displayedMonth == 12) 1 else displayedMonth + 1

            val eventsByDate = snapshot?.optJSONObject("eventsByDate")
            val memoriesByDate = snapshot?.optJSONObject("memoriesByDate")

            // Populate calendar cells
            for (row in 0 until 6) {
                for (col in 0 until 7) {
                    val cellIndex = row * 7 + col

                    val cellResId = context.resources.getIdentifier("cell_${row}_${col}", "id", context.packageName)
                    val dateResId = context.resources.getIdentifier("date_${row}_${col}", "id", context.packageName)
                    val chip1ResId = context.resources.getIdentifier("chip1_${row}_${col}", "id", context.packageName)
                    val chip2ResId = context.resources.getIdentifier("chip2_${row}_${col}", "id", context.packageName)
                    val chip3ResId = context.resources.getIdentifier("chip3_${row}_${col}", "id", context.packageName)

                    if (cellResId == 0 || dateResId == 0) continue

                    val cellYear: Int
                    val cellMonth: Int
                    val cellDay: Int
                    val isCurrentMonth: Boolean

                    if (cellIndex < firstDayOfWeek) {
                        // Leading days from previous month
                        cellDay = daysInPrevMonth - firstDayOfWeek + cellIndex + 1
                        cellYear = prevYear
                        cellMonth = prevMonth
                        isCurrentMonth = false
                    } else if (cellIndex < firstDayOfWeek + daysInCurrentMonth) {
                        // Current month days
                        cellDay = cellIndex - firstDayOfWeek + 1
                        cellYear = displayedYear
                        cellMonth = displayedMonth
                        isCurrentMonth = true
                    } else {
                        // Trailing days from next month
                        cellDay = cellIndex - (firstDayOfWeek + daysInCurrentMonth) + 1
                        cellYear = nextYear
                        cellMonth = nextMonth
                        isCurrentMonth = false
                    }

                    // Set Date Number Text
                    views.setTextViewText(dateResId, cellDay.toString())

                    val dateKey = String.format(Locale.US, "%04d-%02d-%02d", cellYear, cellMonth, cellDay)
                    val isToday = (cellYear == todayYear && cellMonth == todayMonth && cellDay == todayDay)
                    val isSelected = (cellYear == selectedYear && cellMonth == selectedMonth && cellDay == selectedDay)

                    // Date Number Styling
                    if (isToday) {
                        views.setInt(dateResId, "setBackgroundResource", R.drawable.widget_today_badge)
                        views.setTextColor(dateResId, Color.parseColor("#09090B"))
                    } else {
                        views.setInt(dateResId, "setBackgroundResource", 0)
                        val numColor = if (isCurrentMonth) Color.parseColor("#E5E2E1") else Color.parseColor("#5A5A5A")
                        views.setTextColor(dateResId, numColor)
                    }

                    // Cell Border Styling
                    if (isSelected) {
                        views.setInt(cellResId, "setBackgroundResource", R.drawable.widget_cell_selected_border)
                    } else {
                        views.setInt(cellResId, "setBackgroundResource", R.drawable.widget_cell_border)
                    }

                    // Select Date Broadcast Intent
                    val selectIntent = Intent(context, NestoryWidgetProvider::class.java).apply {
                        action = ACTION_SELECT_DATE
                        putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                        putExtra(EXTRA_YEAR, cellYear)
                        putExtra(EXTRA_MONTH, cellMonth)
                        putExtra(EXTRA_DAY, cellDay)
                    }
                    val selectPending = PendingIntent.getBroadcast(
                        context,
                        2000 + (appWidgetId * 100) + cellIndex,
                        selectIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                    views.setOnClickPendingIntent(cellResId, selectPending)

                    // Build chips list: ONLY FOR CURRENT MONTH'S DATES!
                    // Leading/trailing days from other months never display event chips.
                    data class ChipInfo(val text: String, val bgRes: Int, val textColor: Int)
                    val chips = mutableListOf<ChipInfo>()

                    if (isCurrentMonth) {
                        val dateEvents = eventsByDate?.optJSONArray(dateKey)
                        val dateMemory = memoriesByDate?.optJSONObject(dateKey)

                        if (dateMemory != null) {
                            val mTitle = dateMemory.optString("title", "Memory")
                            val preview = if (mTitle.length > 8) mTitle.take(7) + "…" else mTitle
                            chips.add(ChipInfo("✦ $preview", R.drawable.widget_chip_gold, Color.WHITE))
                        }

                        if (dateEvents != null) {
                            for (e in 0 until dateEvents.length()) {
                                val evt = dateEvents.getJSONObject(e)
                                val title = evt.optString("title", "Event")
                                val chipTitle = formatChipTitle(title)
                                val (bgRes, textColor) = getChipBackgroundAndColor(title, evt.optString("calendarColorHex", null))
                                chips.add(ChipInfo(chipTitle, bgRes, textColor))
                            }
                        }
                    }

                    // Bind Chip 1
                    if (chips.isNotEmpty()) {
                        views.setViewVisibility(chip1ResId, View.VISIBLE)
                        views.setTextViewText(chip1ResId, chips[0].text)
                        views.setInt(chip1ResId, "setBackgroundResource", chips[0].bgRes)
                        views.setTextColor(chip1ResId, chips[0].textColor)
                    } else {
                        views.setViewVisibility(chip1ResId, View.GONE)
                    }

                    // Bind Chip 2
                    if (chips.size >= 2) {
                        views.setViewVisibility(chip2ResId, View.VISIBLE)
                        views.setTextViewText(chip2ResId, chips[1].text)
                        views.setInt(chip2ResId, "setBackgroundResource", chips[1].bgRes)
                        views.setTextColor(chip2ResId, chips[1].textColor)
                    } else {
                        views.setViewVisibility(chip2ResId, View.GONE)
                    }

                    // Bind Chip 3 (or overflow +N more)
                    if (chips.size == 3) {
                        views.setViewVisibility(chip3ResId, View.VISIBLE)
                        views.setTextViewText(chip3ResId, chips[2].text)
                        views.setInt(chip3ResId, "setBackgroundResource", chips[2].bgRes)
                        views.setTextColor(chip3ResId, chips[2].textColor)
                    } else if (chips.size > 3) {
                        views.setViewVisibility(chip3ResId, View.VISIBLE)
                        views.setTextViewText(chip3ResId, "+${chips.size - 2} more")
                        views.setInt(chip3ResId, "setBackgroundResource", R.drawable.widget_chip_gray)
                        views.setTextColor(chip3ResId, Color.parseColor("#E2E8F0"))
                    } else {
                        views.setViewVisibility(chip3ResId, View.GONE)
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
            views.setOnClickPendingIntent(R.id.widget_btn_add_event_sidebar, addEventPending)

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
            views.setOnClickPendingIntent(R.id.widget_btn_add_memory_sidebar, addMemoryPending)

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

            // Populate Sidebar / Expanded Agenda details for selected date
            val selectedEvents = eventsByDate?.optJSONArray(selectedDateStr)
                ?: if (selectedDateStr == todayDateStr) snapshot?.optJSONArray("upcomingEvents") else null
            val hasEvents = selectedEvents != null && selectedEvents.length() > 0

            val memory = memoriesByDate?.optJSONObject(selectedDateStr)
                ?: if (selectedDateStr == todayDateStr) snapshot?.optJSONObject("todayMemory") else null
            val memoryTitle = memory?.optString("title")?.takeIf { it.isNotBlank() }
            val memoryImagePath = memory?.optString("imagePath")?.takeIf { it.isNotBlank() }

            // Memory Preview Section (Photo + Title)
            if (memoryTitle != null) {
                views.setViewVisibility(R.id.widget_memory_section, View.VISIBLE)
                views.setTextViewText(R.id.widget_memory_title, "✦ $memoryTitle")

                // Decode memory photo thumbnail safely
                val memoryBmp = loadRoundedThumbnail(memoryImagePath, 240, 160)
                if (memoryBmp != null) {
                    views.setViewVisibility(R.id.widget_memory_image, View.VISIBLE)
                    views.setImageViewBitmap(R.id.widget_memory_image, memoryBmp)
                } else {
                    views.setViewVisibility(R.id.widget_memory_image, View.GONE)
                }
            } else {
                views.setViewVisibility(R.id.widget_memory_section, View.GONE)
            }

            // Populate Events List in Sidebar
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
            } else {
                views.setViewVisibility(R.id.widget_events_view, View.GONE)
                views.setViewVisibility(R.id.widget_empty_view, View.VISIBLE)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        private fun getChipBackgroundAndColor(title: String, colorHex: String?): Pair<Int, Int> {
            val lower = title.lowercase(Locale.ROOT)
            return when {
                lower.contains("formula") || lower.contains("f1") || lower.contains("race") ||
                lower.contains("grand prix") || lower.contains("gp") ->
                    Pair(R.drawable.widget_chip_orange, Color.WHITE)
                lower.contains("mahatma") || lower.contains("dussehra") || lower.contains("karaka") ||
                lower.contains("holiday") || lower.contains("first day") || lower.contains("maha") ||
                lower.contains("jayanti") || lower.contains("diwali") ->
                    Pair(R.drawable.widget_chip_teal, Color.WHITE)
                lower.contains("cancel") || lower.contains("meeting") || lower.contains("call") ->
                    Pair(R.drawable.widget_chip_blue, Color.WHITE)
                else -> {
                    when (Math.abs(title.hashCode()) % 3) {
                        0 -> Pair(R.drawable.widget_chip_teal, Color.WHITE)
                        1 -> Pair(R.drawable.widget_chip_orange, Color.WHITE)
                        else -> Pair(R.drawable.widget_chip_blue, Color.WHITE)
                    }
                }
            }
        }

        private fun formatChipTitle(rawTitle: String): String {
            // Strip leading emoji symbols and excess spacing so textual title is prominent in compact cells
            val cleaned = rawTitle.replace(Regex("^[\\p{So}\\p{Sk}\\p{Sm}\\p{Sc}\\p{C}\\s]+"), "").trim()
            return if (cleaned.isNotEmpty()) cleaned else rawTitle.trim()
        }

        private fun loadRoundedThumbnail(imagePath: String?, maxWidth: Int, maxHeight: Int): Bitmap? {
            if (imagePath.isNullOrBlank()) return null
            val file = File(imagePath)
            if (!file.exists() || !file.canRead()) return null

            return try {
                val options = BitmapFactory.Options().apply { inJustDecodeBounds = true }
                BitmapFactory.decodeFile(file.absolutePath, options)
                var sampleSize = 1
                while (options.outWidth / (sampleSize * 2) >= maxWidth &&
                    options.outHeight / (sampleSize * 2) >= maxHeight
                ) {
                    sampleSize *= 2
                }
                val decodeOptions = BitmapFactory.Options().apply {
                    inSampleSize = sampleSize
                    inPreferredConfig = Bitmap.Config.RGB_565
                }
                val rawBmp = BitmapFactory.decodeFile(file.absolutePath, decodeOptions) ?: return null

                // Round corners cleanly
                val output = Bitmap.createBitmap(rawBmp.width, rawBmp.height, Bitmap.Config.ARGB_8888)
                val canvas = Canvas(output)
                val paint = Paint().apply { isAntiAlias = true }
                val rect = Rect(0, 0, rawBmp.width, rawBmp.height)
                val rectF = RectF(rect)
                val roundPx = 14f
                canvas.drawRoundRect(rectF, roundPx, roundPx, paint)
                paint.xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC_IN)
                canvas.drawBitmap(rawBmp, rect, rect, paint)
                rawBmp.recycle()
                output
            } catch (e: Throwable) {
                null
            }
        }
    }
}
