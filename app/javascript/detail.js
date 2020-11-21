$(function(){
  function buildHTML(comment){
    const html = `<div class="post" data-comment-id="${comment.id}">
                    <div class="post-info">
                      <img alt="コメント投稿者のプロフィール画像" class="icon" src="/assets/${comment.userAvatar}" width="35" height="35">
                      <div class="post-user">
                        ${comment.userNickname}
                      </div>
                      <div class="post-date">
                        ${comment.created_at}
                      </div>
                    </div>
                    <div class="content">
                      <p class="comment">
                        ${comment.content}
                      </p>
                      <div id="comment-delete">
                        <i class="fas fa-trash-alt"></i>
                      </div>
                    </div>
                  </div>`
    return html;
  }

  $('.comment-submit').on('click', function(e){
    e.preventDefault();
    const formInfo = document.forms.new_comment;
    const formData = new FormData(formInfo);
    const url = $(formInfo).attr('action');
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
      document.getElementById("empty-message").remove();
    });
  });
  // コメント削除
  $(document).on('click', '#comment-delete', function(){
    let comment = this.parentNode.parentNode.dataset.commentId
    console.log("test");
    let url = gon.ticket.id + "/comments/" + comment
    $.ajax({
      url: url,
      type: "DELETE",
      data: comment,
      dataType: "json"
    })
    .done(function(comment_id){
      $('[data-comment-id = '+ comment_id + ']').remove();
    })
  })
})
