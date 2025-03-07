class LocalesController < ApplicationController
  def change
    locale = params[:locale].to_sym

    if I18n.available_locales.include?(locale)
      # Store the locale in the session
      session[:locale] = locale

      # Get the previous URL from the referer
      referer = request.referer

      if referer.present?
        # Parse the previous URL
        uri = URI(referer)

        # Extract the path and query parameters
        path = uri.path
        query_params = Rack::Utils.parse_query(uri.query)

        # Update the locale parameter
        path_parts = path.split('/')
        if path_parts.length > 1 && I18n.available_locales.map(&:to_s).include?(path_parts[1])
          path_parts[1] = locale.to_s
        else
          path_parts.insert(1, locale.to_s)
        end

        # Reconstruct the URL with the new locale
        new_path = path_parts.join('/')
        new_uri = URI::HTTP.build(host: uri.host, port: uri.port, path: new_path, query: uri.query)

        redirect_to new_uri.to_s
      else
        redirect_to root_path(locale: locale)
      end
    else
      redirect_to root_path, alert: "Locale not available"
    end
  end
end
