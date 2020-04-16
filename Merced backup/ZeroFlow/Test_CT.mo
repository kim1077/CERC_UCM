model Test_CT 
  
Buildings.HeatExchangers.CoolingTowers.YorkCalc tow1(
    redeclare package Medium = Medium_W,
    TAirInWB0=273.15 + (68 - 32)*5/9,
    TApp0=(75 - 68)*5/9,
    TRan0=(85 - 75)*5/9,
    mWat0_flow=5*(1735*3.785/60),
    PFan0=5*40*745.7)             annotation (extent=[-12,-7; 8,13]);
  
  Modelica.Blocks.Sources.Ramp y(
    offset=1,
    startTime=1,
    duration=5,
    height=-1)   annotation (extent=[-52,4; -38,18]);
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-94,76; -74,96]);
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX CWS(redeclare package Medium
      = Medium_W,
    T=273.15 + (85 - 32)*5/9,
    m_flow=2*(3500*3.785/60)) 
    annotation (extent=[-54,-91; -34,-71]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sink(
    T=283.15,
    p=101325,
    redeclare package Medium = Medium_W) 
                          annotation (extent=[78,-73; 58,-53],
                                                             rotation=0);
  Modelica.Blocks.Sources.Constant TWat1(k=273.15 + (85 - 32)*5/9) 
    "Water temperature" 
    annotation (extent=[-94,-91; -74,-71]);
  Modelica.Blocks.Sources.Sine TOut1(
                                    amplitude=10, offset=293.15) 
    "Outside air temperature" annotation (extent=[-50,80; -30,100]);
    Modelica.Blocks.Sources.Constant phi1(
                                         k=0.5) "Relative air humidity" 
      annotation (extent=[10,76; 30,96]);
  Buildings.Utilities.Psychrometrics.WetBulbTemperature wetBulTem1(
      redeclare package Medium = Modelica.Media.Air.MoistAir) 
    "Model for wet bulb temperature" 
    annotation (extent=[-52,50; -32,70]);
    Modelica.Blocks.Sources.Constant PAtm1(
                                          k=101325) "Atmospheric pressure" 
      annotation (extent=[-92,50; -72,70]);
  
  replaceable package Medium_W = 
      Modelica.Media.Water.ConstantPropertyLiquidWater;
  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    offset=2*(3500*3.785/60),
    height=-0.999*2*(3500*3.785/60)) 
    annotation (extent=[-92,-56; -76,-40]);
equation 
  connect(TWat1.y, CWS.T_in)  annotation (points=[-73,-81; -56,-81],
                  style(color=74, rgbcolor={0,0,127}));
  connect(PAtm1.y, wetBulTem1.p) 
    annotation (points=[-71,60; -51,60], style(color=74, rgbcolor={0,0,127}));
  connect(TOut1.y, wetBulTem1.TDryBul) 
                                     annotation (points=[-29,90; -20,90;
        -20,68; -51,68],
                 style(color=74, rgbcolor={0,0,127}));
  connect(phi1.y, wetBulTem1.phi) 
                                annotation (points=[31,86; 48,86; 48,67;
        -33,67],
      style(color=74, rgbcolor={0,0,127}));
  annotation (Diagram);
  connect(y.y, tow1.y) annotation (points=[-37.3,11; -14,11], style(color=
          74, rgbcolor={0,0,127}));
  connect(tow1.port_a, CWS.port) annotation (points=[-12,3; -24,3; -24,-81;
        -34,-81], style(color=69, rgbcolor={0,127,255}));
  connect(tow1.TAir, wetBulTem1.TWetBul) annotation (points=[-14,7; -24,7;
        -24,60; -33,60], style(color=74, rgbcolor={0,0,127}));
  connect(sink.port, tow1.port_b) annotation (points=[58,-63; 58,3.5; 8,3.5;
        8,3], style(color=69, rgbcolor={0,127,255}));
  connect(ramp.y, CWS.m_flow_in) annotation (points=[-75.2,-48; -66,-48;
        -66,-75; -53.3,-75], style(color=74, rgbcolor={0,0,127}));
end Test_CT;
