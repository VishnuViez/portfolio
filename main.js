// Mobile menu
const toggle = document.getElementById('menu-toggle');
const links = document.getElementById('nav-links');

toggle.addEventListener('click', () => {
    const open = links.classList.toggle('open');
    toggle.setAttribute('aria-expanded', String(open));
    toggle.setAttribute('aria-label', open ? 'Close menu' : 'Open menu');
});

links.addEventListener('click', (e) => {
    if (e.target.closest('a')) {
        links.classList.remove('open');
        toggle.setAttribute('aria-expanded', 'false');
        toggle.setAttribute('aria-label', 'Open menu');
    }
});

// Highlight the nav link of the section in view
const navLinks = [...links.querySelectorAll('a[href^="#"]')];
const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        navLinks.forEach((a) => a.classList.toggle('active', a.getAttribute('href') === '#' + entry.target.id));
    });
}, { rootMargin: '-45% 0px -50% 0px' });
document.querySelectorAll('main section[id]').forEach((s) => observer.observe(s));

// Back-to-top button appears once the hero is scrolled past
const toTop = document.getElementById('to-top');
const onScroll = () => toTop.classList.toggle('visible', window.scrollY > window.innerHeight * 0.6);
window.addEventListener('scroll', onScroll, { passive: true });
onScroll();
