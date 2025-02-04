import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["profileMenu", "links"];

  connect() {}

  toggleProfileMenu() {
    const menu = this.profileMenuTarget;
    menu.classList.toggle('opacity-0');
    menu.classList.toggle('opacity-100');
    const links = this.linksTarget;
    links.classList.toggle('hidden');
    links.classList.toggle('flex');
  }
}
