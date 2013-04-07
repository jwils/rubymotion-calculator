describe "Application 'calculator'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it "has one or more views" do
    @app.windows.size.should >= 1
  end
end
