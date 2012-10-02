$ ->
  if $('#upload-form').size() > 0
    $progress = $ '.progress'
    $bar      = $ '.bar'
    $status   = $ '.bordered-dashed'

    $('#upload_original_name').change ->
      $('.bordered-dashed span').text do $(this).val().split('\\').last
      do upload_file

    $status[0].ondragover = ->
      $status.addClass('hover')
      false

    $status[0].ondragleave = ->
      $status.removeClass('hover')
      false

    $status[0].ondrop = ->
      $status.removeClass('hover')

    upload_file = ->
      $progress.removeClass 'hidden'
      do $('form').submit
      false

    $('form').ajaxForm(
      beforeSend: ->
        percentVal = '0%'
        $bar.width percentVal
      uploadProgress: (event, position, total, percentComplete) ->
        percentVal = percentComplete + '%'
        $bar.width percentVal
      complete: (xhr) ->
        $status.removeClass 'upload-zone'
        $status.html 'Your file located here: <a href="/'+xhr.responseText+'">'+window.location.host+'/'+xhr.responseText+'</a>'
        $progress.addClass 'hidden'
    )

  true