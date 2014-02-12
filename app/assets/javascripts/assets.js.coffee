# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('.fancybox').fancybox();

  $(document).on 'click', '.fancy-no-auth', (e)->
    e.preventDefault()
    helpers.showNoAuthMessage($(this))

  $(document).on 'click', '.close', (event)->
    $(this).parent().hide(300);
    event.preventDefault()

  $(".scrollbar, .dropdown-toggle + .dropdown-menu").mCustomScrollbar({
    advanced:
      updateOnContentResize: true

    scrollInertia: 150
  });

  $(document).tooltip({
    show: {
      delay: 300
    },
    position:
      my: "center top+20",
      at: "center bottom"
      using: (position, feedback) ->
        $(this).css(position)
               .addClass("arrow")
               .addClass(feedback.vertical)
               .addClass(feedback.horizontal)
  });
  if helpers.isFireFox()
    $('input[type="checkbox"] + label').each(()->
      if $(this).prev().is(':checked')
        $(this).addClass('checked')

    ).on 'click', ()->
      $(this).toggleClass('checked')
      if $(this).hasClass('checked')
        $(this).prev().attr('checked', 'checked')
      else
        $(this).prev().removeAttr('checked')

  # validate body
  $('form').submit (e)->
    text = $(this).find('.wysihtml5 textarea')
    if text.hasClass('required')
      if text.val().length == 0
        $(this).find('.redactor-sub .hint').hide().next('.wysihtml5-message').removeClass('hide')
        return false
      else
        $(this).find('.redactor-sub .hint').show().next('.wysihtml5-message').addClass('hide')

  # no-title
  $('.no-title').mouseenter ()->
    $(this).attr('title', '')

  # external
  helpers.checkExternalLinks()