# app/services/gemini_service.rb
require "faraday"

class GeminiService
  BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models"
  DEFAULT_MODEL = "gemini-2.5-flash"

  def self.call(prompt)
    new.call(prompt)
  end

  def initialize
    @api_key = ENV.fetch("GEMINI_API_KEY")
  end

  def call(prompt)
    response = connection_gemini.post(endpoint_url) do |req|
      req.body = request_body(prompt)
    end

    parse_response(response)
  end

  private

  def connection_gemini
    @connection ||= Faraday.new do |f|
      f.request :json
      f.response :json
    end
  end

  def endpoint_url
    "#{BASE_URL}/#{DEFAULT_MODEL}:generateContent?key=#{@api_key}"
  end

  def request_body(prompt)
    {
      contents: [{ parts: [{ text: prompt }] }]
    }
  end

  def parse_response(response)
    if response.success?
      response.body.dig("candidates", 0, "content", "parts", 0, "text")
    else
      Rails.logger.error("Gemini API Error: #{response.body}")
      nil
    end
  end
end