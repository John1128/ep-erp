'use strict';

class Impuesto{
    constructor(){
        this._tipo = null;
        this._base = null;
        this._impuesto = null;
        this._factor = null;
        this._tasaCuota = null;
        this._importe = null;
    }

    set tipo(tipo){
        this._tipo = tipo;
    }

    get tipo(){
        return this._tipo;
    }

    set base(base){
        this._base = base;
    }

    get base(){
        return this._base;
    }

    set impuesto(imp){
        this._impuesto = imp;
    }

    get impuesto(){
        return this._impuesto;
    }

    set factor(factor){
        this._factor = factor;
    }

    get factor(){
        return this._factor;
    }

    set tasaCuota(tc){
        this._tasaCuota = tc;
    }

    get tasaCuota(){
        return this._tasaCuota;
    }

    set importe(importe){
        this._importe = importe;
    }

    get importe(){
        return this._importe;
    }
}

class Concepto{
    constructor(){
        this._producto = "";
        this._unidadMedida = "";
        this._cantidad = "";
        this._claveUnidad = "";
        this._valorUnitario = "";
        this._identificacion = "";
        this._importe = "";
        this._descuento = "";
        this._importeDescuento = "";
        this._impuestos = [];
    }

    set producto(producto){
        this._producto = producto;
    }

    get producto(){
        return this._producto;
    }

    set unidadMedidad(unidad){
        this._unidadMedida = unidad;
    }

    get unidadMedida(){
        return this._unidadMedida;
    }

    set claveUnidad(clave){
        this._claveUnidad = clave;
    }

    get claveUnidad(){
        return this._claveUnidad;
    }

    set cantidad(cantidad){
        this._cantidad = cantidad;
    }

    get cantidad(){
        return this._cantidad;
    }

    set valorUnitario(vu){
        this._valorUnitario = vu;
    }

    get valorUnitario(){
        return this._valorUnitario;
    }

    set identificacion(iden){
        this._identificacion = iden;
    }

    get identificacion(){
        return this._identificacion;
    }

    set importe(importe){
        this._importe = importe;
    }

    get importe(){
        return this._importe;
    }

    set descuento(descuento){
        this._descuento = descuento;
    }

    get descuento(){
        return this._descuento;
    }

    set importeDescuento(impDesc){
        this._importeDescuento = impDesc;
    }

    get importeDescuento(){
        return this._importeDescuento;
    }

    set impuestos(imp){
        this._impuestos = imp;
    }

    get impuestos(){
        return this._impuestos;
    }

    isValid(){
        return (this._producto != "" && this._unidadMedida != "" && this._cantidad != "" &&
            this._claveUnidad != "" &&
            this._valorUnitario != "" &&
            this._importe != "") ? true : false;
        
    }

    formatImpuesto(){
        var output = [];
        for(var i=0;i<this._impuestos.length;i++){
            var imp = this._impuestos[i];
            output.push(
                {
                    tipo_impuesto_id:imp.tipo,
                    base:imp.base,
                    impuesto_id:imp.impuesto,
                    tipo_factor_id:imp.factor,
                    tasa_cuota:imp.tasaCuota,
                    importe:imp.importe
                }
            )
        }
        return output;
    }

    
}

class Cfdi{

    constructor(){
        this._tipoComprobante = null;
        this._emisor = null;
        this._emisorDomicilio = false;
        this._regimenFiscal = null;
        this._receptor = null;
        this._receptorDomicilio = false;
        this._receptorRegTrib = null;
        this._usoCfdi = null;
        this._conceptos = [];
        this._moneda = null;
        this._metodoPago = null;
        this._formaPago = null;
        this._condicionPago = null;
        this._notasCabecera = null;
        this._notasPie = null;
        this._cfdiRelacionado = false;
        this._tipoRelacion = null;
        this._folios = null;
        this._total = null;
        this._subtotal = null;
        this._descuento = null;
        this._generate = 'N';
    }

    set tipoComprobante(tc){
        this._tipoComprobante = tc;
    }

    get tipoComprobante(){
        return this._tipoComprobante;
    }

    set emisor(emisor){
        this._emisor = emisor;
    }

