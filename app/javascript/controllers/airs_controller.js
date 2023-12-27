import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="airs"
export default class extends Controller {
  static targets = [ "template", "container" ]
  connect(){
    console.log("airs_controller.js connected")
  }
  addAir(event) {
    event.preventDefault()

    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML('beforeend', content)
  }

  removeAir(event) {
    event.preventDefault()

    const wrapper = event.target.closest('.nested-fields')
    if (wrapper.dataset.newRecord == 'true') {
      wrapper.remove()
    } else {
      wrapper.querySelector("input[name*='_destroy']").value = '1'
      wrapper.style.display = 'none'
    }
  }
}
