// assets/js/plausible-events.js
(function () {
  // ---- Utilities -----------------------------------------------------------
  function whenPlausibleReady(cb, tries = 80) {
    if (typeof window.plausible === 'function') return cb();
    if (tries <= 0) return;
    setTimeout(() => whenPlausibleReady(cb, tries - 1), 125);
  }
  function fire(name, props) {
    if (typeof window.plausible === 'function') {
      try { window.plausible(name, { props: props || {} }); } catch (_) {}
    }
  }
  function on(el, ev, fn, opts) { el && el.addEventListener(ev, fn, opts || { passive: true }); }
  function sameOrigin(url) { try { return new URL(url, location.href).origin === location.origin; } catch { return true; } }

  // ---- Click bindings via data attributes ----------------------------------
  // Any element with data-plausible-click="event-name" will fire that event on click.
  function bindDataClick() {
    document.querySelectorAll('[data-plausible-click]').forEach(el => {
      const name = el.getAttribute('data-plausible-click');
      if (!name) return;
      // prevent double-binding
      if (el.__plb) return; el.__plb = true;
      on(el, 'click', () => fire(name));
    });
  }

  // ---- Specific CTA bindings (backward-compatible) -------------------------
  function bindCtaEstimate() {
    const el = document.getElementById('cta-estimate');
    if (!el || el.__plb) return;
    el.__plb = true;
    on(el, 'click', () => fire('cta-estimate'));
  }

  // ---- Email only ----------------------------------------------------------
  function bindContactLinks() {
    document.querySelectorAll('a[href^="mailto:"]').forEach(a => {
      if (a.__plb) return; a.__plb = true;
      const address = a.getAttribute('href').replace(/^mailto:/i, '');
      on(a, 'click', () => fire('click-email', { address }));
    });
  }

  // ---- Outbound links (exclude same-origin) --------------------------------
  function bindOutbound() {
    document.querySelectorAll('a[href]').forEach(a => {
      if (a.__plb_out) return; a.__plb_out = true;
      on(a, 'click', () => {
        const href = a.getAttribute('href');
        if (!href || sameOrigin(href)) return;
        const u = new URL(href, location.href);
        fire('outbound-link', { host: u.host, url: u.href });
      });
    });
  }

  // ---- Scroll depth (25/50/75/100) -----------------------------------------
  function bindScrollDepth() {
    const marks = [25, 50, 75, 100];
    const fired = new Set();
    function check() {
      const scrolled = (window.scrollY + window.innerHeight) / Math.max(1, document.documentElement.scrollHeight) * 100;
      for (const m of marks) {
        if (!fired.has(m) && scrolled >= m - 0.5) {
          fired.add(m);
          fire('scroll-depth', { percent: m });
        }
      }
      if (fired.size === marks.length) window.removeEventListener('scroll', onScroll, { passive: true });
    }
    let tid = null;
    function onScroll() { if (tid) cancelAnimationFrame(tid); tid = requestAnimationFrame(check); }
    on(window, 'scroll', onScroll);
    // First check after load
    check();
  }

  // ---- Video tracking (opt-in via data-track-video on <video>) -------------
  function bindVideos() {
    document.querySelectorAll('video[data-track-video]').forEach(v => {
      if (v.__plb) return; v.__plb = true;
      const vid = v.id || '';
      const src = v.currentSrc || v.src || '';
      on(v, 'play',  () => fire('video-play',     { id: vid, src }));
      on(v, 'ended', () => fire('video-complete', { id: vid, src }));
    });
  }

  // ---- Pageview-triggered event via body data attribute --------------------
  function firePageFlaggedEvent() {
    const body = document.body;
    if (!body) return;
    const ev = body.getAttribute('data-plausible-event');
    if (ev) fire(ev);
  }

  // ---- Init ----------------------------------------------------------------
  document.addEventListener('DOMContentLoaded', () => {
    whenPlausibleReady(() => {
      bindDataClick();
      bindCtaEstimate();
      bindContactLinks();
      bindOutbound();
      bindVideos();
      bindScrollDepth();
      firePageFlaggedEvent();
    });
  });
})();
