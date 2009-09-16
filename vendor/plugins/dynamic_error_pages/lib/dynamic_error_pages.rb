module ActionController
  class Base
    def rescue_action_in_public(exception)
      case exception
        when ActiveRecord::RecordNotFound, 
             ActiveRecord::RecordInvalid, 
             ActionController::RoutingError, 
             ActionController::UnknownController, 
             ActionController::UnknownAction, 
             ActionController::MethodNotAllowed
          render :template => "application/404", :status => "404"
        else
          render :template => "application/500", :status => "500"
      end             
    end
  end
end
