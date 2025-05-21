import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    console.log("Modal controller connected")
    this.showModal()
  }

  showModal() {
    console.log("Showing modal")
    const modal = this.modalTarget

    if (modal) {
      modal.style.display = 'block'
      modal.classList.add('show')
      document.body.classList.add('modal-open')

      // Create backdrop if needed
      if (!document.querySelector('.modal-backdrop')) {
        const backdrop = document.createElement('div')
        backdrop.className = 'modal-backdrop fade show'
        document.body.appendChild(backdrop)
      }
    }
  }

  close() {
    console.log("Closing modal")
    const modal = this.modalTarget

    if (modal) {
      modal.style.display = 'none'
      modal.classList.remove('show')
      document.body.classList.remove('modal-open')

      // Remove backdrop
      const backdrop = document.querySelector('.modal-backdrop')
      if (backdrop) {
        backdrop.parentNode.removeChild(backdrop)
      }
    }
  }
}
