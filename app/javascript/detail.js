$(function(){
  function buildHTML(comment){
    const html = `<div class="post">
                    <div class="post-info">
                      <img alt="コメント投稿者のプロフィール画像" class="icon" src="/assets/avatar.jpg" width="35" height="35">
                      <div class="post-user">
                        さかい
                      </div>
                      <div class="post-date">
                        2021年3月15日
                      </div>
                    </div>
                    <div class="content">
                      ${comment.content}
                    </div>
                  </div>`
    return html;
  }


  $('#new_comment').on('submit', function(e){
    e.preventDefault();
    const formData = new FormData(this);
    const url = $(this).attr('action');
    $.ajax({
      url: url,
      type: 'POST',
      dataType: 'json',
      data: formData,
      processData: false,
      contentType: false
    })
    .done(function(comment){
      const commentHTML = buildHTML(comment);
      $('.posts').append(commentHTML);
      document.getElementById("comment_content").value = "";
    });
  });
})
