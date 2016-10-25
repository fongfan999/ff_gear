$ ->
  $(document).ajaxComplete ->
    $('#user_avatar').on "change", ->
      buttonAvatar = $(this).parent().parent().parent().parent().find('button')

      if $(this).val() == ''
        $(buttonAvatar).attr('disabled', true)
      else
        $(buttonAvatar).attr('disabled', false)
