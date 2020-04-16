model Test_Campus 
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  
  annotation (uses(Modelica_Fluid(version="1.0 Beta 2")), Diagram);
  
  Modelica_Fluid.Sources.FixedBoundary Source(
    use_T=true,
    redeclare package Medium = MediumCHW,
    p=101325,
    T=273.15 + (39 - 32)*5/9) 
           annotation (extent=[-76,56; -56,76]);
  inner Modelica_Fluid.Ambient ambient 
    annotation (extent=[-60,-80; -40,-60]);
  Modelica_Fluid.Sources.FixedBoundary Sink(
    use_T=true,
    T=293,
    redeclare package Medium = MediumCHW,
    p=2e5) annotation (extent=[72,62; 52,82]);
  Components.PrescribedFlow_Pump CHWS_Secondary_Pump(
    N_nom=1180,
    redeclare package Medium = MediumCHW,
    a={208542.283151189,205771.962392144,-1518335.08994192},
    b={0.0857970011564655,6.68960721072079,-14.2474444944515},
    qNorMin_flow=0.101276367798246,
    qNorMax_flow=0.303829103394737,
    m_flow_const=10) "P-3: Bell& Gossett HSC3-101212XL" 
    annotation (extent=[-42,60; -30,72]);
  Subsystems.Campus2 campus(
                           redeclare package Medium = MediumCHW) 
    annotation (extent=[-24,60; -8,75]);
  Modelica.Blocks.Math.Gain gain(k=140) 
    annotation (extent=[-44,84; -38,92]);
  Modelica.Blocks.Sources.Ramp y(
    duration=10,
    startTime=10,
    offset=1,
    height=-0.9999) 
                 annotation (extent=[-74,84; -62,92]);
equation 
  connect(gain.y,CHWS_Secondary_Pump. m_flow_in) annotation (points=[-37.7,88;
        -34,88; -34,71.4; -34.2,71.4],      style(color=74, rgbcolor={0,0,
          127}));
  connect(CHWS_Secondary_Pump.port_b, campus.CHWS) annotation (points=[-30,
        66; -27.4,66; -27.4,65.85; -24.8,65.85], style(color=69, rgbcolor={
          0,127,255}));
  connect(CHWS_Secondary_Pump.port_a, Source.port) annotation (points=[-42,
        66; -56,66], style(color=69, rgbcolor={0,127,255}));
  connect(campus.CHWR, Sink.port) annotation (points=[-7.04,72; 52,72],
      style(color=69, rgbcolor={0,127,255}));
  connect(y.y, gain.u) annotation (points=[-61.4,88; -44.6,88], style(color=
         74, rgbcolor={0,0,127}));
end Test_Campus;
