# An instance of this class is a #Cell from a #Board.
class Cell

  attr_reader :tokens, :coords_top, :coords_mid, :coords_bottom, :coords_aux, :id

  # mapping of cell ids versus the possible 3 positions (top, mid, bottom) of tokens
  COORDS = [{top: {}, mid: {x: Parchis::HEIGHT / 2, y: Parchis::HEIGHT / 2}, bottom: {}},
    {top: {x: 392, y: 667}, mid: {x: 415, y: 667}, bottom: {x: 436, y: 667}},
    {top: {x: 392, y: 634}, mid: {x: 415, y: 634}, bottom: {x: 436, y: 634}},
    {top: {x: 392, y: 601}, mid: {x: 415, y: 601}, bottom: {x: 436, y: 601}},
    {top: {x: 392, y: 568}, mid: {x: 415, y: 568}, bottom: {x: 436, y: 568}},
    {top: {x: 392, y: 535}, mid: {x: 415, y: 535}, bottom: {x: 436, y: 535}},
    {top: {x: 392, y: 502}, mid: {x: 415, y: 502}, bottom: {x: 436, y: 502}},
    {top: {x: 392, y: 469}, mid: {x: 415, y: 469}, bottom: {x: 436, y: 469}},
    {top: {x: 390, y: 428}, mid: {x: 415, y: 434}, bottom: {x: 415, y: 440}},
    {top: {x: 428, y: 390}, mid: {x: 434, y: 402}, bottom: {x: 440, y: 415}},
    {top: {x: 468, y: 394}, mid: {x: 468, y: 415}, bottom: {x: 468, y: 436}},
    {top: {x: 501, y: 394}, mid: {x: 501, y: 415}, bottom: {x: 501, y: 436}},
    {top: {x: 535, y: 394}, mid: {x: 535, y: 415}, bottom: {x: 535, y: 436}},
    {top: {x: 565, y: 394}, mid: {x: 565, y: 415}, bottom: {x: 565, y: 436}},
    {top: {x: 600, y: 394}, mid: {x: 600, y: 415}, bottom: {x: 600, y: 436}},
    {top: {x: 633, y: 394}, mid: {x: 633, y: 415}, bottom: {x: 633, y: 436}},
    {top: {x: 666, y: 394}, mid: {x: 666, y: 415}, bottom: {x: 666, y: 436}},
    {top: {x: 666, y: 318}, mid: {x: 666, y: 339}, bottom: {x: 666, y: 360}},
    {top: {x: 666, y: 242}, mid: {x: 666, y: 262}, bottom: {x: 666, y: 284}},
    {top: {x: 633, y: 242}, mid: {x: 633, y: 262}, bottom: {x: 633, y: 284}},
    {top: {x: 600, y: 242}, mid: {x: 600, y: 262}, bottom: {x: 600, y: 284}},
    {top: {x: 568, y: 242}, mid: {x: 568, y: 262}, bottom: {x: 568, y: 284}},
    {top: {x: 535, y: 242}, mid: {x: 535, y: 262}, bottom: {x: 535, y: 284}},
    {top: {x: 501, y: 242}, mid: {x: 501, y: 262}, bottom: {x: 501, y: 284}},
    {top: {x: 468, y: 242}, mid: {x: 468, y: 262}, bottom: {x: 468, y: 284}},
    {top: {x: 428, y: 290}, mid: {x: 434, y: 278}, bottom: {x:440 , y: 265}},
    {top: {x: 390, y: 251}, mid: {x: 403, y: 245}, bottom: {x: 415, y: 239}},
    {top: {x: 392, y: 210}, mid: {x: 415, y: 210}, bottom: {x: 436, y: 210}},
    {top: {x: 392, y: 177}, mid: {x: 415, y: 177}, bottom: {x: 436, y: 177}},
    {top: {x: 392, y: 144}, mid: {x: 415, y: 144}, bottom: {x: 436, y: 144}},
    {top: {x: 392, y: 111}, mid: {x: 415, y: 111}, bottom: {x: 436, y: 111}},
    {top: {x: 392, y: 78}, mid: {x: 415, y: 78}, bottom: {x: 436, y: 78}},
    {top: {x: 392, y: 45}, mid: {x: 415, y: 45}, bottom: {x: 436, y: 45}},
    {top: {x: 392, y: 12}, mid: {x: 415, y: 12}, bottom: {x: 436, y: 12}},
    {top: {x: 318, y: 12}, mid: {x: 339, y: 12}, bottom: {x: 360, y: 12}},
    {top: {x: 243, y: 12}, mid: {x: 264, y: 12}, bottom: {x: 285, y: 12}},
    {top: {x: 243, y: 45}, mid: {x: 264, y: 45}, bottom: {x: 285, y: 45}},
    {top: {x: 243, y: 78}, mid: {x: 264, y: 78}, bottom: {x: 285, y: 78}},
    {top: {x: 243, y: 111}, mid: {x: 264, y: 111}, bottom: {x: 285, y: 111}},
    {top: {x: 243, y: 144}, mid: {x: 264, y: 144}, bottom: {x: 285, y: 144}},
    {top: {x: 243, y: 177}, mid: {x: 264, y: 177}, bottom: {x: 285, y: 177}},
    {top: {x: 243, y: 210}, mid: {x: 264, y: 210}, bottom: {x: 285, y: 210}},
    {top: {x: 264, y: 239}, mid: {x: 277, y: 245}, bottom: {x: 289, y: 251}},
    {top: {x: 251, y: 290}, mid: {x: 245, y: 278}, bottom: {x: 239, y: 265}},
    {top: {x: 211, y: 242}, mid: {x: 211, y: 262}, bottom: {x: 212, y: 284}},
    {top: {x: 178, y: 242}, mid: {x: 178, y: 262}, bottom: {x: 178, y: 284}},
    {top: {x: 145, y: 242}, mid: {x: 145, y: 262}, bottom: {x: 145, y: 284}},
    {top: {x: 112, y: 242}, mid: {x: 112, y: 262}, bottom: {x: 112, y: 284}},
    {top: {x: 79, y: 242}, mid: {x: 79, y: 262}, bottom: {x: 79, y: 284}},
    {top: {x: 46, y: 242}, mid: {x: 46, y: 262}, bottom: {x: 46, y: 284}},
    {top: {x: 13, y: 242}, mid: {x: 13, y: 262}, bottom: {x: 13, y: 284}},
    {top: {x: 13, y: 318}, mid: {x: 13, y: 339}, bottom: {x: 13, y: 360}},
    {top: {x: 13, y: 394}, mid: {x: 13, y: 415}, bottom: {x: 13, y: 436}},
    {top: {x: 46, y: 394}, mid: {x: 46, y: 415}, bottom: {x: 46, y: 436}},
    {top: {x: 79, y: 394}, mid: {x: 79, y: 415}, bottom: {x: 79, y: 436}},
    {top: {x: 112, y: 394}, mid: {x: 112, y: 415}, bottom: {x: 112, y: 436}},
    {top: {x: 145, y: 394}, mid: {x: 145, y: 415}, bottom: {x: 145, y: 436}},
    {top: {x: 178, y: 394}, mid: {x: 178, y: 415}, bottom: {x: 178, y: 436}},
    {top: {x: 211, y: 394}, mid: {x: 211, y: 415}, bottom: {x: 211, y: 436}},
    {top: {x: 251, y: 390}, mid: {x: 245, y: 402}, bottom: {x: 239, y: 415}},
    {top: {x: 264, y: 440}, mid: {x: 277, y: 434}, bottom: {x: 287, y: 428}},
    {top: {x: 243, y: 469}, mid: {x: 264, y: 469}, bottom: {x: 285, y: 469}},
    {top: {x: 243, y: 502}, mid: {x: 264, y: 502}, bottom: {x: 285, y: 502}},
    {top: {x: 243, y: 535}, mid: {x: 264, y: 535}, bottom: {x: 285, y: 535}},
    {top: {x: 243, y: 568}, mid: {x: 264, y: 568}, bottom: {x: 285, y: 568}},
    {top: {x: 243, y: 601}, mid: {x: 264, y: 601}, bottom: {x: 285, y: 601}},
    {top: {x: 243, y: 634}, mid: {x: 264, y: 634}, bottom: {x: 285, y: 634}},
    {top: {x: 243, y: 667}, mid: {x: 264, y: 667}, bottom: {x: 285, y: 667}},
    {top: {x: 318, y: 667}, mid: {x: 339, y: 667}, bottom: {x: 360, y: 667}},
    {top: {x: 318, y: 634}, mid: {x: 339, y: 634}, bottom: {x: 360, y: 634}},
    {top: {x: 318, y: 601}, mid: {x: 339, y: 601}, bottom: {x: 360, y: 601}},
    {top: {x: 318, y: 568}, mid: {x: 339, y: 568}, bottom: {x: 360, y: 568}},
    {top: {x: 318, y: 535}, mid: {x: 339, y: 535}, bottom: {x: 360, y: 535}},
    {top: {x: 318, y: 502}, mid: {x: 339, y: 502}, bottom: {x: 360, y: 502}},
    {top: {x: 318, y: 469}, mid: {x: 339, y: 469}, bottom: {x: 360, y: 469}},
    {top: {x: 318, y: 436}, mid: {x: 339, y: 436}, bottom: {x: 360, y: 436}},
    {top: {x: 303, y: 402}, mid: {x: 339, y: 402}, bottom: {x: 377, y: 402}, aux: {x: 339, y: 365}},
    {top: {x: 633, y: 318}, mid: {x: 633, y: 339}, bottom: {x: 633, y: 360}},
    {top: {x: 600, y: 318}, mid: {x: 600, y: 339}, bottom: {x: 600, y: 360}},
    {top: {x: 567, y: 318}, mid: {x: 567, y: 339}, bottom: {x: 567, y: 360}},
    {top: {x: 534, y: 318}, mid: {x: 534, y: 339}, bottom: {x: 534, y: 360}},
    {top: {x: 501, y: 318}, mid: {x: 501, y: 339}, bottom: {x: 501, y: 360}},
    {top: {x: 468, y: 318}, mid: {x: 468, y: 339}, bottom: {x: 468, y: 360}},
    {top: {x: 435, y: 318}, mid: {x: 435, y: 339}, bottom: {x: 435, y: 360}},
    {top: {x: 402, y: 302}, mid: {x: 402, y: 339}, bottom: {x: 402, y: 376}, aux: {x: 365, y: 339}},
    {top: {x: 318, y: 45}, mid: {x: 339, y: 45}, bottom: {x: 360, y: 45}},
    {top: {x: 318, y: 78}, mid: {x: 339, y: 78}, bottom: {x: 360, y: 78}},
    {top: {x: 318, y: 111}, mid: {x: 339, y: 111}, bottom: {x: 360, y: 111}},
    {top: {x: 318, y: 144}, mid: {x: 339, y: 144}, bottom: {x: 360, y: 144}},
    {top: {x: 318, y: 177}, mid: {x: 339, y: 177}, bottom: {x: 360, y: 177}},
    {top: {x: 318, y: 210}, mid: {x: 339, y: 210}, bottom: {x: 360, y: 210}},
    {top: {x: 318, y: 243}, mid: {x: 339, y: 243}, bottom: {x: 360, y: 243}},
    {top: {x: 303, y: 280}, mid: {x: 339, y: 280}, bottom: {x: 377, y: 280}, aux: {x: 339, y: 315}},
    {top: {x: 46, y: 318}, mid: {x: 46, y: 339}, bottom: {x: 46, y: 360}},
    {top: {x: 79, y: 318}, mid: {x: 79, y: 339}, bottom: {x: 79, y: 360}},
    {top: {x: 112, y: 318}, mid: {x: 112, y: 339}, bottom: {x: 112, y: 360}},
    {top: {x: 145, y: 318}, mid: {x: 145, y: 339}, bottom: {x: 145, y: 360}},
    {top: {x: 178, y: 318}, mid: {x: 178, y: 339}, bottom: {x: 178, y: 360}},
    {top: {x: 211, y: 318}, mid: {x: 211, y: 339}, bottom: {x: 211, y: 360}},
    {top: {x: 244, y: 318}, mid: {x: 244, y: 339}, bottom: {x: 244, y: 360}},
    {top: {x: 279, y: 302}, mid: {x: 279, y: 339}, bottom: {x: 279, y: 376}, aux: {x: 314, y: 339}},
    {top: {}, mid: {x: 536, y: 536}, bottom: {}},
    {top: {}, mid: {x: 598, y: 536}, bottom: {}},
    {top: {}, mid: {x: 536, y: 598}, bottom: {}},
    {top: {}, mid: {x: 598, y: 598}, bottom: {}},
    {top: {}, mid: {x: 536, y: 81}, bottom: {}},
    {top: {}, mid: {x: 598, y: 81}, bottom: {}},
    {top: {}, mid: {x: 536, y: 143}, bottom: {}},
    {top: {}, mid: {x: 598, y: 143}, bottom: {}},
    {top: {}, mid: {x: 80, y: 81}, bottom: {}},
    {top: {}, mid: {x: 142, y: 81}, bottom: {}},
    {top: {}, mid: {x: 80, y: 143}, bottom: {}},
    {top: {}, mid: {x: 142, y: 143}, bottom: {}},
    {top: {}, mid: {x: 80, y: 536}, bottom: {}},
    {top: {}, mid: {x: 142, y: 536}, bottom: {}},
    {top: {}, mid: {x: 80, y: 598}, bottom: {}},
    {top: {}, mid: {x: 142, y: 598}, bottom: {}}
  ].freeze
  FINISH_CELLS = [76, 84, 92, 100].freeze

  # @param id [Integer]
  def initialize(id)
    @id = id
    # view related attributes. Some cells doesn't have data for top and bottom
    @coords_top = {x: COORDS[id][:top][:x] , y: COORDS[id][:top][:y]} rescue {} #: i.e.: {x: 403, y: 677}
    @coords_mid = {x: COORDS[id][:mid][:x] , y: COORDS[id][:mid][:y]} #: i.e.: {x: 424, y: 677}
    @coords_bottom = {x: COORDS[id][:bottom][:x] , y: COORDS[id][:bottom][:y]} rescue {} #: i.e.: {x: 445, y: 677}
    # auxiliary fourth place for finish cells
    @coords_aux = {x: COORDS[id][:aux][:x] , y: COORDS[id][:aux][:y] } if(FINISH_CELLS.include?(id))
    # model related attributes
    @tokens = []
  end

  # TODO: Not finished.
  # @param token [Token]
  # @return [Boolean] returns false if not possible, true if the operation ran successfully
  def place_token(token)
    # ATTENTION: Mockering.
    @tokens << token
    true
  end

  # @return [Boolean]
  # Returns true if the cells is empty of tokens, false otherwise.
  def empty?
    @tokens.empty?
  end
  
  # @return [Integer]
  def get_length_coords
    COORDS.length - 17
  end
end
