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
});
