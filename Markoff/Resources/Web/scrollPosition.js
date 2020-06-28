var scrollEnded = (callback) => {
  if (!callback || typeof callback !== 'function') return;

  var isScrolling;

  window.addEventListener('scroll', function (event) {
    window.clearTimeout(isScrolling);
    isScrolling = setTimeout(function() {
      callback();
    }, 250);
  }, false);
};

scrollEnded(() => {
  window.webkit.messageHandlers.scrollPositionUpdated.postMessage(window.pageYOffset)
});
