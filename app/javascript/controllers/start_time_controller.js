import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("conected start_time controller");
  };

  fetchStartTimes(event) {
    console.log("fecthing start times");
    var day = event.currentTarget.dataset.day;

    var startTimes = Array.from(document.querySelectorAll(`[id^="start_time_${day}"]`)).map(el => el.value);

    document.querySelector('#pause_start_time').innerHTML = startTimes.map(time => `<option value="${time}">${time}</option>`).join("\n");
  }
}
