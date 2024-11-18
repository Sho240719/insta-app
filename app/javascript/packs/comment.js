import $ from 'jquery';
import axios from 'axios';
import { csrfToken } from 'rails-ujs';

axios.defaults.headers.common['X-CSRF-Token'] = csrfToken();

document.addEventListener('turbolinks:load', () => {
  const postId = $('.comment-show').data('post-id');

  $('.comments-list').empty();

  // コメント一覧を取得して表示
  axios.get(`/posts/${postId}/comments.json`)
    .then((response) => {
      const comments = response.data;
      comments.forEach((comment) => {
        $('.comments-list').append(
        // コメントのみ表示
        `<div class="comment-body"><p>${comment.content}</p></div>`
        );
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
  });
});