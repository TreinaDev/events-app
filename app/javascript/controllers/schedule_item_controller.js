import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["description", "responsibleEmail", "responsibleName"]

  connect() {
    this.toggleFields()
  }

  toggleFields() {
    const intervalRadio = document.querySelector('input[name="schedule_item[schedule_type]"][value="interval"]')
    if (intervalRadio && intervalRadio.checked) {
      this.hideFields()
    } else {
      this.showFields()
    }
  }

  hideFields() {
    this.descriptionTarget.classList.add("hidden")
    this.responsibleEmailTarget.classList.add("hidden")
    this.responsibleNameTarget.classList.add("hidden")
  }

  showFields() {
    this.descriptionTarget.classList.remove("hidden")
    this.responsibleEmailTarget.classList.remove("hidden")
    this.responsibleNameTarget.classList.remove("hidden")
  }
}
