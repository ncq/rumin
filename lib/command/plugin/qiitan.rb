# coding: utf-8
module Qiitan
  API_BASE_URL = 'https://qiita.com/api/v1/'

  class Client
    def initialize
      @http_client = HttpRequest.new
      url = "#{API_BASE_URL}auth?url_name=#{ENV['QIITA_URL_NAME']}&password=#{ENV['QIITA_PASSWORD']}"
      response = @http_client.post(url)
      @token = JSON::parse(response.body)['token']
    end

    def post(buffer)
      url = "#{API_BASE_URL}items?token=#{@token}"
      # 日本語が扱えないー。とりあえずcurlで対処
      # headers = {'Content-Type' => 'application/json'}
      # response = @http_client.post(url, data(buffer), headers)
      # JSON.parse(response.body)['url']
      response = `curl -s -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '#{data(buffer)}'  '#{url}'`
      url = JSON.parse(response)['url']
      buffer.display.echo.print_message("URL -> #{url}")
      url
    rescue => e
      buffer.display.echo.print_message("failed")
      debug "post error."
      debug e
    end

    private
    def data(buffer)
      title = buffer.content.content[0]
      tags = buffer.content.content[1].split(',').map{|x|{name: x}}
      body = buffer.content.content[2..-1].join("\n")

      data = {
        title: title,
        body: body,
        tags: tags,
        private: false,
      }
      JSON.generate(data)
    rescue => e
      debug "data error."
      debug e
    end

  end
end
