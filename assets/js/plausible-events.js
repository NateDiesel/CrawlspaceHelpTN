// assets/js/plausible-events.js
(function () {
  function whenPlausibleReady(cb, tries = 40) {
    if (typeof window.plausible === 'function') return cb();
    if (tries <= 0) return;
    setTimeout(() => whenPlausibleReady(cb, tries - 1), 125);
  }

  function fire(name, props) {
    if (typeof window.plausible === 'function') {
      try { window.plausible(name, { props: props || {} }); } catch (_) {}
    }
  }

  function bindCtaEstimate() {
    var el = document.getElementById('cta-estimate');
    if (!el) return;
    el.addEventListener('click', function () {
      fire('cta-estimate');
    }, { passive: true });
  }

  // Fires a pageview-scoped event if the <body> declares a data flag
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
