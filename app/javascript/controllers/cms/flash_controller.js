import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    this.fadeOutAfterDelay();
  }

  fadeOutAfterDelay() {
    setTimeout(() => {
      this.element.style.transition = 'opacity 1s';
      this.element.style.opacity = '0';
      setTimeout(() => { this.element.style.display = 'none' }, 1000); // stop taking up space after it's faded out
      this
    }, 3000); // 3 seconds delay
  }
}
