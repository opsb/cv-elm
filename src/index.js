import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

Main.embed(document.getElementById('root'));

registerServiceWorker();

function addGoogleFonts(fonts, weights) {
    const encoded = fonts.map(font => `${font}:${weights.join(",")}`).join("|");
    const fontsLink = `<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=${encoded}" />`;
    const fontsContainer = document.createElement("div");
    fontsContainer.innerHTML = fontsLink;
    document.head.appendChild(fontsContainer);
}

const fonts = ["Tangerine", "Roboto", "Barlow Condensed", "Open Sans", "Lato", "Source Sans Pro", "Raleway", "Noto Sans"];
const weights = [200, 300, 400, 500, 600];
addGoogleFonts(fonts, weights);
