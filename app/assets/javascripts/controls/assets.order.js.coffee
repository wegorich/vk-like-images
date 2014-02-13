$ ->
  my =
    $fields: $("tbody")
    id: $('table').data('id')

  my.$fields.sortable
    connectWith: ".asset-item"
    items: "> .asset-item"
    axis: "y"
    start: (event, ui)->
      ui.item.startPos = ui.item.index()
    stop: (event, ui)->
      if ui.item.startPos != ui.item.index()
        $.ajax
          url: "/albums/#{my.id}/update_config"
          method: 'POST'
          data:
            key: ui.item.data('id')
            position: ui.item.index() + 1
            id: $('table').data('id')

  my.$fields.find('.asset-item').disableSelection()