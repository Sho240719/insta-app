import $ from 'jquery';
import axios from 'axios';
import { csrfToken } from 'rails-ujs';

axios.defaults.headers.common['X-CSRF-Token'] = csrfToken();


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

document.addEventListener('turbolinks:load', () => {
  // ユーザーがログインしていない場合、処理を中断
  if (window.isLoggedIn) {
    // hasLiked(いいねされているかどうか)を取得し、handleHeartDisplay(いいね表示の切り替え関数)を呼び出す
    $('.post-show').each(function() {
      const postId = $(this).data('post-id');
      axios.get(`/api/posts/${postId}/like`)
        .then((response) => {
          const hasLiked = response.data.hasLiked;
          handleHeartDisplay(postId, hasLiked);
        })
        .catch((e) => {
          window.alert('いいね状態を取得できませんでした');
          console.log(e);
        });
    });
  }
});

document.addEventListener('DOMContentLoaded', () => {
  // いいねをする
  $(document).on('click', '.inactive-heart', function () {
    const postId = $(this).data('post-id');
    axios.post(`/api/posts/${postId}/like`)
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
    axios.delete(`/api/posts/${postId}/like`)
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
