$ ->
  form = $("form[data-role='assetable']")
  if form.length > 0 && form.find('.file-uploader').length > 0

    assetable =
      form: form
      form_id:  form.attr('id')
      form_action: form.attr('action')
      drop: form.find('#dropzone')
      btn:  form.find('.fileinput-btn')
      $contaner: form.find('.file-uploader')
      init: ()->
        a = assetable
        # append file picker
        a.form.after(["<input id='", a.form_id, "_assets' class='fileinput-btn' type='file' name='asset[attachment]'",
                 " data-url='", a.getUrl(), "' multiple>"].join(''))
        a.fileUploadInit()
        a.grapFromJson()

        # fake btn click
        a.btn.on 'click', (event)->
          a.form.next('.fileinput-btn').click()
          event.preventDefault()

        # delete
        $('.assets',a.$contaner).on 'click', '.asset-delete', ()->
          row = $(this);
          onComplite = ()->
            row.parent().remove();
            a.redrawDropzone()

          a.showLoading('Удаляюсь')

          $.ajax(
            type: 'DELETE'
            url: a.getUrl() + '/' + row.data('id')
            success: ()->
              onComplite()
            error: ()->
              onComplite()
          )
          return false;

      getUrl: ()->
        a = assetable
        url = if a.form_id.indexOf("new_") >= 0
                "/assets"
              else
                a.form_action + "/assets"
        a.getUrl = ()->
          url

        return url

      showLoading: (text)->
        a = assetable
        a.drop.addClass('files loading')
        a.drop.find('.data').html(text + "...<i class='icon-spinner icon-spin icon-2x r'></i>")
        a.btn.hide()

      redrawDropzone: ()->
        a = assetable
        a.drop.removeClass('loading')
        if $(".assets", a.$contaner).children().length > 0
          a.drop.find('.data').html(['Загруженно ',$(".assets", a.$contaner).children().length,  helpers._plural($(".assets", a.$contaner).children().length, [' файл', ' файла', ' файлов'])].join(''))
          a.btn.text('Загрузить еще').show()
        else
          a.drop.removeClass('files')
          a.btn.text('Выберите файл').show()
        a.setAssets()

      grapFromJson: ()->
        a = assetable
        assets = $(".assets", a.$contaner).data('assets')
        if assets.length > 0
          a.showLoading()
          _.map assets, (data) ->
            if(data.asset.attachment_file_name)
              a.appendItem(data.asset)

      appendItem: (asset)->
        a = assetable
        $('.assets', a.$contaner).removeClass('no-padding')
                            .append ["<li class='file-preview'><div class='asset-delete delete' data-id='",asset.id,"'>",
                                   "<img alt='",asset.attachment_content_type,
                                   "' src='", asset.thumb_url,"'>",
                                   "<a><i class='icon-trash'></i></a>",
                                   "<span>",

                                   asset.attachment_file_name, "</span></div></li>"].join('')
        a.redrawDropzone()
      setAssets: ()->
        a = assetable
        arr = []
        $('.assets',a.$contaner).find('.delete').each ()->
          arr.push $(this).data('id')
        $("[name='" + a.form.data('resource') + "[asset_ids]']").val(arr.join())

      fileUploadInit: ()->
        a = assetable
        $('#' + a.form_id + "_assets").fileupload
          dropZone: a.drop
          fileInput: $('#' + a.form_id + "_assets")
          dataType: "json"
          add: (e, data) ->
            acceptFileTypes = /(\.|\/)(docx?|xls|pdf)$/i
            if !acceptFileTypes.test(data.originalFiles[0]['type'])
              console.log 'Not an accepted file type'
            else
              a.showLoading('Загружаюсь')
              data.submit()

          done: (e, data) ->
            a.appendItem(data.result.asset)

        $(document).bind "dragover", (e) ->
          timeout = window.dropZoneTimeout
          unless timeout
            a.drop.addClass "in"
          else
            clearTimeout timeout
          if $(e.target).closest('#dropzone')[0] is dropZone[0]
            a.drop.addClass "hover"
          else
            a.drop.removeClass "hover"
          window.dropZoneTimeout = setTimeout(->
            window.dropZoneTimeout = null
            a.drop.removeClass "in hover"
          , 100)

        $(document).bind "drop dragover", (e) ->
          e.preventDefault()

    assetable.init()

  if form.length > 0 && form.find('.gallery-control').length > 0
    assetable =
      form: form
      form_id:  form.attr('id')
      form_action: form.attr('action')
      gallery: form.find('.gallery')
      $container: form.find('.gallery-control')
      init: ()->
        a = assetable
        # append file picker
        if a.form.parent().find("##{a.form_id}_assets").length == 0
          a.form.after(["<input id='", a.form_id, "_assets' class='fileinput-btn' type='file' name='asset[attachment]'",
                        " data-url='", a.getUrl(), "' multiple>"].join(''))
        a.fileUploadInit()
        a.grapFromJson()
        a.gallery.find('.add-item').on 'click', ()->
          a.form.next('.fileinput-btn').click()
        # delete
        $('.assets',a.$container).on 'click', '.asset-delete .delete', ()->
          row = $(this);
          onComplite = ()->
            row.parent().remove();
            a.redrawDropzone()

          a.showLoading()

          $.ajax(
            type: 'DELETE'
            url: a.getUrl() + '/' + row.data('id')
            success: ()->
              onComplite()
            error: ()->
              onComplite()
          )
          return false;

      getUrl: ()->
        a = assetable
        url = if a.form_id.indexOf("new_") >= 0
          "/assets"
        else
          '/' + a.form.data('resource') + a.form_action.split(a.form.data('resource'))[1] + "/assets"
        a.getUrl = ()->
          url

        return url

      showLoading: ()->
        a = assetable
        a.form.addClass('loading')
      setAssets: ()->
        a = assetable
        arr = []
        a.gallery.find('.delete').each ()->
          arr.push $(this).data('id')
        $("[name='" + a.form.data('resource') + "[asset_ids]']").val(arr.join())
      redrawDropzone: ()->
        a = assetable
        a.form.removeClass('loading')
        if a.gallery.children().length > 0
          a.form.addClass('files')
        else
          a.form.removeClass('files')


        if a.gallery.children().length > 5 || a.gallery.children().length == 1
          a.gallery.find('.add-item').addClass('hide')
        else
          a.gallery.find('.add-item').removeClass('hide')

        a.setAssets()

      grapFromJson: ()->
        _.map $(".assets", this.$container).data('assets'), (data) ->
          if(data.asset.attachment_file_name)
            assetable.appendItem(data.asset)

      appendItem: (asset)->
        a = assetable
        $('.assets', a.$container).removeClass('no-padding')
        .prepend ["<div class='asset-delete'>",
                  "<div class='delete' data-id='",asset.id,"' title='Удалить изображение'><i class='icon-remove'></i></div>",
                  "<div class='content'><img alt='",asset.attachment_content_type,
                  "' src='", asset.thumb_url,"'></div></div>"].join('')
        a.redrawDropzone()
      items: 0
      fileUploadInit: ()->
        a = assetable
        $('#' + a.form_id + "_assets").fileupload
          fileInput: $('#' + a.form_id + "_assets")
          dataType: "json"
          add: (e, data) ->
            acceptFileTypes = /(\.|\/)(gif|jpe?g|png)$/i
            if !acceptFileTypes.test(data.originalFiles[0]['type'])
              console.log 'Not an accepted file type'
            else
              if $(".assets", a.$container).children().length + data.originalFiles.length < 7
                a.showLoading()
                data.submit()
              else
                a.gallery.parent().find('.info').removeClass('hide')

          done: (e, data) ->
            a.appendItem(data.result.asset)
    assetable.init()
