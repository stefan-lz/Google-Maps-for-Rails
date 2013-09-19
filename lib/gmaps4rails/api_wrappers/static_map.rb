module Gmaps4rails

  class StaticMap
    include BaseNetMethods

    attr_reader :address, :map_type, :image_size, :protocol

    def initialize(address, options = {})
      raise Gmaps4rails::StaticMapInvalidQuery, "You must provide an address" if address.blank?

      @address  = address
      @map_type  = options[:map_type] || "roadmap"
      @image_size = options[:size]          || "512x512"
      @protocol = options[:protocol]  || "http"
    end

    # returns an png of the map
    # - full_data:       map_png
    def get_map
      raise_net_status unless valid_response?
      return response.body
    end

    private

    def base_request
      "#{protocol}://maps.googleapis.com/maps/api/staticmap?size=#{image_size}&maptype=#{map_type}&markers=#{address}&sensor=false"
    end

    def raise_net_status
      raise Gmaps4rails::StaticMapNetStatus, "The request sent to google was invalid (not http success): #{base_request}.\nResponse was: #{response}"
    end

    def raise_query_error
      raise Gmaps4rails::StaticMapStatus, "The address you passed seems invalid, status was: #{parsed_response["status"]}.\nRequest was: #{base_request}"
    end

  end

end
