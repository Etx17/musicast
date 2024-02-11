class Users::InvitationsController < Devise::InvitationsController
  def update
    if false #to implement
    # if resource.needs_to_accept_terms?
      # redirect_to root_path
    else
      super
    end
  end
end
