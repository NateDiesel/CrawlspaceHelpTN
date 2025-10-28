import { mkdir, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { chromium, request } from "playwright";

const root = "C:/Users/Nathan/Projects/CrawlspaceHelpTN/reference_photos";

const items = [
  { url: "https://upload.wikimedia.org/wikipedia/commons/0/0a/Pooled_water_under_plastic_sheeting_used_in_crawlspace.jpg",
    folder: "00_baseline_muddy_crawlspaces", name: "epa_pooled_water.jpg" },
  { url: "https://upload.wikimedia.org/wikipedia/commons/9/95/Crawlspace_under_house.jpg",
    folder: "00_baseline_muddy_crawlspaces", name: "crawlspace_under_house.jpg" },
  { url: "https://upload.wikimedia.org/wikipedia/commons/2/23/Crawlspace_access_panel.jpg",
    folder: "01_tools_and_materials", name: "access_panel.jpg" },
  { url: "https://upload.wikimedia.org/wikipedia/commons/0/0b/DOE_weatherization_services_%28677%29.jpg",
    folder: "02_partial_install_work", name: "doe_weatherization_install.jpg" },
  { url: "https://upload.wikimedia.org/wikipedia/commons/9/97/Old_House_with_crawl_space_foundation.jpg",
    folder: "04_equipment_details", name: "old_house_crawlspace_foundation.jpg" },
];

async function main() {
  // Playwright’s request context handles redirects+TLS cleanly
  const req = await request.newContext({
    userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Playwright",
    ignoreHTTPSErrors: false,
  });

  for (const i of items) {
    const destFolder = join(root, i.folder);
    const outPath = join(destFolder, i.name);
    await mkdir(destFolder, { recursive: true });

    process.stdout.write(`Downloading ${i.name}... `);
    const res = await req.get(i.url);
    if (!res.ok()) {
      console.log(`FAILED (${res.status()} ${res.statusText()})`);
      continue;
    }
    const buf = await res.body();
    if (!buf || buf.length < 4096) {
      console.log(`FAILED (tiny file ${buf?.length ?? 0} bytes)`);
      continue;
    }
    await writeFile(outPath, buf);
    console.log(`Saved -> ${outPath}`);
  }

  await req.dispose();
  // (No need to launch a browser for straight downloads,
  // but could do: const browser = await chromium.launch(); ... await browser.close();)
}

main().catch(e => {
  console.error(e);
  process.exit(1);
});
