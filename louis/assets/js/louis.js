// Audio demos, video cards and the googly-eyed mascot.
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

    // ---------- audio demos ----------
    var current = null;

    function fmt(sec) {
        if (!isFinite(sec)) sec = 0;
        var m = Math.floor(sec / 60), s = Math.floor(sec % 60);
        return m + ':' + (s < 10 ? '0' : '') + s;
    }

    document.querySelectorAll('.demo').forEach(function (demo, idx) {
        var btn = demo.querySelector('.play');
        var wave = demo.querySelector('.wave');
        var time = demo.querySelector('.time');
        if (!demo.dataset.src) return;
        var seed = idx + 1;
        var audio = null;
        var initial = time.textContent;

        // waveform: real loudness from data-peaks (percent per bar) when given, otherwise a made-up shape
        var peaks = wave.dataset.peaks ? wave.dataset.peaks.split(',').map(Number) : null;
        var rnd = rng(seed), bars = peaks ? peaks.length : +wave.dataset.bars || 56;
        for (var i = 0; i < bars; i++) {
            var bar = document.createElement('i');
            var env = .45 + .55 * Math.sin(Math.PI * (i + .5) / bars);
            bar.style.height = (peaks ? Math.max(8, peaks[i]) : Math.max(14, Math.round((.35 + rnd() * .65) * env * 100))) + '%';
            wave.appendChild(bar);
        }
        var barEls = wave.children;

        function paint() {
            var p = audio && audio.duration ? audio.currentTime / audio.duration : 0;
            var on = Math.round(p * barEls.length);
            for (var j = 0; j < barEls.length; j++) barEls[j].classList.toggle('on', j < on);
            // at rest show the length, while playing the position
            time.textContent = audio && audio.currentTime > 0 ? fmt(audio.currentTime)
                : audio && isFinite(audio.duration) ? fmt(audio.duration) : initial;
            wave.setAttribute('aria-valuenow', Math.round(p * 100));
        }

        function ensure() {
            if (audio) return audio;
            audio = new Audio(demo.dataset.src);
            audio.preload = 'metadata';
            audio.addEventListener('timeupdate', paint);
            audio.addEventListener('play', function () {
                pauseVideos();
                demo.classList.add('is-playing');
                btn.setAttribute('aria-pressed', 'true');
            });
            audio.addEventListener('pause', function () {
                demo.classList.remove('is-playing');
                btn.setAttribute('aria-pressed', 'false');
            });
            audio.addEventListener('ended', function () {
                audio.currentTime = 0;
                paint();
            });
            return audio;
        }

        btn.addEventListener('click', function () {
            var a = ensure();
            if (a.paused) {
                if (current && current !== a) current.pause();
                current = a;
                a.play().catch(function () {});
            } else {
                a.pause();
            }
        });

        function seekTo(p) {
            var a = ensure();
            var go = function () {
                a.currentTime = Math.max(0, Math.min(1, p)) * a.duration;
                paint();
            };
            if (a.readyState >= 1) go(); else a.addEventListener('loadedmetadata', go, {once: true});
        }

        wave.setAttribute('role', 'slider');
        wave.setAttribute('tabindex', '0');
        wave.setAttribute('aria-valuemin', '0');
        wave.setAttribute('aria-valuemax', '100');
        wave.setAttribute('aria-valuenow', '0');
        wave.addEventListener('click', function (e) {
            var r = wave.getBoundingClientRect();
            seekTo((e.clientX - r.left) / r.width);
        });
        wave.addEventListener('keydown', function (e) {
            if (e.key !== 'ArrowLeft' && e.key !== 'ArrowRight') return;
            e.preventDefault();
            var a = ensure();
            var p = a.duration ? a.currentTime / a.duration : 0;
            seekTo(p + (e.key === 'ArrowRight' ? .05 : -.05));
        });
    });

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
