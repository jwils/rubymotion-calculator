describe CalculatorScreen do
  tests CalculatorScreen

  after do
    tap "Clear"
  end

  #Helper functions
  def display_text
    controller.instance_variable_get("@display").trimmed_text
  end

  def string_to_taps(string)
    string.split("").each do |string|
      tap string
    end
  end

  describe "Calculator screen layout" do
    it 'should load the views' do
      controller.instance_variable_get("@view_loaded").should == true
    end

    it 'should have all the numbers' do
      10.times do |x|
        view(x.to_s).is_a?(UIButton).should == true
      end
    end

    it 'should have all basic operations (+-/*)' do
      %w[+ - / *].each do |operation|
        view(operation).is_a?(UIButton).should == true
      end
    end

    it 'should have an =' do
      view("=").is_a?(UIButton).should == true
    end
  end

  describe "calculator screen basic functionality" do
    it 'should display a number when we press it' do
      string_to_taps "11111111111111" #hack to waste time
      tap "Clear"
      tap "1"
      display_text.should == "1"
    end

    it 'should solve 1+1=2' do
      string_to_taps "1+1="
      display_text.should == "2"
    end

    it 'should solve 1+2*3-1/1=6' do
      string_to_taps "1+2*3-1/1="
      display_text.should == "6"
    end

    it 'should return inf on /0' do
      string_to_taps "5/0="
      display_text.should == "Inf"
    end
  end

  describe "Calculator screen advanced usability" do
    it 'should replace input with a new number when a number is pressed after a solved equation' do
      string_to_taps "1+1=1"
      display_text.should == "1"
    end

    it "It shouldnt allow an operator other than -if no number has been pressed" do
      string_to_taps "+*/"
      display_text.should == ""
      string_to_taps "-"
      display_text.should == "-"
    end

    it "should not allow two operations in a row unless it's subtraction" do
      string_to_taps "1++"
      display_text.should == "1+"
      string_to_taps "*"
      display_text.should == "1*"
      string_to_taps "-"
      display_text.should == "1*-"
      string_to_taps "/"
      display_text.should == "1/"
    end

    it "Should allow decimal points only once per number" do
      string_to_taps "100.050.5"
      display_text.should == "100.0505"
    end

    it "Should clear infinity" do
      string_to_taps "5/0=5"
      display_text.should == "5"
    end

    it "should remove training operators when we evaluate" do
      string_to_taps "50*2+="
      display_text.should == "100"
    end
  end

end



