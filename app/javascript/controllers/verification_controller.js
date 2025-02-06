import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "image"]

  open(event) {
    const imageUrl = event.currentTarget.getAttribute("src");
    this.imageTarget.setAttribute("src", imageUrl);
    this.modalTarget.classList.remove("hidden");
    this.modalTarget.classList.add("flex");
  }

  close(event) {
    // Fecha apenas se clicar fora da imagem
    if (event.target === this.modalTarget) {
      this.modalTarget.classList.add("hidden");
      this.modalTarget.classList.remove("flex");
    }
  }
}
