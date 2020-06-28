var scrollEnded = function (callback) {
  if (!callback || typeof callback !== 'function') return;

  var isScrolling;

  window.addEventListener('scroll', function (event) {
    window.clearTimeout(isScrolling);
    isScrolling = setTimeout(function() {
      callback();
    }, 60);
  }, false);
};

scrollEnded(function () {
  webkit.messageHandlers.scrollPositionUpdated.postMessage(window.pageYOffset)
  console.log( 'Scrolling has stopped.' );
});
