import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["openButton"]

  connect() {
    console.log("Modal controller connected")
  }

  open(event) {
    event.preventDefault()
    console.log("Open method called")
    this.element.style.display = "block"
    document.body.style.overflow = "hidden"
    console.log("Modal opened")
  }

  close(event) {
    if (event) event.preventDefault()
    this.element.style.display = "none"
    document.body.style.overflow = "auto"
    console.log("Modal closed")
  }

  disconnect() {
    this.close()
  }
}