    get emisor(){
        return this._emisor;
    }

    set emisorDomicilio(domicilio){
        this._emisorDomicilio = domicilio;
    }

    get emisorDomicilio(){
        return this._emisorDomicilio;
    }

    set receptor(receptor){
        this._receptor = receptor;
    }

    get receptor(){
        return this._receptor;
    }

    set receptorDomicilio(domicilio){
        this._receptorDomicilio = domicilio;
    }

    get receptorDomicilio(){
        return this._receptorDomicilio;
    }

    set conceptos(concepto){
        this._conceptos = concepto;
    }

    get conceptos(){
        return this._conceptos;
    }

    set formaPago(fp){
        this._formaPago = fp;
    }

    get formaPago(){
        return this._formaPago;
    }

    set metodoPago(mp){
        this._metodoPago = mp;
    }

    get metodoPago(){
        return this._metodoPago;
    }

    set condicionPago(cp){
        this._condicionPago = cp;
    }

    get condicionPago(){
        return this._condicionPago;
    }

    set notasCabecera(nc){
        this._notasCabecera = nc;
    }

    get notasCabecera(){
        return this._notasCabecera;
    }

    set notasPie(pie){
        this._notasPie = pie;
    }

    get notasPie(){
        return this._notasPie;
    }

    set cfdiRelacionado(rel){
        this._cfdiRelacionado = rel;
    }

    get cfdiRelacionado(){
        return this._cfdiRelacionado;
    }

    set tipoRelacion(tr){
        this._tipoRelacion = tr;
    }

    get tipoRelacion(){
        return this._tipoRelacion;
    }

    set folios(f){
        this._folios = f;
    }

    get folios(){
        return this._folios;
    }

    set moneda(m){
        this._moneda = m;
    }

    get moneda(){
        return this._moneda;
    }

    set regimenFiscal(rf){
        this._regimenFiscal = rf;
    }

    get regimenFiscal(){
        return this._regimenFiscal;
    }

    set usoCfdi(uso){
        this._usoCfdi = uso;
    }

    get usoCfdi(){
        return this._usoCfdi;
    }

    set total(t){
        this._total =t;
    }

    get total(){
        return this._total;
    }

    set subtotal(st){
        this._subtotal =st;
    }

    get subtotal(){
        return this._subtotal;
    }

    set descuento(descuento){
        this._descuento =descuento;
    }

    get descuento(){
        return this._descuento;
    }

    set generate(generate){
        this._generate =generate;
    }

    get generate(){
        return this._generate;
    }

    formatConceptos(){
        var output = [];
        for(var i=0;i<this._conceptos.length;i++){
            var concepto = this._conceptos[i];
            output.push({
                producto_id:concepto.producto,
                unidad_medida:concepto.unidadMedida,
                cantidad:concepto.cantidad,
                clave_unidad_id:concepto.claveUnidad,
                valor_unitario:concepto.valorUnitario,
                identificacion:concepto.identificacion,
                importe:concepto.importe,
                descuento:concepto.descuento,
                importe_descuento:concepto.importeDescuento,
                concepto_impuestos_attributes:concepto.formatImpuesto()
            });
        }
        return output;
    }


    cfdiData(){
        return {
            tipo_comprobante_id: this._tipoComprobante,
            emisor_id: this._emisor,
            emisor_domicilio: this._emisorDomicilio,
            regimen_fiscal_id: this._regimenFiscal,
            cliente_id: this._receptor,
            receptor_domicilio: this._receptorDomicilio,
            receptor_reg_trib: this._receptorRegTrib,
            uso_cfdi_id: this._usoCfdi,
            conceptos_attributes: this.formatConceptos(),
            forma_pago_id: this._formaPago,
            metodo_pago_id: this._metodoPago,
            condicion_pago: this._condicionPago,
            nota: this._notasCabecera,
            notas_pie: this._notasPie,
            cfdi_relacionado: this._cfdiRelacionado,
            tipo_relacion_id: this._tipoRelacion,                      
            folios_relacionados: this._folios,
            total: this._total,
            subtotal: this._subtotal,
            descuento: this._descuento,
            moneda_id: this._moneda,
            generate: this._generate
        }

    }


}
