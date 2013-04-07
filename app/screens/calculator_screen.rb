class CalculatorScreen < ProMotion::Screen
  MARGIN = 20
  BUTTON_WIDTH = (Device.screen.width - 2 * MARGIN) / 4
  BUTTON_HEIGHT = (Device.screen.height - 3 * MARGIN) / 6
  BUTTON_SIZE = [Device.screen.width/4.8,Device.screen.width/4.8]
  BOTTOM_SPACING = Device.screen.height - 2*MARGIN
  CD_BTN_SIZE = [BUTTON_SIZE[0] + BUTTON_WIDTH, BUTTON_SIZE[1]*0.75]
  FUNCTIONS = %w[+ - * /]

  def on_load
    self.view.backgroundColor = 'gray'.to_color
  end

  def will_appear
    @view_loaded ||= begin
      view.styleId = 'calcView'
      create_display
      10.times{|x| create_number_button(x)}
      FUNCTIONS.each {|x| create_function_button(x)}
      create_dot_button
      create_equal_button
      create_clear_button
      create_delete_button
      @brain = CalculatorBrain.new
      true
    end
    @just_solved=false
  end

  def create_number_button(number)
    if number == 0
      position = [MARGIN + BUTTON_WIDTH, BOTTOM_SPACING - BUTTON_HEIGHT]
    else
      position = [MARGIN + BUTTON_WIDTH * ((number -1)%3),
                  BOTTOM_SPACING - BUTTON_HEIGHT * (((number -1)/3) + 2)]
    end

    button = create_button(number.to_s, [position, BUTTON_SIZE])

    button.when(UIControlEventTouchUpInside) do
      @display.text= "" if @just_solved
      @just_solved = false
      @display.append number.to_s
    end
  end

  def create_function_button(function)
    x_pos = MARGIN + BUTTON_WIDTH * 3
    button_size = BUTTON_SIZE.clone
    y_pos =  BOTTOM_SPACING - BUTTON_HEIGHT * (FUNCTIONS.find_index(function) + 1)

    button = create_button(function, [[x_pos, y_pos], button_size])
    button.when(UIControlEventTouchUpInside) do
      if FUNCTIONS.include? @display.last_char and function != '-'
        if FUNCTIONS.include? @display.trimmed_text[-2]
          @display.text = @display.trimmed_text[0..-2]
        end
        @display.last_char = function
      else
        @display.append function unless (@display.empty? and function != '-') or
            (function == '-' and @display.last_char == '-') or
            @display.trimmed_text == "Inf"
      end
      @display.setNeedsDisplay
      @just_solved = false
    end
  end

  def create_dot_button
    position = [MARGIN, BOTTOM_SPACING - BUTTON_HEIGHT]
    button = create_button('.', [position, BUTTON_SIZE])
    button.when(UIControlEventTouchUpInside) do
      if @display.empty? or FUNCTIONS.include? @display.last_char or @just_solved
        @just_solved = false
        @display.append '0.'
      else
        split = @display.text.split(Regexp.new ('[' + FUNCTIONS.join('').gsub('/', '\/') + ']'))
        @display.append '.' unless split[-1].include? '.' or @display.trimmed_text == "Inf"
      end
    end
  end

  def create_delete_button
    position = [MARGIN + BUTTON_WIDTH * 2, BOTTOM_SPACING - BUTTON_HEIGHT * 4.75]
    button = create_button('Delete', [position, CD_BTN_SIZE])
    button.when(UIControlEventTouchUpInside) do

      @display.text = "" if @display.trimmed_text == "Inf"
      @display.text= @display.trimmed_text[0..-2] unless @display.empty?
    end
  end

  def create_clear_button
    position = [MARGIN, BOTTOM_SPACING - BUTTON_HEIGHT * 4.75]
    button = create_button('Clear', [position, CD_BTN_SIZE])
    button.when(UIControlEventTouchUpInside) do
      @display.text= ""
    end
  end

  def create_equal_button
    position = [MARGIN + BUTTON_WIDTH * 2, BOTTOM_SPACING - BUTTON_HEIGHT]
    button = create_button('=', [position, BUTTON_SIZE])
    button.when(UIControlEventTouchUpInside) do
      text = @display.trimmed_text
      text = text[0..-2] if FUNCTIONS.include? text[-1]
      @display.text = sprintf("%g", @brain.eval(text)) unless  @display.trimmed_text == "Inf"
      @just_solved = true
    end
  end

  def create_button(text, frame)
    button = UIButton.buttonWithType UIButtonTypeRoundedRect
    button.setTitle text, forState: UIControlStateNormal
    button.frame = frame
    button.accessibilityLabel = text
    add button
  end

  def create_display
    @display = add MyLabel.alloc.initWithFrame(CGRectZero), {
        frame: CGRectMake(MARGIN, MARGIN, BUTTON_WIDTH * 3 + BUTTON_SIZE[0], 80),
        textAlignment: UITextAlignmentRight,
        textColor: UIColor.blackColor,
        font: UIFont.systemFontOfSize(24.0),
        text: "",
        numberOfLines: 1,
        styleId: "numbers",
    }
  end
end