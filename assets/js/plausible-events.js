// assets/js/plausible-events.js
(function () {
  // Robust guard: only proceed once plausible is available
  function whenPlausibleReady(cb, tries = 40) {
    if (typeof window.plausible === 'function') return cb();
    if (tries <= 0) return; // give up quietly
    setTimeout(() => whenPlausibleReady(cb, tries - 1), 125);
  }

  // Fire a named event, safely
  function fire(name, props) {
    if (typeof window.plausible === 'function') {
      try { window.plausible(name, { props: props || {} }); } catch (_) {}
    }
  }

  // CTA click → cta-estimate
  function bindCtaEstimate() {
    var el = document.getElementById('cta-estimate');
    if (!el) return;
    el.addEventListener('click', function () {
      fire('cta-estimate');
    }, { passive: true });
  }

  // Pageview-triggered event via body data attribute
  // Put data-plausible-event="dl-checklist" on the success page <body>
  function firePageFlaggedEvent() {
    var body = document.body;
    if (!body) return;
    var ev = body.getAttribute('data-plausible-event');
    if (ev) fire(ev);
  }

  document.addEventListener('DOMContentLoaded', function () {
    whenPlausibleReady(function () {
      bindCtaEstimate();
      firePageFlaggedEvent();
    });
  });
})();
