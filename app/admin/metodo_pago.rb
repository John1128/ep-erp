ActiveAdmin.register MetodoPago do

    config.clear_action_items!
  
    # Parámetros
    resource_name = I18n.t("metodo_pago.resource_name")
    resource_title = I18n.t("metodo_pago.resource_title")
  
    menu label: resource_name, parent: "Config", priority: 3
  
    permit_params :descripcion, :codigo_sat

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
          link_to(resource_title, {controller: "metodo_pagos"})
        ]   
    end 

    #Index
    index title: resource_title do
        id_column
        column I18n.t('metodo_pago.codigo_sat') do |r|
            r.codigo_sat
        end 
        column I18n.t('metodo_pago.descripcion') do |r|
            r.descripcion
        end 
        actions
    end  


    # Filtros
    filter :codigo_sat, label: I18n.t('metodo_pago.codigo_sat')
    filter :descripcion, label: I18n.t('metodo_pago.descripcion')

    show title: I18n.t("active_admin.details", model: resource_name) do |form|
        panel resource_name do
          attributes_table_for form do
            row I18n.t('metodo_pago.codigo_sat') do |f|
              f.codigo_sat
            end
            row I18n.t('metodo_pago.descripcion') do |f|
              f.descripcion
            end
            row I18n.t('global.created_at') do |f| 
              I18n.l(f.created_at)
            end    
            row I18n.t('global.updated_at') do |f| 
              I18n.l(f.updated_at)
            end 
          end
        end  
    end 
    
end