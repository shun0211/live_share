$(function(){
  // サムネイルのプレビュー挿入
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

  // 公演名のセレクトボックス
  document.getElementById('event_name-select').addEventListener('change', function(){
    document.getElementById('event_name-form').value=this.value;
  })

  // バリデーションチェック
  $('#new_ticket').on('submit', function(e){
    const alerts = document.getElementsByClassName('alert');
    if(alerts.length){
      alerts.parentNode.removeChild(alerts);
    }
    e.preventDefault();
    const formData = new FormData(this);
    const url = $(this).attr("action");
    $.ajax({
        url: url,
        type: 'POST',
        dataType: 'json',
        data: formData,
        processData: false,
        contentType: false
    })
    .done(function(error_messages){
      if(error_messages["thumbnail"]){
        document.getElementById('thumbnail-wrapper').insertAdjacentHTML("afterend", '<div class="alert alert-danger" id="thumbnail-error">画像を挿入してください</div>');
      }
      if(error_messages["event_name"]){
        document.getElementById('event_name-select').insertAdjacentHTML("afterend", '<div class="alert alert-danger id="event_name-error"">公演名を選択するか30文字以内で入力してください</div>');
      }
      if(error_messages["event_date"]){
        document.getElementsByName('ticket[event_date]')[0].insertAdjacentHTML("afterend", '<div class="alert alert-danger" id="event_date-error">公演日を入力してください</div>');
      }
      if(error_messages["venue"]){
        document.getElementsByName('ticket[venue]')[0].insertAdjacentHTML('afterend', '<div class="alert alert-danger">開催地を30文字以下で入力してください</div>');
      }
      if(error_messages["number_of_sheets"]){
        document.getElementsByName('ticket[number_of_sheets]')[0].insertAdjacentHTML('afterend', '<div class="alert alert-danger">枚数を選択してください</div>');
      }
      if(error_messages["shipping"]){
        document.getElementsByName('ticket[shipping]')[0].insertAdjacentHTML('afterend', '<div class="alert alert-danger">配送料の負担を選択してください</div>');
      }
      if(error_messages["delivery_method"]){
        document.getElementsByName('ticket[delivery_method]')[0].insertAdjacentHTML('afterend', '<div class="alert alert-danger">受け渡し方法を30文字以内で入力してください</div>');
      }
      if(error_messages["price"]){
        document.getElementsByName('ticket[price]')[0].insertAdjacentHTML('afterend', '<div class="alert alert-danger">販売価格を300 ~ 99,999円で入力してください</div>');
      }
    });
  });

  // 入力した際、エラーメッセージを消す処理
  document.getElementsByName('ticket[event_date]')[0].addEventListener('keyup', function(){
    document.getElementById('event_date-error').remove();
  })

});
