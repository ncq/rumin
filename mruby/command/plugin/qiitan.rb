# coding: utf-8
module Qiitan
	API_BASE_URL = 'https://qiita.com/api/v1/'

	class Client
		def initialize(buffer)
      @http_client = HttpRequest.new

			url = "#{API_BASE_URL}auth?url_name=#{ENV['QIITA_URL_NAME']}&password=#{ENV['QIITA_PASSWORD']}"
      response = @http_client.post(url)
      @buffer = buffer
      @token = JSON::parse(response.body)['token']
    end

   	def post
			url = "#{API_BASE_URL}items?token=#{@token}"
      set_title_and_body
      data = {
        title: @title,
        body: @body,
        private: false,
        tags: [{name: "test"}]
      }
      data = JSON.generate(data)

      headers = {'Content-Type' => 'application/json'}
      response = @http_client.post(url, data, headers)

      # response = `curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '#{data}'  '#{url}'`

			JSON.parse(response.body)['url']
    rescue => e
      debug e
		end

    private
    def set_title_and_body
      @buffer.get_content =~ /(.*?)\n(.*)/m
      @title, @body = $1, $2
    rescue
      debug "parse error."
      raise "parse error."
    end

	end
end
