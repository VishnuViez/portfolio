import '../models/project.dart';
import '../models/skill.dart';

class PortfolioData {
  // Personal Information
  static const String name = "Vishnu";
  static const String title = "Mobile Application Developer";
  static const String tagline = "Crafting seamless mobile experiences with native Android & cross-platform expertise";
  static const String bio = """
I'm a passionate Mobile Application Developer specializing in building high-performance Android applications. 
With expertise in Kotlin, Java, and Flutter, I create elegant solutions that combine robust architecture patterns 
(MVP, MVVM, MVC) with modern development practices. I also leverage Python, Flask, Machine Learning, and AI 
to build intelligent, data-driven applications that solve real-world problems.
""";

  static const String email = "vishnuviez@gmail.com";
  static const String github = "https://github.com/VishnuViez";
  static const String linkedin = "https://www.linkedin.com/in/vishnuviez/";
  static const String phone = "+1234567890";

  // Skills organized by category
  static List<SkillCategory> skillCategories = [
    SkillCategory(
      name: "Mobile Development",
      skills: [
        Skill(name: "Kotlin", proficiency: 0.95, category: "Mobile"),
        Skill(name: "Java", proficiency: 0.90, category: "Mobile"),
        Skill(name: "Flutter", proficiency: 0.85, category: "Mobile"),
        Skill(name: "Android SDK", proficiency: 0.90, category: "Mobile"),
        Skill(name: "XML Layouts", proficiency: 0.90, category: "Mobile"),
        Skill(name: "Jetpack Compose", proficiency: 0.80, category: "Mobile"),
      ],
    ),
    SkillCategory(
      name: "Architecture & Patterns",
      skills: [
        Skill(name: "MVVM", proficiency: 0.90, category: "Architecture"),
        Skill(name: "MVP", proficiency: 0.85, category: "Architecture"),
        Skill(name: "MVC", proficiency: 0.85, category: "Architecture"),
        Skill(name: "Clean Architecture", proficiency: 0.80, category: "Architecture"),
      ],
    ),
    SkillCategory(
      name: "Networking & APIs",
      skills: [
        Skill(name: "Retrofit", proficiency: 0.90, category: "Networking"),
        Skill(name: "REST APIs", proficiency: 0.90, category: "Networking"),
        Skill(name: "GraphQL", proficiency: 0.70, category: "Networking"),
        Skill(name: "WebSockets", proficiency: 0.75, category: "Networking"),
      ],
    ),
    SkillCategory(
      name: "Backend & AI/ML",
      skills: [
        Skill(name: "Python", proficiency: 0.85, category: "Backend"),
        Skill(name: "Flask", proficiency: 0.80, category: "Backend"),
        Skill(name: "Machine Learning", proficiency: 0.75, category: "AI/ML"),
        Skill(name: "Artificial Intelligence", proficiency: 0.75, category: "AI/ML"),
        Skill(name: "TensorFlow", proficiency: 0.70, category: "AI/ML"),
      ],
    ),
    SkillCategory(
      name: "Tools & Technologies",
      skills: [
        Skill(name: "Git", proficiency: 0.90, category: "Tools"),
        Skill(name: "Firebase", proficiency: 0.85, category: "Tools"),
        Skill(name: "Room Database", proficiency: 0.85, category: "Tools"),
        Skill(name: "SQLite", proficiency: 0.85, category: "Tools"),
        Skill(name: "CI/CD", proficiency: 0.75, category: "Tools"),
      ],
    ),
  ];

