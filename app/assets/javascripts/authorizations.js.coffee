$ ->
  $(document).on('click', '.fancybox-modal', (e)->
    type = $(this).data('type');
    if type != undefined
      type = '.' + type
    else
      type = ''
    $.fancybox.showLoading()
    $.ajax
           url: $(this).attr('href') + type,
           success: (data)->
             $.fancybox.hideLoading()
             $.fancybox(data, {
              wrapCSS: 'modal'
              closeBtn : false
              afterShow:()->
                 $('.modal [placeholder]').placeholder()
              overlay :
                locked : true

             })

             true

           dataType: 'html'

    e.preventDefault()
  )

  $(document).on 'click','.modal .btn-close', (e)->
    $.fancybox.close()
    e.preventDefault()


  if window.gon && gon.just_signed_up
    $.fancybox.showLoading()
    $.ajax
      url: '/users/sign_up/success.js',
      success: (data)->
        $.fancybox.hideLoading()
        $.fancybox(data, {
          wrapCSS: 'modal'
          closeBtn : false
          afterShow:()->
            $('.modal [placeholder]').placeholder()
          overlay :
            locked : true

        })

        true

      dataType: 'html'
