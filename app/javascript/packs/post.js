import $ from 'jquery';
import axios from 'axios';
import { csrfToken } from 'rails-ujs';

axios.defaults.headers.common['X-CSRF-Token'] = csrfToken();

document.addEventListener('DOMContentLoaded', () => {

  const postId = $('.comment-show').data('post-id')

  // コメント一覧を表示
  axios.get(`/posts/${postId}/comments.json`)
    .then((response) => {
      const comments = response.data
      comments.forEach((comment) => {
        $('.comments-list').append(
          // コメントのみ表示
          `<div class="comment-body"><p>${comment.content}</p></div>`
        )
      });
    });

  // コメントを投稿
  $('.add-comment-button').on('click', () => {
    const content = $('#comment_content').val();
    if (!content) {
      window.alert('コメントを入力してください');
    } else {
      axios.post(`/posts/${postId}/comments`, {
        comment: {content: content}
      })
        .then((response) => {
          const comment = response.data;
          $('.comments-list').append(
            // コメントのみ表示
            `<div class="comment-body"><p>${comment.content}</p></div>`
          )
          $('#comment_content').val('');
        });
    };
  });

  // コメントを追加クリックでフォームを表示
  $('.show-comment-form').on('click', () => {
    $('.show-comment-form').addClass('hidden');
    $('.comment-form-textarea').removeClass('hidden');
  })


  // いいねの表示を表示、切り替える関数
  function handleHeartDisplay(postId, hasLiked) {
    if (hasLiked) {
      $(`.active-heart[data-post-id=${postId}]`).removeClass('hidden');
      $(`.inactive-heart[data-post-id=${postId}]`).addClass('hidden');
    } else {
      $(`.inactive-heart[data-post-id=${postId}]`).removeClass('hidden');
      $(`.active-heart[data-post-id=${postId}]`).addClass('hidden');
    }
  }

  // hasLiked(いいねされているかどうか)を取得し、handleHeartDisplay(いいね表示の切り替え関数)を呼び出す
  $('.post-show').each(function() {
    const postId = $(this).data('post-id');
    axios.get(`/posts/${postId}/like`)
      .then((response) => {
        const hasLiked = response.data.hasLiked;
        handleHeartDisplay(postId, hasLiked);
      })
      .catch((e) => {
        window.alert('Error');
        console.log(e);
      });
  })

  // いいねをする
  $(document).on('click', '.inactive-heart', function () {
    const postId = $(this).data('post-id');
    axios.post(`/posts/${postId}/like`)
      .then((response) => {
        if (response.data.status === 'ok') {
          handleHeartDisplay(postId, true);
        }
      })
      .catch((e) => {
        window.alert('Error');
        console.log(e);
      });
  });

  // いいねをはずす
  $(document).on('click', '.active-heart', function() {
    const postId = $(this).data('post-id');
    axios.delete(`/posts/${postId}/like`)
      .then((response) => {
        if (response.data.status === 'ok') {
          handleHeartDisplay(postId, false)
        }
      })
      .catch((e) => {
        window.alert('Error');
        console.log(e);
      });
  });
});
