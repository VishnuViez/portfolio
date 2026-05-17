// Main Application Logic
class Portfolio {
    constructor() {
        this.init();
    }

    init() {
        this.setupTheme();
        this.setupNavigation();
        this.setupTypingEffect();
        this.setupTechBadges();
        this.loadSkills();
        this.loadProjects();
        this.loadExperience();
        this.setupScrollAnimations();
        this.setupContactForm();
        this.setupMobileMenu();
        this.setupChatbot();
    }

    // Setup Tech Badges Positioning
    setupTechBadges() {
        const updateBadgePositions = () => {
            const badges = document.querySelectorAll('.tech-badge');
            badges.forEach(badge => {
                const angle = parseFloat(badge.style.getPropertyValue('--angle'));
                let distance = parseFloat(badge.style.getPropertyValue('--distance'));
                
                // Adjust distance based on screen size
                const width = window.innerWidth;
                if (width <= 480) {
                    distance = 110;
                } else if (width <= 768) {
                    distance = 140;
                } else {
                    distance = 180;
                }
                
                // Convert angle to radians
                const radians = angle * (Math.PI / 180);
                
                // Calculate x and y positions
                const x = distance * Math.cos(radians);
                const y = distance * Math.sin(radians);
                
                // Set CSS custom properties for positioning
                badge.style.setProperty('--x', `${x}px`);
                badge.style.setProperty('--y', `${y}px`);
            });
        };

        // Initial setup
        updateBadgePositions();

        // Update on resize
        window.addEventListener('resize', updateBadgePositions);
    }

    // Theme Management
    setupTheme() {
        const themeToggle = document.getElementById('theme-toggle');
        const currentTheme = localStorage.getItem('theme') || 'light';
        
        if (currentTheme === 'dark') {
            document.documentElement.setAttribute('data-theme', 'dark');
            themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
        }

        themeToggle.addEventListener('click', () => {
            const theme = document.documentElement.getAttribute('data-theme');
            const newTheme = theme === 'dark' ? 'light' : 'dark';
            
            document.documentElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            
            themeToggle.innerHTML = newTheme === 'dark' 
                ? '<i class="fas fa-sun"></i>' 
                : '<i class="fas fa-moon"></i>';
            
            // Update Three.js particle color
            if (window.threeScene) {
                const color = newTheme === 'dark' ? '#818cf8' : '#6366f1';
                window.threeScene.updateParticleColor(color);
            }
        });
    }

