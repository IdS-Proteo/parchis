# Visual widget for phase #3. It shows different tips, feedback and else.
class VTips < VWidget

  # TODO: Agregar mantener presionado
  TIPS = ['Para ejecutar acción, presiona un momento la debida tecla.',
          'Cuando sea tu turno, arrojas el dado manteniendo [Spacebar].',
          'Si arrojas un 6, tienes un segundo turno.',
          'Solo con un 5, puedes (debes) sacar una ficha de tu casa.',
          '2 fichas de igual color en un casillero forman una barrera.',
          'Tu barrera debe romperse si sacas un 6.',
          'Tu barrera debe romperse si solo puedes mover sus fichas.',
          'Debes sacar el número exacto para llegar a la meta o rebotas.',
          'Si te encuentras con una barrera, no puedes avanzar.',
          'En una celda "segura" pueden coexistir dos fichas cualquiera.',
          'Las celdas seguras son aquellas que tienen un círculo.',
          'El 3° en arribar a celda segura llena, "come" el último.',
          'Tienes 2 minutos para actuar, luego de eso, tu turno termina.'].freeze

  X_POS = 716
  Y_POS = 326
  Z_POS = 1
  MAX_CHARS_PER_TIP = 61 #: 66 total, so 61 + "TIP: "
  HOLD_TIP = 25 # in seconds

  # @param font [Gosu::Font]
  def initialize(font: nil)
    @last_change = Time.now
    @current_tip = 0
    super
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
