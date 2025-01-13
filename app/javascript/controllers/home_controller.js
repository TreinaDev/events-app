import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["result"]
  connect() {
    console.log("Conectado via Stimulus")
  }

  helloWorld(){
    this.resultTarget.textContent = "Olá mundo via StimulusJS"
  }
}
