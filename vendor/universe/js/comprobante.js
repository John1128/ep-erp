$(function() {
    const cfdi = new Cfdi();

    var emisor_data, receptor, concepto_data, otros_data = false;


    var lista_conceptos = [];
    var lista_impuestos = [];
    var total_imp_traslados = 0;
    var total_imp_retenciones = 0;
    var total_general = 0;
    var subtotal_general = 0;
    var total_descuentos = 0;

    var edit_concepto = null;

    cfdi.emisor = $("#emisor_rfc").val();
    

    $("#e_domicilio").hide();
    $("#r_domicilio").hide();

    $(".nav-link.tabs-alpha__link").on("click",function (event) {
        return false;
    });

    var loadingMsg = new GrowlNotification({
        title: 'Aviso',
        description: 'Procesando el comprobante',
        type: 'info',
        position: 'top-right'
    });

    var impuestos_table =$('#impuestos_datatable').DataTable({
        "searching": false,
        "language": dt_spanish,
        "bLengthChange": false,
        "bPaginate": false,
        "bInfo": false,
        "columnDefs": [ {
            "targets": -1,
            "data": null,
            "defaultContent": "<button class='btn btn-outline-danger'>Eliminar</button>"
        }]
    });

    var conceptos_table =$('#conceptos_datatable').DataTable({
        "searching": false,
        "language": dt_spanish,
        "bLengthChange": false,
        "bPaginate": false,
        "bInfo": false,
        "columnDefs": [ {
            "targets": -1,
            "data": null,
            "defaultContent": "<button class='btn btn-outline-info edit'>Editar</button> <button class='btn btn-outline-danger delete'>Eliminar</button> "
        }]
    });
    
    if($("#concepto_cantidad").length > 0){
        setNumberMask(document.getElementById('concepto_cantidad'));
        setDecimalMask(document.getElementById('concepto_valor'),2);
        setDecimalMask(document.getElementById('concepto_importe'),2);
        setDecimalMask(document.getElementById('concepto_descuento'),2);
        setDecimalMask(document.getElementById('concepto_importe_descuento'),2);

        setDecimalMask(document.getElementById('impuesto_base'),2);
        setDecimalMask(document.getElementById('tasa_cuota'),6);
        setDecimalMask(document.getElementById('impuesto_importe'),2);
    }
    
   
   
    $("#concepto_valor").on("change",function (event) {
        if($(this).val()!=""){
            $("#concepto_importe").val($(this).val());
            importeDescuento();
        }
    });

    $("#concepto_descuento").on("change",function (event) {
        if($(this).val()!=""){
            importeDescuento();
        }
    });


    function importeDescuento(){
        var value = 0;
        if($("#concepto_importe").val()!=""){
            if($("#concepto_descuento").val()!=""){
                importe = $("#concepto_importe").val();
                descuento = $("#concepto_descuento").val();
                value = parseFloat(importe-descuento);
            }else{
                value = $("#concepto_importe").val();
            }
        }
        $("#concepto_importe_descuento").val(truncateTwoDecimal(value,2));
    }
    
    $("#emisor_set_direccion").change(function(){
        if($(this).is(":checked")) {
            $("#e_domicilio").show();
            cfdi.emisorDomicilio = true;
        }else{
            $("#e_domicilio").hide();
            cfdi.emisorDomicilio = false;
        }
    });

    $("#receptor_set_direccion").change(function(){
        if($(this).is(":checked")) {
            $("#r_domicilio").show();
            cfdi.receptorDomicilio = true;
        }else{
            $("#r_domicilio").hide();
            cfdi.receptorDomicilio = false;
        }
    });

    $("#tipo_comprobante").on('change', function(e) {
        var selected = $(this).val();
        if(selected!=null && selected!=''){
            cfdi.tipoComprobante = selected;
            clearError($(this));
        }
    });


    $("#emisor_regimen_fiscal").on('change', function(e) {
        var selected = $(this).val();
        if(selected!=null && selected!=''){
            cfdi.regimenFiscal = selected;
            clearError($(this));
        }
    });

    $('#rfc_receptor').on('change', function(e) {
        var selected = $(this).val();
        if(selected!=null && selected!=''){
            cfdi.receptor = selected;
            clearError($(this));
            $.get( "/cliente/"+ selected, function( data ) {
                console.log(data);
                $("#receptor_razon_social").val(data.razon_social);
                $("#receptor_email").val(data.email);
                $("#receptor_domicilio_calle").val(data.calle);
                $("#receptor_domicilio_nro_e").val(data.numero_exterior);
                $("#receptor_domicilio_nro_i").val(data.numero_interior); 
                $("#receptor_domicilio_colonia").val(data.colonia); 
                $("#receptor_domicilio_municipio").val(data.municipio); 
                $("#receptor_domicilio_estado").val(data.estado); 
                $("#receptor_domicilio_localidad").val(data.localidad); 
                $("#receptor_domicilio_referencia").val(data.referencia);  
                $("#receptor_domicilio_codigo_postal").val(data.codigo_postal); 
                $("#receptor_pais").val(data.pais_id).trigger('change');
            });
        }
    });

    $("#receptor_uso_cfdi").on('change', function(e) {
        var selected = $(this).val();
        if(selected!=null && selected!=''){
            cfdi.usoCfdi = selected;
            clearError($(this));
        }
    });


    $("#producto_descripcion").on('change', function() {
        var selected = $(this).val();
        if(selected!=null && selected!=''){
            clearError($(this));
            $.get( "/producto/"+ selected, function( data ) {
                console.log(data);
                $("#producto_clave").val(data.codigo_sat);
            });
        }
    });

    $("#unidad_medida").on('change', function() {
        clearError($(this));
    });

    $("#clave_unidad").on('change', function() {
        var selected = $(this).val();
        if(selected!=null && selected!=''){
            clearError($(this));
        }

    });

    $("#concepto_cantidad").on('change', function() {
        clearError($(this));
    });

    $("#concepto_valor").on('change', function() {
        clearError($(this));
    });

    
    $("#concepto_importe").on('change', function() {
        clearError($(this));
    });
    
    $("#moneda").on('change', function() {
        var selected = $(this).val();
        if(selected!=null && selected!=''){
            clearError($(this));
        }

    });
    
    $(".data_imp").on('change', function(){
        $(this).removeClass('is_invalid');
    });

    $("#tasa_cuota").on('change', function(){
        value = $(this).val().trim();
        base = $("#impuesto_base").val().trim();
        if(value.length > 0 && base.length > 0){
            $("#impuesto_importe").val(value * base);
        }
    });

    $("#impuesto_base").on('change', function(){
        value = $(this).val().trim();
        tasa_cuota = $("#tasa_cuota").val().trim();
        if(value.length > 0 && tasa_cuota.length > 0){
            $("#impuesto_importe").val(value * tasa_cuota);
        }
    });



    $("#addImpuesto").on( 'click', function(){
        var tipo_impuesto, base, impuesto, factor,tasa_cuota, importe = "";
        var invalid = [];
        if($("#impuesto_tipo").val()!=""){
            tipo_impuesto = $("#impuesto_tipo option:selected").text();
            
        }else{
            invalid.push($("#impuesto_tipo"));
        }
        if($("#impuesto_base").val()!=""){
            base = $("#impuesto_base").val();
        }else{
            invalid.push($("#impuesto_base"));
        }
        if($("#impuesto").val()!=""){
            impuesto = $("#impuesto option:selected").text();
        }else{
            invalid.push($("#impuesto"));
        }
        if($("#tipo_factor").val()!=""){
            factor = $("#tipo_factor option:selected").text();
        }else{
            invalid.push($("#tipo_factor"));
        }
        if($("#tasa_cuota").val()!=""){
            tasa_cuota = $("#tasa_cuota").val();
        }else{
            invalid.push($("#tasa_cuota"));
        }
        if($("#impuesto_importe").val()!=""){
            importe = $("#impuesto_importe").val();
        }else{
            invalid.push($("#impuesto_importe"));
        }

        if(tipo_impuesto!='' && base!='' && impuesto!='' && factor!='' && tasa_cuota!='' && importe!=''){

            var impuestos_cargados = impuestos_table.rows().data().toArray();
            var duplicado = false;
            for(var i=0;i<impuestos_cargados.length;i++){
                if(impuestos_cargados[i][0]==tipo_impuesto && impuestos_cargados[i][2]==impuesto && impuestos_cargados[i][3]==factor && impuestos_cargados[i][4]==tasa_cuota){
                    duplicado = true;
                    break;
                }
            }

            if(!duplicado){
                impuestos_table.row.add([
                    tipo_impuesto,
                    base,
                    impuesto,
                    factor,
                    tasa_cuota,
                    importe,
                    ''
                ]).draw(false);


                let imp = new Impuesto();
                imp.tipo = $("#impuesto_tipo").val();
                imp.base = $("#impuesto_base").val();
                imp.impuesto = $("#impuesto").val();
                imp.factor = $("#tipo_factor").val();
                imp.tasaCuota = $("#tasa_cuota").val();
                imp.importe = $("#impuesto_importe").val();
                lista_impuestos.push(imp);

                $("#impuesto_tipo").val('').trigger('change')
                $("#impuesto").val('').trigger('change')
                $("#tipo_factor").val('').trigger('change')
                $("#impuesto_base").val("");
                $("#tasa_cuota").val("");
                $("#impuesto_importe").val("");
                
            }else{
                showNotification("Aviso","Impuesto duplicado","error");
            }
        }else{
            showNotification("Aviso","Complete todos los datos requeridos para el impuesto","error");
            for(var i=0;i<invalid;i++){
                console.log(invalid[i]);
                invalid[i].addClass('is_invalid');
            }
        }
        
        
        
    });    

    $('#impuestos_datatable').on("click", "button", function(){
        console.log(lista_impuestos);
        var index = impuestos_table.row($(this).parents('tr')).index();
        impuestos_table.row($(this).parents('tr')).remove().draw();
        lista_impuestos.splice(index, 1);
        console.log(lista_impuestos);
        
    });

    function calcularImpuesto(){
        var data_impuestos = impuestos_table.rows().data().toArray();
        var total = 0;
        for(var i=0;i<data_impuestos.length;i++){
            total += data_impuestos[i][5];
        }
        console.log("Total:" + total);
    }

    $("#guardar_concepto").on('click', function(){
        const concepto = new Concepto();
        if($("#producto_descripcion").val()==""){
            setError($("#producto_descripcion"));
        }else{
            concepto.producto = $("#producto_descripcion").val().trim();    
        }
        if($("#unidad_medida").val()==""){
            setError($("#unidad_medida"));
        }else{
            concepto.unidadMedidad = $("#unidad_medida").val().trim();
        }

        if($("#clave_unidad").val()==""){
            setError($("#clave_unidad"));
        }else{
            concepto.claveUnidad = $("#clave_unidad").val().trim();
        }
        concepto.identificacion = $("#concepto_identificacion").val().trim();
        if($("#concepto_cantidad").val()==""){
            setError($("#concepto_cantidad"));
        }else{
            concepto.cantidad = $("#concepto_cantidad").val().trim();
        }
        if($("#concepto_valor").val()==""){
            setError($("#concepto_valor"));
        }else{
            concepto.valorUnitario = $("#concepto_valor").val().trim();
        }

        concepto.importe = $("#concepto_importe").val().trim();
        concepto.descuento = $("#concepto_descuento").val().trim();
        concepto.importeDescuento = $("#concepto_importe_descuento").val().trim();
        
        if(lista_impuestos.length > 0){
            concepto.impuestos = lista_impuestos;
        }

        if(concepto.isValid()){
            console.log("Valido");
            cfdi.regimenFiscal = $("#emisor_regimen_fiscal").val();
            cfdi.receptorRegTrib = $("#receptor_nro_reg_id_trib").val();
            if(edit_concepto!=null){
                lista_conceptos[edit_concepto] = concepto;
                conceptos_table.row(edit_concepto).remove().draw();
                edit_concepto = null;
            }else{
                lista_conceptos.push(concepto);
            }

            cfdi.conceptos = lista_conceptos;
            console.log(cfdi.cfdiData());
            
            conceptos_table.row.add([
                $("#producto_descripcion option:selected").text(),
                $("#concepto_cantidad").val(),
                $("#concepto_valor").val(),
                $("#concepto_importe").val(),
                $("#concepto_descuento").val(),
                ''
            ]).draw(false);
            calcularTotales();
            reset();
        }else{
            showNotification("Aviso","Complete todos los datos requeridos para el concepto","error");
        }
    });

    conceptos_table.on("click", "button", function(){
        var obj = $(this);
        var index = conceptos_table.row(obj.parents('tr')).index();
        console.log(lista_conceptos);
        if(obj.hasClass('edit')){
            console.log("Editar");
            editarConcepto(index);
        }else{
            console.log("Borrar");
            conceptos_table.row(obj.parents('tr')).remove().draw();
            lista_conceptos.splice(index, 1);
            console.log(lista_conceptos);
            cfdi.conceptos = lista_conceptos;
            calcularTotales();
            reset();
        }
    });

    function reset(){
        $("#producto_descripcion").val('').trigger('change')
        $("#producto_clave").val("");
        $("#unidad_medida").val("");
        $("#clave_unidad").val('').trigger('change')
        $("#concepto_cantidad").val("");
        $("#concepto_identificacion").val("");
        $("#concepto_valor").val("");
        $("#concepto_importe").val("");
        $("#concepto_descuento").val("");
        $("#concepto_importe_descuento").val("");               
        impuestos_table.clear().draw();
        lista_impuestos = [];
    }

    function editarConcepto(index){
        edit_concepto = index;
        t_concepto = lista_conceptos[index];
        console.log(t_concepto);
        //data concepto
        $("#producto_descripcion").val(t_concepto.producto).trigger('change');
        $("#unidad_medida").val(t_concepto.unidadMedida);
        $("#clave_unidad").val(t_concepto.claveUnidad).trigger('change');
        $("#concepto_cantidad").val(t_concepto.cantidad);
        $("#concepto_identificacion").val(t_concepto.identificacion);
        $("#concepto_valor").val(t_concepto.valorUnitario);
        $("#concepto_importe").val(t_concepto.importe);
        $("#concepto_descuento").val(t_concepto.descuento);
        $("#concepto_importe_descuento").val(t_concepto.importeDescuento);
        //impuestos 
        for(var i=0;i<t_concepto.impuestos.length;i++){
            t_impuesto = t_concepto.impuestos[i];
            console.log(t_impuesto);
            console.log($("#impuesto_tipo option[value='"+t_impuesto.tipo+"']").text());
            console.log($("#impuesto option[value='"+t_impuesto.impuesto+"']").text());
            console.log($("#tipo_factor option[value='"+t_impuesto.factor+"']").text());
            impuestos_table.row.add([
                    $("#impuesto_tipo option[value='"+t_impuesto.tipo+"']").text(),
                    t_impuesto.base,
                    $("#impuesto option[value='"+t_impuesto.impuesto+"']").text(),
                    $("#tipo_factor option[value='"+t_impuesto.factor+"']").text(),
                    t_impuesto.tasaCuota,
                    t_impuesto.importe,
                    ''
            ]).draw(false);

            let imp = new Impuesto();
            imp.tipo = t_impuesto.tipo;
            imp.base = t_impuesto.base;
            imp.impuesto = t_impuesto.impuesto;
            imp.factor = t_impuesto.factor;
            imp.tasaCuota = t_impuesto.tasaCuota;
            imp.importe = t_impuesto.importe;
            lista_impuestos.push(imp);
            lista_impuestos.push()
        }
    }

    function calcularTotales()
    {
        for(var i=0;i<cfdi.conceptos.length;i++){
            concepto = cfdi.conceptos[i];
            subtotal_general += concepto.importeDescuento;
            total_descuentos += concepto.descuento;
            for(var j=0;j<concepto.impuestos.length;j++){
                imp = concepto.impuestos[j];
                tipo = $("#impuesto_tipo option[value='"+imp.tipo+"']").text().toLowerCase();
                if(tipo=='traslado'){
                    total_imp_traslados += imp.importe;
                }else{
                    total_imp_retenciones += imp.importe;
                }
            }
            //imp_diff = total_imp_retenciones - total_imp_traslados;
            //total_general = subtotal_general - total_descuentos - imp_diff;
            total_general = subtotal_general - total_descuentos;
        }
        $("#conceptos_total").val(truncateTwoDecimal(total_general,2));
        $("#conceptos_subtotal").val(truncateTwoDecimal(subtotal_general,2));
        $("#conceptos_imp_traslados").val(truncateTwoDecimal(total_imp_traslados,2));
        $("#conceptos_imp_retenidos").val(truncateTwoDecimal(total_imp_retenciones,2));
        $("#conceptos_descuento").val(truncateTwoDecimal(total_descuentos,2));

        cfdi.total = truncateTwoDecimal(total_general,2);
        cfdi.subtotal = truncateTwoDecimal(subtotal_general,2);
        cfdi.descuento = truncateTwoDecimal(total_descuentos,2);
    }


    //otros

    $("#metodo_pago").on('change', function(e) {
        var selected = $(this).val();
        if(selected!=null && selected!=''){
            cfdi.metodoPago = selected;
        }
    });

    $("#forma_pago").on('change', function(e) {
        var selected = $(this).val();
        if(selected!=null && selected!=''){
            cfdi.formaPago = selected;
        }
    });
    
    $("#cfdi_relacionado").change(function(){
        if($(this).is(":checked")) {
            cfdi.cfdiRelacionado = true;
        }else{
            cfdi.cfdiRelacionado = false;
        }
    });

    //actions

    $("#emisor_guardar").on('click', function(){
        console.log("Emisor guaradar");
        emisor_data = true;
        tipo_comprobante = $("#tipo_comprobante");
        emisor_regimen_fiscal = $("#emisor_regimen_fiscal");
        if(tipo_comprobante.val()==''){
            setError(tipo_comprobante);
            emisor_data = false;
        }
        if(emisor_regimen_fiscal.val()==''){
            setError(emisor_regimen_fiscal);
            emisor_data = false;
        }
        if(!emisor_data){
            showNotification("Aviso","Complete los campos obligatorios","error");
        }else{
            $("#tab_emisor").find("a").removeClass("active show"); 
            $("#tabs-alpha-emisor").removeClass("active show");
            $("#tab_receptor").find("a").addClass("active show"); 
            $("#tabs-alpha-receptor").addClass("active show");
            //$("a[href$='#tabs-alpha-receptor']").trigger('click');
        }
    });

    $("#receptor_guardar").on('click', function(){
        console.log("Receptor guaradar");
        receptor_data = true;
        rfc_receptor = $("#rfc_receptor");
        receptor_uso_cfdi = $("#receptor_uso_cfdi");
        if(rfc_receptor.val()==''){
            setError(rfc_receptor);
            receptor_data = false;
        }
        if(receptor_uso_cfdi.val()==''){
            setError(receptor_uso_cfdi);
            receptor_data = false;
        }
        if(!receptor_data){
            showNotification("Aviso","Complete los campos obligatorios","error");
        }else{
            $("#tab_receptor").find("a").removeClass("active show"); 
            $("#tabs-alpha-receptor").removeClass("active show");
            $("#tab_conceptos").find("a").addClass("active show"); 
            $("#tabs-alpha-conceptos").addClass("active show");
            //$("a[href$='#tabs-alpha-conceptos']").trigger('click');
        }
    });

    $("#receptor_volver").on('click', function(){
        $("#tab_receptor").find("a").removeClass("active show"); 
        $("#tabs-alpha-receptor").removeClass("active show");
        $("#tab_emisor").find("a").addClass("active show"); 
        $("#tabs-alpha-emisor").addClass("active show");
    });

    $("#conceptos_guardar").on('click', function(){
        console.log("Guardando conceptos");
        if(lista_conceptos.length > 0){
            if($("#moneda").val()!=""){
                $("#tab_conceptos").find("a").removeClass("active show"); 
                $("#tabs-alpha-conceptos").removeClass("active show");
                $("#tab_otros").find("a").addClass("active show"); 
                $("#tabs-alpha-otros").addClass("active show");
                //$("a[href$='#tabs-alpha-otros']").trigger('click');
            }else{
                setError($("#moneda"));
            }
        }else{
            showNotification("Aviso","Debe agregar al menos un concepto","error");
        }
        
    });

    $("#conceptos_volver").on('click', function(){
        $("#tab_conceptos").find("a").removeClass("active show"); 
        $("#tabs-alpha-conceptos").removeClass("active show");
        $("#tab_receptor").find("a").addClass("active show"); 
        $("#tabs-alpha-receptor").addClass("active show");
    });

    $("#generate_cfdi").on('click', function(){
        if(validateOtros()){
            guardar('S');
        }else{
            showNotification("Aviso","Complete los datos para la forma de pago","error");
        }
    });

    $("#save_cfdi").on('click', function(){
        if(validateOtros()){
            guardar('N');
        }else{
            showNotification("Aviso","Complete los datos para la forma de pago","error");
        }
    });

    $("#otros_volver").on('click', function(){
        $("#tab_otros").find("a").removeClass("active show"); 
        $("#tabs-alpha-otros").removeClass("active show");
        $("#tab_conceptos").find("a").addClass("active show"); 
        $("#tabs-alpha-conceptos").addClass("active show");
    });

    
    function validateOtros(){
        if($("#metodo_pago").val() !='' && $("#forma_pago").val()!='' && $("#moneda").val()!=''){
            cfdi.condicionPago = $("#condicion_pago").val();
            cfdi.notasCabecera = $("#notas_cabcera").val();
            cfdi.notasPie = $("#notas_pie").val();
            cfdi.tipoRelacion = $("#tipo_relacion").val();
            cfdi.folios = $("#listado_folios").val();
            cfdi.moneda = $("#moneda").val();
            console.log("PAYLOAD");
            console.log(cfdi.cfdiData());
            return true;
        }else{
            return false;
        }
    }

    function guardar(generate)
    {
        loadingMsg.show();
        $('#generate_cfdi').prop('disabled', true);
        cfdi.generate = generate;
        
        $.ajax({
            url: "/cfdi",
            type: "POST",
            data: cfdi.cfdiData(),
            dataType: "json",
            headers: {
                'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
            },
            success: function (result) {
                console.log(result);
                $('#generate_cfdi').prop('disabled', false);
                GrowlNotification.closeAll();
                if(result.success){
                    swal({
                        title: 'Comprobante guardado',
                        text: "Datos registrado correctamente",
                        icon: 'success',
                        allowOutsideClick: false,
                        closeOnEsc: false,
                        buttons:{
                            confirm: {
                                text: "OK",
                                value: true,
                                visible: true,
                                closeModal: true
                            }
                        }
                    }).then((result) => {
                        window.location.href = '/cfdi';
                    });
                }else{
                    swal("Comprobante no se guardado", result.message, "error");
                }
            },
            error: function (xhr, ajaxOptions, thrownError) {
                console(xhr.status);
                GrowlNotification.closeAll();
                $('#generate_cfdi').prop('disabled', false);
                swal("Comprobante no se guardado", "Se produjo un error. Intente nuevamente", "error");
           }
        });
    }

    function clearError(element){
        element.removeClass("is-invalid");
        parent = element.parents('.form-group');
        parent.children('div.invalid-feedback').remove();
    }

    function setError(element){
        element.addClass("is-invalid");
        parent = element.parents('div');
        parent.children('div.invalid-feedback').remove();
        parent.append('<div class="invalid-feedback">Este campo es requerido</div>');
    }

    

});