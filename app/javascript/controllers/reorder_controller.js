import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "orderedSelection", "submit"]

  connect() {
    this.originalOrder = this.getOrder()
  }

  dragStart(event) {
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setData("text/plain", event.target.dataset.id)
    this.draggedItem = event.target
  }

  dragOver(event) {
    event.preventDefault()  // Necessary to allow dropping
  }

  drop(event) {
    event.preventDefault()

    const targetId = event.dataTransfer.getData("text/plain")
    const target = this.listTarget.querySelector(`[data-id='${targetId}']`)
    const dropTarget = event.target.closest('li')

    if (dropTarget && target !== dropTarget) {
      if (this.isBefore(target, dropTarget)) {
        this.listTarget.insertBefore(target, dropTarget)
      } else {
        this.listTarget.insertBefore(target, dropTarget.nextSibling)
      }

      if (this.getOrder() != this.originalOrder) {
        this.submitTarget.disabled = false
      }
    }
  }

  dragEnd(event) {
    event.preventDefault()
    this.draggedItem = null
  }

  submit(event) {
    this.orderedSelectionTarget.value = JSON.stringify(this.getOrder())
  }

  getOrder() {
    return Array.from(this.listTarget.children).map(li => li.dataset.id)
  }

  isBefore(el1, el2) {
    if (el2.parentNode === el1.parentNode) {
      for (let cur = el1.previousSibling; cur; cur = cur.previousSibling) {
        if (cur === el2) return true
      }
    }
    return false
  }
}
