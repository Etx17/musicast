import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu", "button"];

  connect() {
    // Event listener to close the dropdown when clicking outside
    document.addEventListener('click', this.handleOutsideClick.bind(this));
  }

  toggle(event) {
    event.stopPropagation();

    // Close all other open dropdown menus
    const allMenus = document.querySelectorAll('[data-controller="dropdown"]');
    allMenus.forEach((menu) => {
      if (menu !== this.element) {
        const menuTarget = menu.querySelector('[data-dropdown-target="menu"]');
        menuTarget.classList.remove('show');
      }
    });

    this.menuTarget.classList.toggle('show');

    // Check if we need to adjust the modal position
    this.adjustModalPosition();
  }

  adjustModalPosition() {
    const tableContainer = this.element.closest('.table-component');
    if (!tableContainer) return;

    const modal = this.menuTarget;
    const modalRect = modal.getBoundingClientRect();
    const containerRect = tableContainer.getBoundingClientRect();
    const overflow = modalRect.bottom - containerRect.bottom;
    if (overflow > 0) {
      const currentTop = parseInt(modal.style.top || '0');
      modal.style.top = `${currentTop - overflow}px`;
    }
  }

  close() {
    this.menuTarget.classList.remove('show');
  }

  handleOutsideClick(event) {
    // Closes the menu if click is outside the component
    if (!this.element.contains(event.target)) {
      this.close();
    }
  }

  disconnect() {
    // Removes the event listener when the component is removed
    document.removeEventListener('click', this.handleOutsideClick.bind(this));
  }

}
