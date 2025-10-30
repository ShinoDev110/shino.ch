export default class PepToast {
    constructor(buttonId, messages) {
        this.btn = document.getElementById(buttonId);
        this.messages = messages || [];
        this.currentToast = null;
        this.toastTimer = null;
        if (this.btn) this.btn.addEventListener('click', () => this.show());
    }

    show() {
        if (this.currentToast) {
            clearTimeout(this.toastTimer);
            this.currentToast.remove();
            this.currentToast = null;
        }
        const msg = this.messages[(Math.random() * this.messages.length) | 0] || 'You got this!';
        const n = document.createElement('div');
        n.className = 'toast';
        n.textContent = msg;
        document.body.appendChild(n);
        this.currentToast = n;
        this.toastTimer = setTimeout(() => {
            n.remove();
            if (this.currentToast === n) this.currentToast = null;
        }, 2600);
    }
}
