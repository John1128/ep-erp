class CfdiController < ApplicationController

	rescue_from ActiveRecord::RecordNotFound, with: :render_404
    before_action :authenticate_user!

    include Mailer
    
    def index
        @menu = "comprobante_list"
    end

    def new
        @menu = "comprobante_new"
    end

    
    def create
        #begin
            parametros = cfdi_params(params)
            generate = parametros[:generate]
            parametros[:emisor_id] = Emisor.find_by_rfc(params[:emisor_id]).id
            parametros[:estatus] = 0
            parametros = parametros.except(:generate)
            factura = Factura.new(parametros)
            factura.serie = 'ERP'
            factura.folio = Factura.last_folio
            
            puts "Parametros"
            puts parametros
            puts "Factura valid?"
            puts factura.valid?
            puts "Errors?"
            puts factura.errors.full_messages
            factura.save!   

            if(generate=='S')
                api = CfdiApi.new
                result = api.generarCfdi(factura)
                puts "API OUTPUT"
                puts result
                if(result[:success])
                    factura.uuid = result[:uuid]
                    factura.pdf_url = result[:pdf]
                    factura.xml_url = result[:xml]
                    factura.estatus = 1
                    factura.save!
                    success = true
                    message = "Comprobante guardado y generado"
                else
                    factura.destroy()
                    success = false
                    message = result[:error]
                end
            else
                success = true
                message = "Comprobante guardado"
            end

            render json: {success: success, message: message}
        #rescue => e
        #    render json: {success: false, message: e.message}
        #end
    end

    def update
    end

    def destroy
        Factura.destroy
    end

    def generate_cfdi
        begin
            factura = Factura.find(params[:id])
            api = CfdiApi.new
            result = api.generarCfdi(factura)
            puts "API OUTPUT"
            puts @result
            if(@result[:success])
                factura.uuid = @result[:uuid]
                factura.pdf_url = @result[:pdf]
                factura.xml_url = @result[:xml]
                factura.estatus = 1
                factura.save!
                success = true
                message = "Comprobante generado"
            else
                success = false
                message = @result[:error]
            end
            render json: {success: success, message: message}
        rescue => e
            render json: {success: false, message: e.message}
        end
        
    end

    def cancel_cfdi
        begin
            parametros = cancel_cfdi_params(params)
            factura = Factura.find(parametros[:id])
            api = CfdiApi.new
            result = api.cancelarCfdi(factura,parametros[:justificacion])
            puts result
            if(result[:success])
                factura.justificacion = parametros[:justificacion]
                factura.cancelada = Time.now
                factura.estatus = 2
                factura.save!
                success = true
                message = "Comprobante cancelado"
            else
                success = false
                message = result[:error]
            end
            render json: {success: success, message: message}
        rescue => e
            render json: {success: false, message: e.message}
        end

    end

    def send_cfdi
        begin
            factura = Factura.find(params[:id])
            content = {
                subject: I18n.t("cfdi.messages.subject"),
                body: 	 I18n.t("cfdi.messages.body", uuid: factura.uuid).html_safe,
                pdf_url: factura.pdf_url
            }
            mail = ActionController::Base.new.render_to_string({template: 'email/notification', locals: {content: content}})
            if(send_email(params[:email], I18n.t("cfdi.messages.subject"), mail))
                render json: {success: true, message: "Comprobante enviado"}
            else
                render json: {success: false, message: "No se pudo enviar el comprobante"}
            end
        rescue => e
            render json: {success: false, message: e.message}
        end
    end
    

    private

    def cfdi_params(params)
        params.permit(:generate,:tipo_comprobante_id,:emisor_id,:emisor_domicilio,:regimen_fiscal_id,
        :cliente_id,:receptor_domicilio,:receptor_reg_trib,:uso_cfdi_id,
        :forma_pago_id,:metodo_pago_id,:condicion_pago,:nota,:notas_pie,:cfdi_relacionado,
        :tipo_relacion_id,:folios_relacionados,:total,:subtotal,:descuento,:moneda_id,
        conceptos_attributes: [:producto_id, :clave_unidad_id, :unidad_medida, :cantidad, :valor_unitario, :importe,
        :descuento, :identificacion, :fecha_corte,
        concepto_impuestos_attributes: [:tipo_impuesto_id, :base, :impuesto_id, :tipo_factor_id, :tasa_cuota, :importe]])
    end

    def cancel_cfdi_params(params)
        params.permit(:id,:justificacion)
    end

end