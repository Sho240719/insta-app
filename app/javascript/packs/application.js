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

document.addEventListener('turbolinks:load', () => {
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


  // JSでいいねの表示を切り替える
  const dataset = $('.post-show').data()
  const postId = dataset.postId
  axios.get(`/posts/${postId}/like`)
    .then((response) => {
      const hasLiked = response.data.hasLiked
      if (hasLiked) {
        $('.active-heart').removeClass('hidden')
      } else {
        $('.inactive-heart').removeClass('hidden')
      }
    })
})
