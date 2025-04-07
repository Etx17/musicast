import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="educations"
export default class extends Controller {
  static targets = ["template", "container"]

  connect() {
    console.log("Educations controller connected")
  }

  addEducation(event) {
    event.preventDefault()

    const content = this.templateTarget.innerHTML
      .replace(/NEW_RECORD/g, new Date().getTime())

    this.containerTarget.insertAdjacentHTML('beforeend', content)
  }

  removeEducation(event) {
    event.preventDefault()

    const item = event.target.closest(".nested-fields")

    // Si c'est un nouvel enregistrement, on le supprime directement
    if (item.dataset.newRecord === "true") {
      item.remove()
    } else {
      // Sinon on cache l'élément et on marque le champ _destroy à true
      item.style.display = "none"
      const destroyField = item.querySelector("input[name*='_destroy']")
      destroyField.value = "true"
    }
  }
}
