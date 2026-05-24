/*
  Cossth Tasmota UI Enhancer
  Works with stock Tasmota markup. No firmware HTML template edits required.
*/
(() => {
  'use strict';

  const ROOT_CLASS = 'cossth-modern-ui';
  const BODY_OBSERVER_CFG = {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ['style', 'class']
  };

  let scheduled = false;

  const byId = (id) => document.getElementById(id);
  const qsa = (sel, root = document) => Array.from(root.querySelectorAll(sel));

  function markShell() {
    document.documentElement.classList.add(ROOT_CLASS);
  }

  function classifyTables() {
    const l1 = byId('l1');
    if (l1) {
      const l1Tables = qsa('table', l1);
      if (l1Tables[0]) l1Tables[0].classList.add('ts-status-grid');
      if (l1Tables[1]) l1Tables[1].classList.add('ts-state-grid');
    }

    qsa('table').forEach((table) => {
      const hasRelayButton = !!table.querySelector("button[id^='o']");
      const hasSlider = !!table.querySelector("input[type='range']");
      const hasMainAction = !!table.querySelector("form[id^='but'] button");

      table.classList.toggle('ts-relay-grid', hasRelayButton && !hasSlider && !hasMainAction);
      table.classList.toggle('ts-slider-grid', hasSlider);
      table.classList.toggle('ts-main-actions', hasMainAction);
    });
  }

  function syncRelayButtonState() {
    qsa("button[id^='o']").forEach((btn) => {
      const inlineStyle = btn.getAttribute('style') || '';
      const isOff = inlineStyle.includes('--c_btnoff');
      btn.classList.toggle('is-off', isOff);
      btn.classList.add('ts-relay-button');
    });
  }

  function markMainActions() {
    const iconMap = {
      'Configuration': '⚙',
      'Information': 'ℹ',
      'Firmware Upgrade': '⬆',
      'Tools': '🧰',
      'Restart': '⟲'
    };

    qsa("form[id^='but'] button").forEach((btn) => {
      btn.classList.add('ts-main-action');

      if (btn.dataset.iconReady === '1') return;
      const label = (btn.textContent || '').trim();
      const icon = iconMap[label];
      if (icon) {
        btn.textContent = `${icon} ${label}`;
      }
      btn.dataset.iconReady = '1';
    });
  }

  function markStateCells() {
    qsa('.ts-state-grid td').forEach((cell) => {
      const value = (cell.textContent || '').trim();
      cell.classList.remove('ts-on', 'ts-off');
      if (value === '1' || value.toUpperCase() === 'ON') {
        cell.classList.add('ts-on');
      } else if (value === '0' || value.toUpperCase() === 'OFF') {
        cell.classList.add('ts-off');
      }
    });
  }

  function applyRipple(event) {
    const btn = event.currentTarget;
    if (!(btn instanceof HTMLElement)) return;

    const rect = btn.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    const x = event.clientX - rect.left - size / 2;
    const y = event.clientY - rect.top - size / 2;

    const ripple = document.createElement('span');
    ripple.className = 'ts-ripple';
    ripple.style.width = `${size}px`;
    ripple.style.height = `${size}px`;
    ripple.style.left = `${x}px`;
    ripple.style.top = `${y}px`;

    btn.appendChild(ripple);
    setTimeout(() => ripple.remove(), 450);
  }

  function bindRipple() {
    qsa('button').forEach((btn) => {
      if (btn.dataset.rippleBound === '1') return;
      btn.addEventListener('pointerdown', applyRipple, { passive: true });
      btn.dataset.rippleBound = '1';
    });
  }

  function enhance() {
    markShell();
    classifyTables();
    syncRelayButtonState();
    markMainActions();
    markStateCells();
    bindRipple();
  }

  function scheduleEnhance() {
    if (scheduled) return;
    scheduled = true;
    window.requestAnimationFrame(() => {
      scheduled = false;
      enhance();
    });
  }

  const observer = new MutationObserver(scheduleEnhance);

  window.addEventListener('load', () => {
    enhance();
    observer.observe(document.body, BODY_OBSERVER_CFG);
  });
})();
