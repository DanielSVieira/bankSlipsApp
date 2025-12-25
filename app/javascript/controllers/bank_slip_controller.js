import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // Scope to this controller, not the whole document
    this.rows = this.element.querySelectorAll("tr[data-bank-slip-id]");

    this.rows.forEach((row) => {
      row.addEventListener("click", (event) => this.toggleDetails(event, row));
    });
  }

  stop(event) {
    event.stopPropagation();
  }

  toggleDetails(event, row) {
    // Prevent toggling if clicking on buttons or forms
    if (event.target.closest("button") || event.target.closest("form")) {
      return;
    }

    const id = row.dataset.bankSlipId;
    const detailsRow = document.getElementById(`details_${id}`);
    if (!detailsRow) return;

    detailsRow.classList.toggle("hidden");

    const contentDiv = document.getElementById(`details_content_${id}`);
    if (!contentDiv) return;

    if (contentDiv.innerHTML.trim() === "Loading...") {
      fetch(`/bank_slips/${id}/details`)
        .then((res) => res.text())
        .then((html) => (contentDiv.innerHTML = html))
        .catch(() => {
          contentDiv.innerHTML = `<span class="text-red-500">Failed to load details.</span>`;
        });
    }
  }
}
