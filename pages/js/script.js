// ===== MAIN APPLICATION OBJECT =====
const P2LANApp = {
    currentLang: 'en',
    currentTheme: 'light',
    screenshots: [],
    currentScreenshot: 0,

    // Initialize the application
    init() {
        this.loadConfig();
        this.initTheme();
        this.initLanguage();
        this.initMobileNavigation();
        this.initScrollEffects();
        this.initBackToTop();
        this.initSmoothScrolling();
        this.initAnimations();
        this.initLightbox();
        this.initLazyLoading();
        this.initPerformanceOptimizations();
        this.bindDownloadLinks();
        
        // Log initialization
        console.log('P2LAN Transfer website initialized successfully');
    },

    // ===== CONFIGURATION LOADING =====
    loadConfig() {
        // Load configuration from config.js if available
        if (typeof AppConfig !== 'undefined') {
            this.config = AppConfig;
            this.translations = translations;
        } else {
            console.warn('Config not loaded, using defaults');
            this.config = { features: { darkMode: true, multiLanguage: true } };
            this.translations = { en: {}, vi: {} };
        }
    },

    // ===== THEME MANAGEMENT =====
    initTheme() {
        const savedTheme = localStorage.getItem('p2lan-theme') || 'light';
        this.setTheme(savedTheme);
        
        const themeToggle = document.querySelector('.theme-toggle');
        if (themeToggle) {
            themeToggle.addEventListener('click', () => {
                this.toggleTheme();
            });
        }
    },

    setTheme(theme) {
        this.currentTheme = theme;
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('p2lan-theme', theme);
        
        const themeIcon = document.querySelector('.theme-toggle i');
        if (themeIcon) {
            themeIcon.className = theme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
        }
    },

    toggleTheme() {
        const newTheme = this.currentTheme === 'light' ? 'dark' : 'light';
        this.setTheme(newTheme);
    },

    // ===== LANGUAGE MANAGEMENT =====
    initLanguage() {
        const savedLang = localStorage.getItem('p2lan-lang') || 'en';
        this.setLanguage(savedLang);
        
        const langButtons = document.querySelectorAll('.lang-btn');
        langButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                const lang = btn.getAttribute('data-lang');
                this.setLanguage(lang);
            });
        });
    },

    setLanguage(lang) {
        this.currentLang = lang;
        localStorage.setItem('p2lan-lang', lang);
        
        // Update active language button
        document.querySelectorAll('.lang-btn').forEach(btn => {
            btn.classList.remove('active');
            if (btn.getAttribute('data-lang') === lang) {
                btn.classList.add('active');
            }
        });
        
        // Update text content
        this.updateTexts();
    },

    updateTexts() {
        const t = this.translations[this.currentLang] || this.translations.en;
        
        // Update elements with data-text attributes
        document.querySelectorAll('[data-text]').forEach(el => {
            const key = el.getAttribute('data-text');
            if (t[key]) {
                el.textContent = t[key];
            }
        });
    },

    // ===== LIGHTBOX FUNCTIONALITY =====
    initLightbox() {
        this.screenshots = Array.from(document.querySelectorAll('.screenshot-item img'));
        
        // Add click handlers to screenshots
        this.screenshots.forEach((img, index) => {
            img.parentElement.addEventListener('click', () => {
                this.openLightbox(index);
            });
        });
        
        // Lightbox controls
        const lightbox = document.getElementById('lightbox');
        if (lightbox) {
            lightbox.addEventListener('click', (e) => {
                if (e.target === lightbox) {
                    this.closeLightbox();
                }
            });
        }
        
        // Keyboard controls
        document.addEventListener('keydown', (e) => {
            if (document.getElementById('lightbox').classList.contains('active')) {
                switch(e.key) {
                    case 'Escape':
                        this.closeLightbox();
                        break;
                    case 'ArrowLeft':
                        this.previousImage();
                        break;
                    case 'ArrowRight':
                        this.nextImage();
                        break;
                }
            }
        });
    },

    openLightbox(index) {
        this.currentScreenshot = index;
        const lightbox = document.getElementById('lightbox');
        const lightboxImg = document.getElementById('lightbox-img');
        
        if (lightbox && lightboxImg && this.screenshots[index]) {
            lightboxImg.src = this.screenshots[index].src;
            lightboxImg.alt = this.screenshots[index].alt;
            lightbox.classList.add('active');
            document.body.style.overflow = 'hidden';
        }
    },

    closeLightbox() {
        const lightbox = document.getElementById('lightbox');
        if (lightbox) {
            lightbox.classList.remove('active');
            document.body.style.overflow = '';
        }
    },

    nextImage() {
        this.currentScreenshot = (this.currentScreenshot + 1) % this.screenshots.length;
        this.updateLightboxImage();
    },

    previousImage() {
        this.currentScreenshot = (this.currentScreenshot - 1 + this.screenshots.length) % this.screenshots.length;
        this.updateLightboxImage();
    },

    updateLightboxImage() {
        const lightboxImg = document.getElementById('lightbox-img');
        if (lightboxImg && this.screenshots[this.currentScreenshot]) {
            lightboxImg.src = this.screenshots[this.currentScreenshot].src;
            lightboxImg.alt = this.screenshots[this.currentScreenshot].alt;
        }
    },

    // ===== DOWNLOAD LINK MANAGEMENT =====
    bindDownloadLinks() {
        if (!this.config.links) return;
        
        // Windows download
        const windowsBtn = document.querySelector('[data-download="windows"]');
        if (windowsBtn && this.config.links.downloads.windows) {
            windowsBtn.addEventListener('click', () => {
                this.trackDownload('windows');
                window.open(this.config.links.downloads.windows, '_blank');
            });
        }
        
        // Android download
        const androidBtn = document.querySelector('[data-download="android"]');
        if (androidBtn && this.config.links.downloads.android) {
            androidBtn.addEventListener('click', () => {
                this.trackDownload('android');
                window.open(this.config.links.downloads.android, '_blank');
            });
        }
        
        // GitHub releases
        const releasesBtn = document.querySelector('[data-link="releases"]');
        if (releasesBtn && this.config.links.downloads.github_releases) {
            releasesBtn.addEventListener('click', () => {
                window.open(this.config.links.downloads.github_releases, '_blank');
            });
        }
        
        // GitHub repository
        const githubBtns = document.querySelectorAll('[data-link="github"]');
        githubBtns.forEach(btn => {
            if (this.config.links.github) {
                btn.addEventListener('click', () => {
                    window.open(this.config.links.github, '_blank');
                });
            }
        });
    },

    // ===== MOBILE NAVIGATION =====
    initMobileNavigation() {
        const navToggle = document.querySelector('.nav-toggle');
        const navMenu = document.querySelector('.nav-menu');
        const navLinks = document.querySelectorAll('.nav-link');

        // Toggle mobile menu
        if (navToggle && navMenu) {
            navToggle.addEventListener('click', () => {
                navToggle.classList.toggle('active');
                navMenu.classList.toggle('active');
                
                // Prevent body scroll when menu is open on mobile
                document.body.style.overflow = navMenu.classList.contains('active') ? 'hidden' : '';
            });

            // Close menu when clicking nav links
            navLinks.forEach(link => {
                link.addEventListener('click', () => {
                    navToggle.classList.remove('active');
                    navMenu.classList.remove('active');
                    document.body.style.overflow = '';
                });
            });

            // Close menu when clicking outside
            document.addEventListener('click', (event) => {
                const isClickInsideNav = navToggle.contains(event.target) || navMenu.contains(event.target);
                
                if (!isClickInsideNav && navMenu.classList.contains('active')) {
                    navToggle.classList.remove('active');
                    navMenu.classList.remove('active');
                    document.body.style.overflow = '';
                }
            });
        }
    },

    // ===== SCROLL EFFECTS =====
    initScrollEffects() {
        const navbar = document.querySelector('.navbar');
        let lastScrollTop = 0;
        let ticking = false;

        const updateNavbar = () => {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
            const isDark = this.currentTheme === 'dark';
            
            // Add shadow to navbar when scrolled
            if (scrollTop > 10) {
                navbar.style.boxShadow = isDark ? '0 2px 20px rgba(0,0,0,0.5)' : '0 2px 20px rgba(0,0,0,0.1)';
                navbar.style.background = isDark ? 'rgba(15, 23, 42, 0.98)' : 'rgba(255, 255, 255, 0.98)';
            } else {
                navbar.style.boxShadow = 'none';
                navbar.style.background = isDark ? 'rgba(15, 23, 42, 0.95)' : 'rgba(255, 255, 255, 0.95)';
            }

            // Hide/show navbar on scroll (optional)
            if (Math.abs(lastScrollTop - scrollTop) <= 5) return;
            
            if (scrollTop > lastScrollTop && scrollTop > 100) {
                // Scrolling down
                navbar.style.transform = 'translateY(-100%)';
            } else {
                // Scrolling up
                navbar.style.transform = 'translateY(0)';
            }
            
            lastScrollTop = scrollTop;
            ticking = false;
        };

        const requestNavbarUpdate = () => {
            if (!ticking) {
                requestAnimationFrame(updateNavbar);
                ticking = true;
            }
        };

        window.addEventListener('scroll', requestNavbarUpdate, { passive: true });
        
        // Update active nav link based on scroll position
        this.updateActiveNavLink();
    },

    // ===== UPDATE ACTIVE NAV LINK =====
    updateActiveNavLink() {
        const sections = document.querySelectorAll('section[id]');
        const navLinks = document.querySelectorAll('.nav-link');

        const updateActiveLink = () => {
            const scrollPosition = window.scrollY + 100;

            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionHeight = section.offsetHeight;
                const sectionId = section.getAttribute('id');

                if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
                    navLinks.forEach(link => {
                        link.classList.remove('active');
                        if (link.getAttribute('href') === `#${sectionId}`) {
                            link.classList.add('active');
                        }
                    });
                }
            });
        };

        window.addEventListener('scroll', this.debounce(updateActiveLink, 10), { passive: true });
    },

    // ===== BACK TO TOP BUTTON =====
    initBackToTop() {
        const backToTopButton = document.querySelector('.back-to-top');
        
        if (!backToTopButton) {
            // Create back to top button if it doesn't exist
            const button = document.createElement('button');
            button.className = 'back-to-top';
            button.innerHTML = '<i class="fas fa-chevron-up"></i>';
            button.setAttribute('aria-label', 'Back to top');
            document.body.appendChild(button);
        }

        const backToTop = document.querySelector('.back-to-top');

        // Show/hide button based on scroll position
        const toggleBackToTop = () => {
            if (window.scrollY > 300) {
                backToTop.classList.add('show');
            } else {
                backToTop.classList.remove('show');
            }
        };

        // Smooth scroll to top
        backToTop.addEventListener('click', () => {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });

        window.addEventListener('scroll', this.debounce(toggleBackToTop, 10), { passive: true });
    },

    // ===== SMOOTH SCROLLING =====
    initSmoothScrolling() {
        const links = document.querySelectorAll('a[href^="#"]');
        
        links.forEach(link => {
            link.addEventListener('click', (e) => {
                const href = link.getAttribute('href');
                
                // Skip if it's just "#"
                if (href === '#') return;
                
                const targetId = href.substring(1);
                const targetElement = document.getElementById(targetId);
                
                if (targetElement) {
                    e.preventDefault();
                    
                    const headerOffset = 80; // Account for fixed navbar
                    const elementPosition = targetElement.offsetTop;
                    const offsetPosition = elementPosition - headerOffset;

                    window.scrollTo({
                        top: offsetPosition,
                        behavior: 'smooth'
                    });
                }
            });
        });
    },

    // ===== ANIMATIONS =====
    initAnimations() {
        // Intersection Observer for fade-in animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        // Observe elements for animation
        const animatedElements = document.querySelectorAll(
            '.feature-card, .screenshot-item, .download-card, .doc-card, .hero-text, .hero-image'
        );

        animatedElements.forEach((el, index) => {
            // Set initial state
            el.style.opacity = '0';
            el.style.transform = 'translateY(30px)';
            el.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
            
            observer.observe(el);
        });

        // Counter animation for stats
        this.initCounterAnimation();
    },

    // ===== COUNTER ANIMATION =====
    initCounterAnimation() {
        const counters = document.querySelectorAll('[data-count]');
        
        counters.forEach(counter => {
            const target = parseInt(counter.getAttribute('data-count'));
            const duration = 2000;
            const step = target / (duration / 16);
            let current = 0;

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const updateCounter = () => {
                            if (current < target) {
                                current += step;
                                counter.textContent = Math.floor(current).toLocaleString();
                                requestAnimationFrame(updateCounter);
                            } else {
                                counter.textContent = target.toLocaleString();
                            }
                        };
                        updateCounter();
                        observer.unobserve(counter);
                    }
                });
            });

            observer.observe(counter);
        });
    },

    // ===== LAZY LOADING =====
    initLazyLoading() {
        const images = document.querySelectorAll('img[data-src]');
        
        const imageObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src;
                    img.classList.add('loaded');
                    imageObserver.unobserve(img);
                }
            });
        });

        images.forEach(img => imageObserver.observe(img));
    },

    // ===== PERFORMANCE OPTIMIZATIONS =====
    initPerformanceOptimizations() {
        // Preload critical resources
        this.preloadCriticalResources();
        
        // Initialize service worker (if available)
        this.initServiceWorker();
        
        // Optimize images
        this.optimizeImages();
    },

    preloadCriticalResources() {
        // Preload fonts
        const fontPreload = document.createElement('link');
        fontPreload.rel = 'preload';
        fontPreload.href = 'https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap';
        fontPreload.as = 'style';
        document.head.appendChild(fontPreload);
    },

    initServiceWorker() {
        if ('serviceWorker' in navigator) {
            window.addEventListener('load', () => {
                navigator.serviceWorker.register('/sw.js')
                    .then(() => console.log('Service Worker registered'))
                    .catch(() => console.log('Service Worker registration failed'));
            });
        }
    },

    optimizeImages() {
        const images = document.querySelectorAll('img');
        
        images.forEach(img => {
            // Add loading="lazy" to images below the fold
            if (img.getBoundingClientRect().top > window.innerHeight) {
                img.loading = 'lazy';
            }
            
            // Add error handling
            img.addEventListener('error', () => {
                img.style.display = 'none';
                console.warn(`Failed to load image: ${img.src}`);
            });
        });
    },

    // ===== UTILITY FUNCTIONS =====
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },

    throttle(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    },

    // ===== DOWNLOAD TRACKING =====
    trackDownload(platform) {
        // Analytics tracking (replace with your analytics service)
        if (typeof gtag !== 'undefined') {
            gtag('event', 'download', {
                'event_category': 'app',
                'event_label': platform,
                'value': 1
            });
        }
        
        console.log(`Download tracked: ${platform}`);
    },

    // ===== THEME SWITCHING (Optional) =====
    initThemeSwitch() {
        const themeSwitch = document.querySelector('[data-theme-switch]');
        
        if (themeSwitch) {
            const currentTheme = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', currentTheme);
            
            themeSwitch.addEventListener('click', () => {
                const newTheme = document.documentElement.getAttribute('data-theme') === 'light' ? 'dark' : 'light';
                document.documentElement.setAttribute('data-theme', newTheme);
                localStorage.setItem('theme', newTheme);
            });
        }
    },

    // ===== ERROR HANDLING =====
    handleError(error, context) {
        console.error(`Error in ${context}:`, error);
        
        // Send error to analytics or logging service
        if (typeof gtag !== 'undefined') {
            gtag('event', 'exception', {
                'description': `${context}: ${error.message}`,
                'fatal': false
            });
        }
    }
};

