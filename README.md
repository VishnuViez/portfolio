# 🚀 Vishnu's Portfolio - Mobile App Developer

A stunning, modern portfolio website built with **Flutter Web**, featuring beautiful animations, dark/light theme switching, and an intelligent AI chatbot.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## ✨ Features

### 🎨 **Modern Design**
- Clean, professional UI with smooth animations
- Fully responsive (Mobile, Tablet, Desktop)
- Light & Dark theme with persistent preferences
- Gradient accents and modern color schemes

### 🎭 **Smooth Animations**
- Scroll-triggered reveal animations
- Hover effects on interactive elements
- Page transition animations
- Typing text animations
- Shimmer effects

### 🤖 **AI-Powered Chatbot**
- Interactive chatbot trained on your profile
- Answers questions about skills, experience, and projects
- Quick suggestion chips for common questions
- Typing indicators for natural conversation feel
- Floating chat button with pulse animation

### 📱 **Sections Included**
1. **Hero Section** - Animated introduction with social links
2. **About Me** - Professional bio with stats and highlights
3. **Skills & Expertise** - Categorized skills with proficiency levels
4. **Featured Projects** - Project cards with technologies and highlights
5. **Experience** - Timeline of professional experience
6. **Contact** - Contact form and social links

### 🛠️ **Technologies**
- **Mobile:** Kotlin, Java, Flutter, Android SDK, XML
- **Architecture:** MVVM, MVP, MVC, Clean Architecture
- **Networking:** Retrofit, REST APIs, GraphQL
- **Backend:** Python, Flask, Machine Learning, AI
- **Tools:** Git, Firebase, Room Database, CI/CD

## 📦 Installation

### Prerequisites
- Flutter SDK (3.10+)
- Dart SDK
- Chrome browser (for web testing)

The production build will be in the `build/web` directory.

## 🎨 Customization

### Update Your Information

Edit the file `lib/data/portfolio_data.dart` to customize:

```dart
// Personal Information
static const String name = "Your Name";
static const String title = "Your Title";
static const String email = "your.email@example.com";
static const String github = "https://github.com/yourusername";
static const String linkedin = "https://linkedin.com/in/yourusername";

// Add/Edit Skills
static List<SkillCategory> skillCategories = [
  SkillCategory(
    name: "Mobile Development",
    skills: [
      Skill(name: "Kotlin", proficiency: 0.95, category: "Mobile"),
      // Add more skills...
    ],
  ),
];

// Add/Edit Projects
static List<Project> projects = [
  Project(
    title: "Your Project",
    description: "Project description",
    technologies: ["Tech1", "Tech2"],
    highlights: ["Feature 1", "Feature 2"],
  ),
];
```

### Customize Theme Colors

Edit `lib/theme/app_theme.dart`:

```dart
// Light Theme Colors
static const Color lightPrimary = Color(0xFF2563EB);  // Change primary color
static const Color lightSecondary = Color(0xFF7C3AED); // Change secondary color

// Dark Theme Colors  
static const Color darkPrimary = Color(0xFF60A5FA);
static const Color darkSecondary = Color(0xFFA78BFA);
```

### Customize Chatbot Responses

Edit `lib/services/chatbot_service.dart` to modify chatbot responses and add new patterns.

## 📱 Responsive Design

The portfolio automatically adapts to different screen sizes:
- **Desktop** (> 1200px): Full layout with side-by-side content
- **Tablet** (768px - 1200px): Adjusted layout for medium screens
- **Mobile** (< 768px): Stack layout with mobile menu

## 🎯 Key Components

### Navigation Bar
- Smooth scroll to sections
- Active section highlighting
- Theme toggle button
- Mobile hamburger menu

### Hero Section
- Animated typing text with multiple roles
- CTA buttons (View Work, Download Resume)
- Social media links
- Fade and slide animations

### Projects Section
- Grid layout (responsive)
- Hover effects
- Technology tags
- GitHub & Live demo links

### Chatbot
- Floating button with pulse animation
- Full-screen chat window
- Typing indicators
- Quick suggestions
- Pattern-based responses

## 🚀 Deployment

### GitHub Pages
```bash
flutter build web --release --base-href "/your-repo-name/"
# Upload build/web contents to GitHub Pages
```

### Firebase Hosting
```bash
flutter build web --release
firebase deploy
```

### Netlify
```bash
flutter build web --release
# Drag and drop build/web folder to Netlify
```

### Custom Server
```bash
flutter build web --release
# Upload build/web contents to your web server
```

## 📝 Project Structure

```
lib/
├── main.dart                 # App entry point
├── data/
│   └── portfolio_data.dart   # Your information & content
├── models/
│   ├── project.dart          # Project model
│   ├── skill.dart            # Skill model
│   └── message.dart          # Chat message model
├── providers/
│   └── theme_provider.dart   # Theme state management
├── sections/
│   ├── hero/                 # Hero section
│   ├── about/                # About section
│   ├── skills/               # Skills section
│   ├── projects/             # Projects section
│   ├── experience/           # Experience section
│   └── contact/              # Contact section
├── services/
│   └── chatbot_service.dart  # Chatbot logic
├── theme/
│   └── app_theme.dart        # Theme configuration
└── widgets/
    ├── navigation/           # Navigation bar
    ├── footer/               # Footer section
    └── chatbot/              # Chatbot widget
```

## 🎓 Technologies Used

- **Flutter** - UI framework
- **Provider** - State management
- **flutter_animate** - Animation library
- **animated_text_kit** - Text animations
- **visibility_detector** - Scroll animations
- **font_awesome_flutter** - Icons
- **url_launcher** - Open links
- **shared_preferences** - Theme persistence

## 📧 Contact

For questions or collaboration:
- **Email:** your.email@example.com
- **GitHub:** https://github.com/yourusername
- **LinkedIn:** https://linkedin.com/in/yourusername

---

**Built with ❤️ using Flutter**

🌟 Star this repo if you find it useful!
