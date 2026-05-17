import '../data/portfolio_data.dart';

class ChatbotService {
  // Knowledge base for the chatbot
  static final Map<String, String> _responses = {
    'greeting': "Hello! I'm Vishnu's AI assistant. I can help you learn about his skills, projects, and experience. What would you like to know?",
    'skills': "Vishnu is an expert Mobile Application Developer with skills in:\n\n• Mobile: Kotlin, Java, Flutter, Android SDK\n• Architecture: MVVM, MVP, MVC, Clean Architecture\n• Networking: Retrofit, REST APIs, GraphQL\n• Backend & AI: Python, Flask, Machine Learning, TensorFlow\n• Tools: Git, Firebase, Room Database, CI/CD\n\nWhat specific skill would you like to know more about?",
    'projects': "Vishnu has worked on several impressive projects including:\n\n1. E-Commerce Mobile App (Kotlin, MVVM)\n2. Fitness Tracker with AI (Flutter, ML)\n3. Social Media Dashboard (Java, MVP)\n4. Real-time Chat Application (Kotlin, WebSockets)\n5. Weather Forecast App (Flutter)\n\nWould you like details about any specific project?",
    'experience': "Vishnu has ${PortfolioData.experience.length}+ years of professional experience:\n\n• Currently: Senior Mobile Developer at Tech Solutions Inc.\n• Previously: Android Developer at Mobile Innovations Ltd.\n• Started: Mobile App Developer at StartUp Studios\n\nHe has led teams, mentored developers, and delivered 50+ production applications. What aspect of his experience interests you?",
    'contact': "You can reach Vishnu through:\n\n📧 Email: ${PortfolioData.email}\n🔗 GitHub: ${PortfolioData.github}\n💼 LinkedIn: ${PortfolioData.linkedin}\n\nFeel free to connect for collaborations or opportunities!",
    'kotlin': "Vishnu is highly proficient in Kotlin (95%) and has used it extensively for:\n\n• Building native Android applications\n• Implementing Clean Architecture patterns\n• Creating reactive programming with Coroutines & Flow\n• Developing modern UIs with Jetpack Compose\n\nHe considers Kotlin his primary language for Android development.",
    'flutter': "Vishnu has strong expertise in Flutter (85%) and has:\n\n• Built cross-platform apps for iOS and Android\n• Implemented complex state management with Provider & Bloc\n• Created beautiful, responsive UIs\n• Integrated native platform features\n• Developed apps serving 10K+ active users",
    'mvvm': "Vishnu is an expert in MVVM architecture (90%) and applies it to:\n\n• Separate UI logic from business logic\n• Implement clean, testable code\n• Use ViewModel and LiveData/StateFlow\n• Integrate with Repository pattern\n• Ensure maintainable and scalable apps",
    'ml': "Vishnu has experience with Machine Learning (75%) including:\n\n• Building ML models with TensorFlow\n• Integrating ML into mobile applications\n• Exercise recognition with 94% accuracy\n• Python-based ML pipelines\n• AI-powered features in apps",
    'default': "I'm not sure about that specific question, but I can tell you about:\n\n• Vishnu's skills and technologies\n• His projects and achievements\n• Work experience and career\n• How to contact him\n\nWhat would you like to explore?"
  };

  static String getResponse(String userMessage) {
    final message = userMessage.toLowerCase().trim();

    // Greeting patterns
    if (_containsAny(message, ['hi', 'hello', 'hey', 'greetings', 'good morning', 'good afternoon'])) {
      return _responses['greeting']!;
    }

    // Skills patterns
    if (_containsAny(message, ['skill', 'technology', 'tech stack', 'expertise', 'proficiency', 'what can', 'what does', 'know about'])) {
      if (_containsAny(message, ['kotlin'])) {
        return _responses['kotlin']!;
      }
      if (_containsAny(message, ['flutter', 'cross platform', 'dart'])) {
        return _responses['flutter']!;
      }
      if (_containsAny(message, ['mvvm', 'architecture', 'pattern', 'mvp', 'mvc'])) {
        return _responses['mvvm']!;
      }
      if (_containsAny(message, ['ml', 'machine learning', 'ai', 'artificial intelligence', 'tensorflow'])) {
        return _responses['ml']!;
      }
      return _responses['skills']!;
    }

    // Projects patterns
    if (_containsAny(message, ['project', 'work', 'portfolio', 'built', 'developed', 'created', 'app'])) {
      return _responses['projects']!;
    }

    // Experience patterns
    if (_containsAny(message, ['experience', 'career', 'job', 'work', 'company', 'years', 'background'])) {
      return _responses['experience']!;
    }

    // Contact patterns
    if (_containsAny(message, ['contact', 'email', 'reach', 'connect', 'hire', 'available'])) {
      return _responses['contact']!;
    }

    // About patterns
    if (_containsAny(message, ['who', 'about', 'tell me', 'introduce'])) {
      return "Vishnu is a passionate Mobile Application Developer specializing in Android and cross-platform development. With expertise in Kotlin, Java, Flutter, and modern architecture patterns, he creates high-performance apps. He also works with Python, Flask, and Machine Learning to build intelligent applications.\n\nWhat specific aspect would you like to know more about?";
    }

    // Education patterns
    if (_containsAny(message, ['education', 'degree', 'university', 'college', 'study'])) {
      return "I don't have specific information about Vishnu's education in my database, but based on his expertise and professional experience, he has a strong technical background in Computer Science and Software Engineering.\n\nWould you like to know about his professional skills or projects instead?";
    }

    // Availability patterns
    if (_containsAny(message, ['available', 'open to', 'looking for', 'hiring', 'freelance'])) {
      return "Vishnu is always interested in exciting opportunities and collaborations! You can reach out to discuss:\n\n• Full-time positions\n• Contract/Freelance work\n• Consulting opportunities\n• Open source collaborations\n\nContact him at: ${PortfolioData.email}";
    }

    return _responses['default']!;
  }

  static bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  static List<String> getSuggestions() {
    return [
      "What are your skills?",
      "Tell me about your projects",
      "What's your experience?",
      "How can I contact you?",
      "What technologies do you know?",
      "Are you available for work?",
    ];
  }
}
