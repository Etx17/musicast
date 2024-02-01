import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="character-counter"
export default class extends Controller {
  static targets = [ "input", "counter" ]

  connect() {
    this.update()
  }

  update() {
    this.counterTargets.forEach((counter, index) => {
      const length = this.inputTargets[index].value.length
      counter.textContent = length
    })
  }
}
