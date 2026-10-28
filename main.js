// Mobile menu
const toggle = document.getElementById('menu-toggle');
const links = document.getElementById('nav-links');

const setMenu = (open) => {
    links.classList.toggle('open', open);
    toggle.setAttribute('aria-expanded', String(open));
    toggle.setAttribute('aria-label', open ? 'Close menu' : 'Open menu');
};

toggle.addEventListener('click', () => setMenu(!links.classList.contains('open')));
links.addEventListener('click', (e) => { if (e.target.closest('a')) setMenu(false); });
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && links.classList.contains('open')) {
        setMenu(false);
        toggle.focus();
    }
});
document.addEventListener('click', (e) => {
    if (links.classList.contains('open') && !e.target.closest('#nav')) setMenu(false);
});

// Highlight the nav link of the section in view
const navLinks = [...links.querySelectorAll('a[href^="#"]')];
const setActive = (id) => navLinks.forEach((a) => a.classList.toggle('active', a.getAttribute('href') === '#' + id));

const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => { if (entry.isIntersecting) setActive(entry.target.id); });
}, { rootMargin: '-45% 0px -50% 0px' });
document.querySelectorAll('main section[id]').forEach((s) => observer.observe(s));

// Back-to-top button appears once the hero is scrolled past. At the very
// bottom the contact section is too short to reach the middle band the
// observer watches, so it is marked active here instead.
const toTop = document.getElementById('to-top');
const onScroll = () => {
    toTop.classList.toggle('visible', window.scrollY > window.innerHeight * 0.6);
    if (window.innerHeight + window.scrollY >= document.documentElement.scrollHeight - 2) setActive('contact');
};
window.addEventListener('scroll', onScroll, { passive: true });
onScroll();
