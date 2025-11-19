import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileMenu", "mobileSearch"]

  toggleMenu() {
    this.mobileMenuTarget.classList.toggle('hidden')
  }

  toggleSearch() {
    this.mobileSearchTarget.classList.toggle('hidden')
  }

  closeMenu() {
    this.mobileMenuTarget.classList.add('hidden')
  }

  closeSearch() {
    this.mobileSearchTarget.classList.add('hidden')
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.closeMenu()
      this.closeSearch()
    }
  }
}
