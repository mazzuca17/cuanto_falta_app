package com.example.cuanto_falta_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class CountdownWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.countdown_widget)
            views.setTextViewText(
                R.id.widget_range_title,
                widgetData.getString("rangeTitle", "Progreso Año")
            )
            views.setTextViewText(
                R.id.widget_range_progress,
                widgetData.getString("rangeProgress", "0%")
            )
            views.setTextViewText(
                R.id.widget_range_remaining,
                widgetData.getString("rangeRemaining", "--")
            )
            views.setTextViewText(
                R.id.widget_event_title,
                widgetData.getString("eventTitle", "Mi evento")
            )
            views.setTextViewText(
                R.id.widget_event_remaining,
                widgetData.getString("eventRemaining", "Sin evento seleccionado")
            )

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
