import $ from 'jquery';
import axios from 'axios';
import { csrfToken } from 'rails-ujs';

axios.defaults.headers.common['X-CSRF-Token'] = csrfToken();

document.addEventListener('turbolinks:load', () => {
  // コメント機能に必要なpostIdを取得
  const postId = $('.comment-show').data('post-id');

  // 現在のページURLを取得
  const path = window.location.pathname;
  // コメント機能が必要なページか確認
  if (path.match(/^\/posts\/\d+\/comments$/)) { // posts/:id/comments の形式の場合のみ実行
    // コメント表示の重複防止のため、一度コメント一覧を空に
    $('.comments-list').empty();
    // コメント一覧を取得して表示
    axios.get(`/posts/${postId}/comments.json`)
      .then((response) => {
        const comments = response.data;
        comments.forEach((comment) => {
          $('.comments-list').append(
            // コメントの投稿者名、内容を表示
            `<div class="comments-container">
              <img src="${comment.user.profile.avatar_url}" class="comment-account-icon">
              <div class="comment-author"><p>${comment.user.account_name}</p></div>
              <div class="comment-body"><p>${comment.content}</p></div>
            </div>`
          );
        });
      });
  }

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
            // コメントの投稿者名、内容を追加
            `<div class="comments-container">
              <div class="comment-author"><p>${comment.user.account_name}</p></div>
              <div class="comment-body"><p>${comment.content}</p></div>
            </div>`
          )
          $('#comment_content').val('');
          $('.comment-form-textarea').addClass('hidden');
          $('.show-comment-form').removeClass('hidden');
        });
    };
  });

  // コメントを追加クリックでフォームを表示
  $('.show-comment-form').on('click', () => {
    $('.show-comment-form').addClass('hidden');
    $('.comment-form-textarea').removeClass('hidden');
  });
});