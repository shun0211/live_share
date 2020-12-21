document.addEventListener("turbolinks:load", e => {
  if(document.URL.match("/cards/new")){
    // カード情報を暗号化するため、公開鍵を指定
    const payjp = Payjp("pk_test_018ce8fdc73b775ddd4f225c");
    let elements = payjp.elements();

    let numberElement = elements.create('cardNumber');
    let cvcElement = elements.create('cardCvc');
    let expiryElement = elements.create('cardExpiry');

    numberElement.mount('#number-form');
    cvcElement.mount('#cvc-form');
    expiryElement.mount('#expiry-form');

    let btn = document.getElementById("token_submit");
    btn.addEventListener("click", e => {
      e.preventDefault();

      // 入力されたカード情報からトークンを生成
      payjp.createToken(numberElement).then(function(response){
        if (response.error){
          alert(response.error.message);
        }else{
          $("#card_token").append(
            $('<input type="hidden" name="payjp-token">').val(response.id)
          )
          $("#number-form").removeAttr("name");
          $("#cvc-form").removeAttr("name");
          $("#expiry-form").removeAttr("name");
          document.cardForm.submit();
          alert("登録が完了しました");
        }
      })
    });
  }
});
