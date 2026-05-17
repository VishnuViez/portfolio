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

  static const String email = "your.email@example.com";
  static const String github = "https://github.com/yourusername";
  static const String linkedin = "https://linkedin.com/in/yourusername";
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
      "company": "Tech Solutions Inc.",
      "position": "Senior Mobile Developer",
      "duration": "2023 - Present",
      "description": "Leading mobile development team, architecting scalable Android applications, and mentoring junior developers.",
      "achievements": [
        "Architected and delivered 3 major Android applications",
        "Reduced app crash rate by 75% through optimization",
        "Implemented CI/CD pipeline reducing deployment time by 60%",
        "Mentored 5 junior developers in mobile best practices",
      ],
    },
    {
      "company": "Mobile Innovations Ltd.",
      "position": "Android Developer",
      "duration": "2021 - 2023",
      "description": "Developed and maintained multiple Android applications using Kotlin and Java.",
      "achievements": [
        "Built 10+ production Android applications",
        "Integrated ML models for smart features",
        "Improved app performance by 40%",
        "Collaborated with cross-functional teams",
      ],
    },
    {
      "company": "StartUp Studios",
      "position": "Mobile App Developer",
      "duration": "2020 - 2021",
      "description": "Created cross-platform mobile applications using Flutter.",
      "achievements": [
        "Developed MVP for 5 startup projects",
        "Implemented responsive UI for multiple screen sizes",
        "Integrated third-party APIs and services",
        "Participated in agile development processes",
      ],
    },
  ];
}
