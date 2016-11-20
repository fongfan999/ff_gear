# $ ->
#   #Override the default confirm dialog by rails
#   $.rails.allowAction = (link) ->
#     if link.data('confirm') == undefined
#       return true

#     $.rails.showConfirmationDialog link
#     false

#   # User click confirm button
#   $.rails.confirmed = (link) ->
#     link.data 'confirm', null
#     link.trigger 'click.rails'

#   #Display the confirmation dialog
#   $.rails.showConfirmationDialog = (link) ->
#     message = link.data('confirm')
#     swal(
#       title: message
#       type: 'warning'
#       confirmButtonText: 'Sure'
#       confirmButtonColor: '#2acbb3'
#       showCancelButton: true
#     ).then (e) ->
#       $.rails.confirmed link