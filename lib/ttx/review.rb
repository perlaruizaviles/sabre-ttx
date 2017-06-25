module TTx

  class Review

    attr_accessor :title
    attr_accessor :user
    attr_accessor :content
    attr_accessor :date
    attr_accessor  :rating

    def initialize(
        title   = nil,
        user    = nil,
        content = nil,
        date    = nil,
        rating  = nil
    )
      @title    = title
      @user     = user
      @content  = content
      @date     = date
      @rating   = rating

    end

  end

end