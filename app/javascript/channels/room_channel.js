import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  // createの中身でparamsの中に入るkeyが決まる
  consumer.subscriptions.create({ channel: "RoomChannel", room: $('#messages').data('room_id')}, {
    connected() {
      document
        .querySelector('[data-behavior="room_speaker"]')
        .addEventListener('click', () => {
          const form = $('input[data-behavior="form_data"]');
          this.speak(form.val());
          form.val('');
        })
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data);
      const element = document.querySelector('#messages');
      element.insertAdjacentHTML('beforeend', data['message']);
    },

    speak: function(message) {
      // this.perform(...)でroom_channel.rbのspeakメソッドを呼び出す
      return this.perform('speak', {message: message});
    }
  });

  function buildMessageHTML(messages){
    for(let i=0; i<30; i++){
      if(gon.current_user_id === messages[i].user_id){
        let html = `<div class="message">
                      <img alt="ユーザのプロフィール画像" class="avatar" src="/assets/${messages[i].user.avatar}" width="40" height="40">
                      <div class="speech-bubble-own">
                        ${messages[i].content}
                      </div>
                    </div>`
        document.getElementById('messages').insertAdjacentHTML('afterbegin', html)
      }else{
        let html = `<div class="message">
                      <img alt="ユーザのプロフィール画像" class="avatar" src="/assets/${messages[i].user.avatar}" width="40" height="40">
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
  $(".message-wrapper").scroll(function(){
    if ($('.message-wrapper').scrollTop() === 0){
      let url = $(".message-wrapper").find('.pagination .next_page a').attr("href");
      $.ajax({
        url: url,
        type: "GET",
        dataType: "json"
      })
      .done(function(messages){
        buildMessageHTML(messages);
      });
    };
  })
});
