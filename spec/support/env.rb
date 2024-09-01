require 'simplecov'
SimpleCov.command_name 'features' + (ENV['TEST_ENV_NUMBER'] || '') # remove the TEST_ENV_NUMBER part if you don't use parallel_tests
