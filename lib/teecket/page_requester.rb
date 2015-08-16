  module PageRequester
    def request(uri, req, use_ssl = true)
      http = Net::HTTP.new(uri.host, uri.port)

      if use_ssl
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      http.request(req)
    end
  end
