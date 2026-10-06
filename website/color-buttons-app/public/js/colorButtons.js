// Class-based design for the two-button website.
// BackgroundChanger owns the page background, ColorButton wires one button to
// one color, and ColorButtonApp creates and initializes both buttons.

export class BackgroundChanger {
  constructor(target) {
    this.target = target;
  }

  setColor(color) {
    this.target.style.backgroundColor = color;
  }

  getColor() {
    return this.target.style.backgroundColor;
  }
}

export class ColorButton {
  constructor(element, color, changer) {
    this.element = element;
    this.color = color;
    this.changer = changer;
  }

  bind() {
    this.element.addEventListener("click", () => this.handleClick());
  }

  handleClick() {
    this.changer.setColor(this.color);
  }
}

export class ColorButtonApp {
  static BUTTONS = [
    { id: "blueBtn", color: "blue" },
    { id: "redBtn", color: "red" },
  ];

  constructor(doc) {
    this.doc = doc;
    this.changer = new BackgroundChanger(doc.body);
    this.buttons = [];
  }

  init() {
    for (const { id, color } of ColorButtonApp.BUTTONS) {
      const button = new ColorButton(this.doc.getElementById(id), color, this.changer);
      button.bind();
      this.buttons.push(button);
    }
    return this;
  }
}
