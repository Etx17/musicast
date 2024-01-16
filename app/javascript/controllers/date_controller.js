import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="date"
export default class extends Controller {
  connect() {
    console.log("Hello, Stimulus!", this.element)
  }

  static targets = [ "newStartDate" ]

  validateDateFormat(event) {
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;

    // Immediately check the regex and change the color of the text
    if (!dateRegex.test(this.newStartDateTarget.value)) {
      this.newStartDateTarget.style.color = "red";
    } else {
      this.newStartDateTarget.style.color = "initial";
    }

    // If the regex is not met, prevent the default action and show the alert
    if (!dateRegex.test(this.newStartDateTarget.value)) {
      setTimeout(() => {
        alert('Entrez une date au format AAAA-MM-JJ (ex: 2024-01-01)');
        // Change the color of the text back to black when the alert is closed
        this.newStartDateTarget.style.color = "black";
      }, 0);
      event.preventDefault();
    }
  }
}
