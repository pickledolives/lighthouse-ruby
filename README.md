# Lighthouse::Ruby

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/lighthouse/ruby`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'lighthouse-ruby'
end
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install lighthouse-ruby

Another dependency you also need to have the `lighthouse` CLI tool available. The gem will automatically pick up the tool
if `lighthouse` already installed, or if there are no executable lighthouse file then it will automatically install for you.
Additionally if you want install it manually and added to dev dependency on the`package.sjon`, feel free to use any of this commands:
                   
* `npm install --save-dev lighthouse` 
* `yarn add --dev lighthouse`

If you have the `lighthouse` CLI tool installed, but available somewhere on your system, you can set the location manually.
See [Configuration](#configuration) for further instructions.

## Usage
After all the installation, now the `lighthouse\ruby` can be imported by adding this code to your test helper.

```
 require "lighthouse/ruby"
``` 
The idea to have this inside your test framework without adding too much overhead and un-necessary code in order to use 
the same Chrome session as your system test framework (e.g. the page requires a logged-in user), then you should change 
the definition of your system test Chrome browser arguments to define a "remote debugging port". Without defining this 
port, The `lighthouse/ruby` cannot connect to your existing Chrome session and will begin a new
one, clearing any session information.

## Setup Code
```
Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless remote-debugging-port=9222) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

Capybara.javascript_driver = :chrome
Lighthouse::Matchers.remote_debugging_port = 9222
```

#### For Rspec
Place the configuration on `spec/spec_helper.rb` or `spec/rails_helper.rb`
 
#### For Cucumber
Place the configuration on `features/env.rb` or where the Capybara and Chromedriver defined. 

## Configuration
There are several additional configuration that accessible and align with official `lighthouse-cli`. 
All the additional options:
* **`remote_debugging_port`:** If defined, Lighthouse will connect to this Chrome debugging port. 
  This allows the test to run in the same session as the Chrome session that created the port 
  (in th case of Capybara, this will be the same _current_state_ of `page` or `Capybara::Session` under test) 
  by match up the remote debugging port that has been configured for the Chrome browser instance. 
* **`lighthouse_path`:** The path to the Lighthouse CLI tool. By default, it will check `/usr/bin/`, `/usr/local/bin` 
  and `node_modules/.bin/` for the CLI. Therefor when the gem cannot find any executable file do not panic because
  it will install the latest `lighthouse` from npm globally.
* **`chrome_flags`:** Any additional flags that should be passed to Chrome when Lighthouse launches a browser instance. 
  As an example, running Lighthouse in Docker container or CI environment might requires the headless Chrome flags 
  (`--headless`, `--no-sandbox`) in order Chrome to successfully start. Chrome flags can be either specified as an array
  or string.(eq: `["headless", "no-sandbox"]` or `"headless", "no-sandbox"`). 
* **`lighthouse_options`:** Any additional options that can be passed to Lighthouse CLI. All the options can be found by 
  running `lighthouse --help` in the terminal or go this [link](https://github.com/GoogleChrome/lighthouse#cli-options) for more details. For an example usage, running Lighthouse in different emulated form factor 
  such as: a mobile, or desktop use `emulated-form-factor=<type>`. Another usage by adding additional headers during the 
  erequest simply add `--extra-headers`. Also, Lighthouse options can either be specified as an array or string. 
  (eq: `["emulated-form-factor=desktop", "--extra-headers '{\"food\":\"burger\", \"drink\":\"coke\"}'"]` or `"emulated-form-factor=desktop", "--extra-headers '{\"food\":\"burger\", \"drink\":\"coke\"}'"`). 

## Run Test
How to get the test report simply create object for `lighthouse-ruby` with url that need to be tested.
For `Capybara::Session` then `current_url` is the URL that you want to access.
```
 report = Lighthouse::Ruby::Builder.new(current_url)
 report.execute  # => will get all JSON object
 report.test_scores  # => Will get only meaningful hash of scores such as: performance, accessibility, best-practices, and SEO 
 => {:url=>"http://test.example.com:3001/", :run_time=>2020-05-14 13:10:12 +0000, :performance=>100, :accessibility=>80.0, :best_practices=>77.0, :seo=>90.0} 
```  
To be more flexible `report.execute` will return the JSON report and it should be easily parse into Ruby Hash as needed.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/UseFedora/lighthouse-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/lighthouse-ruby/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Lighthouse::Ruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/lighthouse-ruby/blob/master/CODE_OF_CONDUCT.md).
