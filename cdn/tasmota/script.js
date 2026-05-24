/*
  Cossth Tasmota UI Loader
  Purpose: safely load external CSS without touching control behavior.
*/
(() => {
  'use strict';

  const ROOT_CLASS = 'cossth-modern-ui';
  const CSS_URL = 'https://assets.cossth.com/tasmota/styles.css';

  function ensureStylesheet() {
    const exists = Array.from(document.querySelectorAll("link[rel='stylesheet']"))
      .some((lnk) => (lnk.getAttribute('href') || '').includes('/tasmota/styles.css'));

    if (exists) return;

    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = CSS_URL;
    document.head.appendChild(link);
  }

  function boot() {
    document.documentElement.classList.add(ROOT_CLASS);
    ensureStylesheet();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot, { once: true });
  } else {
    boot();
  }
})();
