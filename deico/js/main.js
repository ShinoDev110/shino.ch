/* main.js - progressive enhancement only.
   Every page is fully readable and navigable with this file absent, blocked
   or failing. Nothing here creates content or links. */

(function () {
  "use strict";

  var toggle = document.querySelector(".nav-toggle");
  var nav = document.getElementById("site-nav");
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

    /* Same-page anchors navigate without a reload, which would otherwise
       leave the panel covering the content it just scrolled to. */
    nav.addEventListener("click", function (event) {
      if (event.target.closest("a")) closeNav();
    });
  }

  document.addEventListener("keydown", function (event) {
    if (event.key !== "Escape") return;

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

  document.addEventListener("click", function (event) {
    if (lang && lang.open && !lang.contains(event.target)) {
      lang.open = false;
    }
  });

  /* The contact form is a visual mockup and must never send. The disabled
     submit button already blocks clicking and Enter without any script; this
     also cancels a scripted submit, which would otherwise reload the page with
     every typed value in the query string and so into history and server logs. */
  var mockForm = document.querySelector('form[data-mockup]');
  if (mockForm) {
    mockForm.addEventListener('submit', function (event) {
      event.preventDefault();
    });
  }

  /* A panel left open on a phone would otherwise persist after a rotate or a
     resize past the breakpoint, where the desktop nav is already showing. */
  var wide = window.matchMedia("(min-width: 768px)");

  function onBreakpoint(event) {
    if (event.matches) closeNav();
  }

  if (wide.addEventListener) {
    wide.addEventListener("change", onBreakpoint);
  } else if (wide.addListener) {
    wide.addListener(onBreakpoint);
  }
})();
