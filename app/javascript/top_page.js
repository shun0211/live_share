document.addEventListener('turbolinks:load', function(){
  setTimeout("$('.flash').addClass('slideUp')", 2000);
  let checkbox = document.getElementById('hamburger-menu');
  checkbox.addEventListener('change', function(){
    if(checkbox.checked){
      document.body.style.overflow = "hidden";
    }else{
      document.body.style.overflow = "visible";
    };
  });
})
