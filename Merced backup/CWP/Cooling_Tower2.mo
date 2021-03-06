model Cooling_Tower2 
  
YorkCalc_PrescribedTemp2 tow(
    TAirInWB0=273.15 + (68 - 32)*5/9,
    TApp0=(75 - 68)*5/9,
    TRan0=(85 - 75)*5/9,
    redeclare package Medium = Medium,
    mWat0_flow=5*(1735*3.785/60),
    PFan0=5*40*745.7,
    Q_flow(nominal=-2E7, start=-3E7),
    dTMin=10)                     annotation (extent=[-12,-10; 8,10]);
  
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  //replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Real TAppMin=2 "Minimum Approach Temperature [K]";
  
  Modelica_Fluid.PressureLosses.PressureDropPipe Pipe_CT(
    diameter=0.05,
    redeclare package Medium = Medium,
    length=1,
    from_dp=false,
    dp_nominal=1*995*9.81,
    m_flow_nominal=(2*3500*3.785*0.001/60)*995,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    flowDirection=Modelica_Fluid.Types.FlowDirection.Unidirectional,
    m_flow(start=(2*3500*3.785*0.001/60)*995),
    dp(start=1*995*9.81)) 
    annotation (extent=[22,-6; 36,6]);
  Modelica_Fluid.Interfaces.FluidPort_a CWR(redeclare package Medium = Medium) 
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-117,-11; -97,9]);
  Modelica_Fluid.Interfaces.FluidPort_b CWS(redeclare package Medium = Medium) 
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (extent=[98,-10; 118,10]);
  Modelica.Blocks.Interfaces.RealInput Twb "weather data" 
    annotation (extent=[-138,60; -98,100]);
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
          fillPattern=1)),
      Text(extent=[66,50; 116,36], string="P")));
  Modelica.Blocks.Interfaces.RealInput Tref "CWS temperature set point" 
    annotation (extent=[-140,20; -100,60]);
  Modelica.Blocks.Interfaces.RealOutput P "power" 
    annotation (extent=[100,32; 120,52],   rotation=0);
equation 
  connect(Pipe_CT.port_a, tow.port_b) 
    annotation (points=[22,0; 8,0], style(color=69, rgbcolor={0,127,255}));
  connect(Pipe_CT.port_b, CWS) 
    annotation (points=[36,0; 108,0], style(color=69, rgbcolor={0,127,255}));
  connect(tow.P, P) annotation (points=[8.2,4; 52,4; 52,42; 110,42], style(
        color=74, rgbcolor={0,0,127}));
  connect(tow.TAir, Twb) annotation (points=[-14,4; -58,4; -58,80; -118,80],
      style(color=74, rgbcolor={0,0,127}));
  connect(Tref, tow.T_CWS_in) annotation (points=[-120,40; -68,40; -68,8; -14,8],
      style(color=74, rgbcolor={0,0,127}));
  connect(CWR, tow.port_a) annotation (points=[-107,-1; -59.5,-1; -59.5,0; -12,
        0], style(color=69, rgbcolor={0,127,255}));
end Cooling_Tower2;
