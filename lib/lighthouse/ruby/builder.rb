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
        get_test_scores(parsed_response)
      end

      def parsed_response
        @parsed_response = JSON.parse(@response)
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
        @test_scores = { url: @url}
        @test_scores[:run_time] = Time.now
        @test_scores[:performance] = response.dig("categories", "performance" , "score").to_f * 100
        @test_scores[:accessibility] = response.dig("categories", "accessibility" , "score").to_f * 100
        @test_scores[:best_practices] = response.dig("categories", "best-practices" , "score").to_f * 100
        @test_scores[:seo] = response.dig("categories", "seo" , "score").to_f * 100
        @test_scores
      end

    end
  end
end
