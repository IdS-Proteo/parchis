require_relative '../lib/parchis/cell'
require_relative '../lib/parchis/token'
require_relative '../lib/parchis/parchis'

class TestCell < MiniTest::Test

    def setup
        @cell=Cell.new(1)
        @token=Token.new(yellow,1,A)
    end

    def test_place_token
        assert(@cell.place_token(@token))
    end

    def test_empty?
        assert(@cell.empty?)
    end

end