module Jiragit

  class Tag

    attr_accessor :type, :label

    def initialize(hashtag)
      @type = hashtag.first.first.to_sym
      @label = hashtag.first.last.to_s
    end

    def to_s
      "#{type}: #{label}"
    end

    def inspect
      to_s
    end

    def hash
      to_s.hash
    end

    def eql?(other)
      other.to_s.hash == to_s.hash
    end

  end

end
