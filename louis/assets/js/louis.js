// Audio demos, the random clip player, the "Hoi!" bubble, video cards and the googly-eyed mascot.
(function () {
    'use strict';

    // Small seeded random generator, used for the fallback waveform when a demo has no data-peaks.
    function rng(seed) {
        var s = seed * 7919 + 13;
        return function () {
            s = (s * 9301 + 49297) % 233280;
            return s / 233280;
        };
    }

    // ---------- ticker band ----------
    // The HTML holds one set of words. Repeat it until one half is wider than any screen, then
    // double it: the CSS slides by exactly half, so the loop has no gap. Speed stays constant.
    // Runs before i18n.js, so the copies are translated along with the originals.
    document.querySelectorAll('.ticker-track').forEach(function (track) {
        var set = [].slice.call(track.children);
        if (!set.length) return;
        var need = Math.max(window.screen.width || 0, window.innerWidth, 1600) * 1.25;
        for (var guard = 0; track.offsetWidth < need && guard < 30; guard++) {
            set.forEach(function (s) {
                track.appendChild(s.cloneNode(true));
            });
        }
        [].slice.call(track.children).forEach(function (s) {
            track.appendChild(s.cloneNode(true));
        });
        track.style.animationDuration = Math.round(track.offsetWidth / 2 / 60) + 's'; // about 60 px per second
    });

    // ---------- audio ----------
    // One Audio object per file, shared by every player that shows it (home rows, portfolio cards,
    // the random clip bar), so they always stay in sync. Only one clip plays at a time.
    var current = null;
    var audios = {};

    function fmt(sec) {
        if (!isFinite(sec)) sec = 0;
        var m = Math.floor(sec / 60), s = Math.floor(sec % 60);
        return m + ':' + (s < 10 ? '0' : '') + s;
    }

    function audioFor(src) {
        if (audios[src]) return audios[src];
        var a = new Audio();
        a.preload = 'none';
        a.src = src;
        a.addEventListener('play', function () {
            if (current && current !== a) current.pause();
            current = a;
            pauseVideos();
        });
        a.addEventListener('ended', function () {
            a.currentTime = 0;
        });
        audios[src] = a;
        return a;
    }

    function toggle(a) {
        if (a.paused) a.play().catch(function () {});
        else a.pause();
    }

    function seek(a, p) {
        p = Math.max(0, Math.min(1, p));
        var go = function () {
            if (isFinite(a.duration)) a.currentTime = p * a.duration;
        };
        if (a.readyState >= 1) return go();
        a.preload = 'metadata';
        a.addEventListener('loadedmetadata', go, {once: true});
        a.load();
    }

    // ---------- demo players (waveform rows and cards) ----------
    document.querySelectorAll('.demo').forEach(function (demo, idx) {
        if (!demo.dataset.src) return;
        var btn = demo.querySelector('.play');
        var wave = demo.querySelector('.wave');
        var time = demo.querySelector('.time');
        var a = audioFor(demo.dataset.src);
        var initial = time.textContent;

        // waveform: real loudness from data-peaks (percent per bar) when given, otherwise a made-up shape
        var peaks = wave.dataset.peaks ? wave.dataset.peaks.split(',').map(Number) : null;
        var rnd = rng(idx + 1), bars = peaks ? peaks.length : +wave.dataset.bars || 56;
        for (var i = 0; i < bars; i++) {
            var bar = document.createElement('i');
            var env = .45 + .55 * Math.sin(Math.PI * (i + .5) / bars);
            bar.style.height = (peaks ? Math.max(8, peaks[i]) : Math.max(14, Math.round((.35 + rnd() * .65) * env * 100))) + '%';
            wave.appendChild(bar);
        }
        var barEls = wave.children;

        function paint() {
            var p = a.duration ? a.currentTime / a.duration : 0;
            var on = Math.round(p * barEls.length);
            for (var j = 0; j < barEls.length; j++) barEls[j].classList.toggle('on', j < on);
            // at rest show the length, while playing the position
            time.textContent = a.currentTime > 0 ? fmt(a.currentTime)
                : isFinite(a.duration) ? fmt(a.duration) : initial;
            wave.setAttribute('aria-valuenow', Math.round(p * 100));
        }

        a.addEventListener('timeupdate', paint);
        a.addEventListener('loadedmetadata', paint);
        a.addEventListener('play', function () {
            demo.classList.add('is-playing');
            btn.setAttribute('aria-pressed', 'true');
        });
        a.addEventListener('pause', function () {
            demo.classList.remove('is-playing');
            btn.setAttribute('aria-pressed', 'false');
        });

        btn.addEventListener('click', function () {
            toggle(a);
        });

        wave.setAttribute('role', 'slider');
        wave.setAttribute('tabindex', '0');
        wave.setAttribute('aria-valuemin', '0');
        wave.setAttribute('aria-valuemax', '100');
        wave.setAttribute('aria-valuenow', '0');
        wave.addEventListener('click', function (e) {
            var r = wave.getBoundingClientRect();
            seek(a, (e.clientX - r.left) / r.width);
        });
        wave.addEventListener('keydown', function (e) {
            if (e.key !== 'ArrowLeft' && e.key !== 'ArrowRight') return;
            e.preventDefault();
            var p = a.duration ? a.currentTime / a.duration : 0;
            seek(a, p + (e.key === 'ArrowRight' ? .05 : -.05));
        });
    });

    // ---------- random clip ("Keine Lust zu suchen?") ----------
    // Plays a random audio demo from the portfolio page, so new portfolio cards join automatically.
    // The "Hoi!" greetings are never part of the pool: they are not portfolio cards, and hoiN.mp3
    // files are filtered out as well.
    var shuffle = document.querySelector('.shuffle');
    if (shuffle) {
        var sBtn = shuffle.querySelector('.shuffle-btn');
        var now = shuffle.querySelector('.shuffle-now');
        var nPlay = now.querySelector('.play');
        var nName = now.querySelector('.shuffle-name');
        var track = now.querySelector('.progress');
        var fill = now.querySelector('.progress-fill');
        var nTime = now.querySelector('.time');
        var pool = null, cur = null, last = null, dragging = false;
        var hooked = [];

        var clipsIn = function (doc) {
            var seen = {};
            return [].map.call(doc.querySelectorAll('.demo[data-src]'), function (d) {
                var h = (d.closest('.card') || d).querySelector('h3');
                return {src: d.dataset.src, title: h ? h.textContent.trim() : ''};
            }).filter(function (c) {
                if (!c.src || seen[c.src] || /\/hoi\d*\.mp3$/i.test(c.src)) return false;
                seen[c.src] = true;
                return true;
            });
        };

        // load the list up front, so a click can usually start playback right away (browsers prefer that)
        var ready = fetch('/louis/portfolio/').then(function (r) {
            return r.ok ? r.text() : '';
        }).then(function (html) {
            var list = html ? clipsIn(new DOMParser().parseFromString(html, 'text/html')) : [];
            pool = list.length ? list : clipsIn(document);
        }).catch(function () {
            pool = clipsIn(document);
        });

        var paintNow = function (p) {
            if (!cur) return;
            if (p === undefined) p = cur.duration ? cur.currentTime / cur.duration : 0;
            fill.style.width = (p * 100) + '%';
            track.setAttribute('aria-valuenow', Math.round(p * 100));
            nTime.textContent = fmt(cur.currentTime) + ' / ' + fmt(cur.duration);
            now.classList.toggle('is-playing', !cur.paused);
            nPlay.setAttribute('aria-pressed', String(!cur.paused));
        };

        var hook = function (a) {
            if (hooked.indexOf(a) !== -1) return;
            hooked.push(a);
            ['timeupdate', 'play', 'pause', 'loadedmetadata'].forEach(function (ev) {
                a.addEventListener(ev, function () {
                    if (a === cur && !dragging) paintNow();
                });
            });
        };

        var playRandom = function () {
            if (!pool || !pool.length) return;
            var options = pool.length > 1 ? pool.filter(function (c) {
                return c.src !== last;
            }) : pool;
            var clip = options[Math.floor(Math.random() * options.length)];
            last = clip.src;

            var next = audioFor(clip.src);
            if (cur && cur !== next) cur.pause();
            cur = next;
            hook(cur);
            cur.currentTime = 0;
            nName.textContent = clip.title;
            now.hidden = false;
            cur.play().catch(function () {});
            paintNow(0);
        };

        sBtn.addEventListener('click', function () {
            if (pool) playRandom(); else ready.then(playRandom);

            sBtn.classList.remove('spin');
            void sBtn.offsetWidth; // restart the dice animation
            sBtn.classList.add('spin');
        });

        nPlay.addEventListener('click', function () {
            if (cur) toggle(cur);
        });

        // progress bar: click, drag or use the arrow keys to skip through the clip
        var at = function (e) {
            var r = track.getBoundingClientRect();
            return Math.max(0, Math.min(1, (e.clientX - r.left) / r.width));
        };
        track.addEventListener('pointerdown', function (e) {
            if (!cur) return;
            dragging = true;
            track.setPointerCapture(e.pointerId);
            paintNow(at(e));
            seek(cur, at(e));
        });
        track.addEventListener('pointermove', function (e) {
            if (!dragging) return;
            paintNow(at(e));
            seek(cur, at(e));
        });
        ['pointerup', 'pointercancel'].forEach(function (ev) {
            track.addEventListener(ev, function () {
                dragging = false;
                paintNow();
            });
        });
        track.addEventListener('keydown', function (e) {
            if (!cur || (e.key !== 'ArrowLeft' && e.key !== 'ArrowRight')) return;
            e.preventDefault();
            var p = cur.duration ? cur.currentTime / cur.duration : 0;
            seek(cur, p + (e.key === 'ArrowRight' ? .05 : -.05));
        });
    }

    // ---------- "Hoi!" bubble ----------
    // Each click says hoi with one of three recordings, never the same one twice in a row.
    // These are tiny, so they load up front and answer instantly; they don't stop other audio.
    var bubble = document.querySelector('.bubble');
    if (bubble) {
        var hois = [1, 2, 3].map(function (n) {
            var a = new Audio('/louis/assets/audio/hoi' + n + '.mp3');
            a.preload = 'auto';
            return a;
        });
        var lastHoi = -1;
        bubble.addEventListener('click', function () {
            var i;
            do {
                i = Math.floor(Math.random() * hois.length);
            } while (i === lastHoi && hois.length > 1);
            lastHoi = i;
            hois.forEach(function (a) {
                a.pause();
            });
            hois[i].currentTime = 0;
            hois[i].play().catch(function () {});

            bubble.classList.remove('say');
            void bubble.offsetWidth; // restart the wiggle
            bubble.classList.add('say');
        });
    }

    // ---------- videos ----------
    // data-video="/louis/assets/video/x.mp4" plays the local file in place.
    // data-youtube="VIDEO_ID" embeds YouTube, and nothing loads from YouTube until the visitor clicks.
    function pauseVideos(except) {
        document.querySelectorAll('.video-frame video').forEach(function (v) {
            if (v !== except) v.pause();
        });
    }

    // a video starting (also via its own controls) stops the audio demo
    document.addEventListener('play', function (e) {
        if (e.target.tagName === 'VIDEO' && current) current.pause();
    }, true);

    document.querySelectorAll('.video-frame').forEach(function (frame) {
        var btn = frame.querySelector('.play');
        btn.addEventListener('click', function () {
            var src = frame.dataset.video;
            var vid = frame.querySelector('video');
            if (src && vid) {
                if (vid.getAttribute('src') !== src) vid.src = src; // drop the #t=0.5 preview fragment
                vid.muted = false;
                vid.controls = true;
                vid.removeAttribute('tabindex');
                vid.removeAttribute('aria-hidden');
                frame.classList.add('is-on');
                btn.remove();
                pauseVideos(vid);
                if (current) current.pause();
                vid.play().catch(function () {});
                return;
            }
            var id = frame.dataset.youtube;
            if (!id) return;
            var f = document.createElement('iframe');
            f.src = 'https://www.youtube-nocookie.com/embed/' + encodeURIComponent(id) + '?autoplay=1&rel=0';
            f.allow = 'autoplay; encrypted-media; picture-in-picture; fullscreen';
            f.title = btn.getAttribute('aria-label') || 'Video';
            frame.appendChild(f);
            btn.remove();
        });
    });

    // ---------- googly eyes ----------
    var pupils = document.querySelectorAll('.mascot .pupil');
    if (pupils.length && !matchMedia('(prefers-reduced-motion: reduce)').matches) {
        var mx = 0, my = 0, queued = false;
        var move = function () {
            queued = false;
            pupils.forEach(function (p) {
                var eye = p.previousElementSibling.getBoundingClientRect();
                var cx = eye.left + eye.width / 2, cy = eye.top + eye.height / 2;
                var a = Math.atan2(my - cy, mx - cx);
                var d = Math.min(1, Math.hypot(mx - cx, my - cy) / 200) * 4.5;
                p.setAttribute('transform', 'translate(' + (Math.cos(a) * d).toFixed(2) + ' ' + (Math.sin(a) * d).toFixed(2) + ')');
            });
        };
        window.addEventListener('pointermove', function (e) {
            mx = e.clientX;
            my = e.clientY;
            if (!queued) {
                queued = true;
                requestAnimationFrame(move);
            }
        }, {passive: true});
    }
})();
