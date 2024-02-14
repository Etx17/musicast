// app/javascript/controllers/draggable_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "submit"]

  connect() {
    this.originalOrder = this.getOrder()
  }

  dragStart(event) {
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setData("text/plain", event.target.dataset.id)
    this.draggedItem = event.target
  }

  dragOver(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
  }

  drop(event) {
    event.preventDefault()

    const targetId = event.dataTransfer.getData("text/plain")
    const target = this.listTarget.querySelector(`[data-id='${targetId}']`)
    const dropTarget = event.target.closest('[data-id]')

    if (dropTarget && target !== dropTarget) {
      if (this.isBefore(target, dropTarget)) {
        this.listTarget.insertBefore(target, dropTarget)
      } else {
        this.listTarget.insertBefore(target, dropTarget.nextSibling)
      }

      // Retrieve the category ID from the drop target
      this.categoryId = dropTarget.dataset.id

      if (this.getOrder() != this.originalOrder) {
        this.submit()
      }
    }
  }

  dragEnd(event) {
    event.preventDefault()
    this.draggedItem = null
  }

  submit() {
    let data = new FormData()
    const newOrder = Array.from(this.listTarget.children).map(child => child.dataset.id)

    data.append("new_order", JSON.stringify(this.getOrder()))

    fetch(`/organisms/1/competitions/1/edition_competitions/1/categories/${this.categoryId}/tours/reorder_tours`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': getMetaValue('csrf-token')
      },
      body: JSON.stringify({
        new_order: newOrder,
        category: this.categoryId
      })
    }).then(response => location.reload())

  }

  getOrder() {
    return Array.from(this.listTarget.children).map(div => div.dataset.id)
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

function getMetaValue(name) {
  let element = document.head.querySelector(`meta[name="${name}"]`)
  return element.getAttribute("content")
}
