import $ from 'jquery';
import axios from 'axios';
import { csrfToken } from 'rails-ujs';

axios.defaults.headers.common['X-CSRF-Token'] = csrfToken();

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
});
