// Portfolio Data
const portfolioData = {
    // Personal Information
    personal: {
        name: "Vishnu",
        title: "Mobile Application Developer",
        tagline: "Crafting seamless mobile experiences with native Android & cross-platform expertise",
        bio: `I'm a passionate Mobile Application Developer specializing in building high-performance Android applications. 
With expertise in Kotlin, Java, and Flutter, I create elegant solutions that combine robust architecture patterns 
(MVP, MVVM, MVC) with modern development practices. I also leverage Python, Flask, Machine Learning, and AI 
to build intelligent, data-driven applications that solve real-world problems.`,
        email: "vishnuviez@gmail.com",
        github: "https://github.com/vishnuviez",
        linkedin: "https://linkedin.com/in/vishnuviez",
        phone: "+1234567890"
    },

    // Skills organized by category
    skillCategories: [
        {
            name: "Mobile Development",
            skills: [
                { name: "Kotlin", proficiency: 95 },
                { name: "Java", proficiency: 90 },
                { name: "Flutter", proficiency: 85 },
                { name: "Android SDK", proficiency: 90 },
                { name: "XML Layouts", proficiency: 90 },
                { name: "Jetpack Compose", proficiency: 80 }
            ]
        },
        {
            name: "Architecture & Patterns",
            skills: [
                { name: "MVVM", proficiency: 90 },
                { name: "MVP", proficiency: 85 },
                { name: "MVC", proficiency: 85 },
                { name: "Clean Architecture", proficiency: 80 }
            ]
        },
        {
            name: "Networking & APIs",
            skills: [
                { name: "Retrofit", proficiency: 90 },
                { name: "REST APIs", proficiency: 90 },
                { name: "GraphQL", proficiency: 70 },
                { name: "WebSockets", proficiency: 75 }
            ]
        },
        {
            name: "Backend & AI/ML",
            skills: [
                { name: "Python", proficiency: 85 },
                { name: "Flask", proficiency: 80 },
                { name: "Machine Learning", proficiency: 75 },
                { name: "Artificial Intelligence", proficiency: 75 },
                { name: "TensorFlow", proficiency: 70 }
            ]
        },
        {
            name: "Tools & Technologies",
            skills: [
                { name: "Git", proficiency: 90 },
                { name: "Firebase", proficiency: 85 },
                { name: "Room Database", proficiency: 85 },
                { name: "SQLite", proficiency: 85 },
                { name: "CI/CD", proficiency: 75 }
            ]
        }
    ],

    // Projects
    projects: [
        {
            title: "E-Commerce Mobile App",
            description: "A full-featured e-commerce application with product catalog, cart management, and secure payment integration.",
            technologies: ["Kotlin", "MVVM", "Retrofit", "Room", "Firebase"],
            highlights: [
                "Implemented clean architecture with MVVM pattern",
                "Integrated payment gateway with 99.9% success rate",
                "Optimized app performance for smooth 60fps animations",
                "Implemented offline-first approach with Room database"
            ]
        },
        {
            title: "Fitness Tracker with AI",
            description: "An intelligent fitness tracking app that uses ML models to provide personalized workout recommendations.",
            technologies: ["Flutter", "Python", "TensorFlow", "Flask", "Firebase"],
            highlights: [
                "Built ML model for exercise recognition with 94% accuracy",
                "Cross-platform app serving 10K+ active users",
                "Real-time workout tracking with live statistics",
                "RESTful API backend with Flask and PostgreSQL"
            ]
        },
        {
            title: "Social Media Dashboard",
            description: "A comprehensive social media management dashboard for scheduling posts and analytics.",
            technologies: ["Java", "MVP", "Retrofit", "Material Design"],
            highlights: [
                "Multi-account management for 5+ social platforms",
                "Implemented efficient image caching mechanism",
                "Push notifications for engagement metrics",
                "Analytics dashboard with interactive charts"
            ]
        },
        {
            title: "Chat Application",
            description: "Real-time messaging app with end-to-end encryption and multimedia support.",
            technologies: ["Kotlin", "WebSockets", "Firebase", "Jetpack Compose"],
            highlights: [
                "Real-time messaging with WebSocket connection",
                "End-to-end encryption for secure communication",
                "Modern UI built with Jetpack Compose",
                "Support for text, images, videos, and voice messages"
            ]
        },
        {
            title: "Weather Forecast App",
            description: "Beautiful weather app with accurate forecasts and location-based alerts.",
            technologies: ["Flutter", "REST API", "Provider", "Geolocator"],
            highlights: [
                "Integration with multiple weather APIs",
                "Location-based severe weather alerts",
                "Animated weather visualizations",
                "7-day and hourly forecast views"
            ]
        }
    ],

    // Experience
    experience: [
        {
            company: "CronJ IT Technologies",
            position: "Android Developer (SDE-2)",
            duration: "Feb 2023 - Dec 2024",
            description: "Developed new features and modules with stateful and stateless widgets in Flutter and implemented for multi-platform usage.",
            achievements: [
                "Improved application performance by 30% using ViewBinding and DataBinding",
                "Implemented Firebase Crashlytics for optimal defect management",
                "Made production releases with app signing in native Android development",
                "Performed code reviews and recommended best practices for improvements",
                "Integrated Firebase Analytics and ProGuard for monitoring application statistics"
            ]
        },
        {
            company: "Aroha Technologies Pvt Ltd",
            position: "Android Developer",
            duration: "Dec 2021 - Nov 2022",
            description: "Developed several modules following MVVM architecture for both mobile and PAX devices.",
            achievements: [
                "Developed UI from wireframes for mobile and PAX applications",
                "Implemented QR scanning using play-services-vision (EAN, ITF, UPC, QR)",
                "Integrated Firebase Cloud Messaging and third-party calendar libraries",
                "Developed custom views for optimized reusable UI components",
                "Successfully published apps on PlayStore and PAXStore"
            ]
        },
        {
            company: "Infount - The Source of IT Solutions",
            position: "Software Developer",
            duration: "Jun 2019 - Aug 2021",
            description: "Designed and created software solutions using Test-Driven Development to solve client painpoints.",
            achievements: [
                "Designed and created software solutions for various clients",
                "Checked feasibility of software prototypes",
                "Modified code to fix errors and improve functionality",
                "Created designer templates for different Android projects"
            ]
        }
    ]
};

