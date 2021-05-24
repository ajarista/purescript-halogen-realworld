exports.importHome = function(onError, onSuccess) {

  /* // TEST CODE
  var home = require('../../output/Conduit.Page.Home');
  setTimeout(function() {onSuccess(home);}, 3000);
  return function (cancelError, onCancelerError, onCancelerSuccess) {
    debugger;
    onCancelError(cancelError);
  };
  */

  // debugger;
  var homePromise = import('../../output/Conduit.Page.Home');
  homePromise.then(function(home) {
    debugger;
    onSuccess(home);
  });
  // No way to cancel
  return function (cancelError, onCancelerError, onCancelerSuccess) {
    debugger;
    onCancelError(cancelError);
  };
};
