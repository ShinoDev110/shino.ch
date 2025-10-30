import HeartField from './heart-field.js';
import PepToast from './pep-toast.js';

document.addEventListener('DOMContentLoaded', () => {
    const hearts = new HeartField('hearts', 500);
    hearts.start();

    const pepLines = ["Ich liebe dich!", "Du schaffsch das!", "Masse isch nümm Konstant!", "Bald sind Ferie!", "Bstellemer hüt abig Sushi!"];
    new PepToast('pep', pepLines);

    const sparkleBtn = document.getElementById('sparkle');
    if (sparkleBtn) {
        let more = false;
        sparkleBtn.addEventListener('click', (e) => {
            more = !more;
            hearts.setIntensity(more ? 220 : 500);
            e.target.textContent = more ? 'Tone it down ✨' : 'Add more sparkle ✨';
        });
    }
});
