import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dayItems"]

  connect() {}

  toggle(event) {
    const dayId = event.currentTarget.dataset.day
    const itemsContainer = this.dayItemsTargets.find(div => div.dataset.day === dayId)

    if (itemsContainer) {
      itemsContainer.classList.toggle("hidden")
    }
  }
}
