class ApplicationController < ActionController::Base
  def render_layout
    render layout: 'application', html: nil
  end
end
