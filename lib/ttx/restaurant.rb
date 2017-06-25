module TTx

  class Restaurant

    attr_accessor :name
    attr_accessor :rating
    attr_accessor :distance

    def initialize(
        name      = nil,
        rating    = nil,
        distance  = nil
    )
      @name     = name
      @rating   = rating
      @distance = distance

    end

  end

end