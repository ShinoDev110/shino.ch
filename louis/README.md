# louis/

Portfolio site for Louis Kessler (voice actor), staged at `shino.ch/louis/` for him to review.
Self-contained: everything it needs lives in this folder, nothing outside it references it.

Design: Hunter Guidroz's site (hunterguidroz.com) as the base, simplified, mixed with the bright,
chunky "Bunt" direction and a cartoon touch because Louis does character voices. Copy is written to
sell him (informal "du"), German by default with an English switch. Contact is email only
(louis.eggerschwiler@gmail.com, every contact button is a mailto); there is no phone number on purpose.

## Texts and languages

German is the source and lives in the HTML. English lives in `assets/js/i18n.js`, in the `EN` object.

- Text: `<p data-i18n="some.key">Deutscher Text</p>` plus `'some.key': 'English text'` in `EN`.
  The value is inner HTML, so markup like `<span class="mark">` works.
- Attributes: `data-i18n-attr="alt:some.key"`, several separated by `;`
  (`aria-label:a.key;title:b.key`). Used for `alt`, `aria-label` and the meta description.
- A key missing from `EN` keeps the German text and logs `[i18n] no English text for ...` in the console.
- The choice is stored in `localStorage` (`louis-lang`). `?lang=en` or `?lang=de` in a link wins,
  so `https://shino.ch/louis/?lang=en` opens in English.
- Names (Aldi, Edward, series titles) need no key.

## Pages

| URL                  | File                   | Content                                          |
|----------------------|------------------------|--------------------------------------------------|
| `/louis/`            | `index.html`           | Hero photo, demo panel, ticker, about, pills, CTA |
| `/louis/portfolio/`  | `portfolio/index.html` | Audio cards, video grid                          |
| `/louis/contact/`    | `contact/index.html`   | Contact cards, about block with photo            |

All pages carry `noindex, nofollow` while this is a preview. Remove that once it moves to its own domain.

## Current media

| Kind  | File(s)                                                    | Used on                          |
|-------|------------------------------------------------------------|----------------------------------|
| Photo | `assets/img/louis-hero-{600,1000}.webp` (from louis1)      | Home hero blob                   |
| Photo | `assets/img/louis-mic-{480,880}.webp` (from louis2)        | Home about block                 |
| Photo | `assets/img/louis-booth-{480,880}.webp` (from louis3)      | Contact about block              |
| Audio | `assets/audio/aldi_sample_commercial.mp3` (0:12)           | Home demo panel, portfolio card  |
| Audio | `assets/audio/mcdonalds_sample_commercial.mp3` (0:13)      | Home demo panel, portfolio card  |
| Video | `assets/video/edward.mp4` + `edward-poster.webp`           | Portfolio (Fullmetal Alchemist)  |
| Video | `assets/video/gojo.mp4` + `gojo-poster.webp`               | Portfolio (Gojo & Geto, JJK)     |

Full-size photo originals live in `assets/_src/` (ignored by `louis/.gitignore`, they contain GPS data).

## Adding media

General rules for every file:

- **Lowercase names, no spaces or umlauts** (`edward.mp4`, not `Edward.mp4`). GitHub Pages is
  case-sensitive and Windows hides the difference. Fix a wrong case with `git mv -f Old.mp4 old.mp4`
  if the file is already staged (the IDE stages new files on its own).
- **Never commit** anything; the owner commits.
- Preview locally with the `shino-static` launch config (`.claude/launch.json`, server script
  `.claude/serve.ps1`, port 8080, supports range requests). Then open `http://localhost:8080/louis/`.

ImageMagick: `"/c/Program Files/ImageMagick-7.1.2-Q16-HDRI/magick.exe"` (not on PATH).

### Audio demo

1. Put the MP3 in `assets/audio/`.
2. Measure the waveform. With the preview server running, run this in the browser console on any
   `/louis/` page (change the file name). It prints the duration and the `data-peaks` values for a
   56-bar (home panel) and a 34-bar (portfolio card) waveform:

   ```js
   const ctx = new OfflineAudioContext(1, 44100, 44100);
   const a = await ctx.decodeAudioData(await (await fetch('/louis/assets/audio/NAME.mp3')).arrayBuffer());
   const d = a.getChannelData(0);
   const peaks = n => { const st = Math.floor(d.length / n), p = [];
     for (let i = 0; i < n; i++) { let s = 0; for (let j = i * st; j < (i + 1) * st; j++) s += d[j] * d[j]; p.push(Math.sqrt(s / st)); }
     const m = Math.max(...p); return p.map(v => Math.max(8, Math.round(v / m * 100))).join(','); };
   ({ dur: a.duration, p56: peaks(56), p34: peaks(34) })
   ```
