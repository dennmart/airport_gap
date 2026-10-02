// Switches the home page's example between the successful and the simulated
// failure response. Without JavaScript, both examples show one after the other.
function setup(container) {
  if (container.dataset.exampleTabsReady) return;
  container.dataset.exampleTabsReady = "true";

  const tablist = container.querySelector("[role=tablist]");
  const tabs = [...tablist.querySelectorAll("[role=tab]")];

  function select(tab, focus = false) {
    tabs.forEach((other) => {
      const selected = other === tab;
      other.setAttribute("aria-selected", selected);
      other.tabIndex = selected ? 0 : -1;
      document.getElementById(other.getAttribute("aria-controls")).classList.toggle("is-inactive", !selected);
    });
    if (focus) tab.focus();
  }

  tabs.forEach((tab, index) => {
    tab.addEventListener("click", () => select(tab));
    tab.addEventListener("keydown", (event) => {
      const offset = { ArrowRight: 1, ArrowLeft: -1 }[event.key];
      if (!offset) return;
      event.preventDefault();
      select(tabs[(index + offset + tabs.length) % tabs.length], true);
    });
  });

  tablist.hidden = false;
  select(tabs.find((tab) => tab.getAttribute("aria-selected") === "true"));
}

document.addEventListener("turbo:load", () => {
  document.querySelectorAll("[data-example-tabs]").forEach(setup);
});
