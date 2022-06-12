require 'minitest/autorun'
require_relative '../lib/parchis/v_widget'
require_relative '../lib/parchis/v_tips'

class TestVTips < MiniTest::Test

  TIPS = ['Cuando sea tu turno, arrojás tu dado pulsando [Spacebar].',
    'Si te sacás un 6, tenés un segundo turno.',
    'Con un 5, podés sacar una ficha a la salida de tu casa.',
    '2 fichas de igual color en un casillero forman una barrera.',
    'La barrera se rompe si el dueño saca un 6 o tiene 2 fichas.',
    'Llegás a la meta con número exacto o rebotás.',
    'Al llegar a la meta, o ganaste o avanzás 10 con otra ficha.',
    'Podés elegir fichas con las teclas A-B-C-D en tu teclado.',
    'Si te encontrás con una barrera, no podés avanzar.',
    'Una ficha come a otra de otro color si llega al mismo lugar.'].freeze
  HOLD_TIP = 25

  def setup
    @current_tip = 0
    @last_change = Time.now
  end

  def test_update
    #UT016
    #UT017
    if((Time.now - @last_change)> HOLD_TIP)
      assert_equal(TIPS[0],TIPS[@current_tip])
    else
      @current_tip += 1
      assert_equal(TIPS[1],TIPS[@current_tip])
    end
  end

end