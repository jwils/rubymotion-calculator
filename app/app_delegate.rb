class AppDelegate < ProMotion::AppDelegateParent
  def on_load(app, options)
    open CalculatorScreen.new(nav_bar: false)
  end
end
