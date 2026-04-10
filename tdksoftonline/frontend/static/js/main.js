document.addEventListener('DOMContentLoaded', () => {
    // 1. Gestion du bouton CTA (Google Form)
    const ctaButtons = document.querySelectorAll('.cta-btn, .cta a');
    ctaButtons.forEach(button => {
        button.addEventListener('click', () => {
            console.log("🚀 Un parent a cliqué sur le bouton de réservation !");
        });
    });

    // 2. Gestion du formulaire de contact (Uniquement s'il existe dans le HTML)
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const data = {
                full_name: document.getElementById('full_name').value,
                email: document.getElementById('email').value,
                subject: document.getElementById('subject').value,
                message: document.getElementById('message').value
            };
            
            try {
                const res = await fetch('/api/v1/contact', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify(data)
                });
                const result = await res.json();
                const responseEl = document.getElementById('response');
                if (responseEl) responseEl.innerText = result.detail || "Message envoyé !";
            } catch (error) {
                console.error("Erreur lors de l'envoi:", error);
            }
        });
    }
});