// Script réutilisable pour toutes les pages

if (history.scrollRestoration) {
  history.scrollRestoration = 'manual';
}

window.addEventListener('beforeunload', function() {
  window.scrollTo(0, 0);
});

window.onload = function() {
  setTimeout(function() {
    window.scrollTo(0, 0);
  }, 0);
};

window.addEventListener('scroll', function() {
  const header = document.getElementById('header');
  if (header && window.scrollY > 50) {
    header.classList.add('header--scrolled');
  } else if (header) {
    header.classList.remove('header--scrolled');
  }
});

const observerOptions = {
  threshold: 0.15,
  rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
    }
  });
}, observerOptions);

function initAnimations() {
  const sections = document.querySelectorAll('.section');
  sections.forEach(section => {
    observer.observe(section);
  });
  
  const cards = document.querySelectorAll('.card, .doctor-card');
  cards.forEach(card => {
    observer.observe(card);
  });
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initAnimations);
} else {
  initAnimations();
}