    // Navigation
    setupNavigation() {
        const navLinks = document.querySelectorAll('.nav-link');
        const sections = document.querySelectorAll('.section');
        
        // Smooth scroll to section
        navLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const targetId = link.getAttribute('href').substring(1);
                const targetSection = document.getElementById(targetId);
                
                if (targetSection) {
                    targetSection.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Highlight active section
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    navLinks.forEach(link => {
                        link.classList.remove('active');
                        if (link.getAttribute('href').substring(1) === entry.target.id) {
                            link.classList.add('active');
                        }
                    });
                }
            });
        }, { threshold: 0.5 });

        sections.forEach(section => observer.observe(section));

        // Navbar scroll effect
        let lastScroll = 0;
        const navbar = document.getElementById('navbar');
        
        window.addEventListener('scroll', () => {
            const currentScroll = window.pageYOffset;
            
            if (currentScroll > 100) {
                navbar.style.boxShadow = '0 2px 20px var(--shadow)';
            } else {
                navbar.style.boxShadow = 'none';
            }
            
            lastScroll = currentScroll;
        });
    }

    // Typing Effect
    setupTypingEffect() {
        const typedTextElement = document.getElementById('typed-text');
        const texts = [
            'Mobile Application Developer',
            'Android Expert',
            'Flutter Developer',
            'AI/ML Enthusiast'
        ];
        let textIndex = 0;
        let charIndex = 0;
        let isDeleting = false;
        let typingSpeed = 100;

        const type = () => {
            const currentText = texts[textIndex];
            
            if (isDeleting) {
                typedTextElement.textContent = currentText.substring(0, charIndex - 1);
                charIndex--;
                typingSpeed = 50;
            } else {
                typedTextElement.textContent = currentText.substring(0, charIndex + 1);
                charIndex++;
                typingSpeed = 100;
            }

            if (!isDeleting && charIndex === currentText.length) {
                isDeleting = true;
                typingSpeed = 2000;
            } else if (isDeleting && charIndex === 0) {
                isDeleting = false;
                textIndex = (textIndex + 1) % texts.length;
                typingSpeed = 500;
            }

            setTimeout(type, typingSpeed);
        };

        type();
    }

    // Load Skills
    loadSkills() {
        const skillsGrid = document.getElementById('skills-grid');
        
        portfolioData.skillCategories.forEach((category, index) => {
            const categoryElement = document.createElement('div');
            categoryElement.className = 'skill-category';
            categoryElement.style.animationDelay = `${index * 0.1}s`;
            
            let skillsHTML = `<h3>${category.name}</h3>`;
            
            category.skills.forEach(skill => {
                skillsHTML += `
                    <div class="skill-item">
                        <div class="skill-header">
                            <span class="skill-name">${skill.name}</span>
                            <span class="skill-percentage">${skill.proficiency}%</span>
                        </div>
                        <div class="skill-bar">
                            <div class="skill-progress" style="--progress: ${skill.proficiency}%"></div>
                        </div>
                    </div>
                `;
            });
            
            categoryElement.innerHTML = skillsHTML;
            skillsGrid.appendChild(categoryElement);
        });

        // Animate skill bars on scroll
        const skillObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                }
            });
        }, { threshold: 0.3 });

        document.querySelectorAll('.skill-category').forEach(category => {
            skillObserver.observe(category);
        });
    }

    // Load Projects
    loadProjects() {
        const projectsGrid = document.getElementById('projects-grid');
        
        portfolioData.projects.forEach((project, index) => {
            const projectCard = document.createElement('div');
            projectCard.className = 'project-card';
            projectCard.style.animationDelay = `${index * 0.1}s`;
            
            let techTagsHTML = '';
            project.technologies.forEach(tech => {
                techTagsHTML += `<span class="tech-tag">${tech}</span>`;
            });
            
            let highlightsHTML = '';
            project.highlights.forEach(highlight => {
                highlightsHTML += `<li>${highlight}</li>`;
            });
            
            projectCard.innerHTML = `
                <div class="project-content">
                    <h3 class="project-title">${project.title}</h3>
                    <p class="project-description">${project.description}</p>
                    <div class="project-tech">${techTagsHTML}</div>
                    <ul class="project-highlights">${highlightsHTML}</ul>
                </div>
            `;
            
            projectsGrid.appendChild(projectCard);
        });

        // Add scroll animation
        const projectObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('fade-in');
                }
            });
        }, { threshold: 0.1 });

        document.querySelectorAll('.project-card').forEach(card => {
            projectObserver.observe(card);
        });
    }

    // Load Experience
    loadExperience() {
        const experienceTimeline = document.getElementById('experience-timeline');
        
        portfolioData.experience.forEach((exp, index) => {
            const expItem = document.createElement('div');
            expItem.className = 'experience-item';
            expItem.style.animationDelay = `${index * 0.2}s`;
            
            let achievementsHTML = '';
            exp.achievements.forEach(achievement => {
                achievementsHTML += `<li>${achievement}</li>`;
            });
            
            expItem.innerHTML = `
                <div class="experience-header">
                    <h3 class="experience-position">${exp.position}</h3>
                    <div class="experience-company">${exp.company}</div>
                    <div class="experience-duration">${exp.duration}</div>
                </div>
                <p class="experience-description">${exp.description}</p>
                <ul class="experience-achievements">${achievementsHTML}</ul>
            `;
            
            experienceTimeline.appendChild(expItem);
        });

        // Add scroll animation
        const expObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('fade-in');
                }
            });
        }, { threshold: 0.1 });

        document.querySelectorAll('.experience-item').forEach(item => {
            expObserver.observe(item);
        });
    }

    // Scroll Animations
    setupScrollAnimations() {
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -100px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('fade-in');
                }
            });
        }, observerOptions);

        // Observe elements for animation
        document.querySelectorAll('.section-title, .about-text, .highlight-item').forEach(el => {
            observer.observe(el);
        });
    }

    // Contact Form
    setupContactForm() {
        const form = document.getElementById('contact-form');
        
        form.addEventListener('submit', (e) => {
            e.preventDefault();
            
            const formData = {
                name: document.getElementById('name').value,
                email: document.getElementById('email').value,
                message: document.getElementById('message').value
            };
            
            // Here you would typically send the data to a server
            console.log('Form submitted:', formData);
            
            // Show success message
            alert('Thank you for your message! I\'ll get back to you soon.');
            
            // Reset form
            form.reset();
        });
    }

    // Mobile Menu
    setupMobileMenu() {
        const mobileToggle = document.querySelector('.mobile-menu-toggle');
        const navMenu = document.querySelector('.nav-menu');
        
        if (mobileToggle) {
            mobileToggle.addEventListener('click', () => {
                navMenu.classList.toggle('active');
                mobileToggle.classList.toggle('active');
            });

            // Close menu when clicking on a link
            document.querySelectorAll('.nav-link').forEach(link => {
                link.addEventListener('click', () => {
                    navMenu.classList.remove('active');
                    mobileToggle.classList.remove('active');
                });
            });
        }
    }

    // Chatbot
    setupChatbot() {
        const chatbotToggle = document.getElementById('chatbot-toggle');
        const chatbotClose = document.getElementById('chatbot-close');
        const chatbotWindow = document.getElementById('chatbot-window');
        const chatbotInput = document.getElementById('chatbot-input');
        const chatbotSend = document.getElementById('chatbot-send');
        const chatbotMessages = document.getElementById('chatbot-messages');
        const chatbotTyping = document.getElementById('chatbot-typing');
        const chatbotSuggestions = document.getElementById('chatbot-suggestions');

        // Toggle chatbot
        chatbotToggle.addEventListener('click', () => {
            chatbotWindow.classList.add('active');
            chatbotToggle.classList.add('active');
            chatbotInput.focus();
            
            // Show welcome message if no messages
            if (chatbotMessages.children.length === 0) {
                this.addBotMessage(ChatbotService.getResponse('hello'));
                this.showSuggestions();
            }
        });

        chatbotClose.addEventListener('click', () => {
            chatbotWindow.classList.remove('active');
            chatbotToggle.classList.remove('active');
        });

        // Send message
        const sendMessage = () => {
            const message = chatbotInput.value.trim();
            if (!message) return;

            // Add user message
            this.addUserMessage(message);
            chatbotInput.value = '';
            
            // Hide suggestions
            chatbotSuggestions.innerHTML = '';

            // Show typing indicator
            chatbotTyping.style.display = 'flex';
            
            // Simulate typing delay
            setTimeout(() => {
                chatbotTyping.style.display = 'none';
                const response = ChatbotService.getResponse(message);
                this.addBotMessage(response);
                this.showSuggestions();
            }, 1000);
        };

        chatbotSend.addEventListener('click', sendMessage);
        
        chatbotInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });
    }

    addUserMessage(text) {
        const messagesContainer = document.getElementById('chatbot-messages');
        const messageDiv = document.createElement('div');
        messageDiv.className = 'message user';
        messageDiv.innerHTML = `
            <div class="message-avatar">
                <i class="fas fa-user"></i>
            </div>
            <div class="message-content">${this.escapeHtml(text)}</div>
        `;
        messagesContainer.appendChild(messageDiv);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }

    addBotMessage(text) {
        const messagesContainer = document.getElementById('chatbot-messages');
        const messageDiv = document.createElement('div');
        messageDiv.className = 'message bot';
        messageDiv.innerHTML = `
            <div class="message-avatar">
                <i class="fas fa-robot"></i>
            </div>
            <div class="message-content">${this.formatBotMessage(text)}</div>
        `;
        messagesContainer.appendChild(messageDiv);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }

    showSuggestions() {
        const suggestionsContainer = document.getElementById('chatbot-suggestions');
        suggestionsContainer.innerHTML = '';
        
        const suggestions = ChatbotService.getSuggestions();
        suggestions.forEach(suggestion => {
            const chip = document.createElement('button');
            chip.className = 'suggestion-chip';
            chip.textContent = suggestion;
            chip.addEventListener('click', () => {
                document.getElementById('chatbot-input').value = suggestion;
                document.getElementById('chatbot-send').click();
            });
            suggestionsContainer.appendChild(chip);
        });
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    formatBotMessage(text) {
        // Convert line breaks to <br>
        return this.escapeHtml(text).replace(/\n/g, '<br>');
    }
}

// Initialize Portfolio when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    new Portfolio();
});

// Smooth scroll for all anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Add parallax effect to hero section
window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const hero = document.querySelector('.hero-section');
    
    if (hero) {
        hero.style.transform = `translateY(${scrolled * 0.5}px)`;
        hero.style.opacity = 1 - (scrolled / 800);
    }
});

// Cursor trail effect (optional)
let mouseX = 0;
let mouseY = 0;
let cursorX = 0;
let cursorY = 0;

document.addEventListener('mousemove', (e) => {
    mouseX = e.clientX;
    mouseY = e.clientY;
});

// Performance optimization: Use requestAnimationFrame for smooth animations
function animate() {
    const diffX = mouseX - cursorX;
    const diffY = mouseY - cursorY;
    
    cursorX += diffX * 0.1;
    cursorY += diffY * 0.1;
    
    requestAnimationFrame(animate);
}

animate();
