export default class HeartField {
    constructor(containerId, intervalMs = 500) {
        this.container = document.getElementById(containerId);
        this.intervalMs = intervalMs;
        this.timer = null;
        this._spawn = this._spawn.bind(this);
    }

    _spawn() {
        if (!this.container) return;
        const el = document.createElement('div');
        el.className = 'heart';
        el.textContent = '❤';
        el.style.left = Math.random() * 100 + 'vw';
        el.style.animationDuration = (8 + Math.random() * 8) + 's';
        el.style.fontSize = (12 + Math.random() * 18) + 'px';
        this.container.appendChild(el);
        setTimeout(() => el.remove(), 14000);
    }

    start() {
        this.stop();
        this.timer = setInterval(this._spawn, this.intervalMs);
    }

    stop() {
        if (this.timer) clearInterval(this.timer);
        this.timer = null;
    }

    setIntensity(ms) {
        this.intervalMs = ms;
        this.start();
    }
}
