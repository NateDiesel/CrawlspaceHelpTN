// Shared site constants (placeholders — please replace with live values)
const PHONE_DISPLAY = "REPLACE_WITH_REAL_DISPLAY_NUMBER";
const PHONE_TEL = "REPLACE_WITH_REAL_E164_NUMBER"; // e.g. +16155551234
// Replace this with the full Google Form embed URL (including ?embedded=true)
const GOOGLE_FORM_EMBED_URL = "PASTE_FULL_GOOGLE_FORM_EMBED_URL_HERE";

// Convenience: expose a function to render a call link HTML
function callNowHtml() {
  return `<a class="btn secondary" href="tel:${PHONE_TEL}">Call Now ${PHONE_DISPLAY}</a>`;
}

