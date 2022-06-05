class TestCell < MiniTest::Test

    def setup
        @cell=Cell.new(1)
    end

    def test_place_token
        assert_equal(true, @cell.place_token)
    end

    def test_empty?
        assert_equal(false, @cell.empty)
    end

end