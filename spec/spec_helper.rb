$:.unshift File.expand_path("../lib", File.dirname(__FILE__))

require 'snapcat'
require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/pride'
require 'minitest/spec'
require 'mocha/setup'
require 'webmock/minitest'

SPEC_ROOT = File.dirname(__FILE__)

Dir["#{SPEC_ROOT}/support/**.rb"].each{ |file| require file }
