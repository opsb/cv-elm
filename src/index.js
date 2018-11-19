import "./main.css";
import { Elm } from "./Main.elm";
import Pdf from "./pdf.js";

Elm.Main.init({
    node: document.getElementById("root"),
    flags: {
        width: window.innerWidth,
        height: window.innerHeight
    }
});
