/* main.js - progressive enhancement for the deico site.

   Every page is fully readable and navigable with this file absent, blocked
   or failing: the nav renders as a plain list, the language switcher is a
   native <details>, and each showroom tile is an ordinary link to the large
   image. Nothing here creates content or links. */

(function () {
  "use strict";

  /* ---------------------------------------------------------- navigation */

  var toggle = document.querySelector(".navtoggle");
  var nav = document.getElementById("nav");
  var lang = document.querySelector(".lang");

  function closeNav() {
    if (!toggle || !nav) return;
    toggle.setAttribute("aria-expanded", "false");
    nav.classList.remove("is-open");
  }

  if (toggle && nav) {
    toggle.addEventListener("click", function () {
      var open = toggle.getAttribute("aria-expanded") === "true";
      toggle.setAttribute("aria-expanded", open ? "false" : "true");
      nav.classList.toggle("is-open", !open);
    });

    /* A same-page anchor navigates without a reload, which would otherwise
       leave the panel covering the content it just scrolled to. */
    nav.addEventListener("click", function (event) {
      if (event.target.closest("a")) closeNav();
    });
  }

  document.addEventListener("click", function (event) {
    if (lang && lang.open && !lang.contains(event.target)) lang.open = false;
  });

  document.addEventListener("keydown", function (event) {
    if (event.key !== "Escape") return;

    /* A modal <dialog> cancels itself on Escape. Bailing out here keeps this
       handler from also collapsing the nav behind the open lightbox. */
    var openDialog = document.querySelector("dialog[open]");
    if (openDialog) return;

    if (lang && lang.open) {
      lang.open = false;
      var summary = lang.querySelector("summary");
      if (summary) summary.focus();
    }

    if (toggle && toggle.getAttribute("aria-expanded") === "true") {
      closeNav();
      toggle.focus();
    }
  });

  /* A panel left open on a phone should not persist past the breakpoint,
     where the desktop nav is already showing. */
  var wide = window.matchMedia("(min-width: 768px)");

  function onBreakpoint(event) { if (event.matches) closeNav(); }

  if (wide.addEventListener) wide.addEventListener("change", onBreakpoint);
  else if (wide.addListener) wide.addListener(onBreakpoint);

  /* ------------------------------------------------------- contact form

     The form is a visual mockup and must never send. The disabled submit
     already blocks clicking and Enter without any script; this also cancels
     a scripted submit, which would otherwise reload the page with every
     typed value in the query string, and so into history and server logs. */

  var mockForm = document.querySelector("form[data-mockup]");
  if (mockForm) {
    mockForm.addEventListener("submit", function (event) {
      event.preventDefault();
    });
  }

  /* -------------------------------------------------- showroom lightbox

     Each tile is already a link to the large image, so with this block
     absent, or with <dialog> unsupported, the gallery still works: the link
     opens the file. preventDefault is only called once we know we can
     handle the click ourselves. */

  var gallery = document.querySelector(".gallery");
  var box = document.getElementById("lightbox");
  if (!gallery || !box || typeof box.showModal !== "function") return;

  var shots = Array.prototype.slice.call(gallery.querySelectorAll(".shot"));
  if (!shots.length) return;

  var lbImg = box.querySelector(".lightbox__img");
  var lbDesc = box.querySelector(".lightbox__desc");
  var lbCount = box.querySelector(".lightbox__count");
  var lbPrev = box.querySelector('[data-lb="prev"]');
  var lbNext = box.querySelector('[data-lb="next"]');
  var index = 0;
  var opener = null;

  function show(i) {
    if (i < 0 || i >= shots.length) return;
    index = i;
    var shot = shots[i];
    var link = shot.querySelector(".shot__link");
    var thumb = shot.querySelector("img");
    var cap = shot.querySelector(".shot__cap");

    /* href is the JPEG, which is what a no-script visitor gets. Every browser
       that can run this also handles WebP, so prefer the smaller file. */
    lbImg.src = link.getAttribute("data-full") || link.getAttribute("href");
    lbImg.alt = thumb ? thumb.alt : "";
    lbDesc.textContent = cap ? cap.textContent.trim() : "";
    lbCount.textContent = (i + 1) + " / " + shots.length;
    if (lbPrev) lbPrev.disabled = i === 0;
    if (lbNext) lbNext.disabled = i === shots.length - 1;
  }

  gallery.addEventListener("click", function (event) {
    var link = event.target.closest(".shot__link");
    if (!link) return;
    var i = shots.indexOf(link.closest(".shot"));
    if (i === -1) return;
    event.preventDefault();
    opener = link;
    show(i);
    box.showModal();
  });

  if (lbPrev) lbPrev.addEventListener("click", function () { show(index - 1); });
  if (lbNext) lbNext.addEventListener("click", function () { show(index + 1); });

  var lbClose = box.querySelector('[data-lb="close"]');
  if (lbClose) lbClose.addEventListener("click", function () { box.close(); });

  box.addEventListener("keydown", function (event) {
    if (event.key === "ArrowLeft") { event.preventDefault(); show(index - 1); }
    if (event.key === "ArrowRight") { event.preventDefault(); show(index + 1); }
  });

  /* The dialog box fills only part of the backdrop, so a click counts as
     "outside" when it lands beyond the dialog's own rectangle. */
  box.addEventListener("click", function (event) {
    if (event.target !== box) return;
    var r = box.getBoundingClientRect();
    var outside = event.clientX < r.left || event.clientX > r.right ||
                  event.clientY < r.top || event.clientY > r.bottom;
    if (outside) box.close();
  });

  /* Return focus to the thumbnail that opened the dialog, so a keyboard user
     is not dropped back at the top of a seventy-tile grid. */
  box.addEventListener("close", function () {
    if (opener && typeof opener.focus === "function") opener.focus();
    opener = null;
    lbImg.removeAttribute("src");
  });
})();