3. **Portfolio:** copy one `<article class="card">` in `portfolio/index.html` and change the title,
   tag (`<small>`), `data-src`, `aria-label`, `data-peaks` (34 values) and the `.time` text (length,
   e.g. `0:12`). Pick or draw a face SVG that fits the voice. The grid switches from 2 to 3 columns
   by itself once there are three cards. Give the description `<p>` and the play button new i18n
   keys (`data-i18n`, `data-i18n-attr="aria-label:..."`) and add their English to `assets/js/i18n.js`.
4. **Home (optional, for highlights):** copy one `<article class="demo">` in the `.demos` panel of
   `index.html`, same fields, `data-peaks` with 56 values. Keep the panel to about 3 rows.

Without `data-peaks` the player still works and draws a made-up waveform. A `.demo` without
`data-src` is ignored by the script, so never leave one in the page.

### Video

1. MP4 with H.264 video and AAC audio, lowercase name, into `assets/video/`. Keep each file well
   under 100 MB (GitHub's hard limit), ideally under 30 MB. "Web optimized / fast start" on export
   makes playback start sooner.
2. Make a poster frame. Find a good moment (character on screen, not a black fade), then with the
   preview server running, run in the console on the portfolio page after adding the block:

   ```js
   const v = document.querySelector('video[src$="NAME.mp4"]');
   v.preload = 'auto'; await new Promise(r => v.readyState >= 1 ? r() : v.addEventListener('loadedmetadata', r, {once: true}));
   await new Promise(r => { v.addEventListener('seeked', r, {once: true}); v.currentTime = SECONDS; });
   const c = Object.assign(document.createElement('canvas'), {width: v.videoWidth, height: v.videoHeight});
   c.getContext('2d').drawImage(v, 0, 0);
   await fetch('/__save?name=NAME-poster.png', {method: 'POST', body: await new Promise(r => c.toBlob(r, 'image/png'))});
   ```

   The frame lands in `.claude/_grab/`. Convert it:
   `magick .claude/_grab/NAME-poster.png -strip -resize 1280x720 -quality 78 louis/assets/video/NAME-poster.webp`
3. Copy one `<article class="video">` in `portfolio/index.html` and change `data-video`, the
   `<video src>` and `poster`, the button's `aria-label` (with a new i18n key), the `<h3>` and the sticker.

YouTube instead of a file: `<div class="video-frame" data-youtube="VIDEO_ID">` with only the play
button inside. It loads youtube-nocookie after a click.

### Photo

1. Keep the original in `assets/_src/` (never deployed). Check it for GPS data; the web copies must
   be exported with `-strip`.
2. Crop to the frame's shape and export two widths as WebP, quality 80:
   - square frame (home hero): 1000 and 600 px
   - 4:5 frame (about blocks): 880x1100 and 480x600 px

   `magick assets/_src/X.jpg -auto-orient -crop WxH+X+Y +repage -strip -resize 880x1100 -quality 80 assets/img/louis-NAME-880.webp`
3. Put an `<img>` with `srcset`, `sizes`, `width`, `height` and a real German `alt` inside a
   `<div class="photo">` (copy an existing one). The frame adds the outline, inner ring and warm tint;
   set `object-position` on the img if the face sits off-center.

## Removing media

Delete the whole block (`article.card`, `article.demo` or `article.video`) and its files in
`assets/`. Nothing else references them.

## Assets

- `assets/css/louis.css` theme and layout
- `assets/js/i18n.js` English texts and the DE/EN switch (load before `louis.js`)
- `assets/js/louis.js` audio players, click-to-load videos, googly-eyed mascot
- `assets/img/favicon.svg` tab icon (the googly-eyed mic), `assets/img/louis-og.jpg` 1200x630 link preview
- Fonts: Lilita One and Nunito from Google Fonts. Self-host them before going live (Swiss/EU privacy).
