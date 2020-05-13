require "lighthouse/preferences"
require "json"

module Lighthouse
  module Ruby
    class Builder

      def initialize(url)
        @url = url
        @runner = Lighthouse::Preferences.runner
        @cli = Lighthouse::Preferences.lighthouse_cli
        @port = Lighthouse::Preferences.remote_debugging_port
        @chrome_flags = Lighthouse::Preferences.chrome_flags
        @lighthouse_options = Lighthouse::Preferences.lighthouse_options
      end

      def run_test
        get_test_scores
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

      def get_test_scores
        json_result = JSON.parse(@runner.call("#{@cli} #{options}"))

        @test_scores = { url: @url}
        @test_scores[:run_time] = Time.now
        @test_scores[:performance] = json_result.dig("categories", "performance" , "score") * 100
        @test_scores[:accessibility] = json_result.dig("categories", "accessibility" , "score") * 100
        @test_scores[:best_practices] = json_result.dig("categories", "best-practices" , "score") * 100
        @test_scores[:seo] = json_result.dig("categories", "seo" , "score") * 100
        @test_scores
      end

    end
  end
end
