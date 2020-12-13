$(document).ready(function () {
  if (window.location.pathname == "/details") {
    $('.unnecessary-detail').show();
  }
  else {
    $('.unnecessary-detail').hide();
  }
})