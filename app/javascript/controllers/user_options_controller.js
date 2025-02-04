import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["profileMenu"];

  connect() {}

  toggleProfileMenu() {
    const menu = this.profileMenuTarget;
    menu.classList.toggle('opacity-0');
    menu.classList.toggle('opacity-100');
  }
}
