// Copies the text of the element named by data-copy and confirms it, both on
// the button and through a live region for screen readers. Without JavaScript
// or the Clipboard API, the button stays hidden.
const RESET_AFTER = 2000;

function setup(button) {
  if (button.dataset.copyReady || !navigator.clipboard) return;
  button.dataset.copyReady = "true";

  const source = document.querySelector(button.dataset.copy);
  const status = document.querySelector(button.dataset.copyStatus);
  let timer;

  button.addEventListener("click", async () => {
    try {
      await navigator.clipboard.writeText(source.textContent.trim());
      button.classList.add("is-copied");
      status.textContent = "Copied to the clipboard.";
    } catch {
      status.textContent = "Couldn't copy. Select the token and copy it instead.";
    }

    clearTimeout(timer);
    timer = setTimeout(() => {
      button.classList.remove("is-copied");
      status.textContent = "";
    }, RESET_AFTER);
  });

  button.hidden = false;
}

document.addEventListener("turbo:load", () => {
  document.querySelectorAll("[data-copy]").forEach(setup);
});
