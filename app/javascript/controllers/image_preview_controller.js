// app/javascript/controllers/image_preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "placeholder"]

  connect() {
    this.inputTarget.addEventListener("change", (event) => {
      if (event.target.files.length) {
        this.updateThumbnail(event.target.files[0]);
      }
    });
  }

  updateThumbnail(file) {
    // Show thumbnail for image files
    if (file.type.startsWith("image/")) {
      const reader = new FileReader();

      reader.readAsDataURL(file);
      reader.onload = () => {
        this.previewTarget.style.backgroundImage = `url('${reader.result}')`;
        this.previewTarget.style.display = 'block';
        this.placeholderTarget.style.display = 'none';
      };
    } else {
      this.previewTarget.style.backgroundImage = null;
      this.placeholderTarget.style.display = 'block';
    }
  }
}
