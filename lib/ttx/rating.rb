module TTx

  class Rating

    attr_accessor :value
    attr_accessor :category

    def initialize(
        value     = nil,
        category  = nil
    )
      @value    = value
      @category = category
    end

  end

end
