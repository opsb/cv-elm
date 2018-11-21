import "./main.css";
import { Elm } from "./Main.elm";
import Pdf from "./pdf.js";

const app = Elm.Main.init({
    node: document.getElementById("root"),
    flags: {
        width: window.innerWidth,
        height: window.innerHeight
    }
});

const buildPdf = new Promise((resolve) => {
    window.requestAnimationFrame(() => {
        resolve(Pdf.build("[data-class=page]"));
    });
});

buildPdf.then(() => app.ports.pdfGenerated.send(null));

app.ports.downloadPdf.subscribe(() => {
    buildPdf.then(pdf => pdf.save("cv.oliver_searle-barnes.pdf"));
});
