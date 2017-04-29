
function upDate(previewPic){
 /*
    1) change the url for the background image of the div with the id = "image"
    to the source file of the preview image

    2) Change the text  of the div with the id = "image"
    to the alt text of the preview image
    var srcImg = previewPic.getAttribute("src");
    */
    bigPic = document.getElementById('image');
    bigPic.innerHTML=previewPic.alt;
    bigPic.style.backgroundImage = "url('" + previewPic.src + "')";
}

function unDo(){
     /*
    1) Update the url for the background image of the div with the id = "image"
    back to the orginal-image.  You can use the css code to see what that original URL was

    2) Change the text  of the div with the id = "image"
    back to the original text.  You can use the html code to see what that original text was
    */
    bigPic = document.getElementById('image');
    bigPic.style.backgroundImage = "url('')";
    bigPic.innerHTML="Hover over an image below to display here.";

}
