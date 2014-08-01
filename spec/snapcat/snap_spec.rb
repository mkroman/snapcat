require 'spec_helper'

describe Snapcat::Snap do
  describe '.new' do
    it 'converts fields' do
      snap_data = Fixture.snap_data
      snap = Snapcat::Snap.new(snap_data)

      snap.broadcast.must_equal snap_data[:broadcast]
      snap.broadcast_action_text.must_equal snap_data[:broadcast_action_text]
      snap.broadcast_hide_timer.must_equal snap_data[:broadcast_hide_timer]
      snap.broadcast_url.must_equal snap_data[:broadcast_url]
      snap.screenshot_count.must_equal snap_data[:c]
      snap.media_id.must_equal snap_data[:c_id]
      snap.id.must_equal snap_data[:id]
      snap.media_type.code.must_equal snap_data[:m]
      snap.recipient.must_equal snap_data[:rp]
      snap.sender.must_equal snap_data[:sn]
      snap.sent.must_equal snap_data[:sts]
      snap.opened.must_equal snap_data[:ts]
    end

    it 'sets status to value object' do
      snap_data = Fixture.snap_data
      snap = Snapcat::Snap.new(snap_data)

      snap.status.code.must_equal snap_data[:st]
      snap.status.delivered?.must_equal true
      snap.status.none?.must_equal false
    end
  end

  describe '#received?' do
    context 'when it was a snap received' do
      it 'returns true' do
        snap_data = Fixture.snap_data(:received)
        snap = Snapcat::Snap.new(snap_data)

        snap.received?.must_equal true
      end
    end

    context 'when it was a snap sent' do
      it 'returns false' do
        snap_data = Fixture.snap_data(:sent)
        snap = Snapcat::Snap.new(snap_data)

        snap.received?.must_equal false
      end
    end
  end

  describe '#sent?' do
    context 'when it was a snap sent' do
      it 'returns true' do
        snap_data = Fixture.snap_data(:sent)
        snap = Snapcat::Snap.new(snap_data)

        snap.sent?.must_equal true
      end
    end

    context 'when it was a snap received' do
      it 'returns false' do
        snap_data = Fixture.snap_data(:received)
        snap = Snapcat::Snap.new(snap_data)

        snap.sent?.must_equal false
      end
    end
  end
end
