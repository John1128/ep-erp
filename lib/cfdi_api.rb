class CfdiApi

    BASE_ENDPOINT = "https://api.enlacefiscal.com/v6/"
    USER = "ETH160802QMA"
    PASSWORD = "32748f0193008dd9debc0ca77fff0be6"
    KEY = "e9aT1ajrRh1NyRkzOtDoN1ZEGmIsEKuJ6f3FYyLh"
    RFC = "ETH160802QMA"

   
        
    def prepare_call(method,url,data)
        @curl = CurlWrapper.new do |config|
            config.request "#{method}"
            config.user "#{RFC}:#{PASSWORD}"
            config.header "Content-Type:application/json"
            config.header "x-api-key:#{KEY}"
            config.data data
            config.url BASE_ENDPOINT + url
            config.verbose
        end    
    end


    def probar_conexion()
        data = '{"Solicitud":{"modo":"debug","rfc":"'+RFC+'","accion":"probarConexion"}}'
        puts data
        self.prepare_call("POST","probarConexion",data)
        @curl.run
        return JSON.parse(@curl.body)
    end

    def generarCfdi(comprobante)
        data = buildDataGenerarCfdi(comprobante)
        puts data
        self.prepare_call("POST","generarCfdi",data)
        @curl.run
        response = Hash.new
        body = @curl.body
        if body.size > 0
            result = JSON.parse(body)
            if result["AckEnlaceFiscal"]["estatusDocumento"] == "aceptado"
                response[:success] = true
                response[:uuid] = result["AckEnlaceFiscal"]["folioFiscalUUID"]
                response[:pdf] = result["AckEnlaceFiscal"]["descargaArchivoPDF"]
                response[:xml] = result["AckEnlaceFiscal"]["descargaXmlCFDi"]
            else
                response[:success] = false
                response[:error] = result["AckEnlaceFiscal"]["mensajeError"]["descripcionError"]
            end
        else
            response[:success] = false
            response[:error] = "No se obtuvo respuesta"
        end
        return response
    end

    def cancelarCfdi(comprobante,justificacion)
        data = buildDataCancelarCfdi(comprobante,justificacion)
        puts data
        self.prepare_call("POST","cancelarCfdi",data)
        @curl.run
        response = Hash.new
        body = @curl.body
        if body.size > 0
            result = JSON.parse(body)
            if result["AckEnlaceFiscal"]["estatusDocumento"] == "aceptado"
                response[:success] = true
            else
                response[:success] = false
                response[:error] = result["AckEnlaceFiscal"]["mensajeError"]["descripcionError"]
            end
        else
            response[:success] = false
            response[:error] = "No se obtuvo respuesta"
        end
        return response
    end

    private 

    def buildDataGenerarCfdi(comprobante)
        output = Hash.new
        data = Hash.new

        #begin
            
            
            cfdi = {}
            cfdi["rfc"] = comprobante.emisor.rfc   
            cfdi["modo"] = "debug"    #modo: debug, produccion
            cfdi["versionEF"] = "6.0"
    
            cfdi["serie"] = comprobante.serie
            cfdi["folioInterno"] = comprobante.folio
            cfdi["fechaEmision"] = comprobante.created_at.strftime("%Y-%m-%d %H:%M:%S")
            cfdi["subTotal"] = comprobante.subtotal
            cfdi["descuento"] = comprobante.descuento
            cfdi["total"] = comprobante.total
            cfdi["tipoMoneda"] = comprobante.moneda.codigo_sat
            cfdi["tipoCambio"] = ""
            cfdi["nombreDisenio"] = "ethicsglobal"   #opcional
            data["CFDi"] = cfdi

            #datos de pago
            pago = {}
            pago["metodoDePago"] = comprobante.metodo_pago.codigo_sat
            pago["formaDePago"] = comprobante.forma_pago.codigo_sat
            #pago["referenciaBancaria"] = invoiceParser.getNumCtaPago

            data["CFDi"]["DatosDePago"] = pago

            #receptor
            receptor = {}
            receptor["rfc"] = comprobante.cliente.rfc
            receptor["nombre"] = comprobante.cliente.razon_social
            receptor["usoCfdi"] = comprobante.uso_cfdi.codigo_sat  

            #comprobantes
            if(comprobante.cfdi_relacionado)
                '''data_comprobante = {}
                data_comprobante["tipoRelacion"] = comprobante.tipo_relacion.codigo_sat
                comprobante = comprobante.folios
                data_comprobante["Comprobantes"] = comprobante
                data["ComprobantesRelacionados"] = data_comprobante'''
            end

            if(comprobante.receptor_domicilio)
                '''domicilio_receptor = {}
                
                domicilio_receptor["calle"] = comprobante.cliente.calle
                domicilio_receptor["noExterior"] = comprobante.cliente.numero_exterior
                domicilio_receptor["noInterior"] = comprobante.cliente.numero_interior
                domicilio_receptor["colonia"] = comprobante.cliente.colonia
                domicilio_receptor["localidad"] = comprobante.cliente.localidad
                domicilio_receptor["municipio"] = comprobante.cliente.municipio
                domicilio_receptor["estado"] = invoiceParser.getReceptor[:Domicilio]["estado"]
                domicilio_receptor["pais"] = invoiceParser.getReceptor[:Domicilio]["pais"]
                domicilio_receptor["cp"] = invoiceParser.getReceptor[:Domicilio]["codigoPostal"]
                receptor["DomicilioFiscal"] = domicilio_receptor
                '''
            end

            data["CFDi"]["Receptor"] = receptor

            #conceptos
            conceptos = comprobante.conceptos
            partidas = Array.new
            impuestos = Array.new
            partida = {}

            total_impuestos_traslados = 0
            total_impuestos_retenidos = 0

            conceptos.each do |c|
                partida["cantidad"] = c.cantidad
                partida["claveUnidad"] = c.clave_unidad.codigo_sat
                partida["noIdentificacion"] = c.identificacion
                partida["claveProdServ"] = c.producto.codigo_sat
                partida["descripcion"] = c.producto.descripcion
                partida["valorUnitario"] = c.valor_unitario
                partida["importe"] = c.importe

                c_impuestos = c.concepto_impuestos
                imp = {}
                c_impuestos.each do |i|
                    tipo = i.tipo_impuesto.descripcion.downcase
                    if(tipo == "traslado")
                        total_impuestos_traslados = total_impuestos_traslados + i.importe
                    else
                        total_impuestos_retenidos = total_impuestos_traslados + i.importe
                    end
                    imp["tipo"] = 
                    imp["claveImpuesto"] = i.impuesto.descripcion
                    imp["tipoFactor"] = i.tipo_factor.descripcion.downcase
                    imp["tasaOCuota"] = i.tasa_cuota
                    imp["baseImpuesto"] = i.base
                    imp["importe"] = i.importe
                    impuestos.push(imp)
                end
                partida["impuestos"] = impuestos
                partidas.push(partida)
            end
            data["CFDi"]["Partidas"] = partidas

            #impuestos
            totales = {}
            totales["traslados"] = total_impuestos_traslados
            data["CFDi"]["Totales"] = totales
            #data["CFDi"]["Impuestos"]["Impuestos"] = impuestos

            return data.to_json    
        #rescue => e
        #    puts e
        #end
        
        
    end

    def buildDataCancelarCfdi(comprobante,justificacion)
        output = Hash.new
        data = Hash.new
        begin
            
            data["rfc"] = comprobante.emisor.rfc
            data["accion"] = "cancelarCfdi"
            data["modo"] = "debug" 
            
            cfdi = {}
            cfdi["serie"] = comprobante.serie
            cfdi["folio"] = comprobante.folio
            cfdi["justificacion"] = justificacion

            data["CFDi"] = cfdi
        rescue => e
            puts e
        end
        output["Solicitud"] = data
        return output.to_json
    end


end