module AkamaiApi::Ccu
  class StatusRequest
    include HTTParty
    format :json
    base_uri 'https://api.ccu.akamai.com/ccu/v2/queues/default'

    def execute
      response = self.class.get('/', basic_auth: auth)
      parse_response response
    end

    private

    def auth
      AkamaiApi::Ccu.auth
    end

    def parse_response response
      raise AkamaiApi::Ccu::Unauthorized if response.code == 401
      AkamaiApi::Ccu::StatusResponse.new response.parsed_response
    end
  end
end
