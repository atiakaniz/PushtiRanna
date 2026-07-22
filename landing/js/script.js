/* PushtiRanna landing — minimal vanilla JS
   - mobile menu toggle
   - smooth-scroll for anchor links
   - reveal-on-scroll via IntersectionObserver
   - light/dark theme toggle (with localStorage + system-pref fallback)
*/
(function () {
  'use strict';

  // -------- Theme (light / dark) --------
  const THEME_KEY = 'pushtiranna_theme';
  const themeBtn = document.getElementById('themeToggle');

  function currentTheme() {
    return document.documentElement.getAttribute('data-theme') === 'dark'
      ? 'dark' : 'light';
  }

  function applyTheme(next, persist) {
    if (next === 'dark') {
      document.documentElement.setAttribute('data-theme', 'dark');
    } else {
      document.documentElement.removeAttribute('data-theme');
    }
    if (persist) {
      try { localStorage.setItem(THEME_KEY, next); } catch (e) { /* private mode */ }
    }
    if (themeBtn) {
      themeBtn.setAttribute('aria-label',
        next === 'dark' ? 'Switch to light mode' : 'Switch to dark mode');
      themeBtn.setAttribute('title',
        next === 'dark' ? 'Switch to light mode' : 'Switch to dark mode');
    }
  }

  if (themeBtn) {
    // Initialize button state to match the theme already applied in <head>
    applyTheme(currentTheme(), false);

    themeBtn.addEventListener('click', function () {
      const next = currentTheme() === 'dark' ? 'light' : 'dark';
      applyTheme(next, true);
    });
  }

  // -------- Mobile nav toggle --------
  const toggle = document.getElementById('navToggle');
  const nav    = document.getElementById('primaryNav');

  if (toggle && nav) {
    toggle.addEventListener('click', function () {
      const open = nav.classList.toggle('is-open');
      toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    });

    // Close on link click (mobile)
    nav.querySelectorAll('a').forEach(function (a) {
      a.addEventListener('click', function () {
        if (nav.classList.contains('is-open')) {
          nav.classList.remove('is-open');
          toggle.setAttribute('aria-expanded', 'false');
        }
      });
    });
  }

  // -------- Smooth-scroll for in-page anchors --------
  document.querySelectorAll('a[href^="#"]').forEach(function (a) {
    a.addEventListener('click', function (e) {
      const id = a.getAttribute('href');
      if (id.length < 2) return;
      const target = document.querySelector(id);
      if (!target) return;
      e.preventDefault();
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    });
  });

  // -------- Reveal on scroll --------
  if ('IntersectionObserver' in window) {
    const io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          io.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });

    document.querySelectorAll('.reveal').forEach(function (el) {
      io.observe(el);
    });
  } else {
    // Fallback: just show everything
    document.querySelectorAll('.reveal').forEach(function (el) {
      el.classList.add('is-visible');
    });
  }
})();
