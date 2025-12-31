# app/services/gemini_service.rb
require 'faraday'
require 'json'

class GeminiService
  BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

  def initialize
    @api_key = ENV['GEMINI_API_KEY']
  end

  def call(prompt)
    # 1. 接続の設定
    gemini_connect = Faraday.new(url: BASE_URL) do |f|
      f.request :json
      f.response :json
      f.adapter Faraday.default_adapter
    end

    # 2. リクエストの送信
    response = gemini_connect.post("?key=#{@api_key}") do |req|
      req.body = {
        contents: [
          {
            parts: [{ text: prompt }]
          }
        ]
      }
    end

    # 3. 結果の取り出し
    response.body
  end
end