document.addEventListener("DOMContentLoaded", () => {
  const header = document.getElementById("site-header");
  if (!header || !header.classList.contains("header--home")) return;

  const toggle = () => {
    header.classList.toggle("header--scrolled", window.scrollY > 20);
  };

  toggle();
  window.addEventListener("scroll", toggle, { passive: true });
});
