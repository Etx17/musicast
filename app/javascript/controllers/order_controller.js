import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input" ]

  connect() {
    this.inputTarget.addEventListener('change', this.updateOrder.bind(this));
  }

  updateOrder(event) {
    const url = this.inputTarget.dataset.url;
    const newOrder = this.inputTarget.value;

    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ new_order: newOrder })
    }).then(response => {
      if (response.ok) {
        location.reload();
      }
    });
  }
}
