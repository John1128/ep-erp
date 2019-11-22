// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// require rails-ujs
// require activestorage
// require turbolinks
// require_tree .


//= require vendor/jquery/jquery.min
//= require vendor/popper/popper.min
//= require vendor/bootstrap/js/bootstrap.min
//= require vendor/select2/js/select2.full.min
//= require vendor/simplebar/simplebar
//= require vendor/text-avatar/jquery.textavatar
//= require vendor/tippyjs/tippy.all.min
//= require vendor/flatpickr/flatpickr.min
//= require vendor/wnumb/wNumb
//= require vendor/datatables/datatables.min
//= require vendor/imaskjs/imask.min
//= require vendor/growl-notification/growl-notification.min
//= require vendor/sweet-alert/sweetalert.min
//= require vendor/jquery-confirm/jquery-confirm.min
//= require js/form-wizard/form-wizard
//= require js/main
//= require js/global
//= require js/cfdi
//= require js/comprobante
//datatable languaje
var dt_spanish = {
    "sProcessing":     "Procesando...",
    "sLengthMenu":     "Mostrar _MENU_ registros",
    "sZeroRecords":    "No se encontraron resultados",
    "sEmptyTable":     "Ningún dato disponible en esta tabla",
    "sInfo":           "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
    "sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
    "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
    "sInfoPostFix":    "",
    "sSearch":         "Buscar:",
    "sUrl":            "",
    "sInfoThousands":  ",",
    "sLoadingRecords": "Cargando...",
    "oPaginate": {
        "sFirst":    "Primero",
        "sLast":     "Último",
        "sNext":     "Siguiente",
        "sPrevious": "Anterior"
    },
    "oAria": {
        "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
        "sSortDescending": ": Activar para ordenar la columna de manera descendente"
    }
};

function setNumberMask(selector){
    console.log(selector);
    var numberMask = new IMask(selector, {
        mask: Number,
        scale: 0,
        signed: true,
        thousandsSeparator: '',
        min: 0
    });

}

//format: 12.45
function setDecimalMask(selector,decimals){
    console.log(selector);
    var numberMask = new IMask(selector, {
        mask: Number,
        scale: decimals,
        signed: true,
        thousandsSeparator: '',
        padFractionalZeros: false,
        normalizeZeros: true,
        radix: '.', 
        mapToRadix: ['.'],
        min: 0
    });

}

function truncateTwoDecimal(num, places) {
    return Math.trunc(num * Math.pow(10, places)) / Math.pow(10, places);
}

//growl notifications
//types:success, warning, info, error
function showNotification(title,msg,type){
    options = {
        title: title,
        description: msg,
        type: type,
        position: 'top-right',
        closeTimeout: 4000
    };

    new GrowlNotification(options).show();
}


function windowMsg(title,msg,icon,buttons){
    swal({
        title: title,
        text: msg,
        icon: icon,
        buttons: buttons
      });
      
}