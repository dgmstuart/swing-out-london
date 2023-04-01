import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="organiser-link"
export default class extends Controller {
  static targets = [ "source" ]

  copy(event) {
    event.preventDefault();

    const buttonActive = function (element, changeText) {
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

    const target = event.target;

    target.disabled = true;
    buttonActive(target, "Copied");

    navigator.clipboard.writeText(this.sourceTarget.value);

    target.disabled = false;
  }
}