// ===== FEATURE DETECTION =====
const FeatureDetection = {
    supportsIntersectionObserver: 'IntersectionObserver' in window,
    supportsServiceWorker: 'serviceWorker' in navigator,
    supportsWebP: false,
    
    init() {
        this.detectWebP();
        this.addFeatureClasses();
    },
    
    detectWebP() {
        const webP = new Image();
        webP.onload = webP.onerror = () => {
            this.supportsWebP = (webP.height === 2);
            if (this.supportsWebP) {
                document.documentElement.classList.add('webp');
            }
        };
        webP.src = 'data:image/webp;base64,UklGRjoAAABXRUJQVlA4IC4AAACyAgCdASoCAAIALmk0mk0iIiIiIgBoSygABc6WWgAA/veff/0PP8bA//LwYAAA';
    },
    
    addFeatureClasses() {
        const html = document.documentElement;
        
        if (this.supportsIntersectionObserver) {
            html.classList.add('intersection-observer');
        }
        
        if (this.supportsServiceWorker) {
            html.classList.add('service-worker');
        }
        
        if ('ontouchstart' in window) {
            html.classList.add('touch');
        }
    }
};

// ===== PERFORMANCE MONITORING =====
const PerformanceMonitor = {
    init() {
        if ('performance' in window) {
            window.addEventListener('load', () => {
                setTimeout(() => {
                    const perfData = performance.getEntriesByType('navigation')[0];
                    const loadTime = perfData.loadEventEnd - perfData.loadEventStart;
                    
                    console.log(`Page load time: ${loadTime}ms`);
                    
                    // Send performance data to analytics
                    if (typeof gtag !== 'undefined') {
                        gtag('event', 'timing_complete', {
                            'name': 'page_load',
                            'value': Math.round(loadTime)
                        });
                    }
                }, 0);
            });
        }
    }
};

