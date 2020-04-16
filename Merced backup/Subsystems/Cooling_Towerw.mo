model Cooling_Towerw 
  
Buildings.HeatExchangers.CoolingTowers.YorkCalc tow1(
    TAirInWB0=273.15 + (68 - 32)*5/9,
    TApp0=(75 - 68)*5/9,
    TRan0=(85 - 75)*5/9,
    redeclare package Medium = Medium,
    mWat0_flow=5*(1735*3.785/60),
    PFan0=5*40*745.7)             annotation (extent=[-12,-10; 8,10]);
  
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  //replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  
  Modelica_Fluid.PressureLosses.PressureDropPipe Pipe_CT(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    diameter=0.05,
    redeclare package Medium = Medium,
    length=1,
    from_dp=false,
    dp_nominal=1*995*9.81,
    m_flow_nominal=(2*3500*3.785*0.001/60)*995) 
    annotation (extent=[22,-6; 36,6]);
  Modelica_Fluid.Interfaces.FluidPort_a CWR(redeclare package Medium = Medium) 
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-122,-10; -102,10]);
  Modelica_Fluid.Interfaces.FluidPort_b CWS(redeclare package Medium = Medium) 
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (extent=[102,-10; 122,10]);
  inner Modelica_Fluid.Ambient ambient annotation (extent=[40,-40; 60,-20]);
  Modelica.Blocks.Routing.DeMultiplex3 deMultiplex3_1 
    annotation (extent=[10,70; 30,90]);
  Buildings.Utilities.Psychrometrics.WetBulbTemperature wetBulTem2(
      redeclare package Medium = Modelica.Media.Air.MoistAir) 
    "Model for wet bulb temperature" 
    annotation (extent=[40,68; 60,88]);
  Modelica.Blocks.Routing.ExtractSignal extractSignal(       nout=3,
    extract=1:3,
    nin=Nw) 
    annotation (extent=[-32,70; -12,90]);
  Modelica.Blocks.Interfaces.RealInput w[Nw] "weather data" 
    annotation (extent=[-140,60; -100,100]);
  Modelica.Blocks.Interfaces.RealInput Fair "fraction air flow rate" 
    annotation (extent=[-140,20; -100,60]);
  parameter Integer Nw=4 "dimension of weather bus";
  annotation (Diagram, Icon(
      Polygon(points=[-80,60; 80,60; 40,-80; -40,-80; -80,60], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=9,
          rgbfillColor={175,175,175})),
      Ellipse(extent=[-80,72; 0,62], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=9,
          rgbfillColor={175,175,175},
          fillPattern=1)),
      Ellipse(extent=[0,72; 80,62], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=9,
          rgbfillColor={175,175,175},
          fillPattern=1)),
      Line(points=[-60,100; -60,20], style(
          color=3,
          rgbcolor={0,0,255},
          pattern=3,
          arrow=2,
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1)),
      Rectangle(extent=[-100,6; 100,-6], style(
          pattern=0,
          thickness=2,
          arrow=2,
          fillColor=10,
          rgbfillColor={135,135,135},
          fillPattern=1)),
      Line(points=[-84,0; 84,0], style(
          color=1,
          rgbcolor={255,0,0},
          thickness=2,
          arrow=1,
          fillColor=1,
          rgbfillColor={255,0,0},
          fillPattern=1)),
      Line(points=[-20,100; -20,20], style(
          color=3,
          rgbcolor={0,0,255},
          pattern=3,
          arrow=2,
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1)),
      Line(points=[20,100; 20,20], style(
          color=3,
          rgbcolor={0,0,255},
          pattern=3,
          arrow=2,
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1)),
      Line(points=[60,100; 60,20], style(
          color=3,
          rgbcolor={0,0,255},
          pattern=3,
          arrow=2,
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1))));
equation 
  connect(Pipe_CT.port_a, tow1.port_b) 
    annotation (points=[22,0; 8,0], style(color=69, rgbcolor={0,127,255}));
  connect(tow1.port_a, CWR) annotation (points=[-12,0; -112,0],
      style(color=69, rgbcolor={0,127,255}));
  connect(Pipe_CT.port_b, CWS)  annotation (points=[36,0; 112,0],
      style(color=69, rgbcolor={0,127,255}));
  connect(wetBulTem2.TDryBul,deMultiplex3_1. y1[1]) annotation (points=[41,86;
        35,86; 35,87; 31,87], style(color=3, rgbcolor={0,0,255}));
  connect(wetBulTem2.p,deMultiplex3_1. y3[1]) annotation (points=[41,78; 36,78;
        36,73; 31,73], style(color=3, rgbcolor={0,0,255}));
  connect(deMultiplex3_1.y2[1],wetBulTem2. phi) annotation (points=[31,80; 44,
        80; 44,85; 59,85], style(color=74, rgbcolor={0,0,127}));
  connect(wetBulTem2.TWetBul, tow1.TAir) annotation (points=[59,78; 68,78; 68,
        40; -34,40; -34,4; -14,4],
                style(color=3, rgbcolor={0,0,255}));
  connect(extractSignal.y,deMultiplex3_1. u) 
    annotation (points=[-11,80; 8,80],  style(color=74, rgbcolor={0,0,127}));
  connect(extractSignal.u,w) 
    annotation (points=[-34,80; -120,80], style(color=74, rgbcolor={0,0,127}));
  connect(Fair, tow1.y) annotation (points=[-120,40; -68,40; -68,8; -14,8],
      style(color=74, rgbcolor={0,0,127}));
end Cooling_Towerw;
