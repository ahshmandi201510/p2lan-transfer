package com.p2lantransfer.app

import android.app.Application
import androidx.work.Configuration
import androidx.work.WorkManager
import io.flutter.app.FlutterApplication

class MainApplication : FlutterApplication(), Configuration.Provider {
    
    override fun onCreate() {
        super.onCreate()
        
        // Initialize WorkManager with custom configuration
        if (!WorkManager.isInitialized()) {
            WorkManager.initialize(this, workManagerConfiguration)
        }
    }
    
    override val workManagerConfiguration: Configuration
        get() = Configuration.Builder()
            .setMinimumLoggingLevel(android.util.Log.ERROR) // Reduce logging to prevent notifications
            .build()
}
