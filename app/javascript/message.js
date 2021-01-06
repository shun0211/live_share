document.addEventListener('turbolinks:load', function(){
  if(document.URL.match("/rooms")){
    function buildMessageHTML(messages){
      let messageNum = Object.keys(messages).length
      for(let i=0; i<messageNum; i++){
        if(gon.current_user_id === messages[i].user_id){
          let html = `<div class="message">
                        <div class="speech-bubble-own">
                          ${messages[i].content}
                        </div>
                      </div>`
          document.getElementById('messages').insertAdjacentHTML('afterbegin', html)
        }else{

          let html = `<div class="message">
                        <img alt="ユーザのプロフィール画像" class="avatar" src="${messages[i].user.avatar}" width="40" height="40">
                        <div class="speech-bubble-partner">
                          ${messages[i].content}
                        </div>
                      </div>`
          document.getElementById('messages').insertAdjacentHTML('afterbegin', html)
        }
      }
    }

    function scrollToBottom(){
      let messageScreenHeight = $(".message-wrapper")[0].scrollHeight;
      $(".message-wrapper").scrollTop(messageScreenHeight);
    };
    scrollToBottom();
    let nextPageNum = 2;
    $(".message-wrapper").scroll(function(){
      let messageScreenHeight = $(".message-wrapper")[0].scrollHeight;
      if ($('.message-wrapper').scrollTop() === 0){
        let url = "/rooms?page=" + nextPageNum;
        $.ajax({
          url: url,
          type: "GET",
          dataType: "json"
        })
        .done(function(messages){
          buildMessageHTML(messages);
          let messagePosition = $(".message-wrapper")[0].scrollHeight - messageScreenHeight;
          $('.message-wrapper').scrollTop(messagePosition);
          nextPageNum = nextPageNum + 1;
        })
      }
    })
  }
})
