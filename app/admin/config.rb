ActiveAdmin.register_page "Config" do
	menu label: I18n.t("global.config_parent_title"), priority: 3

	controller do
		def index
			redirect_to controller: :regimen_fiscals
		end	
	end	
end