import { Controller } from "@hotwired/stimulus"
// import debounce from "lodash/debounce";
// Connects to data-controller="music-autocomplete"
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
  }


  searchComposer(event) {
    const query = this.composerInputTarget.value;
    console.log('searhComposer fired')
    fetch(`/classical_works/composer_search?query=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        if(!data==null) {
          this.suggestionsTarget.innerHTML = '';
          return
        }
        if(data["composers"]?.length > 0) {
          console.log(data["composers"])

          const suggestionsHtml = data["composers"]?.map(composer =>
            `<li class="suggestion-item" style="list-style-type: none; text-decoration: none;" data-action="click->music-autocomplete#selectComposer" data-value="${composer.id}">${composer.complete_name}</li>`
          ).join("");
          this.suggestionsTarget.innerHTML = suggestionsHtml;
        } else {
          this.suggestionsTarget.innerHTML = '';
        }
      })
      .catch(error => {
        this.suggestionsTarget.innerHTML = '';
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
}
