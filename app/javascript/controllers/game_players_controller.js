import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="game-players"
export default class extends Controller {
  static targets = ['counter']
  
  connect() {
    this.updateCounter()
  }

  updateCounter() {
    const selectedPlayers = this.element.querySelectorAll('li').length
    const totalPlayers = this.data.get('total')
    if (this.counteTarget) {
      this.counterTarget.textCount = `${selectedPlayers}/${totalPlayers} joueurs prêts 🎮`
    }
  }
}