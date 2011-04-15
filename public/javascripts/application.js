$().ready(function() {
  setInterval(function() {
    $('#projects').load($("#status_path").val());
  }, 5000);
});
