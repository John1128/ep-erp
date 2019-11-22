ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    columns do
      column do
        panel I18n.t("dashboard.recent_clients") do
           table_for Cliente.order(created_at: :desc).limit(5) do |form|
              column I18n.t('cliente.rfc') do |f|
                f.rfc
              end 
              column I18n.t('cliente.razon_social') do |f|
                link_to(f.razon_social, controller: :clientes, action: :show, id: f.id)
              end  
              column I18n.t('global.created_at') do |t| 
                I18n.l(t.created_at)
              end    
              column I18n.t('global.updated_at') do |t| 
                I18n.l(t.updated_at)
              end  
            end
        end
      end
    end
  end # content
end
