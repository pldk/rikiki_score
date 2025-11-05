import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="game-players"
export default class extends Controller {
  static targets = ["counter", "startButton"]
  static values = { total: Number }

  connect() {
    this.boundHandlePlayersUpdated = this.handlePlayersUpdated.bind(this)
    document.addEventListener("players:updated", this.boundHandlePlayersUpdated)
    this.refreshButtonState()
  }

  disconnect() {
    document.removeEventListener("players:updated", this.handlePlayersUpdated)
  }

  handlePlayersUpdated = (event) => {
    const newCount = event.detail.count
    this.totalValue = newCount
    this.updateCounter(newCount)
    this.refreshButtonState()
  }

  updateCounter(count = this.totalValue) {
    if (this.hasCounterTarget) {
      this.counterTarget.textContent = `${count} joueurs prêts 🎮`
    }
  }

  refreshButtonState() {
    const totalPlayers = parseInt(this.totalValue || 0)
    const enabled = totalPlayers >= 3

    this.startButtonTarget.disabled = !enabled
    this.startButtonTarget.classList.toggle("bg-gray-400", !enabled)
    this.startButtonTarget.classList.toggle("cursor-not-allowed", !enabled)
    this.startButtonTarget.classList.toggle("bg-indigo-600", enabled)
    this.startButtonTarget.classList.toggle("hover:bg-indigo-700", enabled)
  }

  updatePlayersCount(event) {
    console.log("🔄 players:updated reçu !", event.detail)
    const newCount = event.detail?.count || this.totalValue
    this.totalValue = newCount
    this.updateCounter(newCount)
    this.refreshButtonState()
  }
}
