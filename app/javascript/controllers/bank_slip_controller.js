import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("BankSlipController connected!");

    // Scope to this controller, not the whole document
    this.rows = this.element.querySelectorAll("tr[data-bank-slip-id]");

    this.rows.forEach((row) => {
      row.addEventListener("click", () => this.toggleDetails(row));
    });
  }

  toggleDetails(row) {
    const id = row.dataset.bankSlipId; // <-- numeric ID, e.g. "42"

    const detailsRow = document.getElementById(`details_${id}`);
    if (!detailsRow) {
      console.log("Details row not found for id:", id);
      return;
    }

    detailsRow.classList.toggle("hidden");

    const contentDiv = document.getElementById(`details_content_${id}`);
    if (!contentDiv) return;

    if (contentDiv.innerHTML.trim() === "Loading...") {
      fetch(`/bank_slips/${id}/details`)
        .then((res) => {
          if (!res.ok) throw new Error("Network response was not ok");
          return res.text();
        })
        .then((html) => {
          contentDiv.innerHTML = html;
        })
        .catch((err) => {
          contentDiv.innerHTML = `<span class="text-red-500">Failed to load details.</span>`;
          console.error(err);
        });
    }
  }
}
