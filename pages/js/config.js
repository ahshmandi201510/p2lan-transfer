// ===== CONFIGURATION & LINKS MANAGEMENT =====
const AppConfig = {
    // ===== EXTERNAL LINKS =====
    links: {
        // GitHub Repository
        github: 'https://github.com/TrongAJTT/p2lan-transfer',
        
        // Download Links
        downloads: {
            windows: 'https://github.com/TrongAJTT/p2lan-transfer/releases/download/v1.0.0/P2Lan-Transfer-v1.0.0-windows-x64-release.7z',
            android: {
                'android-arm64-v8a': 'https://github.com/TrongAJTT/p2lan-transfer/releases/download/v1.0.0/P2Lan-Transfer-v1.0.0-android-arm64-v8a-release.apk',
                'android-armeabi-v7a': 'https://github.com/TrongAJTT/p2lan-transfer/releases/download/v1.0.0/P2Lan-Transfer-v1.0.0-android-armeabi-v7a-release.apk',
                'android-x86_64': 'https://github.com/TrongAJTT/p2lan-transfer/releases/download/v1.0.0/P2Lan-Transfer-v1.0.0-android-x86_64-release.apk',
                'android-universal': 'https://github.com/TrongAJTT/p2lan-transfer/releases/download/v1.0.0/P2Lan-Transfer-v1.0.0-android-universal-release.apk'
            },
            github_releases: 'https://github.com/TrongAJTT/p2lan-transfer/releases'
        },
        
        // Documentation
        docs: {
            guide: 'https://github.com/TrongAJTT/p2lan-transfer/blob/main/README.md',
            api: 'https://github.com/TrongAJTT/p2lan-transfer/blob/main/docs',
            issues: 'https://github.com/TrongAJTT/p2lan-transfer/issues'
        },
        
        // Social
        social: {
            github: 'https://github.com/TrongAJTT',
            email: 'trong.ajtt.dev@gmail.com'
        }
    },
    
    // ===== APP INFORMATION =====
    app: {
        name: 'P2LAN Transfer',
        version: '1.0.0',
        description: 'Make LAN transfers easy, no server needed',
        author: 'TrongAJTT',
        license: 'GPL-3.0'
    },
    
    // ===== FEATURE FLAGS =====
    features: {
        analytics: false,
        serviceWorker: true,
        darkMode: true,
        multiLanguage: true,
        lightbox: true
    },
    
    // ===== THEME CONFIGURATION =====
    themes: {
        light: {
            primary: '#2563eb',
            secondary: '#64748b',
            background: '#ffffff',
            surface: '#f8fafc',
            text: '#1e293b'
        },
        dark: {
            primary: '#3b82f6',
            secondary: '#94a3b8',
            background: '#0f172a',
            surface: '#1e293b',
            text: '#f1f5f9'
        }
    },
    
    // ===== LANGUAGE CONFIGURATION =====
    languages: {
        en: {
            name: 'English',
            flag: '🇺🇸',
            rtl: false
        },
        vi: {
            name: 'Tiếng Việt',
            flag: '🇻🇳',
            rtl: false
        }
    },
    
    // ===== FEATURE COLORS =====
    featureColors: [
        { primary: '#3b82f6', secondary: '#1e40af' }, // Blue
        { primary: '#10b981', secondary: '#059669' }, // Green
        { primary: '#f59e0b', secondary: '#d97706' }, // Yellow
        { primary: '#ef4444', secondary: '#dc2626' }, // Red
        { primary: '#8b5cf6', secondary: '#7c3aed' }, // Purple
        { primary: '#06b6d4', secondary: '#0891b2' }  // Cyan
    ]
};

