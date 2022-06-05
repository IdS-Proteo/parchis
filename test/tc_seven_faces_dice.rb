class TestSevenFacesDice < MiniTest::Test

def setup
    @seven_faces_dice=SevenFacesDice.new()
end

def test_roll
    assert_includes([1,2,3,4,5,6,7],roll,"empty")
end

end