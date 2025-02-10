import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message"];
  connect() {
    setTimeout(() => {
      this.close();
    }, 7000);
  }

  close() {
    this.messageTarget.remove();
  }
}
