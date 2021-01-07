import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  function buildReceivedMessageHTML(data){
    // console.log(gon.current_user_id);
    console.log(data.message.user);
    if(data.message.user_id == gon.current_user_id){
      let html = `<div class="message">
                    <div class="speech-bubble-own">
                      ${data.message.content}
                    </div>
                  </div>`
      return html
    } else {
      let html = `<div class="message">
                    <img alt="ユーザのプロフィール画像" class="avatar" src="${gon.partner_avatar_url}" width="40" height="40">
                    <div class="speech-bubble-partner">
                      ${data.message.content}
                    </div>
                  </div>`
      return html
    }
  };
  // createの中身でparamsの中に入るkeyが決まる
  consumer.subscriptions.create({ channel: "RoomChannel", room: $('#messages').data('room_id')}, {
    connected() {
      if(document.URL.match("/rooms")){
        document.querySelector('[data-behavior="room_speaker"]').addEventListener('click', () => {
          const form = $('input[data-behavior="form_data"]');
          this.speak(form.val());
          form.val('');
        })
      }
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data);
      const receiveMessage = buildReceivedMessageHTML(data);
      const element = document.querySelector('#messages');
      element.insertAdjacentHTML('beforeend', receiveMessage);
    },

    speak: function(message) {
      // this.perform(...)でroom_channel.rbのspeakメソッドを呼び出す
      return this.perform('speak', {message: message});
    }
  });
});