// Chatbot Service
class ChatbotService {
    static responses = {
        'greeting': "Hello! I'm Vishnu's AI assistant. I can help you learn about his skills, projects, and experience. What would you like to know?",
        'skills': "Vishnu is an expert Mobile Application Developer with skills in:\n\n• Mobile: Kotlin, Java, Flutter, Android SDK\n• Architecture: MVVM, MVP, MVC, Clean Architecture\n• Networking: Retrofit, REST APIs, GraphQL\n• Backend & AI: Python, Flask, Machine Learning, TensorFlow\n• Tools: Git, Firebase, Room Database, CI/CD\n\nWhat specific skill would you like to know more about?",
        'projects': "Vishnu has worked on several impressive projects including:\n\n1. E-Commerce Mobile App (Kotlin, MVVM)\n2. Fitness Tracker with AI (Flutter, ML)\n3. Social Media Dashboard (Java, MVP)\n4. Real-time Chat Application (Kotlin, WebSockets)\n5. Weather Forecast App (Flutter)\n\nWould you like details about any specific project?",
        'experience': `Vishnu has ${portfolioData.experience.length}+ years of professional experience:\n\n• CronJ IT Technologies - Android Developer (SDE-2)\n• Aroha Technologies - Android Developer\n• Infount - Software Developer\n\nHe has led teams, mentored developers, and delivered 50+ production applications. What aspect of his experience interests you?`,
        'contact': `You can reach Vishnu through:\n\n📧 Email: ${portfolioData.personal.email}\n🔗 GitHub: ${portfolioData.personal.github}\n💼 LinkedIn: ${portfolioData.personal.linkedin}\n\nFeel free to connect for collaborations or opportunities!`,
        'kotlin': "Vishnu is highly proficient in Kotlin (95%) and has used it extensively for:\n\n• Building native Android applications\n• Implementing Clean Architecture patterns\n• Creating reactive programming with Coroutines & Flow\n• Developing modern UIs with Jetpack Compose\n\nHe considers Kotlin his primary language for Android development.",
        'flutter': "Vishnu has strong expertise in Flutter (85%) and has:\n\n• Built cross-platform apps for iOS and Android\n• Implemented complex state management with Provider & Bloc\n• Created beautiful, responsive UIs\n• Integrated native platform features\n• Developed apps serving 10K+ active users",
        'mvvm': "Vishnu is an expert in MVVM architecture (90%) and applies it to:\n\n• Separate UI logic from business logic\n• Implement clean, testable code\n• Use ViewModel and LiveData/StateFlow\n• Integrate with Repository pattern\n• Ensure maintainable and scalable apps",
        'ml': "Vishnu has experience with Machine Learning (75%) including:\n\n• Building ML models with TensorFlow\n• Integrating ML into mobile applications\n• Exercise recognition with 94% accuracy\n• Python-based ML pipelines\n• AI-powered features in apps",
        'default': "I'm not sure about that specific question, but I can tell you about:\n\n• Vishnu's skills and technologies\n• His projects and achievements\n• Work experience and career\n• How to contact him\n\nWhat would you like to explore?"
    };

