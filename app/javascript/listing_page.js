window.onload = function(){
  document.getElementById('thumbnail-wrapper').addEventListener('click', function(){
    document.getElementById('thumbnail-uploadButton').click();
  });
  document.getElementById('thumbnail-uploadButton').addEventListener('change', function(){
    var file = this.files[0];
    var fileReader = new FileReader();
    fileReader.readAsDataURL(file);
    fileReader.onloadend = function(){
      var src = fileReader.result;
      var html = `<div class="thumbnail">
                    <img src="${src}" alt="チケットのサムネイル写真" width="100%" height="100%">
                  </div>`
      document.getElementById('thumbnail-wrapper').innerHTML = html;
    };
  })

  // 販売手数料と出品者へのお礼
  document.getElementsByName('ticket[price]')[0].addEventListener('keyup', function(){
    const sales_commition = Number(this.value) * 0.05;
    document.getElementById('sales-commition').innerHTML = "<span>¥</span>" + sales_commition;
    const sales_profit = Number(this.value) - sales_commition;
    document.getElementById('sales-profit').innerHTML = "<span>¥</span>" + sales_profit;
  });


};
