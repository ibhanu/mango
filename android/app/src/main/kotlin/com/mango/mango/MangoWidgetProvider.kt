package com.mango.mango

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class MangoWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.mango_widget).apply {
                val affirmationText = widgetData.getString("affirmation_text", "Deep breaths. You've got this.")
                val categoryText = widgetData.getString("category_text", "Mango")
                
                setTextViewText(R.id.app_widget_text, affirmationText)
                setTextViewText(R.id.app_widget_category, categoryText)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
