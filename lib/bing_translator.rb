#!/usr/bin/env ruby
# (c) 2011-present. Ricky Elrod <ricky@elrod.me>
# Released under the MIT license.
require 'rubygems'
require 'cgi'
require 'uri'
require 'net/http'
require 'nokogiri'

class BingTranslator
  TRANSLATE_URI = 'http://api.microsofttranslator.com/V2/Http.svc/Translate'
  
  def initialize(api_key)
    @api_key = api_key
  end
  
  def translate(text, params = {})
    if params[:to].nil? or params[:from].nil?
      raise "Must provide :to and :from."
    else
      to = CGI.escape params[:to].to_s
      from = CGI.escape params[:from].to_s
      text = CGI.escape text.to_s
      uri = URI.parse(TRANSLATE_URI)
      params = {
        'to' => to,
        'from' => from,
        'text' => text,
        'appId' => @api_key,
        'category' => 'general',
        'contentType' => 'text/plain'
      }
      params_s = params.map {|key, value| "#{key}=#{value}"}.join '&'
      result = Net::HTTP.new(uri.host, uri.port)
      result = result.get("#{uri.path}?#{params_s}")
      noko = Nokogiri.parse(result.body)
      noko.xpath("//xmlns:string")[0].content
    end
  end
end
