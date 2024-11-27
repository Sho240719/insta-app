import $ from 'jquery';
import axios from 'axios';
import { csrfToken } from 'rails-ujs';

axios.defaults.headers.common['X-CSRF-Token'] = csrfToken();

// フォローの表示切替
function handleFollowDisplay(accountId, hasFollowed) {
  if (hasFollowed) {
    $(`.active-follow[data-account-id=${accountId}]`).removeClass('hidden');
    $(`.inactive-follow[data-account-id=${accountId}]`).addClass('hidden');
  } else {
    $(`.inactive-follow[data-account-id=${accountId}]`).removeClass('hidden');
    $(`.active-follow[data-account-id=${accountId}]`).addClass('hidden');
  }
}

// 現在のページURLを取得
const path = window.location.pathname;

if (path.match(/^\/accounts\/\d+$/)) {
  document.addEventListener('turbolinks:load', () => {
    const accountId = $('.account-show').data('account-id');
    //フォロー状態を取得
    axios.get(`/accounts/${accountId}.json`)
      .then((response) => {
        const hasFollowed = response.data.hasFollowed;
        handleFollowDisplay(accountId, hasFollowed)
      })
      .catch((error) => {
        window.alert('フォロー状態の取得に失敗しました');
        console.log(error);
      });
  });
}
