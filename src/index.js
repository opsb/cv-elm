import "./main.css";
import { Elm } from "./Main.elm";

Elm.Main.init({
  flags: {
    width: window.innerWidth,
    height: window.innerHeight,
  },
});
