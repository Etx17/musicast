import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="requirement"
export default class extends Controller {
  static targets = [ "title" ]

  changeIdOfInput() {
    const newId = "requirement-" + new Date().getTime();
    this.titleTarget.id = newId;
  }
}
