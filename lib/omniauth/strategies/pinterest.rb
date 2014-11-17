require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Pinterest < OmniAuth::Strategies::OAuth2
      option :client_options, {
        site: 'https://pinterest.com',
        authorize_url: 'https://pinterest.com/oauth',
        token_url: 'https://api.pinterest.com/v2/oauth/access_token'
      }

      def authorize_params
        super.tap do |params|
          params['response_token'] = 'token'
          params['consumer_id'] = options.client_id
        end
      end

      def request_phase
        redirect client.auth_code.authorize_url(authorize_params)
      end

      uid { raw_info['id'] }

      info do
        {
          'nickname' => raw_info['username'],
          'name'     => raw_info['full_name'],
          'image'    => raw_info['image_url'],
        }
      end

      def raw_info
        @data ||= access_token.params["user"]
      end
    end
  end
end
