document.addEventListener('turbolinks:load', function(){
  if(document.URL.match("/users/edit")){
    document.getElementById('file-insert').addEventListener('click', function(){
      document.getElementById('user_avatar').click();
    });
    document.getElementById('edit-avatar').addEventListener('click', function(){
      document.getElementById('user_avatar').click();
    });

    // プロフィール画像のプレビュー挿入
    document.getElementById('user_avatar').addEventListener('change', function(){
      let file = this.files[0];
      let fileReader = new FileReader();
      fileReader.readAsDataURL(file);
      fileReader.onloadend = function(){
        let src = fileReader.result;
        let html = `<img src="${src}" alt="プロフィール画像プレビュー" class="icon" id="edit-avatar">`
        document.getElementById('avatar-preview').innerHTML = html;
        document.getElementById('avatar-preview').insertAdjacentHTML('afterend', "<p id='preview-alert'>まだ変更されていません。更新するボタンを押してください</p>")
      }
    })
  }
})
