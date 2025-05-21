import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="requirement"
export default class extends Controller {
  static targets = [ "title", "selectedTypeItem", "typeItemsGrid" ]

  connect() {
    // Si une valeur est déjà sélectionnée lors du chargement
    const selectedValue = this.selectedTypeItemTarget.value;
    if (selectedValue) {
      this.selectTileByType(selectedValue);
    }
  }

  changeIdOfInput() {
    const newId = "requirement-" + new Date().getTime();
    this.titleTarget.id = newId;
  }

  selectTypeItem(event) {
    const clickedTile = event.currentTarget;
    const selectedType = clickedTile.dataset.type;

    // Mise à jour de la classe visuelle pour toutes les tuiles
    this.clearSelectedTiles();
    clickedTile.classList.add('selected');

    // Mettre à jour le champ caché avec la valeur sélectionnée
    this.selectedTypeItemTarget.value = selectedType;

    // Afficher/masquer le champ ratio en fonction du type sélectionné
    this.toggleRatioField(selectedType);
  }

  clearSelectedTiles() {
    // Supprimer la classe 'selected' de toutes les tuiles
    const tiles = this.typeItemsGridTarget.querySelectorAll('.type-item-tile');
    tiles.forEach(tile => tile.classList.remove('selected'));
  }

  selectTileByType(type) {
    // Sélectionner visuellement la tuile correspondant au type
    const tile = this.typeItemsGridTarget.querySelector(`[data-type="${type}"]`);
    if (tile) {
      this.clearSelectedTiles();
      tile.classList.add('selected');
    }
  }

  toggleRatioField(typeValue) {
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
