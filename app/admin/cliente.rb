ActiveAdmin.register Cliente do

    config.clear_action_items!
  
    # Parámetros
    resource_name = I18n.t("cliente.resource_name")
    resource_title = I18n.t("cliente.resource_title")
  
    menu label: I18n.t("cliente.resource_name"), priority: 5
      
    permit_params :rfc, :razon_social, :email,
    :pais_id,:municipio_id,:colonia,:calle,:codigo_postal,:localidad,:referencia,:numero_interior,:numero_exterior

    before_action { @page_title = I18n.t("active_admin.new_model",model: resource_name) } 

    
    collection_action :edit do
        @page_title = I18n.t("active_admin.edit_model",model: resource_name)
    end    

    action_item :new do
        link_to(I18n.t('global.action_items.new',resource: resource_name), new_resource_path)
    end

    action_item :edit, only: :show do
        link_to(I18n.t('global.action_items.edit',resource: resource_name), edit_resource_path)
    end

    breadcrumb do
        [
          link_to(I18n.t("active_admin.dashboard"), {controller: "dashboard"}),
          link_to(resource_title, {controller: "clientes"})
        ]   
    end 

    #Index
    index title: resource_title do
        id_column
        column I18n.t('cliente.rfc') do |r|
            r.rfc
        end 
        column I18n.t('cliente.razon_social') do |r|
            r.razon_social
        end 
        column I18n.t('cliente.email') do |r|
            r.email
        end

        actions
    end  


    # Filtros
    filter :rfc, label: I18n.t('cliente.rfc')
    filter :razon_social, label: I18n.t('cliente.razon_social')
    filter :email, label: I18n.t('cliente.email')

    form do |f|
        f.semantic_errors *f.object.errors.keys
        f.inputs resource_name do
          f.input :rfc, label: I18n.t('cliente.rfc')
          f.input :razon_social, label: I18n.t('cliente.razon_social')
          f.input :email, label: I18n.t('cliente.email')   
        end
        f.inputs I18n.t('cliente.domicilio') do

            f.input :pais_id,
                as: :select, 
                label: I18n.t('domicilio_fiscal.pais'), 
                collection: Pais.all.map{|a| a = [a.nombre,a.id] }

            f.input :municipio_id, 
                as: :select, 
                label: I18n.t('domicilio_fiscal.municipio'), 
                collection: Municipio.all.map{|a| a = [a.nombre,a.id] }

            f.input :colonia, label: I18n.t('domicilio_fiscal.colonia')
            f.input :codigo_postal, label: I18n.t('domicilio_fiscal.codigo_postal')
            f.input :calle, label: I18n.t('domicilio_fiscal.calle')
            f.input :numero_exterior, label: I18n.t('domicilio_fiscal.numero_exterior')
            f.input :numero_interior, label: I18n.t('domicilio_fiscal.numero_interior')
            f.input :localidad, label: I18n.t('domicilio_fiscal.localidad')
            f.input :referencia, label: I18n.t('domicilio_fiscal.referencia')
            
        end
        f.actions do
            f.action :submit, label: I18n.t("global.save_button")
            f.action :cancel, label: I18n.t("global.cancel_button")
        end
      end 

    show title: I18n.t("active_admin.details", model: resource_name) do |form|
        panel resource_name do
          attributes_table_for form do
            row I18n.t('cliente.rfc') do |f|
              f.rfc
            end
            row I18n.t('cliente.razon_social') do |f|
              f.razon_social
            end
            row I18n.t('cliente.email') do |f|
                f.email
            end
            row I18n.t('global.created_at') do |f| 
              I18n.l(f.created_at)
            end    
            row I18n.t('global.updated_at') do |f| 
              I18n.l(f.updated_at)
            end 

            row I18n.t('domicilio_fiscal.municipio') do |f|
                (f.municipio!=nil) ? f.municipio.nombre : ''
            end

            row I18n.t('domicilio_fiscal.colonia') do |f|
                f.colonia
            end

            row I18n.t('domicilio_fiscal.codigo_postal') do |f|
                f.codigo_postal
            end

            row I18n.t('domicilio_fiscal.calle') do |f|
                f.calle
            end

            row I18n.t('domicilio_fiscal.numero_interior') do |f|
                f.numero_interior
            end

            row I18n.t('domicilio_fiscal.numero_exterior') do |f|
                f.numero_exterior
            end

            row I18n.t('domicilio_fiscal.localidad') do |f|
                f.localidad
            end

            row I18n.t('domicilio_fiscal.referencia') do |f|
                f.referencia
            end

          end
        end  
        
    end 
    
end