// German / English switch.
// German is the page source: every translatable element carries data-i18n="key" (its inner HTML)
// or data-i18n-attr="attr:key;attr2:key2" (attributes such as alt or aria-label).
// This file only holds the English versions. The choice is remembered, and ?lang=en / ?lang=de
// in a link overrides it, so an English link can be sent to international clients.
(function () {
    'use strict';

    var EN = {
        // shared
        'nav.label': 'Main navigation',
        'nav.home': 'Home',
        'nav.portfolio': 'Portfolio',
        'nav.contact': 'Contact',
        'foot.label': 'Footer',
        'lang.label': 'Language',
        'btn.listen': 'Listen to demos',
        'btn.request': 'Get in touch',
        'btn.write': 'Write an email',
        'demo.tag.commercial': 'Commercial · Sample',
        'demo.aldi.play': 'Play Aldi commercial',
        'demo.mcd.play': 'Play McDonald’s commercial',
        'demo.lunea.play': 'Play Lunea commercial',
        'ticker.1': 'Commercials',
        'ticker.2': 'Anime dubbing',
        'ticker.3': 'Cartoons',
        'ticker.4': 'Video games',
        'ticker.5': 'Character voices',
        'ticker.6': 'Explainer videos',

        // home
        'home.meta.title': 'Louis Kessler | Voice actor for commercials, anime & characters',
        'home.meta.desc': 'Louis Kessler is a voice actor from Switzerland: commercials, anime dubbing and character voices with energy and wit. Listen to his demos and get in touch.',
        'home.hero.sticker': 'Voice actor from Switzerland',
        'home.hero.title': 'One voice. <span class="mark">A hundred</span> characters.',
        'home.hero.lead': 'From a friendly commercial to an anime hero! I give your project a voice that sticks.',
        'home.hero.alt': 'Louis Kessler with headphones at the microphone in the vocal booth',
        'home.hero.hoi': 'Say hoi',
        'home.demos.all': 'Full portfolio',
        'home.shuffle.q': 'Don’t feel like browsing?',
        'home.shuffle.sub': 'I’ll just play you a random clip.',
        'home.shuffle.btn': 'Surprise me!',
        'home.shuffle.now': 'Now playing',
        'home.shuffle.toggle': 'Play or pause',
        'home.about.sticker': 'About me',
        'home.about.title': 'Behind the mic',
        'home.about.p1': 'Hi, I’m Louis! I love bringing characters to life. Whether it’s a shining hero, a twisted villain or the friendly voice that makes this week’s deal sound irresistible, I find the tone that fits your story.',
        'home.about.p2': 'Give me a direction and I’ll try it. Give me three and you get three takes. I work with enthusiasm, pace and a real feel for timing, so your recording sounds exactly the way you imagined it.',
        'home.about.cta': 'Let’s talk',
        'home.about.alt': 'Louis Kessler laughing into the camera in front of the microphone',
        'home.services.title': 'What you can book me for',
        'home.services.lead': 'Short and punchy or full-on drama: I tailor my voice to your project.',
        'service.1': 'Commercials',
        'service.2': 'Anime & dubbing',
        'service.3': 'Cartoons',
        'service.4': 'Video games',
        'service.5': 'Explainer videos',
        'service.6': 'Social media clips',
        'home.cta.title': 'Ready for a voice that stands out?',
        'home.cta.text': 'Tell me about your project and I’ll get back to you as soon as I can.',
        'home.cta.button': 'Start a project',

        // portfolio
        'portfolio.meta.desc': 'Audio demos and videos by Louis Kessler: commercials and anime dubbing to listen to.',
        'portfolio.title': 'Listen. Watch.',
        'portfolio.lead': 'Here are my audio demos and videos. Hit play and hear for yourself how much fits into one voice.',
        'portfolio.audio.title': 'Audio demos',
        'portfolio.audio.lead': 'Commercials with a smile in the voice: clear, likeable and right on point.',
        'portfolio.aldi.text': 'Sample spot for a supermarket. Friendly and familiar, like a neighbour letting you in on the best deal of the week.',
        'portfolio.mcd.text': 'Sample spot for a fast food chain. Relaxed, lively and so appetising you’ll want to head out right away.',
        'portfolio.lunea.text': 'Sample spot for mattresses and pillows. Calm, warm and so relaxed you’ll want to lie down right away.',
        'portfolio.video.title': 'Anime dubbing',
        'portfolio.video.lead': 'Two cult series, completely different energies, one voice. My dubbing samples from Fullmetal Alchemist and Jujutsu Kaisen.',
        'portfolio.edward.play': 'Play Edward',
        'portfolio.gojo.play': 'Play Gojo & Geto',
        'portfolio.film.title': 'Film dubbing',
        'portfolio.film.lead': 'Real actors, real emotions: my dubbing sample for a scene from Don’t Worry Darling.',
        'portfolio.film.play': 'Play Don’t Worry Darling',
        'portfolio.film.tag': 'Feature film',
        'portfolio.cta.title': 'Like what you hear?',
        'portfolio.cta.text': 'Then let’s record something together. Send me your script and we’ll get going.',

        // contact
        'contact.meta.title': 'Contact | Louis Kessler',
        'contact.meta.desc': 'Book Louis Kessler as a voice actor: send an email about your project.',
        'contact.title': 'Let’s record something!',
        'contact.lead': 'Got a project, an idea or just a question? Send me an email. I’m looking forward to hearing from you.',
        'contact.email.label': 'Email',
        'contact.quote.label': 'For a quick quote',
        'contact.quote.value': 'Script, length and usage',
        'contact.how.sticker': 'How it works',
        'contact.how.title': 'From request to finished recording',
        'contact.how.text': 'You send me your script and a few details about the project. I record, you listen, and if something isn’t quite right yet, we fine-tune it together. Easy-going and with plenty of fun along the way.',
        'contact.how.alt': 'Louis Kessler in the vocal booth, photographed through the glass'
    };

    var KEY = 'louis-lang';
    var originals = new WeakMap(); // element -> {html, attrs} in German, captured on first switch

    function remember(el) {
        if (!originals.has(el)) originals.set(el, {html: el.innerHTML, attrs: {}});
        return originals.get(el);
    }

    function apply(lang) {
        var en = lang === 'en';
        document.querySelectorAll('[data-i18n]').forEach(function (el) {
            var key = el.getAttribute('data-i18n');
            var de = remember(el);
            if (en && !(key in EN)) console.warn('[i18n] no English text for', key);
            el.innerHTML = en && key in EN ? EN[key] : de.html;
        });
        document.querySelectorAll('[data-i18n-attr]').forEach(function (el) {
            var de = remember(el);
            el.getAttribute('data-i18n-attr').split(';').forEach(function (pair) {
                var p = pair.split(':'), attr = p[0].trim(), key = (p[1] || '').trim();
                if (!(attr in de.attrs)) de.attrs[attr] = el.getAttribute(attr);
                if (en && !(key in EN)) console.warn('[i18n] no English text for', key);
                el.setAttribute(attr, en && key in EN ? EN[key] : de.attrs[attr]);
            });
        });
        document.documentElement.lang = lang;
        document.querySelectorAll('.lang button').forEach(function (b) {
            b.setAttribute('aria-pressed', String(b.dataset.lang === lang));
        });
        try {
            localStorage.setItem(KEY, lang);
        } catch (e) { /* private mode: the choice just isn't remembered */ }
    }

    var lang = 'de';
    try {
        lang = localStorage.getItem(KEY) || lang;
    } catch (e) { /* ignore */ }
    var param = new URLSearchParams(location.search).get('lang');
    if (param === 'en' || param === 'de') lang = param;
    if (lang !== 'en') lang = 'de';

    apply(lang);
    document.querySelectorAll('.lang button').forEach(function (b) {
        b.addEventListener('click', function () {
            apply(b.dataset.lang);
        });
    });
})();
