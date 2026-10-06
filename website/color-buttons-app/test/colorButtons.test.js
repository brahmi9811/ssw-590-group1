import { test } from "node:test";
import assert from "node:assert/strict";
import { BackgroundChanger, ColorButton, ColorButtonApp } from "../public/js/colorButtons.js";

// Minimal stand-ins for the browser DOM objects the classes use.
class FakeElement {
  constructor() {
    this.style = {};
    this.listeners = {};
  }
  addEventListener(type, fn) {
    this.listeners[type] = fn;
  }
  click() {
    this.listeners.click?.();
  }
}

function fakeDocument() {
  const elements = { blueBtn: new FakeElement(), redBtn: new FakeElement() };
  return { body: new FakeElement(), getElementById: (id) => elements[id] };
}

test("BackgroundChanger sets and reports the color", () => {
  const changer = new BackgroundChanger(new FakeElement());
  changer.setColor("green");
  assert.equal(changer.getColor(), "green");
});

test("ColorButton applies its color when clicked", () => {
  const element = new FakeElement();
  const changer = new BackgroundChanger(new FakeElement());
  new ColorButton(element, "blue", changer).bind();
  element.click();
  assert.equal(changer.getColor(), "blue");
});

test("ColorButtonApp wires the Blue and Red buttons", () => {
  const doc = fakeDocument();
  const app = new ColorButtonApp(doc).init();
  assert.equal(app.buttons.length, 2);
  doc.getElementById("blueBtn").click();
  assert.equal(doc.body.style.backgroundColor, "blue");
  doc.getElementById("redBtn").click();
  assert.equal(doc.body.style.backgroundColor, "red");
});
