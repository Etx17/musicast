import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rehearsalTypeContainer", "rehearsalType"]

  connect() {
    // Déclencher l'initialisation au chargement
    this.updateVisibility()
  }

  // Appelé quand la checkbox change d'état
  toggleRehearsal(event) {
    this.updateVisibility()
  }

  // Met à jour la visibilité des champs conditionnels
  updateVisibility() {
    const needsRehearsal = this.element.querySelector('#flexSwitchNeedsRehearsal').checked

    if (this.hasRehearsalTypeContainerTarget) {
      this.rehearsalTypeContainerTarget.style.display = needsRehearsal ? 'block' : 'none'
    }

    // Si besoin de répétition est coché et qu'aucun type n'est sélectionné, sélectionner solo_warmup par défaut
    if (needsRehearsal && this.hasRehearsalTypeTarget) {
      if (!this.rehearsalTypeTarget.value) {
        // Sélectionner la valeur solo_warmup si disponible
        const soloWarmupOption = Array.from(this.rehearsalTypeTarget.options)
          .find(option => option.value === 'solo_warmup' && !option.disabled)

        if (soloWarmupOption) {
          this.rehearsalTypeTarget.value = 'solo_warmup'
        }
      }
    }
  }
}
