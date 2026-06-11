// HtmlBasePlugin rewrites every root-relative href with the path prefix and
// offers no per-element opt-out, so cross-era links (the moved-banner, the
// back-links to previous incarnations of this blog) come out as /2023/2024/,
// /2023/2022/, and so on. This puts them back. The data-moved-to attribute is
// never rewritten (it is not an href), so machine readers were always fine.
import { readFileSync, writeFileSync, globSync } from 'node:fs';

const ERAS = ['2013', '2015', '2018', '2020', '2022', '2024'];

for (const file of globSync('_site/**/*.html')) {
	const html = readFileSync(file, 'utf8');
	let fixed = html;
	for (const era of ERAS) {
		fixed = fixed.replaceAll(`href="/2023/${era}/`, `href="/${era}/`);
	}
	if (fixed !== html) {
		writeFileSync(file, fixed);
		console.log(`fix-banner: ${file}`);
	}
}
