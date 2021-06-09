module OrcidClient
  module Base
    # load ENV variables from .env file if it exists
    env_file = File.expand_path("../../../.env", __FILE__)
    if File.exist?(env_file)
      require 'dotenv'
      Dotenv.load! env_file
    end

    # load ENV variables from container environment if json file exists
    # see https://github.com/phusion/baseimage-docker#envvar_dumps
    env_json_file = "/etc/container_environment.json"
    json = File.exist?(env_json_file) ? File.read(env_json_file) : ""
    if json.length >= 2
      env_vars = JSON.parse(json)
      env_vars.each { |k, v| ENV[k] = v }
    end

    # default values for some ENV variables
    ENV['ORCID_API_URL'] ||= "https://api.sandbox.orcid.org"
    ENV['API_URL'] ||= "https://api.stage.datacite.org"
  end
end
