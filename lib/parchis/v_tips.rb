# Visual widget for phase #3. It shows different tips, feedback and else.
class VTips < VWidget

  # TODO: Write tips. These are placeholders.
  TIPS = ['Cuando sea tu turno, arrojás tu dado pulsando [Spacebar].',
          'Si rolás un 6, tenés un segundo turno.',
          'Con un 5, podés sacar una ficha a la salida de tu casa.',
          '2 fichas de igual color en un casillero forman una barrera.',
          'La barrera se rompe si el dueño saca un 6 o tiene 2 fichas.',
          'Llegás a la meta roland un número exacto o rebotás.',
          'Al llegar a la meta, o ganaste o avanzás 10 con otra ficha.',
          'Si te encontrás con una barrera, no podés avanzar.',
          'En una celda "segura" pueden coexistir dos fichas.'].freeze

  X_POS = 716
  Y_POS = 326
  Z_POS = 1
  MAX_CHARS_PER_TIP = 61 #: 66 total, so 61 + "TIP: "
  HOLD_TIP = 25 # in seconds

  # @param font [Gosu::Font]
  def initialize(font: nil)
    super
    @last_change = Time.now
    @current_tip = 0
  end

  # Called 60 times per second.
  def update
    if((Time.now - @last_change) > HOLD_TIP)
      @last_change = Time.now
      if(TIPS.length >= (@current_tip + 2))
        @current_tip += 1
      else
        @current_tip = 0
      end
    end
  end

  def draw
    @font.draw_text("TIP: #{TIPS[@current_tip]}", X_POS, Y_POS, Z_POS, 1, 1, 0xff_000000)
  end
end
