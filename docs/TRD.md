TECHNICAL REQUIREMENTS DOCUMENT (TRD)
Project Name
    SENTRA Mobile Application

Technology Stack
    Framework
        Flutter Stable

    Language
        Dart

    State Management
        Riverpod
        or
        Provider
        (prefer Riverpod)

    WebView
        Use:
            webview_flutter
            Latest stable version.

    Architecture
        Clean Architecture
            lib/

            ├── core/
            │   ├── services/
            │   ├── utils/
            │   ├── constants/
            │
            ├── features/
            │   ├── webview/
            │   ├── connectivity/
            │   ├── downloads/
            │   ├── deep_links/
            │
            ├── shared/
            │
            ├── main.dart

Packages
    Required
        webview_flutter
        flutter_inappwebview
        connectivity_plus
        flutter_secure_storage
        url_launcher
        permission_handler
        file_picker
        path_provider
        open_filex
        firebase_core
        firebase_messaging
        app_links
        device_info_plus

Recommended WebView Strategy
    Prefer:
        flutter_inappwebview
    Reason:
        Better support for:
            File uploads
            Downloads
            Cookie management
            JavaScript bridge
            Performance tuning


WebView Configuration
    Android
        Enable:
            javaScriptEnabled = true
            domStorageEnabled = true
            databaseEnabled = true
            supportZoom = false
            allowFileAccess = true
            allowContentAccess = true

    iOS
        Enable:
            allowsInlineMediaPlayback = true
            sharedCookiesEnabled = true

Cookie Management
    Persist:
    CookieManager
    between sessions.

URL Handling Rules
    Internal URLs
        https://sentra.airforce.lk/*
        Load inside WebView.

    External URLs
        Open using:
            url_launcher

    Examples:
        tel:
        mailto:
        whatsapp:
        maps:
        youtube:

Back Button Handling
    Android behavior:

        If webview can go back:
            navigate back

        Else:
            show exit confirmation

Download Management
    Implement download listener.
        Flow:
            User downloads file
                    ↓
            Save to app storage
                    ↓
            Show notification
                    ↓
            Open file

Upload Management
    Support:
        Camera
        Gallery
        Files
        PDF
        Images  

Connectivity Architecture
    Create ConnectivityService.
        States:
            online
            offline

        When offline:
            Show native offline page.

Deep Linking
    Supported URLs
        sentra://https://sentra.airforce.lk/*
    Flow:
        Open app
            ↓
        Open corresponding URL
            ↓
        Load in WebView

Security Configuration
    Android
        Release builds:
            android:debuggable="false"
        Disable WebView debugging.

    iOS
        Use ATS.
            NSAppTransportSecurity
        HTTPS only.

Performance Optimization
    Caching
        Enable:
            WebView cache
            Service workers
            Cookies

Rendering
    Enable:
        Hardware acceleration
        Hybrid composition

    Android:
        SurfaceAndroidWebView

    Preloading
        Preload WebView after splash screen.

Build Configuration
    Android
        Minimum SDK
            24
        Target SDK
            Latest Stable

    iOS
        Minimum Version
            iOS 14+

CI/CD
    Recommended:
        GitHub Actions
            Build:
                Android APK
                Android AAB
                iOS IPA

Future Enhancements
    Phase 2:
        Push notifications
        Biometric login
        Native dashboard widgets
        Native notifications center
        Offline cache

Definition of Done
    The solution is complete when:
        Android and iOS builds are generated successfully.
        Play Store review passes.
        App Store review passes.
        All internal URLs load correctly.
        Authentication persists.
        Downloads and uploads function correctly.
        External URLs open natively.
        Offline handling functions correctly.
        No major WebView performance issues exist.
        Production URL https://sentra.airforce.lk operates seamlessly inside the mobile application.