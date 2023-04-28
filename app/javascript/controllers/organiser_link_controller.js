import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="organiser-link"
export default class extends Controller {
  static targets = [ "source" ]

  copy(event) {
    event.preventDefault();

    const button = event.target;

    this._copyToClipboard(button)
  }

  delayedCopy() {
    window.addEventListener('turbo:frame-load', () => {
      const button = document.querySelector('[data-action="organiser-link#copy"]')

      this._copyToClipboard(button)
    });
  }

  revoke(event) {
    let confirmed = confirm("Are you sure you want to create a new link? This will invalidate the previous link")

    if (!confirmed) {
      event.preventDefault()
    }
  }

  _copyToClipboard(button) {
    button.disabled = true;
    this._buttonActive(button, "Copied");

    navigator.clipboard.writeText(this.sourceTarget.value);

    button.disabled = false;
  }

  _buttonActive(element, changeText) {
    const {
      innerText,
      style: { color, backgroundColor },
    } = element;

    setTimeout(() => {
      element.style.color = color;
      element.style.backgroundColor = backgroundColor;
      element.innerText = innerText;
    }, 1500);

    element.style.color = "#384f6e";
    element.style.backgroundColor = "white";
    element.innerText = changeText;
  };
}
