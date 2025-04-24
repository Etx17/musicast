import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="requirement"
export default class extends Controller {
  static targets = [ "title" ]

  changeIdOfInput() {
    const newId = "requirement-" + new Date().getTime();
    this.titleTarget.id = newId;
  }

  toggleRatioField(event) {
    const typeValue = event.target.value;
    const ratioField = document.getElementById('ratio-field');

    if (typeValue === 'photo') {
      ratioField.classList.remove('d-none');
    } else {
      ratioField.classList.add('d-none');
    }
  }

  updateRatioPreview(event) {
    const ratioValue = parseFloat(event.target.value);
    const previewEl = document.getElementById('ratio-preview');

    if (!isNaN(ratioValue) && previewEl) {
      const previewWidth = 200;
      const previewHeight = previewWidth / ratioValue;

      const maxHeight = 300;
      const finalHeight = Math.min(previewHeight, maxHeight);

      previewEl.style.width = previewWidth + 'px';
      previewEl.style.height = finalHeight + 'px';
    }
  }
}
