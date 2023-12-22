import { Controller } from "@hotwired/stimulus"
function debounce(func, wait) {
  let timeout;

  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };

    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
};

export default class extends Controller {
  static targets = ["composerInput", "workInput", "suggestions"];

  connect() {
    console.log("Connected!");
    this.searchComposer = debounce(this.searchComposer.bind(this), 300);
    this.searchWork = debounce(this.searchWork.bind(this), 300);
    document.addEventListener('click', this.handleClickOutside.bind(this));
  }


  searchComposer(event) {
    document.querySelector('.loader').style.display = 'block';
    const query = this.composerInputTarget.value;
    if(query == '') {
      this.suggestionsTarget.innerHTML = '';
      document.querySelector('.loader').style.display = 'none';
      return
    }
    fetch(`/classical_works/composer_search?query=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        console.log(data, 'data')
        document.querySelector('.loader').style.display = 'none';

        if(!data==null) {
          this.suggestionsTarget.innerHTML = '';
          return
        }
        if(data?.length > 0) {

          const suggestionsHtml = data?.map(composer =>
            `<li class="suggestion-item" style="list-style-type: none; text-decoration: none;" data-action="click->music-autocomplete#selectComposer" data-value="${composer}">${composer}</li>`
          ).join("");
          this.suggestionsTarget.innerHTML = suggestionsHtml;
        } else {
          this.suggestionsTarget.innerHTML = '';
          document.querySelector('.loader').style.display = 'none';
        }
      })
      .catch(error => {
        this.suggestionsTarget.innerHTML = '';
        document.querySelector('.loader').style.display = 'none';
      });
  }

  searchWork(event) {
    const query = this.workInputTarget.value;
    const composerId = this.selectedComposerId; // Assuming you have stored the selected composer's ID
    fetch(`/classical_works/work_search?composer_id=${composerId}&query=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        // Assuming 'data' contains an array of works
        // const suggestionsHtml = data.map(work => `<li>${work.title}</li>`).join("");
        // this.suggestionsTarget.innerHTML = suggestionsHtml;
      })
      .catch(error => console.error('Error:', error));
  }

  selectComposer(event) {
    const composerName = event.target.textContent;
    this.composerInputTarget.value = composerName;

    // Optionally, store the selected composer's ID for further queries
    this.selectedComposerId = event.target.getAttribute('data-value');

    // Clear the suggestions
    this.suggestionsTarget.innerHTML = '';
  }

  handleClickOutside(event) {
    const withinBoundaries = event.composedPath().includes(this.element);
    if (!withinBoundaries) {
      this.suggestionsTarget.innerHTML = '';
    }
  }
  disconnect() {
    document.removeEventListener('click', this.handleClickOutside.bind(this));
  }
}
