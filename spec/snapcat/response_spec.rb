require 'spec_helper'

describe Snapcat::Response do
  describe '.new' do
    it 'sets data to formatted result' do
      test_data = '{"test":"data"}'
      response_stub = stubbed_response(body: test_data)

      response = Snapcat::Response.new(response_stub)

      response.data.must_equal JSON.parse(test_data, symbolize_names: true)
    end

    it 'sets code' do
      response_stub = stubbed_response(code: 200)

      response = Snapcat::Response.new(response_stub)

      response.code.must_equal 200
    end

    it 'sets http_success' do
      response_stub = stubbed_response(:success? => true)

      response = Snapcat::Response.new(response_stub)

      response.http_success.must_equal true
    end
  end

  describe '#auth_token' do
    it 'returns auth token from response body' do
      response_stub = stubbed_response(body: '{"auth_token":"a_token"}')

      response = Snapcat::Response.new(response_stub)

      response.auth_token.must_equal 'a_token'
    end
  end

  describe '#success?' do
    context 'with logged response' do
      it 'returns true' do
        response_stub = stubbed_response(body: '{"logged":true}')

        response = Snapcat::Response.new(response_stub)

        response.success?.must_equal true
      end
    end

    context 'with response falling back to http' do
      it 'returns false' do
        response_stub = stubbed_response(:success? => false)

        response = Snapcat::Response.new(response_stub)

        response.success?.must_equal false
      end
    end
  end

  def stubbed_response(options = {})
    stub(
      code: options[:code] || 200,
      content_type: options[:content_type] || 'application/json',
      body: options[:body] || '{"test":"data"}',
      :success? => options[:success?].nil? ? true : options[:success?]
    )
  end
end
