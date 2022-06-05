require 'minitest/autorun'
require_relative '../lib/parchis/parchis'
require_relative '../lib/parchis/cell'

class TestCell < MiniTest::Test

    def setup
        @cell= Cell.new(1)
    end

    def test_place_token
        
    end

    def test_empty?
           
    end

    def test_get_length_coords
        assert_equal 100, @cell.get_length_coords
    end

end