    static getResponse(userMessage) {
        const message = userMessage.toLowerCase().trim();

        // Greeting patterns
        if (this.containsAny(message, ['hi', 'hello', 'hey', 'greetings', 'good morning', 'good afternoon', 'sup'])) {
            return this.responses.greeting;
        }

        // Skills patterns
        if (this.containsAny(message, ['skill', 'technology', 'tech stack', 'expertise', 'proficiency', 'what can', 'what does', 'know about'])) {
            if (this.containsAny(message, ['kotlin'])) {
                return this.responses.kotlin;
            }
            if (this.containsAny(message, ['flutter', 'cross platform', 'dart'])) {
                return this.responses.flutter;
            }
            if (this.containsAny(message, ['mvvm', 'architecture', 'pattern', 'mvp', 'mvc'])) {
                return this.responses.mvvm;
            }
            if (this.containsAny(message, ['ml', 'machine learning', 'ai', 'artificial intelligence', 'tensorflow'])) {
                return this.responses.ml;
            }
            return this.responses.skills;
        }

        // Projects patterns
        if (this.containsAny(message, ['project', 'work', 'portfolio', 'built', 'developed', 'created', 'app'])) {
            return this.responses.projects;
        }

        // Experience patterns
        if (this.containsAny(message, ['experience', 'career', 'job', 'company', 'years', 'background'])) {
            return this.responses.experience;
        }

        // Contact patterns
        if (this.containsAny(message, ['contact', 'email', 'reach', 'connect', 'hire', 'available'])) {
            return this.responses.contact;
        }

        // About patterns
        if (this.containsAny(message, ['who', 'about', 'tell me', 'introduce'])) {
            return "Vishnu is a passionate Mobile Application Developer specializing in Android and cross-platform development. With expertise in Kotlin, Java, Flutter, and modern architecture patterns, he creates high-performance apps. He also works with Python, Flask, and Machine Learning to build intelligent applications.\n\nWhat specific aspect would you like to know more about?";
        }

        // Education patterns
        if (this.containsAny(message, ['education', 'degree', 'university', 'college', 'study'])) {
            return "I don't have specific information about Vishnu's education in my database, but based on his expertise and professional experience, he has a strong technical background in Computer Science and Software Engineering.\n\nWould you like to know about his professional skills or projects instead?";
        }

        // Availability patterns
        if (this.containsAny(message, ['available', 'open to', 'looking for', 'hiring', 'freelance'])) {
            return `Vishnu is always interested in exciting opportunities and collaborations! You can reach out to discuss:\n\n• Full-time positions\n• Contract/Freelance work\n• Consulting opportunities\n• Open source collaborations\n\nContact him at: ${portfolioData.personal.email}`;
        }

        return this.responses.default;
    }

    static containsAny(text, keywords) {
        return keywords.some(keyword => text.includes(keyword));
    }

    static getSuggestions() {
        return [
            "What are your skills?",
            "Tell me about your projects",
            "What's your experience?",
            "How can I contact you?",
            "What technologies do you know?",
            "Are you available for work?"
        ];
    }
}
