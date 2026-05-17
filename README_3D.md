# 🚀 3D Portfolio Website

A stunning, interactive 3D portfolio website built with Three.js, featuring immersive 3D graphics, smooth animations, and a modern design.

## ✨ Features

- **3D Background**: Interactive particle system with Three.js
- **Animated 3D Objects**: Rotating torus knot, floating cubes, and orbiting spheres
- **Smooth Animations**: Scroll-based animations and transitions
- **Dark/Light Theme**: Toggle between themes with smooth transitions
- **Typing Effect**: Dynamic text animation in hero section
- **Responsive Design**: Fully responsive across all devices
- **Modern UI**: Clean, professional design with gradient accents
- **Performance Optimized**: Efficient rendering and animations

## 🛠️ Technologies Used

- **Three.js** - 3D graphics library
- **HTML5** - Structure
- **CSS3** - Styling with custom properties (CSS variables)
- **Vanilla JavaScript** - Interactivity and animations
- **Font Awesome** - Icons
- **Google Fonts** - Typography (Inter & Space Grotesk)

## 📁 File Structure

```
Portfolio/
├── index.html          # Main HTML file
├── styles.css          # All styling and animations
├── app.js              # Main application logic
├── scene.js            # Three.js scene management
├── portfolioData.js    # Portfolio content data
└── README_3D.md        # This file
```

## 🚀 Getting Started

### Option 1: Open Directly in Browser

1. Simply open `index.html` in your web browser
2. That's it! No build process required.

### Option 2: Use a Local Server (Recommended)

For the best experience, use a local development server:

**Using Python:**
```bash
# Python 3
python -m http.server 8000

# Then open: http://localhost:8000
```

**Using Node.js (http-server):**
```bash
npx http-server -p 8000

# Then open: http://localhost:8000
```

**Using VS Code Live Server:**
1. Install "Live Server" extension
2. Right-click on `index.html`
3. Select "Open with Live Server"

## 🎨 Customization

### Update Personal Information

Edit `portfolioData.js` to update:
- Personal details (name, email, social links)
- Skills and proficiency levels
- Projects and descriptions
- Work experience

### Modify Colors

Edit CSS variables in `styles.css`:
```css
:root {
    --primary: #6366f1;      /* Primary color */
    --secondary: #06b6d4;    /* Secondary color */
    --accent: #8b5cf6;       /* Accent color */
    /* ... more variables */
}
```

### Adjust 3D Effects

Modify 3D scenes in `scene.js`:
- Change particle count
- Modify geometry types
- Adjust animation speeds
- Add new 3D objects

## 📱 Responsive Breakpoints

- **Desktop**: > 1024px
- **Tablet**: 768px - 1024px
- **Mobile**: < 768px

## 🎯 Sections

1. **Hero** - Introduction with animated text and 3D torus knot
2. **About** - Personal bio with floating 3D cubes
3. **Skills** - Skill categories with progress bars and orbiting spheres
4. **Projects** - Featured projects with hover effects
5. **Experience** - Timeline of work history
6. **Contact** - Contact form and social links

## ⚡ Performance Tips

1. **Reduce Particles**: Lower `particlesCount` in scene.js for better performance on slower devices
2. **Simplify Geometry**: Use lower polygon counts for 3D objects
3. **Disable 3D on Mobile**: Add media queries to hide 3D canvases on small screens if needed

## 🌐 Deployment

### Deploy to GitHub Pages

1. Create a new repository on GitHub
2. Push your files:
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/portfolio.git
git push -u origin main
```
3. Go to repository Settings > Pages
4. Select "main" branch as source
5. Your site will be live at `https://YOUR_USERNAME.github.io/portfolio/`

### Deploy to Netlify

1. Create account at [netlify.com](https://netlify.com)
2. Drag and drop your project folder
3. Your site is live!

### Deploy to Vercel

1. Create account at [vercel.com](https://vercel.com)
2. Import your Git repository
3. Deploy with one click

## 🐛 Troubleshooting

### 3D Scenes Not Showing

- Check browser console for errors
- Ensure Three.js CDN is loading correctly
- Verify canvas elements exist in HTML

### Performance Issues

- Reduce particle count in `scene.js`
- Lower the pixel ratio: `renderer.setPixelRatio(1)`
- Simplify 3D geometries

### Font Icons Not Loading

- Check internet connection (Font Awesome CDN)
- Verify Font Awesome CDN link in HTML

## 📄 Browser Support

- ✅ Chrome (recommended)
- ✅ Firefox
- ✅ Safari
- ✅ Edge
- ⚠️ IE11 (Limited support for 3D features)

## 🤝 Contributing

Feel free to fork this project and customize it for your own portfolio!

## 📝 License

This project is open source and available under the MIT License.

## 👨‍💻 Author

**Vishnu**
- Email: vishnuviez@gmail.com
- GitHub: [@vishnuviez](https://github.com/vishnuviez)
- LinkedIn: [vishnuviez](https://linkedin.com/in/vishnuviez)

---

Built with ❤️ using Three.js