// ===== INITIALIZATION =====
document.addEventListener('DOMContentLoaded', () => {
    try {
        FeatureDetection.init();
        PerformanceMonitor.init();
        P2LANApp.init();
    } catch (error) {
        P2LANApp.handleError(error, 'initialization');
    }
});

// ===== GLOBAL ERROR HANDLER =====
window.addEventListener('error', (event) => {
    P2LANApp.handleError(event.error, 'global');
});

window.addEventListener('unhandledrejection', (event) => {
    P2LANApp.handleError(event.reason, 'promise rejection');
});

// ===== EXPORT FOR MODULE SYSTEMS =====
if (typeof module !== 'undefined' && module.exports) {
    module.exports = P2LANApp;
}

// ===== LEGACY BROWSER SUPPORT =====
(function() {
    // Polyfill for older browsers
    if (!Array.prototype.forEach) {
        Array.prototype.forEach = function(callback, thisArg) {
            for (let i = 0; i < this.length; i++) {
                callback.call(thisArg, this[i], i, this);
            }
        };
    }
    
    if (!Element.prototype.classList) {
        // Simple classList polyfill
        Element.prototype.classList = {
            add: function(className) {
                if (!this.className.includes(className)) {
                    this.className += (this.className ? ' ' : '') + className;
                }
            },
            remove: function(className) {
                this.className = this.className.replace(new RegExp('\\b' + className + '\\b'), '').trim();
            },
            toggle: function(className) {
                if (this.className.includes(className)) {
                    this.remove(className);
                } else {
                    this.add(className);
                }
            },
            contains: function(className) {
                return this.className.includes(className);
            }
        };
    }
})();
