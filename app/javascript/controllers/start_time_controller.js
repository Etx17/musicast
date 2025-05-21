import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["oldStartDate", "newStartDate"]

  connect() {
    console.log("connected start_time controller");

    // Vérifier si on est sur le formulaire de date ou sur le bouton de pause
    if (this.hasOldStartDateTarget && this.hasNewStartDateTarget) {
      this.oldStartDateTarget.value = this.element.dataset.day;
      this.newStartDateTarget.value = this.element.dataset.day;
    }
  };

  updateDateInput() {
    const form = document.querySelector("#pauseModal form");
    const dateInput = form.querySelector(".pause_day");
    if (dateInput) {
      dateInput.value = this.element.dataset.day;
    }
  }

  fetchStartTimes(event) {
    console.log("fetching start times");
    // Récupérer la date du jour sélectionné
    var day = this.element.dataset.day;
    console.log("Selected day:", day);

    // Mettre à jour le champ caché avec la date sélectionnée
    const modal = document.getElementById("pauseModal");
    const form = modal.querySelector("form");
    const dateInput = form.querySelector(".pause_day");

    if (dateInput) {
      dateInput.value = day;
      console.log("Date set in form:", dateInput.value);
    }

    // Obtenir la liste des performances pour ce jour
    var performanceRows = document.querySelectorAll(`tr:has(td:nth-child(2)[data-date="${day}"])`);
    var startTimes = Array.from(performanceRows).map(row => row.querySelector('td:nth-child(2)').textContent.trim());

    // Obtenir les heures de pauses déjà existantes
    var pauseTimes = Array.from(document.querySelectorAll(`[id^="pause_time_${day}"]`)).map(el => el.textContent.split(' - ')[0]);

    // Trouver l'heure de la dernière pause (pour éviter d'en créer avant celle-ci)
    var latestPauseTime = pauseTimes.sort().pop();
    if (!latestPauseTime) {
      latestPauseTime = '00:00';
    }

    // Filtrer les heures disponibles après la dernière pause
    startTimes = startTimes.filter(time => time > latestPauseTime);

    // Configuration du select pour les heures de début
    const startTimeField = form.querySelector('#pause_start_time');
    if (startTimeField) {
      // Si l'élément existe, mettre à jour les options
      startTimeField.innerHTML = startTimes.map(time => `<option value="${time}">${time}</option>`).join("\n");
    } else {
      // Sinon, nous avons un élément de collection
      const startTimeSelect = form.querySelector('select[name="pause[start_time]"]');
      if (startTimeSelect) {
        // Si aucune performance n'est disponible pour ce jour, on permet une entrée manuelle
        if (startTimes.length === 0) {
          // Remplacer le select par un input time
          const parent = startTimeSelect.parentElement;
          const label = parent.querySelector('label').textContent;
          parent.innerHTML = `
            <label>${label}</label>
            <input type="time" name="pause[start_time]" class="form-control" value="09:00">
            <small class="text-muted">Aucune performance trouvée pour ce jour, veuillez entrer une heure manuellement</small>
          `;
        } else {
          // Ajouter les options au select existant
          startTimeSelect.innerHTML = startTimes.map(time => `<option value="${time}">${time}</option>`).join("\n");
        }
      }
    }
  }
}
