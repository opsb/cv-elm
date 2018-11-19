function a4PdfFromPngs(pagePngs) {
    const pdf = new jsPDF({
        orientation: "landscape",
        unit: "mm",
        format: "a4"
    });

    pagePngs.forEach((png, index) => {
        if (index !== 0) pdf.addPage();
        pdf.setPage(index + 1);
        pdf.addImage(png, "png", 0, 0, 298, 211); // slightly larger than a4 page to avoid white gaps around blocks
    });

    return pdf;
};

function canvasToPng(canvas) {
    return canvas.toDataURL("image/png", 1.0);
}

function elementToPng(element) {
    return html2canvas(element).then(canvasToPng);
}

function build(pagesSelector, filename) {
    const pages = Array.from(document.querySelectorAll("[data-class=page]"));

    return Promise.all(pages.map(elementToPng))
        .then(a4PdfFromPngs);
}

export default { build };
