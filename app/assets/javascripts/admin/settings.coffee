$ ->
  $('.swal-settings').click ->
    $('.tooltipped').tooltip('remove');
    swal
      title: "Đang thực hiện ...",
      text: "Quá trình này sẽ thực hiện sau 30 phút",
      type: 'success',
      confirmButtonText: 'Đóng',
      confirmButtonColor: '#26a69a'