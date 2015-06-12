  module PageRequester
    def request(uri, req)
      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      http.request(req)
    end
  end
