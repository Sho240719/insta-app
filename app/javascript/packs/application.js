// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import $ from 'jquery'
import axios from 'axios'
import { csrfToken } from 'rails-ujs'

axios.defaults.headers.common['X-CSRF-Token'] = csrfToken()

document.addEventListener('turbolinks:load', () => {
// プロフィール画像を変更するコード
  $('.account-icon').on('click', () => {
    $('.file-upload').toggleClass('hidden')
  })

  $('.file-upload').on('change', (event) => {
    const file = event.target.files[0];
    if (file) {
      const formData = new FormData();
      formData.append('profile[avatar]', file);

      // CSRFトークンをmetaタグから取得
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      axios.patch('/profile', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
          'X-CSRF-Token': csrfToken  // CSRFトークンを追加
        }
      })
      .then(response => {
        alert(response.data.message);
        // アップロード成功時に画像を更新
        $('.account-icon').attr('src', URL.createObjectURL(file));
      })
      .catch(error => {
        alert('Failed to update profile image');
      });
    }
  });


// いいね機能に関するコード
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
