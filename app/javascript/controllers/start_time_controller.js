import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("conected start_time controller");
  };

  fetchStartTimes(event) {
    console.log("fecthing start times");
    var day = event.currentTarget.dataset.day;
    console.log(day)
    var startTimes = Array.from(document.querySelectorAll(`[id^="start_time_${day}"]`)).map(el => el.value);
    var pauseTimes = Array.from(document.querySelectorAll(`[id^="pause_time_${day}"]`)).map(el => el.textContent.split(' - ')[0]);

    var latestPauseTime = pauseTimes.sort().pop();

    if(!latestPauseTime) {
      latestPauseTime = '00:00';
    }
    startTimes = startTimes.filter(time => time > latestPauseTime);

    document.querySelector('#pause_start_time').innerHTML = startTimes.map(time => `<option value="${time}">${time}</option>`).join("\n");

    const form = document.querySelector("#pauseModal form");
    const dateInput = form.querySelector(".pause_day");
    if (dateInput) {
      dateInput.value = day;
    }
    console.log(dateInput.value, "dateinput value");
  }
}
