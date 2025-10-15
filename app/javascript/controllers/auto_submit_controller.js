import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auto-submit"
export default class extends Controller {
  submit(event) {
    // Empêche le submit si l'élément est vide
    if (event.target.value !== "") {
      this.element.requestSubmit()  // 🔥 submit automatique
    }
  }
}