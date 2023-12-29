import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hover"
export default class extends Controller {
  static targets = [ "text" ]
  connect() {
    this.data.set("original", this.textTarget.textContent)
  }

  hover() {
    this.textTarget.textContent = "Voir"
  }

  unhover() {
    this.textTarget.textContent = this.data.get("original")
  }

}
