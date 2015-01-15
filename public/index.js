(function(){
  
  var 
    SIZE = 120,
    PLACEHOLDER = "Enter a word containing 'ted'",
    MAX_TITLE_LENGTH = 15,
    TED='<span class="red">TED</span>',
    CURSOR = '<span class="cursor"></span>',
    pat = new RegExp(".*(ted$)", "i")
    images = ["destr.jpg","homs.jpg","homs2.jpg","hote.jpg","imaginestreet.jpg"],
    image = null,
    inputEl = document.getElementsByName("title")[0],
    viewEl = document.getElementsByClassName("title")[0],
    bgEl = document.getElementsByClassName("bg")[0],
    downloadEl = document.getElementsByClassName("download")[0],
    downloadLinkEl = document.getElementsByClassName("download-link")[0],  
    title = null;
  
  inputEl.addEventListener("keyup", function(e) {
    if(e.keyCode===37){
      e.preventDefault()
      inputEl.value = inputEl.value.substr(0,inputEl.value.length-1)
    }
    // all other letters become lowercase, TED capitalised
    title = (e.target.value || "").toLowerCase();

    // add any word less than 15 characters(?) that contains the letters 'ted' in a sequence
    if (title.length <= MAX_TITLE_LENGTH && title.match(pat) !== null) {
      image = images[Math.floor(Math.random()*images.length)];

      downloadEl.setAttribute("style", "display:block");
      titleWithoutTed = title.replace(/ted$/i,"");
      downloadLinkEl.setAttribute("href", "/image?text=" + 
        encodeURIComponent(titleWithoutTed) + 
        "&image=" + encodeURIComponent(image) + 
        "&size=" + SIZE
      );
      downloadLinkEl.setAttribute("download",titleWithoutTed + "TED")
      
      image = "url(/images/"+image+")";      
      title = titleWithoutTed + title.replace(pat,TED);      
    }else{
      image = "none";
      downloadEl.removeAttribute("style");      
    }
    
    bgEl.setAttribute("style","background-image:" + image);    
    
    if (title === ""){
      title = PLACEHOLDER
    }
    
    viewEl.innerHTML = title + CURSOR;
  });   
  

  document.getElementsByTagName("form")[0].addEventListener("submit", function(e) {  
    e.preventDefault();
    
  });
  
  inputEl.focus()
  
}).call(this);