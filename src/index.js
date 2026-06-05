import "./main.css";
import { Elm } from "./Main.elm";
import "./chat-widget.js";

Elm.Main.init({
  flags: {
    width: window.innerWidth,
    height: window.innerHeight,
  },
});
