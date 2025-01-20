import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["address"]
  connect() {
  }

  handleLocation(event){
    const select = event.currentTarget;
    const value = select.value;
    const address = this.addressTarget;

    if(value == "online"){
        address.classList.add("hidden");
    }
    else {
        address.classList.remove("hidden");
    }
    
  }
}
