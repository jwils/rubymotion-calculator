describe CalculatorBrain do
  before do
    @brain = CalculatorBrain.new
  end

  it 'should convert infix to postfix' do
    @brain.convert("3+4").should == [3, 4, "+"]
    @brain.convert("3+4*2/5").should == [3.0, 4.0, 2.0, 5.0, "/", "*", "+"]
  end

  it 'should convert infix to postfix with neg numbers' do
    @brain.convert("-5+-8*2--4").should == [-5.0, -8.0, 2.0, "*", "+", -4.0, "-"]
  end

  it 'it should solve equations' do
    @brain.eval("1+1").should == 2
    @brain.eval("1+2*3-1/1").should == 1+2*3-1/1
  end

  it 'it should return infinity on devide by 0' do
    @brain.eval("5/0").should == Float::INFINITY
    @brain.eval("5+3*1/0").should == Float::INFINITY
  end

  it 'should solve decimals' do
    (@brain.eval("5.05*2") - 5.05*2).should < 0.0005
    (@brain.eval("0.2*0.3") - 0.2*0.3).should < 0.0005
  end

  it 'should solve negative number equations' do
    @brain.eval("-5*2").should == -5*2
    @brain.eval("-5+-8*2--4").should == -5+-8*2--4
  end
end