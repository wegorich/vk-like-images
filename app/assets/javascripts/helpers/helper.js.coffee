@helpers = @helpers || {}
@localStorage = @localStorage || {}

# HTML > elemtn[3] ...
jQuery.fn.getElementPath = ->
  throw "Requires one element."  unless @length is 1
  path = undefined
  node = this
  while node.length
    realNode = node[0]
    name = realNode.localName
    break  unless name
    name = name.toLowerCase()
    if realNode.id

      # As soon as an id is found, there's no need to specify more.
      return name + "#" + realNode.id + ((if path then ">" + path else ""))
    else name += "." + realNode.className.split(/\s+/).join(".")  if realNode.className
    parent = node.parent()
    siblings = parent.children(name)
    name += ":eq(" + siblings.index(node) + ")"  if siblings.length > 1
    path = name + ((if path then ">" + path else ""))
    node = parent
  path

helpers._plural = (n, forms)->
  forms[if n%10==1 && n%100!=11 then 0 else if n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) then 1 else 2]

helpers.isUserLogined = ()->
  window.gon && gon.user_id != undefined

helpers.isFireFox = ()->
   navigator.userAgent.indexOf("Firefox")!=-1

helpers.checkExternalLinks = ()->
  $('a').each ()->
    host = this.hostname
    if host != window.location.hostname
      $(this).attr('target', '_blank').addClass('external');

helpers.keyAt = (obj, index)->
  num = 0
  for key, value of obj
    if num == index
      return value
    num +=1

helpers.showMessage = (title, content)->
  $.fancybox(['<div class="auth"><div class="block">',
              '<h2>',title,'<a href="#" class="btn-close"><i class="icon-remove"></i></a></h2>',
              '<div>',content,'</div>',
              '</div></div>'].join(''),{
    wrapCSS: 'modal'
    closeBtn : false
  })

helpers.showConfirmBox = (data)->
  data ||= {}
  $.fancybox(['<div class="auth"><div class="block">',
              '<h2>',data.title,'</h2>',
              '<div>',data.content,'</div>',
              '<div class="input">',
              '<a href="#" class="btn btn-sub-gray-green r">', data.no || 'Нет','</a>',
              '<a href="#" class="btn btn-light-green">', data.yes || 'Да','</a>',
              '</div>',
              '</div></div>'].join(''),{
    wrapCSS: 'modal'
    afterShow: ()->
      if data.callback
        $('.auth .btn').on 'click', ()->
          data.callback($(this).hasClass('btn-light-green'))
          return false

    closeBtn : false
  })

helpers.showNoAuthMessage = (element)->
  localStorage.beforeAuth = JSON.stringify {
    path: element.getElementPath() if element
    userState: helpers.isUserLogined()
  }

  helpers.showMessage('Ошибка прав доступа <a href="/users/sign_in" class="fancybox-modal r" data-type="js">Вы точно авторизованы?</a>',
                      '<p> Возможно действие которые вы пытаетесь совершить, вам недоступно.</p>
                       <p>Если у вас нет аккаунта <a href="/users/sign_in" class="fancybox-modal" data-type="js">
                       <b>присоединяйтесь</b></a> к нам!</p>')

helpers.getRedactorBtns = (btns)->
  arr = ['bold', 'italic', 'deleted', '|', 'unorderedlist', 'orderedlist']
  if helpers.isUserLogined() && btns
    for i in btns
      arr.push (i)

  arr

helpers.getHashParam = (name, def)->
  if location.href.split(name+'=')[1]
    location.href.split(name+'=')[1].split('&')[0]
  else
    def
helpers.scrollAfterAuth = ()->
  if localStorage.beforeAuth != undefined
    auth = JSON.parse localStorage.beforeAuth
    setTimeout(
      ()->
        if auth.path && auth.userState != helpers.isUserLogined() && $(auth.path).length > 0
          $('html, body').animate({scrollTop: $(auth.path).offset().top  }, 'slow')
      500)
  localStorage.removeItem('beforeAuth')
