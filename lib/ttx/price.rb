module TTx

  class Price

    attr_accessor :min
    attr_accessor :max

    def initialize(
        min   = nil,
        max    = nil
    )
      @min   = min
      @max   = max
    end

  end

end