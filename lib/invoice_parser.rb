require 'xmlsimple'

class InvoiceParser

    @invoice = nil

    def initialize(path)
        @path = path
    end

    def parse()
        if File.exist?(@path)
            begin
                @invoice = XmlSimple.xml_in(@path)
            rescue => e
                puts e
            end
        else
            puts "File not found"    
        end
    end

    def getFolio()
        @invoice["folio"]
    end

    def getFecha()
        @invoice["fecha"]
    end

    def getFormaDePago()
        @invoice["formaDePago"]
    end

    def getCondicionesDePago()
        @invoice["condicionesDePago"]
    end

    def getSubTotal()
        @invoice["subTotal"]
    end

    def getTipoCambio()
        @invoice["TipoCambio"]
    end

    def getMoneda()
        @invoice["Moneda"]
    end

    def getTotal()
        @invoice["total"]
    end
 
    def getTipoDeComprobante()
        @invoice["tipoDeComprobante"]
    end

    def getMetodoDePago()
        @invoice["metodoDePago"]
    end

    def getLugarExpedicion()
        @invoice["LugarExpedicion"]
    end

    def getNumCtaPago()
        @invoice["NumCtaPago"]
    end

    def getSello()
        @invoice["sello"]
    end

    def getCertificado()
        @invoice["certificado"]
    end

    def getNoCertificado()
        @invoice["noCertificado"]
    end

    def getEmisor()
        emisor = @invoice["Emisor"][0]
        output = Hash.new
        output[:rfc] = emisor["rfc"]
        output[:nombre] = emisor["nombre"]
        output[:DomicilioFiscal] = emisor["DomicilioFiscal"][0]
        output[:RegimenFiscal] = emisor["RegimenFiscal"][0]
        return output
    end

    def getReceptor()
        receptor = @invoice["Receptor"][0]
        output = Hash.new
        output[:rfc] = receptor["rfc"]
        output[:nombre] = receptor["nombre"]
        output[:Domicilio] = receptor["Domicilio"][0]
        return output
    end

    def getConceptos()
        output = Array.new
        conceptos = @invoice["Conceptos"][0]["Concepto"]
        conceptos.each do |c|
            output.push(c)
        end
        return output
    end

    def getTotalImpuestosTrasladados()
        @invoice["Impuestos"][0]["totalImpuestosTrasladados"]
    end

    def getImpuestos()
        output = Array.new
        impuestos = @invoice["Impuestos"][0]["Traslados"]
        impuestos.each do |i|
            i["Traslado"].each do |t|
                output.push(t)
            end
        end
        return output
    end

    def getComplemento()
        output = Hash.new
        complemento = @invoice["Complemento"][0]["TimbreFiscalDigital"][0]
        output[:uuid] = complemento["UUID"]
        output[:FechaTimbrado] = complemento["FechaTimbrado"]
        output[:selloCFD] = complemento["selloCFD"]
        output[:selloSAT] = complemento["selloSAT"]
        return output
    end

end