// ===== TRANSLATIONS =====
const translations = {
    en: {
        // Navigation
        home: 'Home',
        features: 'Features',
        screenshots: 'Screenshots',
        download: 'Download',
        gettingStarted: 'Getting Started',
        
        // Hero Section
        heroTitle: 'Make LAN transfers easy, no server needed',
        heroSubtitle: 'Transfer files securely between devices on your local network. No internet required, no server needed.',
        downloadNow: 'Download Now',
        viewOnGitHub: 'View on GitHub',
        
        // Stats
        fastTransfer: 'Fast Transfer',
        secureConnection: 'Secure Connection',
        crossPlatform: 'Cross Platform',
        
        // Features
        featuresTitle: 'Why Choose P2LAN Transfer?',
        featuresSubtitle: 'Built with modern technology for a smooth file sharing experience',

        feature1Title: 'Fast & Reliable',
        feature1Desc: 'Transfer files at up to 70% of LAN speed with reliable peer-to-peer connections.',

        feature2Title: 'Encrypted Transfer',
        feature2Desc: 'Supports AES-256 or Chacha20 encryption to keep your data secure when needed.',

        feature3Title: 'Cross Platform',
        feature3Desc: 'Works seamlessly on Windows, Android, and more platforms coming soon.',

        feature4Title: 'No Server Required',
        feature4Desc: 'Direct device-to-device communication without any central server.',

        feature5Title: 'Easy to Use',
        feature5Desc: 'Simple, intuitive interface that anyone can use without technical knowledge.',

        feature6Title: 'Open Source',
        feature6Desc: 'Completely open source with GPL-3.0 license.',
        // Screenshots
        screenshotsTitle: 'See It In Action',
        screenshotsSubtitle: 'Take a look at the clean and intuitive interface',
        
        // Download
        downloadTitle: 'Download P2LAN Transfer',
        downloadSubtitle: 'Get started with fast and secure file sharing today',
        
        windowsTitle: 'For Windows',
        windowsDesc: 'Windows 10/11 compatible.',
        downloadWindows: 'Download for Windows',
        
        androidTitle: 'For Android',
        androidDesc: 'Android 7.0 (API 24) or newer.',
        downloadAndroid: 'Download for Android',
        
        // Android Architecture Selection
        selectAndroidVersion: 'Select Android Version',
        androidArchitectures: {
            'android-arm64-v8a': 'ARM64 (64-bit) - Recommended for most modern devices',
            'android-armeabi-v7a': 'ARM (32-bit) - For older devices',
            'android-x86_64': 'x86_64 - For Intel/AMD processors',
            'android-universal': 'Universal - Works on all devices (larger file size)'
        },
        selectArchitecture: 'Select Architecture',
        downloadNow: 'Download Now',
        cancel: 'Cancel',
        
        viewAllReleases: 'View All Releases',
        
        // Getting Started
        docsTitle: 'Getting Started',
        docsSubtitle: 'Learn how to use P2LAN Transfer in just a few simple steps',
        
        step1Title: 'Install the App',
        step1Desc: 'Download and install P2LAN Transfer on your devices.',
        
        step2Title: 'Configure Settings',
        step2Desc: 'Access settings to customize options such as speed, protocol, and transfer security as needed.',
        
        step3Title: 'Connect to Network',
        step3Desc: 'Make sure both devices are connected to the same local network.',
        
        step4Title: 'Pair Devices',
        step4Desc: 'Use the built-in discovery feature to find and pair with other devices.',
        
        step5Title: 'Start Sharing',
        step5Desc: 'Select files and start transferring with just a few clicks.',
        
        // Footer
        footerTagline: 'Simple, fast, and secure file sharing for everyone.',
        product: 'Product',
        developer: 'Developer',
        connect: 'Connect',
        github: 'GitHub',
        reportIssues: 'Report Issues',
        documentation: 'Documentation',
        
        // Buttons & Actions
        backToTop: 'Back to top',
        close: 'Close',
        next: 'Next',
        previous: 'Previous',
        
        // Theme
        toggleTheme: 'Toggle theme'
    },
    
    vi: {
        // Navigation
        home: 'Trang chủ',
        features: 'Tính năng',
        screenshots: 'Ảnh chụp màn hình',
        download: 'Tải về',
        gettingStarted: 'Bắt đầu',
        
        // Hero Section
        heroTitle: 'Chuyển file qua LAN dễ dàng, không cần máy chủ',
        heroSubtitle: 'Truyền file an toàn giữa các thiết bị trên mạng cục bộ. Không cần internet, không cần máy chủ.',
        downloadNow: 'Tải ngay',
        viewOnGitHub: 'Xem trên GitHub',
        
        // Stats
        fastTransfer: 'Truyền nhanh',
        secureConnection: 'Kết nối an toàn',
        crossPlatform: 'Đa nền tảng',
        
        // Features
        featuresTitle: 'Tại sao chọn P2LAN Transfer?',
        featuresSubtitle: 'Được xây dựng với công nghệ hiện đại cho trải nghiệm chia sẻ file mượt mà',
        
        feature1Title: 'Nhanh & Tin cậy',
        feature1Desc: 'Truyền file với tốc độ lên đến 70% tốc độ LAN và kết nối ngang hàng tin cậy.',
        
        feature2Title: 'Mã hóa truyền tải',
        feature2Desc: 'Hỗ trợ mã hóa truyền tải bằng AES-256 hoặc Chacha20 để đảm bảo dữ liệu của bạn được bảo mật khi cần.',

        feature3Title: 'Đa nền tảng',
        feature3Desc: 'Hoạt động mượt mà trên Windows, Android và nhiều nền tảng khác sắp ra mắt.',
        
        feature4Title: 'Không cần máy chủ',
        feature4Desc: 'Giao tiếp trực tiếp giữa các thiết bị mà không cần máy chủ trung tâm.',
        
        feature5Title: 'Dễ sử dụng',
        feature5Desc: 'Giao diện đơn giản, trực quan mà ai cũng có thể sử dụng mà không cần kiến thức kỹ thuật.',
        
        feature6Title: 'Mã nguồn mở',
        feature6Desc: 'Hoàn toàn mã nguồn mở với giấy phép GPL-3.0.',
        
        // Screenshots
        screenshotsTitle: 'Xem hoạt động',
        screenshotsSubtitle: 'Hãy xem giao diện sạch sẽ và trực quan',
        
        // Download
        downloadTitle: 'Tải P2LAN Transfer',
        downloadSubtitle: 'Bắt đầu với việc chia sẻ file nhanh chóng và an toàn ngay hôm nay',
        
        windowsTitle: 'Cho Windows',
        windowsDesc: 'Phiên bản tương thích trên Windows 10/11.',
        downloadWindows: 'Tải cho Windows',
        
        androidTitle: 'Cho Android',
        androidDesc: 'Android 7.0 (API 24) hoặc mới hơn.',
        downloadAndroid: 'Tải cho Android',
        
        // Android Architecture Selection
        selectAndroidVersion: 'Chọn phiên bản Android',
        androidArchitectures: {
            'android-arm64-v8a': 'ARM64 (64-bit) - Khuyến nghị cho hầu hết thiết bị hiện đại',
            'android-armeabi-v7a': 'ARM (32-bit) - Dành cho thiết bị cũ',
            'android-x86_64': 'x86_64 - Dành cho bộ xử lý Intel/AMD',
            'android-universal': 'Universal - Hoạt động trên mọi thiết bị (kích thước file lớn hơn)'
        },
        selectArchitecture: 'Chọn kiến trúc',
        downloadNow: 'Tải ngay',
        cancel: 'Hủy',
        
        viewAllReleases: 'Xem tất cả phiên bản',
        
        // Getting Started
        docsTitle: 'Bắt đầu',
        docsSubtitle: 'Học cách sử dụng P2LAN Transfer chỉ trong vài bước đơn giản',
        
        step1Title: 'Cài đặt ứng dụng',
        step1Desc: 'Tải và cài đặt P2LAN Transfer trên thiết bị của bạn.',
        
        step2Title: 'Cấu hình cài đặt',
        step2Desc: 'Truy cập cài đặt để tùy chỉnh theo nhu cầu từ tốc độ đến giao thức đến bảo mật truyền tải.',
        
        step3Title: 'Kết nối mạng',
        step3Desc: 'Đảm bảo cả hai thiết bị đều kết nối với cùng một mạng cục bộ.',
        
        step4Title: 'Ghép nối thiết bị',
        step4Desc: 'Sử dụng tính năng khám phá tích hợp để tìm và ghép nối với các thiết bị khác.',
        
        step5Title: 'Bắt đầu chia sẻ',
        step5Desc: 'Chọn file và bắt đầu truyền chỉ với vài cú nhấp chuột.',
        
        // Footer
        footerTagline: 'Chia sẻ file đơn giản, nhanh chóng và an toàn cho mọi người.',
        product: 'Sản phẩm',
        developer: 'Nhà phát triển',
        connect: 'Kết nối',
        github: 'GitHub',
        reportIssues: 'Báo lỗi',
        documentation: 'Tài liệu',
        
        // Buttons & Actions
        backToTop: 'Về đầu trang',
        close: 'Đóng',
        next: 'Tiếp theo',
        previous: 'Trước đó',
        
        // Theme
        toggleTheme: 'Chuyển đổi giao diện'
    }
};

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { AppConfig, translations };
}
