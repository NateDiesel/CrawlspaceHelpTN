// Shared site constants (placeholders — update as needed)
const PHONE_DISPLAY = "(615) 555-1234";
const PHONE_TEL = "+16155551234";
// Replace this with the full Google Form embed URL (including ?embedded=true)
const GOOGLE_FORM_EMBED_URL = "PASTE_FULL_GOOGLE_FORM_EMBED_URL_HERE";

// Convenience: expose a function to render a call link HTML
function callNowHtml() {
  return `<a class="btn secondary" href="tel:${PHONE_TEL}">Call Now ${PHONE_DISPLAY}</a>`;
}

