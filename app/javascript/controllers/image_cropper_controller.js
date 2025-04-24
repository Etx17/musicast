import { Controller } from "@hotwired/stimulus"
import Cropper from "cropperjs"

// Connects to data-controller="image-cropper"
export default class extends Controller {
  static targets = ["input", "preview", "croppedResult", "modal", "cropButton", "cropperContainer"]
  static values = { aspectRatio: Number }

  initialize() {
    this.cropper = null
    this.aspectRatioValue = this.aspectRatioValue || 1.0 // Ratio par défaut 1:1
  }

  connect() {
    console.log("Image Cropper controller connected with ratio:", this.aspectRatioValue)
    // Initialiser le modal Bootstrap si disponible
    if (typeof bootstrap !== 'undefined' && this.hasModalTarget) {
      this.bootstrapModal = new bootstrap.Modal(this.modalTarget)
    }
  }

  // Quand un fichier est sélectionné
  onFileSelect(event) {
    const file = event.target.files[0]
    if (!file || !file.type.match('image.*')) return

    // Lire le fichier et afficher la prévisualisation
    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewTarget.src = e.target.result
      this.showModal()
      this.initCropper()
    }
    reader.readAsDataURL(file)
  }

  // Afficher le modal
  showModal() {
    if (this.bootstrapModal) {
      this.bootstrapModal.show()
    } else {
      this.modalTarget.classList.remove('d-none')
      this.modalTarget.classList.add('show')
    }
  }

  // Masquer le modal
  hideModal() {
    if (this.bootstrapModal) {
      this.bootstrapModal.hide()
    } else {
      this.modalTarget.classList.add('d-none')
      this.modalTarget.classList.remove('show')
    }
  }

  // Initialiser le cropper
  initCropper() {
    if (this.cropper) {
      this.cropper.destroy()
    }

    this.cropper = new Cropper(this.previewTarget, {
      aspectRatio: this.aspectRatioValue,
      viewMode: 1,
      dragMode: 'move',
      autoCropArea: 0.8,
      restore: false,
      guides: true,
      center: true,
      highlight: false,
      cropBoxMovable: true,
      cropBoxResizable: true,
      toggleDragModeOnDblclick: false,
    })
  }

  // Appliquer le recadrage
  applyCrop() {
    if (!this.cropper) return

    // Récupérer l'image recadrée
    const canvas = this.cropper.getCroppedCanvas({
      maxWidth: 2000,
      maxHeight: 2000,
      fillColor: '#fff',
      imageSmoothingEnabled: true,
      imageSmoothingQuality: 'high',
    })

    if (canvas) {
      // Afficher l'image recadrée
      const croppedImageUrl = canvas.toDataURL('image/jpeg')
      this.croppedResultTarget.src = croppedImageUrl
      this.croppedResultTarget.classList.remove('d-none')

      // Convertir l'image en fichier et la stocker
      canvas.toBlob((blob) => {
        // Créer un nouveau fichier
        const fileName = this.inputTarget.files[0].name
        const croppedFile = new File([blob], fileName, {
          type: 'image/jpeg',
          lastModified: new Date().getTime()
        })

        // Créer un nouveau FileList contenant le fichier recadré
        const dataTransfer = new DataTransfer()
        dataTransfer.items.add(croppedFile)
        this.inputTarget.files = dataTransfer.files

        // Déclencher l'événement change pour tout validateur qui pourrait écouter
        const event = new Event('change', { bubbles: true })
        this.inputTarget.dispatchEvent(event)
      }, 'image/jpeg', 0.9)

      // Fermer le modal
      this.hideModal()

      // Détruire le cropper
      this.cropper.destroy()
      this.cropper = null
    }
  }

  // Fermer le modal sans appliquer le recadrage
  closeModal() {
    this.hideModal()
    if (this.cropper) {
      this.cropper.destroy()
      this.cropper = null
    }

    // Réinitialiser l'input file
    this.inputTarget.value = ''
  }
}
