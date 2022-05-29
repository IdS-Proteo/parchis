class Cell

  attr_reader :tokens, :coords_top, :coords_mid, :coords_bottom, :coords_aux

  # mapping of cell ids versus the possible 3 positions (top, mid, bottom) of tokens
  COORDS = [{top: {}, mid: {x: Parchis::HEIGHT / 2, y: Parchis::HEIGHT / 2}, bottom: {}},
    {top: {x: 403, y: 677}, mid: {x: 424, y: 677}, bottom: {x: 445, y: 677}},
    {top: {x: 403, y: 644}, mid: {x: 424, y: 644}, bottom: {x: 445, y: 644}},
    {top: {x: 403, y: 611}, mid: {x: 424, y: 611}, bottom: {x: 445, y: 611}},
    {top: {x: 403, y: 578}, mid: {x: 424, y: 578}, bottom: {x: 445, y: 578}},
    {top: {x: 403, y: 545}, mid: {x: 424, y: 545}, bottom: {x: 445, y: 545}},
    {top: {x: 403, y: 512}, mid: {x: 424, y: 512}, bottom: {x: 445, y: 512}},
    {top: {x: 403, y: 479}, mid: {x: 424, y: 479}, bottom: {x: 445, y: 479}},
    {top: {x: 399, y: 438}, mid: {x: 412, y: 444}, bottom: {x: 424, y: 450}},
    {top: {x: 437, y: 400}, mid: {x: 443, y: 412}, bottom: {x: 449, y: 425}},
    {top: {x: 477, y: 404}, mid: {x: 477, y: 425}, bottom: {x: 477, y: 446}},
    {top: {x: 510, y: 404}, mid: {x: 510, y: 425}, bottom: {x: 510, y: 446}},
    {top: {x: 543, y: 404}, mid: {x: 543, y: 425}, bottom: {x: 543, y: 446}},
    {top: {x: 576, y: 404}, mid: {x: 576, y: 425}, bottom: {x: 576, y: 446}},
    {top: {x: 609, y: 404}, mid: {x: 609, y: 425}, bottom: {x: 609, y: 446}},
    {top: {x: 642, y: 404}, mid: {x: 642, y: 425}, bottom: {x: 642, y: 446}},
    {top: {x: 675, y: 404}, mid: {x: 675, y: 425}, bottom: {x: 675, y: 446}},
    {top: {x: 675, y: 328}, mid: {x: 675, y: 349}, bottom: {x: 675, y: 370}},
    {top: {x: 675, y: 252}, mid: {x: 675, y: 272}, bottom: {x: 675, y: 294}},
    {top: {x: 642, y: 252}, mid: {x: 642, y: 272}, bottom: {x: 642, y: 294}},
    {top: {x: 609, y: 252}, mid: {x: 609, y: 272}, bottom: {x: 609, y: 294}},
    {top: {x: 576, y: 252}, mid: {x: 576, y: 272}, bottom: {x: 576, y: 294}},
    {top: {x: 543, y: 252}, mid: {x: 543, y: 272}, bottom: {x: 543, y: 294}},
    {top: {x: 510, y: 252}, mid: {x: 510, y: 272}, bottom: {x: 510, y: 294}},
    {top: {x: 477, y: 252}, mid: {x: 477, y: 272}, bottom: {x: 477, y: 294}},
    {top: {x: 437, y: 300}, mid: {x: 443, y: 288}, bottom: {x:449 , y: 275}},
    {top: {x: 399, y: 261}, mid: {x: 412, y: 255}, bottom: {x: 424, y: 249}},
    {top: {x: 403, y: 220}, mid: {x: 424, y: 220}, bottom: {x: 445, y: 220}},
    {top: {x: 403, y: 187}, mid: {x: 424, y: 187}, bottom: {x: 445, y: 187}},
    {top: {x: 403, y: 154}, mid: {x: 424, y: 154}, bottom: {x: 445, y: 154}},
    {top: {x: 403, y: 121}, mid: {x: 424, y: 121}, bottom: {x: 445, y: 121}},
    {top: {x: 403, y: 88}, mid: {x: 424, y: 88}, bottom: {x: 445, y: 88}},
    {top: {x: 403, y: 55}, mid: {x: 424, y: 55}, bottom: {x: 445, y: 55}},
    {top: {x: 403, y: 22}, mid: {x: 424, y: 22}, bottom: {x: 445, y: 22}},
    {top: {x: 327, y: 22}, mid: {x: 348, y: 22}, bottom: {x: 369, y: 22}},
    {top: {x: 252, y: 22}, mid: {x: 273, y: 22}, bottom: {x: 249, y: 22}},
    {top: {x: 252, y: 55}, mid: {x: 273, y: 55}, bottom: {x: 249, y: 55}},
    {top: {x: 252, y: 88}, mid: {x: 273, y: 88}, bottom: {x: 249, y: 88}},
    {top: {x: 252, y: 121}, mid: {x: 273, y: 121}, bottom: {x: 249, y: 121}},
    {top: {x: 252, y: 154}, mid: {x: 273, y: 154}, bottom: {x: 249, y: 154}},
    {top: {x: 252, y: 187}, mid: {x: 273, y: 187}, bottom: {x: 249, y: 187}},
    {top: {x: 252, y: 220}, mid: {x: 273, y: 220}, bottom: {x: 249, y: 220}},
    {top: {x: 273, y: 249}, mid: {x: 286, y: 255}, bottom: {x: 298, y: 261}},
    {top: {x: 260, y: 300}, mid: {x: 254, y: 288}, bottom: {x: 248, y: 275}},
    {top: {x: 220, y: 252}, mid: {x: 220, y: 272}, bottom: {x: 220, y: 294}},
    {top: {x: 187, y: 252}, mid: {x: 187, y: 272}, bottom: {x: 187, y: 294}},
    {top: {x: 154, y: 252}, mid: {x: 154, y: 272}, bottom: {x: 154, y: 294}},
    {top: {x: 121, y: 252}, mid: {x: 121, y: 272}, bottom: {x: 121, y: 294}},
    {top: {x: 88, y: 252}, mid: {x: 88, y: 272}, bottom: {x: 88, y: 294}},
    {top: {x: 55, y: 252}, mid: {x: 55, y: 272}, bottom: {x: 55, y: 294}},
    {top: {x: 22, y: 252}, mid: {x: 22, y: 272}, bottom: {x: 22, y: 294}},
    {top: {x: 22, y: 328}, mid: {x: 22, y: 349}, bottom: {x: 22, y: 370}},
    {top: {x: 22, y: 404}, mid: {x: 22, y: 425}, bottom: {x: 22, y: 446}},
    {top: {x: 55, y: 404}, mid: {x: 55, y: 425}, bottom: {x: 55, y: 446}},
    {top: {x: 88, y: 404}, mid: {x: 88, y: 425}, bottom: {x: 88, y: 446}},
    {top: {x: 121, y: 404}, mid: {x: 121, y: 425}, bottom: {x: 121, y: 446}},
    {top: {x: 154, y: 404}, mid: {x: 154, y: 425}, bottom: {x: 154, y: 446}},
    {top: {x: 187, y: 404}, mid: {x: 187, y: 425}, bottom: {x: 187, y: 446}},
    {top: {x: 220, y: 404}, mid: {x: 220, y: 425}, bottom: {x: 220, y: 446}},
    {top: {x: 260, y: 400}, mid: {x: 254, y: 412}, bottom: {x: 248, y: 425}},
    {top: {x: 273, y: 450}, mid: {x: 286, y: 444}, bottom: {x: 298, y: 438}},
    {top: {x: 252, y: 479}, mid: {x: 273, y: 479}, bottom: {x: 294, y: 479}},
    {top: {x: 252, y: 512}, mid: {x: 273, y: 512}, bottom: {x: 294, y: 512}},
    {top: {x: 252, y: 545}, mid: {x: 273, y: 545}, bottom: {x: 294, y: 545}},
    {top: {x: 252, y: 578}, mid: {x: 273, y: 578}, bottom: {x: 294, y: 578}},
    {top: {x: 252, y: 611}, mid: {x: 273, y: 611}, bottom: {x: 294, y: 611}},
    {top: {x: 252, y: 644}, mid: {x: 273, y: 644}, bottom: {x: 294, y: 644}},
    {top: {x: 252, y: 677}, mid: {x: 273, y: 677}, bottom: {x: 294, y: 677}},
    {top: {x: 327, y: 677}, mid: {x: 348, y: 677}, bottom: {x: 369, y: 677}},
    {top: {x: 327, y: 644}, mid: {x: 348, y: 644}, bottom: {x: 369, y: 644}},
    {top: {x: 327, y: 611}, mid: {x: 348, y: 611}, bottom: {x: 369, y: 611}},
    {top: {x: 327, y: 578}, mid: {x: 348, y: 578}, bottom: {x: 369, y: 578}},
    {top: {x: 327, y: 545}, mid: {x: 348, y: 545}, bottom: {x: 369, y: 545}},
    {top: {x: 327, y: 512}, mid: {x: 348, y: 512}, bottom: {x: 369, y: 512}},
    {top: {x: 327, y: 479}, mid: {x: 348, y: 479}, bottom: {x: 369, y: 479}},
    {top: {x: 327, y: 446}, mid: {x: 348, y: 446}, bottom: {x: 369, y: 446}},
    {top: {x: 312, y: 412}, mid: {x: 348, y: 412}, bottom: {x: 386, y: 412}, aux: {x: 348, y: 375}},
    {top: {x: 642, y: 328}, mid: {x: 642, y: 349}, bottom: {x: 642, y: 370}},
    {top: {x: 609, y: 328}, mid: {x: 609, y: 349}, bottom: {x: 609, y: 370}},
    {top: {x: 576, y: 328}, mid: {x: 576, y: 349}, bottom: {x: 576, y: 370}},
    {top: {x: 543, y: 328}, mid: {x: 543, y: 349}, bottom: {x: 543, y: 370}},
    {top: {x: 510, y: 328}, mid: {x: 510, y: 349}, bottom: {x: 510, y: 370}},
    {top: {x: 477, y: 328}, mid: {x: 477, y: 349}, bottom: {x: 477, y: 370}},
    {top: {x: 444, y: 328}, mid: {x: 444, y: 349}, bottom: {x: 444, y: 370}},
    {top: {x: 411, y: 312}, mid: {x: 411, y: 349}, bottom: {x: 411, y: 386}, aux: {x: 374, y: 349}},
    {top: {x: 327, y: 55}, mid: {x: 348, y: 55}, bottom: {x: 369, y: 55}},
    {top: {x: 327, y: 88}, mid: {x: 348, y: 88}, bottom: {x: 369, y: 88}},
    {top: {x: 327, y: 121}, mid: {x: 348, y: 121}, bottom: {x: 369, y: 121}},
    {top: {x: 327, y: 154}, mid: {x: 348, y: 154}, bottom: {x: 369, y: 154}},
    {top: {x: 327, y: 187}, mid: {x: 348, y: 187}, bottom: {x: 369, y: 187}},
    {top: {x: 327, y: 220}, mid: {x: 348, y: 220}, bottom: {x: 369, y: 220}},
    {top: {x: 327, y: 253}, mid: {x: 348, y: 253}, bottom: {x: 369, y: 253}},
    {top: {x: 312, y: 288}, mid: {x: 348, y: 288}, bottom: {x: 386, y: 288}, aux: {x: 348, y: 325}},
    {top: {x: 55, y: 328}, mid: {x: 55, y: 349}, bottom: {x: 55, y: 370}},
    {top: {x: 88, y: 328}, mid: {x: 88, y: 349}, bottom: {x: 88, y: 370}},
    {top: {x: 121, y: 328}, mid: {x: 121, y: 349}, bottom: {x: 121, y: 370}},
    {top: {x: 154, y: 328}, mid: {x: 154, y: 349}, bottom: {x: 154, y: 370}},
    {top: {x: 187, y: 328}, mid: {x: 187, y: 349}, bottom: {x: 187, y: 370}},
    {top: {x: 220, y: 328}, mid: {x: 220, y: 349}, bottom: {x: 220, y: 370}},
    {top: {x: 220, y: 328}, mid: {x: 220, y: 349}, bottom: {x: 220, y: 370}},
    {top: {x: 286, y: 312}, mid: {x: 286, y: 349}, bottom: {x: 286, y: 386}, aux: {x: 323, y: 349}},
    {top: {}, mid: {x: 545, y: 546}, bottom: {}},
    {top: {}, mid: {x: 607, y: 546}, bottom: {}},
    {top: {}, mid: {x: 545, y: 608}, bottom: {}},
    {top: {}, mid: {x: 607, y: 608}, bottom: {}},
    {top: {}, mid: {x: 545, y: 91}, bottom: {}},
    {top: {}, mid: {x: 607, y: 91}, bottom: {}},
    {top: {}, mid: {x: 545, y: 153}, bottom: {}},
    {top: {}, mid: {x: 607, y: 153}, bottom: {}},
    {top: {}, mid: {x: 89, y: 91}, bottom: {}},
    {top: {}, mid: {x: 151, y: 91}, bottom: {}},
    {top: {}, mid: {x: 89, y: 153}, bottom: {}},
    {top: {}, mid: {x: 151, y: 153}, bottom: {}},
    {top: {}, mid: {x: 89, y: 546}, bottom: {}},
    {top: {}, mid: {x: 151, y: 546}, bottom: {}},
    {top: {}, mid: {x: 89, y: 608}, bottom: {}},
    {top: {}, mid: {x: 151, y: 608}, bottom: {}}
  ].freeze
  FINISH_CELLS = [76, 84, 92, 100].freeze

  # @param id [Integer]
  def initialize(id)
    # view related attributes. Some cells doesn't have data for top and bottom
    @coords_top = {x: COORDS[id][:top][:x] - 11, y: COORDS[id][:top][:y] - 11} rescue {} #: i.e.: {x: 403, y: 677}
    @coords_mid = {x: COORDS[id][:mid][:x] - 11, y: COORDS[id][:mid][:y] - 11} #: i.e.: {x: 424, y: 677}
    @coords_bottom = {x: COORDS[id][:bottom][:x] - 11, y: COORDS[id][:bottom][:y] - 11} rescue {} #: i.e.: {x: 445, y: 677}
    # auxiliary fourth place for finish cells
    @coords_aux = {x: COORDS[id][:aux][:x] - 11, y: COORDS[id][:aux][:y] - 11} if(FINISH_CELLS.include?(id))
    # model related attributes
    @tokens = []
  end

  # TODO: Not finished.
  # @param token [Token]
  # @return [Boolean] returns false if not possible, true if the operation ran successfully
  def place_token(token)
    @tokens << token
    true
  end

  # @return [Boolean]
  # Returns true if the cells is empty of tokens, false otherwise.
  def empty?
    @tokens.empty?
  end
end
