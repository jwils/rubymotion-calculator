class AppDelegate < ProMotion::AppDelegateParent
  @@nui_settings = NUISettings.initWithStylesheet('Default.NUI')

  def on_load(app, options)
    @nui = NUIAppearance.init
    open CalculatorScreen.new(nav_bar: false)
  end
end
