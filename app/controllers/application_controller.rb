class ApplicationController < ActionController::Base

    protect_from_forgery with: :exception

    before_action :set_emisor

    def after_sign_in_path_for(resource_or_scope)
        root_path
    end

    def after_sign_out_path_for(resource_or_scope)
        '/users/sign_in'  
    end

    def set_emisor
        @emisor = Emisor.first
    end

end
