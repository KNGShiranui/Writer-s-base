document.addEventListener('turbolinks:load', () => {
  const header = document.getElementById('header');
  let lastScrollTop = 0;

  window.addEventListener('scroll', () => {
    const currentScrollTop = window.pageYOffset || document.documentElement.scrollTop;

    if (currentScrollTop > lastScrollTop) {
      // スクロールダウン時
      header.style.display = 'none';
    } else {
      // スクロールアップ時
      header.style.display = 'flex'; // ここを 'block' から 'flex' に変更
    }

    lastScrollTop = currentScrollTop;
  });
});