  // Projects
  static List<Project> projects = [
    Project(
      title: "E-Commerce Mobile App",
      description: "A full-featured e-commerce application with product catalog, cart management, and secure payment integration.",
      githubUrl: "https://github.com/VishnuViez/portfolio/tree/main/projects/ecommerce_app",
      technologies: ["Kotlin", "MVVM", "Retrofit", "Room", "Firebase"],
      highlights: [
        "Implemented clean architecture with MVVM pattern",
        "Integrated payment gateway with 99.9% success rate",
        "Optimized app performance for smooth 60fps animations",
        "Implemented offline-first approach with Room database",
      ],
    ),
    Project(
      title: "Fitness Tracker with AI",
      description: "An intelligent fitness tracking app that uses ML models to provide personalized workout recommendations.",
      githubUrl: "https://github.com/VishnuViez/portfolio/tree/main/projects/fitness_tracker_ai",
      technologies: ["Flutter", "Python", "TensorFlow", "Flask", "Firebase"],
      highlights: [
        "Built ML model for exercise recognition with 94% accuracy",
        "Cross-platform app serving 10K+ active users",
        "Real-time workout tracking with live statistics",
        "RESTful API backend with Flask and PostgreSQL",
      ],
    ),
    Project(
      title: "Social Media Dashboard",
      description: "A comprehensive social media management dashboard for scheduling posts and analytics.",
      githubUrl: "https://github.com/VishnuViez/portfolio/tree/main/projects/social_media_dashboard",
      technologies: ["Java", "MVP", "Retrofit", "Material Design"],
      highlights: [
        "Multi-account management for 5+ social platforms",
        "Implemented efficient image caching mechanism",
        "Push notifications for engagement metrics",
        "Analytics dashboard with interactive charts",
      ],
    ),
    Project(
      title: "Chat Application",
      description: "Real-time messaging app with end-to-end encryption and multimedia support.",
      githubUrl: "https://github.com/VishnuViez/portfolio/tree/main/projects/chat_app",
      technologies: ["Kotlin", "WebSockets", "Firebase", "Jetpack Compose"],
      highlights: [
        "Real-time messaging with WebSocket connection",
        "End-to-end encryption for secure communication",
        "Modern UI built with Jetpack Compose",
        "Support for text, images, videos, and voice messages",
      ],
    ),
    Project(
      title: "Weather Forecast App",
      description: "Beautiful weather app with accurate forecasts and location-based alerts.",
      githubUrl: "https://github.com/VishnuViez/portfolio/tree/main/projects/weather_forecast",
      technologies: ["Flutter", "REST API", "Provider", "Geolocator"],
      highlights: [
        "Integration with multiple weather APIs",
        "Location-based severe weather alerts",
        "Animated weather visualizations",
        "7-day and hourly forecast views",
      ],
    ),
  ];

  // Experience
  static List<Map<String, dynamic>> experience = [
    {
      "company": "CronJ IT Technologies",
      "position": "Android Developer (SDE-2)",
      "duration": "Feb 2023 - Dec 2024",
      "description": "Developed new features and modules with stateful and stateless widgets in Flutter and implemented for multi-platform usage.",
      "achievements": [
        "Improved application performance by 30% using ViewBinding and DataBinding",
        "Implemented Firebase Crashlytics for optimal defect management",
        "Made production releases with app signing in native Android development",
        "Performed code reviews and recommended best practices for improvements",
        "Integrated Firebase Analytics and ProGuard for monitoring application statistics",
      ],
    },
    {
      "company": "Aroha Technologies Pvt Ltd",
      "position": "Android Developer",
      "duration": "Dec 2021 - Nov 2022",
      "description": "Developed several modules following MVVM architecture for both mobile and PAX devices.",
      "achievements": [
        "Developed UI from wireframes for mobile and PAX applications",
        "Implemented QR scanning using play-services-vision (EAN, ITF, UPC, QR)",
        "Integrated Firebase Cloud Messaging and third-party calendar libraries",
        "Developed custom views for optimized reusable UI components",
        "Successfully published apps on PlayStore and PAXStore",
      ],
    },
    {
      "company": "Infount - The Source of IT Solutions",
      "position": "Software Developer",
      "duration": "Jun 2019 - Aug 2021",
      "description": "Designed and created software solutions using Test-Driven Development to solve client painpoints.",
      "achievements": [
        "Designed and created software solutions for various clients",
        "Checked feasibility of software prototypes",
        "Modified code to fix errors and improve functionality",
        "Created designer templates for different Android projects",
      ],
    },
  ];
}
