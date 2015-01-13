(function(){
  
  var 
    MAX_TITLE_LENGTH = 15,
    TED='<span class="red">TED</span>',
    CURSOR = '<span class="cursor"></span>',
    images = ["destr.jpg","homs.jpg","homs2.jpg","hote.jpg","imaginestreet.jpg"],
    image = null,
    inputEl = document.getElementsByName("title")[0],
    viewEl = document.getElementsByClassName("title")[0],
    bgEl = document.getElementsByClassName("bg")[0],
    downloadEl = document.getElementsByClassName("download")[0],
    title = null;
  
  inputEl.addEventListener("keyup", function(e) {
    // all other letters become lowercase, TED capitalised
    title = (e.target.value || "").toLowerCase();

    // add any word less than 15 characters(?) that contains the letters 'ted' in a sequence
    if (title.length < MAX_TITLE_LENGTH && title.match(/ted$/) !== null) {
      image = images[Math.floor(Math.random()*images.length)];

      downloadEl.setAttribute("style", "display:block");
      downloadEl.setAttribute("href", "/image?text=" + 
        encodeURIComponent(title.replace(/ted$/i,"TED")) + 
        "&image=" + encodeURIComponent(image)
      );
      
      image = "url(/images/"+image+")";      
      title = title.replace(/ted$/i,TED);      
    }else{
      image = "none";
      downloadEl.removeAttribute("style");      
    }
    
    bgEl.setAttribute("style","background-image:" + image);    
    
    if (title === ""){
      title = "How do you feel?"
    }
    
    viewEl.innerHTML = title + CURSOR;
  });   
  

  document.getElementsByTagName("form")[0].addEventListener("submit", function(e) {  
    e.preventDefault();
    
  });
  
  inputEl.focus()
  
}).call(this);