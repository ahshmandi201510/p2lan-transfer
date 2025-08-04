package com.p2lantransfer.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.net.wifi.WifiManager
import android.net.wifi.WifiInfo
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.NetworkInfo
import android.os.Build
import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import java.net.NetworkInterface
import java.util.*
import android.telephony.TelephonyManager
import android.net.TrafficStats
import android.content.Intent
import android.provider.Settings
import android.app.AppOpsManager
import android.os.Process
import java.util.Calendar

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.p2lantransfer.app/network_security"
    private val DATA_USAGE_CHANNEL = "com.p2lantransfer.app/data_usage_tracking"
    private val PERMISSION_REQUEST_CODE = 123

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Network security channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkWifiSecurity" -> {
                    try {
                        val securityInfo = checkWifiSecurity()
                        result.success(securityInfo)
                    } catch (e: Exception) {
                        result.error("WIFI_ERROR", "Failed to check WiFi security: ${e.message}", null)
                    }
                }
                "getWifiSecurityInfo" -> {
                    try {
                        val securityInfo = getWifiSecurityInfo()
                        result.success(securityInfo)
                    } catch (e: Exception) {
                        result.error("WIFI_ERROR", "Failed to get WiFi security info: ${e.message}", null)
                    }
                }
                "getNetworkInfo" -> {
                    try {
                        val networkInfo = getNetworkInfo()
                        result.success(networkInfo)
                    } catch (e: Exception) {
                        result.error("NETWORK_ERROR", "Failed to get network info: ${e.message}", null)
                    }
                }
                "getMobileIpAddress" -> {
                    try {
                        val ipInfo = getMobileIpAddress()
                        result.success(ipInfo)
                    } catch (e: Exception) {
                        result.error("MOBILE_IP_ERROR", "Failed to get mobile IP: ${e.message}", null)
                    }
                }
                "getRoamingStatus" -> {
                    try {
                        val roamingInfo = getRoamingStatus()
                        result.success(roamingInfo)
                    } catch (e: Exception) {
                        result.error("ROAMING_ERROR", "Failed to get roaming status: ${e.message}", null)
                    }
                }
                "requestPermissions" -> {
                    requestNetworkPermissions()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        
        // Data usage tracking channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DATA_USAGE_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAppDataUsage" -> {
                    try {
                        val usageData = getAppDataUsage()
                        result.success(usageData)
                    } catch (e: Exception) {
                        result.error("DATA_USAGE_ERROR", "Failed to get app data usage: ${e.message}", null)
                    }
                }
                "getAppDataUsageForPeriod" -> {
                    try {
                        val startDate = call.argument<Long>("startDate") ?: 0L
                        val endDate = call.argument<Long>("endDate") ?: System.currentTimeMillis()
                        val usageData = getAppDataUsageForPeriod(startDate, endDate)
                        result.success(usageData)
                    } catch (e: Exception) {
                        result.error("DATA_USAGE_ERROR", "Failed to get app data usage for period: ${e.message}", null)
                    }
                }
                "getSystemDataUsage" -> {
                    try {
                        val usageData = getSystemDataUsage()
                        result.success(usageData)
                    } catch (e: Exception) {
                        result.error("DATA_USAGE_ERROR", "Failed to get system data usage: ${e.message}", null)
                    }
                }
                "hasUsagePermission" -> {
                    try {
                        val hasPermission = hasUsageStatsPermission()
                        result.success(hasPermission)
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", "Failed to check usage permission: ${e.message}", null)
                    }
                }
                "requestUsagePermission" -> {
                    try {
                        requestUsageStatsPermission()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", "Failed to request usage permission: ${e.message}", null)
                    }
                }
                "getDataUsageCapabilities" -> {
                    try {
                        val capabilities = getDataUsageCapabilities()
                        result.success(capabilities)
                    } catch (e: Exception) {
                        result.error("CAPABILITY_ERROR", "Failed to get data usage capabilities: ${e.message}", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun checkWifiSecurity(): Map<String, Any> {
        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        
        val result = mutableMapOf<String, Any>()
        
        // Check if we have permission
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_WIFI_STATE) != PackageManager.PERMISSION_GRANTED) {
            result["hasPermission"] = false
            result["error"] = "WiFi permission not granted"
            return result
        }
        
        result["hasPermission"] = true
        
        // Get current WiFi connection info
        val wifiInfo: WifiInfo? = wifiManager.connectionInfo
        
        if (wifiInfo == null || wifiInfo.networkId == -1) {
            result["isConnected"] = false
            result["isWiFi"] = false
            return result
        }
        
        result["isConnected"] = true
        result["isWiFi"] = true
        
        // Get network name (SSID)
        var ssid = wifiInfo.ssid
        if (ssid.startsWith("\"") && ssid.endsWith("\"")) {
            ssid = ssid.substring(1, ssid.length - 1)
        }
        result["ssid"] = ssid
        
        // Get security type - simplified approach
        val securityType = "WPA2" // Default assumption for connected networks
        result["securityType"] = securityType
        result["isSecure"] = securityType != "OPEN" && securityType != "NONE"
        
        // Get signal strength
        val rssi = wifiInfo.rssi
        result["signalStrength"] = rssi
        result["signalLevel"] = WifiManager.calculateSignalLevel(rssi, 5)
        
        // Get frequency
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            result["frequency"] = wifiInfo.frequency
        }
        
        // Get IP address
        val ipAddress = wifiInfo.ipAddress
        result["ipAddress"] = String.format("%d.%d.%d.%d", 
            ipAddress and 0xff,
            ipAddress shr 8 and 0xff,
            ipAddress shr 16 and 0xff,
            ipAddress shr 24 and 0xff)
        
        return result
    }
    
    private fun getNetworkInfo(): Map<String, Any> {
        val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val result = mutableMapOf<String, Any>()
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val network = connectivityManager.activeNetwork
            val networkCapabilities = connectivityManager.getNetworkCapabilities(network)
            
            if (networkCapabilities != null) {
                result["isConnected"] = true
                result["isWiFi"] = networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
                result["isMobile"] = networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)
                result["isEthernet"] = networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)
                result["hasInternet"] = networkCapabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                result["isValidated"] = networkCapabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)
            } else {
                result["isConnected"] = false
                result["isWiFi"] = false
                result["isMobile"] = false
                result["isEthernet"] = false
                result["hasInternet"] = false
                result["isValidated"] = false
            }
        } else {
            // Fallback for older Android versions
            val activeNetwork: NetworkInfo? = connectivityManager.activeNetworkInfo
            result["isConnected"] = activeNetwork?.isConnectedOrConnecting == true
            result["isWiFi"] = activeNetwork?.type == ConnectivityManager.TYPE_WIFI
            result["isMobile"] = activeNetwork?.type == ConnectivityManager.TYPE_MOBILE
            result["isEthernet"] = activeNetwork?.type == ConnectivityManager.TYPE_ETHERNET
            result["hasInternet"] = activeNetwork?.isConnected == true
            result["isValidated"] = activeNetwork?.isConnected == true
        }
        
        return result
    }
    
    private fun getWifiSecurityInfo(): Map<String, Any> {
        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        val result = mutableMapOf<String, Any>()
        
        // Check permissions first
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_WIFI_STATE) != PackageManager.PERMISSION_GRANTED) {
            result["isSecure"] = true // Default to secure if we can't check
            result["securityType"] = "UNKNOWN"
            result["error"] = "Permission not granted"
            android.util.Log.d("WiFiSecurity", "Permission not granted")
            return result
        }
        
        val wifiInfo: WifiInfo? = wifiManager.connectionInfo
        
        if (wifiInfo == null) {
            // WiFi is disabled or not available
            result["isSecure"] = true // Default to secure
            result["securityType"] = "NOT_CONNECTED"
            android.util.Log.d("WiFiSecurity", "WifiInfo is null")
            return result
        }
        
        // Debug log all WiFi info
        val ssid = wifiInfo.ssid
        val ipAddress = wifiInfo.ipAddress
        val networkId = wifiInfo.networkId
        val bssid = wifiInfo.bssid
        
        android.util.Log.d("WiFiSecurity", "SSID: $ssid")
        android.util.Log.d("WiFiSecurity", "IP Address: $ipAddress")
        android.util.Log.d("WiFiSecurity", "Network ID: $networkId")
        android.util.Log.d("WiFiSecurity", "BSSID: $bssid")
        android.util.Log.d("WiFiSecurity", "WiFi Enabled: ${wifiManager.isWifiEnabled}")
        
        // Check if we are actually connected to WiFi
        val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val activeNetwork = connectivityManager.activeNetwork
        val networkCapabilities = connectivityManager.getNetworkCapabilities(activeNetwork)
        
        if (networkCapabilities != null && networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
            android.util.Log.d("WiFiSecurity", "Connected via WiFi transport")
            
            // We are connected via WiFi
            var isSecure = true // Start with secure assumption for regular WiFi
            var securityType = "WPA2"
            
            // Clean up SSID (remove quotes if present)
            val cleanSSID = ssid?.replace("\"", "") ?: ""
            android.util.Log.d("WiFiSecurity", "Clean SSID: '$cleanSSID'")
            
            // Enhanced logic for security detection
            // 1. First check if SSID indicates open network by name
            val lowerSSID = cleanSSID.lowercase()
            if (lowerSSID.contains("guest") || 
                lowerSSID.contains("open") || 
                lowerSSID.contains("free") ||
                lowerSSID.contains("public") ||
                lowerSSID.contains("hotspot")) {
                android.util.Log.d("WiFiSecurity", "SSID indicates open network by name")
                isSecure = false
                securityType = "OPEN"
            }
            // 2. Check for hotspot patterns with IP address analysis
            else if ((cleanSSID.isEmpty() || cleanSSID == "<unknown ssid>") && networkId == -1) {
                android.util.Log.d("WiFiSecurity", "SSID unknown + networkId=-1, checking IP for hotspot patterns")
                
                // Convert IP address to readable format
                val ip = ipAddress
                val ipStr = String.format("%d.%d.%d.%d", 
                    (ip and 0xff), 
                    (ip shr 8 and 0xff), 
                    (ip shr 16 and 0xff), 
                    (ip shr 24 and 0xff))
                
                android.util.Log.d("WiFiSecurity", "IP address: $ipStr")
                
                // Check if IP is in common hotspot ranges
                if (ipStr.startsWith("192.168.43.") ||   // Android hotspot (default)
                    ipStr.startsWith("192.168.75.") ||   // Android hotspot (alternative)
                    ipStr.startsWith("192.168.137.") ||  // Windows hotspot
                    ipStr.startsWith("172.20.10.") ||    // iOS hotspot  
                    ipStr.startsWith("10.0.0.") ||       // Some other hotspots
                    ipStr.startsWith("192.168.12.") ||   // Some Samsung hotspots
                    ipStr.startsWith("192.168.42.") ||   // Some custom hotspots
                    ipStr.startsWith("192.168.44.") ||   // Some Huawei hotspots
                    (ipStr.startsWith("192.168.") && ipStr.endsWith(".1"))) { // Generic hotspot gateway patterns
                    
                    android.util.Log.d("WiFiSecurity", "IP in hotspot range - confirmed hotspot")
                    isSecure = false
                    securityType = "OPEN"
                } else {
                    android.util.Log.d("WiFiSecurity", "IP NOT in hotspot range - likely secured WiFi with hidden SSID")
                    // Even though SSID is unknown and networkId=-1, IP suggests regular WiFi
                    isSecure = true
                    securityType = "WPA2"
                }
            }
            // 3. Try to get more detailed network info for Android 10+
            else if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
                try {
                    // Try to access WifiManager.getConnectionInfo() more details
                    val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                    val dhcpInfo = wifiManager.dhcpInfo
                    
                    // Check if this looks like a typical hotspot IP range
                    val ip = ipAddress
                    val ipStr = String.format("%d.%d.%d.%d", 
                        (ip and 0xff), 
                        (ip shr 8 and 0xff), 
                        (ip shr 16 and 0xff), 
                        (ip shr 24 and 0xff))
                    
                    android.util.Log.d("WiFiSecurity", "IP address: $ipStr")
                    
                    // Common hotspot IP ranges
                    if (ipStr.startsWith("192.168.43.") ||   // Android hotspot
                        ipStr.startsWith("172.20.10.") ||    // iOS hotspot  
                        ipStr.startsWith("192.168.137.") ||  // Windows hotspot
                        ipStr.startsWith("10.0.0.") ||       // Some hotspots
                        ipStr.startsWith("192.168.1.1") ||   // Router admin but could be hotspot
                        (ipStr.startsWith("192.168.") && cleanSSID.isEmpty())) { // Generic range with no SSID
                        
                        android.util.Log.d("WiFiSecurity", "IP suggests potential hotspot, checking other factors")
                        
                        // Additional check: if networkId is -1 AND IP is in hotspot range, likely hotspot
                        if (networkId == -1) {
                            android.util.Log.d("WiFiSecurity", "Confirmed hotspot: networkId=-1 + hotspot IP range")
                            isSecure = false
                            securityType = "OPEN"
                        } else {
                            android.util.Log.d("WiFiSecurity", "Regular WiFi in hotspot-like IP range, assuming secured")
                            isSecure = true
                            securityType = "WPA2"
                        }
                    } else {
                        android.util.Log.d("WiFiSecurity", "Regular IP range, assuming secured WiFi")
                        isSecure = true
                        securityType = "WPA2"
                    }
                } catch (e: Exception) {
                    android.util.Log.d("WiFiSecurity", "Exception in detailed check: $e, defaulting to secured")
                    isSecure = true
                    securityType = "WPA2"
                }
            } else {
                // For older Android versions, use simpler logic
                if (networkId == -1 && cleanSSID.isEmpty()) {
                    android.util.Log.d("WiFiSecurity", "Older Android: likely hotspot (networkId=-1 + empty SSID)")
                    isSecure = false
                    securityType = "OPEN"
                } else {
                    android.util.Log.d("WiFiSecurity", "Older Android: assuming secured WiFi")
                    isSecure = true
                    securityType = "WPA2"
                }
            }
            
            result["isSecure"] = isSecure
            result["securityType"] = securityType
            if (cleanSSID.isNotEmpty() && cleanSSID != "<unknown ssid>") {
                result["ssid"] = cleanSSID
            }
            result["signalStrength"] = wifiInfo.rssi
            
            android.util.Log.d("WiFiSecurity", "Final result: isSecure=$isSecure, securityType=$securityType, ssid=${result["ssid"]}")
        } else {
            // Not connected to WiFi
            android.util.Log.d("WiFiSecurity", "Not connected to WiFi transport")
            result["isSecure"] = true // Default to secure
            result["securityType"] = "NOT_CONNECTED"
        }
        
        return result
    }
    
    private fun requestNetworkPermissions() {
        val permissions = arrayOf(
            Manifest.permission.ACCESS_WIFI_STATE,
            Manifest.permission.ACCESS_NETWORK_STATE,
            Manifest.permission.CHANGE_WIFI_STATE
        )
        
        ActivityCompat.requestPermissions(this, permissions, PERMISSION_REQUEST_CODE)
    }
    
    private fun getMobileIpAddress(): Map<String, Any> {
        val result = mutableMapOf<String, Any>()
        
        try {
            // Get all network interfaces
            val networkInterfaces = Collections.list(NetworkInterface.getNetworkInterfaces())
            
            for (networkInterface in networkInterfaces) {
                if (!networkInterface.isUp || networkInterface.isLoopback) {
                    continue
                }
                
                val addresses = Collections.list(networkInterface.inetAddresses)
                for (address in addresses) {
                    if (!address.isLoopbackAddress && !address.isLinkLocalAddress) {
                        val hostAddress = address.hostAddress
                        
                        // Filter IPv4 addresses
                        if (hostAddress != null && hostAddress.indexOf(':') < 0) {
                            val interfaceName = networkInterface.name
                            
                            // Check if this is a mobile/cellular interface
                            if (interfaceName.startsWith("rmnet") ||    // Qualcomm
                                interfaceName.startsWith("ccmni") ||    // MediaTek  
                                interfaceName.startsWith("pdp") ||      // Samsung
                                interfaceName.startsWith("ppp") ||      // Point-to-Point
                                interfaceName.startsWith("wwan") ||     // Wireless WAN
                                interfaceName.startsWith("usb") ||      // USB tethering
                                interfaceName.contains("cellular") ||
                                interfaceName.contains("mobile") ||
                                interfaceName.contains("lte") ||
                                interfaceName.contains("4g") ||
                                interfaceName.contains("5g")) {
                                
                                result["ipAddress"] = hostAddress
                                result["interfaceName"] = interfaceName
                                result["type"] = "mobile"
                                result["isUp"] = networkInterface.isUp
                                result["displayName"] = networkInterface.displayName ?: interfaceName
                                return result
                            }
                            
                            // Check for WiFi hotspot interfaces (when device is sharing mobile data)
                            if (interfaceName.startsWith("ap") ||       // Access Point
                                interfaceName.startsWith("wlan") ||     // WiFi LAN
                                interfaceName.startsWith("wifi") ||     // WiFi
                                interfaceName.startsWith("softap") ||   // Software Access Point
                                interfaceName.contains("hotspot")) {
                                
                                // This could be the device acting as a hotspot
                                // Store as potential hotspot interface
                                result["hotspotIpAddress"] = hostAddress
                                result["hotspotInterfaceName"] = interfaceName
                                result["hotspotType"] = "wifi_hotspot"
                            }
                        }
                    }
                }
            }
            
            // If we found hotspot info but no mobile IP, use hotspot IP
            if (result["ipAddress"] == null && result["hotspotIpAddress"] != null) {
                result["ipAddress"] = result["hotspotIpAddress"] ?: ""
                result["interfaceName"] = result["hotspotInterfaceName"] ?: ""
                result["type"] = result["hotspotType"] ?: "unknown"
                result["isUp"] = true
            }
            
            // If still no IP found, try to get any non-loopback IPv4 address
            if (result["ipAddress"] == null) {
                for (networkInterface in networkInterfaces) {
                    if (!networkInterface.isUp || networkInterface.isLoopback) {
                        continue
                    }
                    
                    val addresses = Collections.list(networkInterface.inetAddresses)
                    for (address in addresses) {
                        if (!address.isLoopbackAddress && !address.isLinkLocalAddress) {
                            val hostAddress = address.hostAddress
                            
                            if (hostAddress != null && hostAddress.indexOf(':') < 0) {
                                result["ipAddress"] = hostAddress
                                result["interfaceName"] = networkInterface.name
                                result["type"] = "unknown"
                                result["isUp"] = networkInterface.isUp
                                result["displayName"] = networkInterface.displayName ?: networkInterface.name
                                break
                            }
                        }
                    }
                    
                    if (result["ipAddress"] != null) {
                        break
                    }
                }
            }
            
            result["success"] = result["ipAddress"] != null
            if (result["ipAddress"] == null) {
                result["error"] = "No valid IP address found"
            }
            
        } catch (e: Exception) {
            result["success"] = false
            result["error"] = "Exception: ${e.message}"
        }
        
        return result
    }
    
    private fun getRoamingStatus(): Map<String, Any> {
        val result = mutableMapOf<String, Any>()
        
        try {
            val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            
            // Check if we have permission to read phone state
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
                result["hasPermission"] = false
                result["error"] = "READ_PHONE_STATE permission not granted"
                result["isRoaming"] = false // Conservative default
                return result
            }
            
            result["hasPermission"] = true
            
            // Check roaming status
            val isRoaming = telephonyManager.isNetworkRoaming
            result["isRoaming"] = isRoaming
            
            // Get network operator info
            val networkOperator = telephonyManager.networkOperatorName
            val simOperator = telephonyManager.simOperatorName
            val networkCountryIso = telephonyManager.networkCountryIso
            val simCountryIso = telephonyManager.simCountryIso
            
            result["networkOperator"] = networkOperator ?: "Unknown"
            result["simOperator"] = simOperator ?: "Unknown"
            result["networkCountryIso"] = networkCountryIso ?: ""
            result["simCountryIso"] = simCountryIso ?: ""
            
            // Determine if roaming by comparing country codes
            val isRoamingByCountry = if (networkCountryIso.isNotEmpty() && simCountryIso.isNotEmpty()) {
                networkCountryIso.lowercase() != simCountryIso.lowercase()
            } else {
                false
            }
            
            result["isRoamingByCountry"] = isRoamingByCountry
            result["isRoamingDetected"] = isRoaming || isRoamingByCountry
            
            // Get network type
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                result["dataNetworkType"] = telephonyManager.dataNetworkType
            }
            
            result["success"] = true
            
        } catch (e: Exception) {
            result["success"] = false
            result["error"] = "Exception: ${e.message}"
            result["isRoaming"] = false
            result["isRoamingDetected"] = false
        }
        
        return result
    }
    
    private fun getAppDataUsage(): Map<String, Any> {
        val result = mutableMapOf<String, Any>()
        
        try {
            val uid = applicationContext.applicationInfo.uid
            
            // Use TrafficStats to get app's data usage
            val mobileRxBytes = TrafficStats.getUidRxBytes(uid)
            val mobileTxBytes = TrafficStats.getUidTxBytes(uid)
            
            // TrafficStats gives total data (mobile + wifi) for the app
            val totalBytes = if (mobileRxBytes != TrafficStats.UNSUPPORTED.toLong() && 
                               mobileTxBytes != TrafficStats.UNSUPPORTED.toLong()) {
                mobileRxBytes + mobileTxBytes
            } else {
                0L
            }
            
            result["mobileBytes"] = totalBytes // TrafficStats doesn't separate mobile/wifi
            result["wifiBytes"] = 0L
            result["totalBytes"] = totalBytes
            result["periodStart"] = 0L // TrafficStats gives lifetime data
            result["periodEnd"] = System.currentTimeMillis()
            result["success"] = true
            
        } catch (e: Exception) {
            result["success"] = false
            result["error"] = "Exception: ${e.message}"
            result["mobileBytes"] = 0
            result["wifiBytes"] = 0
            result["totalBytes"] = 0
        }
        
        return result
    }
    
    private fun getAppDataUsageForPeriod(startDate: Long, endDate: Long): Map<String, Any> {
        // TrafficStats doesn't support period queries, so return same as getAppDataUsage
        val result = getAppDataUsage().toMutableMap()
        result["periodStart"] = startDate
        result["periodEnd"] = endDate
        return result
    }
    
    private fun getSystemDataUsage(): Map<String, Any> {
        val result = mutableMapOf<String, Any>()
        
        try {
            // Get system-wide mobile data usage
            val totalMobileRx = TrafficStats.getMobileRxBytes()
            val totalMobileTx = TrafficStats.getMobileTxBytes()
            
            // Get system-wide total data usage 
            val totalRx = TrafficStats.getTotalRxBytes()
            val totalTx = TrafficStats.getTotalTxBytes()
            
            val mobileBytes = if (totalMobileRx != TrafficStats.UNSUPPORTED.toLong() && 
                                totalMobileTx != TrafficStats.UNSUPPORTED.toLong()) {
                totalMobileRx + totalMobileTx
            } else {
                0L
            }
            
            val totalBytes = if (totalRx != TrafficStats.UNSUPPORTED.toLong() && 
                               totalTx != TrafficStats.UNSUPPORTED.toLong()) {
                totalRx + totalTx
            } else {
                0L
            }
            
            val wifiBytes = totalBytes - mobileBytes
            
            result["mobileBytes"] = mobileBytes
            result["wifiBytes"] = wifiBytes.coerceAtLeast(0L)
            result["totalBytes"] = totalBytes
            result["periodStart"] = 0L // TrafficStats gives lifetime data
            result["periodEnd"] = System.currentTimeMillis()
            result["success"] = true
            
        } catch (e: Exception) {
            result["success"] = false
            result["error"] = "Exception: ${e.message}"
            result["mobileBytes"] = 0
            result["wifiBytes"] = 0
            result["totalBytes"] = 0
        }
        
        return result
    }
    
    private fun hasUsageStatsPermission(): Boolean {
        // TrafficStats doesn't require special permissions for app's own data
        return true
    }
    
    private fun requestUsageStatsPermission() {
        // No permission needed for TrafficStats
    }
    
    private fun getDataUsageCapabilities(): Map<String, Boolean> {
        val result = mutableMapOf<String, Boolean>()
        
        try {
            result["canTrackAppUsage"] = true // TrafficStats is always available
            result["canTrackSystemUsage"] = true // TrafficStats is always available
            result["requiresPermission"] = false // TrafficStats doesn't require special permissions
            result["hasPermission"] = true
            
        } catch (e: Exception) {
            result["canTrackAppUsage"] = false
            result["canTrackSystemUsage"] = false
            result["requiresPermission"] = false
            result["hasPermission"] = false
        }
        
        return result
    }
}