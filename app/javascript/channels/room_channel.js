import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  // createの中身でparamsの中に入るkeyが決まる
  const chatCannel = consumer.subscriptions.create({ channel: "RoomChannel", room: $('#messages').data('room_id')}, {
    connected() {
      document.
        querySelector('input[data-behavior="room_speaker"]')
        addEventListener('keypress', (event) => {
          this.speak(event.target.value);
          event.target.value = '';
          return event.preventDefault();
        })
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      const element = document.querySelector('#message')
      element.insertAdjacentHTML('beforeend', data['message'])
    },

    speak: function(message) {
      return this.perform('speak', {message: message});
    }
  });
});
