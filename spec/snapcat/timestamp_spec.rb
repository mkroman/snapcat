require 'spec_helper'

describe Snapcat::Timestamp do
  before(:each) do
    fake_time = Time.now.to_f
    Time.stubs(:now).returns(fake_time)
  end

  describe '.float' do
    it 'returns timestamp with decimals' do
      timestamp = Snapcat::Timestamp.float

      timestamp.must_equal Time.now.to_f
    end
  end

  describe '.macro' do
    it 'returns timestamp with second precision' do
      timestamp = Snapcat::Timestamp.macro

      timestamp.must_equal Time.now.to_f.floor
    end
  end

  describe '.micro' do
    it 'returns timestamp with high precision' do
      timestamp = Snapcat::Timestamp.micro

      timestamp.must_equal (Time.now.to_f * 1000).floor
    end
  end
end
