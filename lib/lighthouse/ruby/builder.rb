require "lighthouse/preferences"
require "json"

module Lighthouse
  module Ruby
    class Builder

      attr_reader :response

      def initialize(url)
        @url = url
        @runner = Lighthouse::Preferences.runner
        @cli = Lighthouse::Preferences.lighthouse_cli
        @port = Lighthouse::Preferences.remote_debugging_port
        @chrome_flags = Lighthouse::Preferences.chrome_flags
        @lighthouse_options = Lighthouse::Preferences.lighthouse_options
      end

      def execute
        @response = @runner.call("#{@cli} #{options}")
      end

      def parsed_response
        @test_scores ||= get_test_scores(raw_response)
      end

      def raw_response
        JSON.parse(@response)
      end

      private

      def options
        "'#{@url}'".tap do |builder|
          builder << ' --quiet'
          builder << ' --output=json'
          builder << " --port=#{@port}" if @port
          builder << " --#{@lighthouse_options}" if @lighthouse_options
          builder << " --chrome-flags='#{@chrome_flags}'" if @chrome_flags
        end.strip
      end

      def get_test_scores(response)
        @test_scores = { 'url' => @url}
        @test_scores['version'] = response['lighthouseVersion']
        @test_scores['time'] = Time.current
        @test_scores['categories'] = response['categories'].map { |k, v| [k, v["score"].to_f * 100] }.to_h
        @test_scores['audits'] = response['audits'].map { |k, v| [k, v["score"].to_f * 100] }.to_h
        @test_scores['screenshot'] = response['audits']['full-page-screenshot']['details']['screenshot']['data']
        @test_scores
      end

    end
  end
end
