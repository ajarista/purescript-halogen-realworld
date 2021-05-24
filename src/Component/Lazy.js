// THE IMPORT NEEDS TO BE IN A SEPARATE FILE BECAUSE PS DOESN'T HANDLE ES IMPORT STATEMENTS
// exports.importHome_ = require('../../src/Component/importHome.js').importHome;

// DEBUG CODE: TEST DIRECT IMPORT THROUGH FFI IN PURESCRIPT
// EVEN THIS DOESN'T SEEM TO BE WORKING
var home = require('../../output/Conduit.Page.Home');

console.log("HOME LOADED", home);

exports.importHome_ = function(onError, onSuccess) {
  setTimeout(function() {
    console.log("TIMEOUT CALLED", home);
    onSuccess(home);
  }, 3000);
  return function (cancelError, onCancelerError, onCancelerSuccess) {
    console.log("TIMEOUT CANCELLED", home);
    onCancelError(cancelError);
  };
};

exports.clog = function(x) {
  return function() {
    console.log(x);
  };
};

exports.debug = function() {
  debugger;
};
