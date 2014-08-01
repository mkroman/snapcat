module Snapcat
  module Timestamp
    extend self

    def float
      Time.now.to_f
    end

    def macro
      float.floor
    end

    def micro
      (float * 1000).floor
    end
  end
end
