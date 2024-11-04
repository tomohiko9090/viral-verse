import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "star"]
  static values = {
    score: { type: Number, default: 0 }
  }

  connect() {
    this.scoreValue = parseInt(this.inputTarget.value) || 0
    this.updateStars()
  }

  setValue(event) {
    const score = parseInt(event.currentTarget.dataset.value)
    this.scoreValue = score
    this.inputTarget.value = score
    this.updateStars()
    console.log(`Score set to: ${score}`) // デバッグ用
  }

  updateStars() {
    this.starTargets.forEach((star, index) => {
      if (index < this.scoreValue) {
        star.classList.add('filled')
        star.classList.remove('empty')
      } else {
        star.classList.remove('filled')
        star.classList.add('empty')
      }
    })
  }

  preview(event) {
    const score = parseInt(event.currentTarget.dataset.value)
    this.starTargets.forEach((star, index) => {
      if (index < score) {
        star.classList.add('preview')
      } else {
        star.classList.remove('preview')
      }
    })
  }

  clearPreview() {
    this.starTargets.forEach(star => {
      star.classList.remove('preview')
    })
    this.updateStars()
  }
}