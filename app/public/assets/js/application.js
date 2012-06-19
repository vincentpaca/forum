//when clicking topics on sidebar
$(document).on('click', '.sidebar-topic', function(e){
  e.preventDefault();
  id = $(this).attr('id')
  $.ajax({
    url: base_url + "/topics/" + id + "/json",
    type: "GET",
    dataType: "json",
    success: function(html){
      history.pushState(null, null, '/topics/' + id);
      $('.main-content > h3').html("On going conversations on " + html['topic']['title']);
      $('.main-content > .on-going-chat').html(html['posts']);
    },
    error: function(html){
      alert("We can't contact the server at this time.");
    }
  });
});


//for scrolling
$(document).ready(function() {
  $(".scrollable").niceScroll({cursorborder:"",cursorcolor:"#666"}); // First scrollable DIV
});

