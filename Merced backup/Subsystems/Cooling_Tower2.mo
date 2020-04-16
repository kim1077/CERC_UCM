model Cooling_Tower2 
  
Components.YorkCalc_PrescribedTemp tow1(
    TAirInWB0=273.15 + (68 - 32)*5/9,
    TApp0=(75 - 68)*5/9,
    TRan0=(85 - 75)*5/9,
    redeclare package Medium = Medium,
    mWat0_flow=5*(1735*3.785/60),
    PFan0=5*40*745.7)             annotation (extent=[-12,-10; 8,10]);
  
  Modelica.Blocks.Sources.Sine TOut(
    offset=298.15,
    freqHz=1/86400,
    amplitude=3) "Outside air temperature" 
                              annotation (extent=[-96,76; -80,90]);
    Modelica.Blocks.Sources.Constant phi(k=0.5) "Relative air humidity" 
      annotation (extent=[-2,62; -20,74]);
  Buildings.Utilities.Psychrometrics.WetBulbTemperature wetBulTem1(
      redeclare package Medium = Modelica.Media.Air.MoistAir) 
    "Model for wet bulb temperature" 
    annotation (extent=[-64,50; -44,70]);
    Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure" 
      annotation (extent=[-96,54; -80,66]);
  
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  //replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  
  Modelica_Fluid.PressureLosses.PressureDropPipe Pipe_CT(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    diameter=0.05,
    redeclare package Medium = Medium,
    length=1,
    from_dp=false,
    dp_nominal=1*995*9.81,
    m_flow_nominal=(2*3500*3.785*0.001/60)*995,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar) 
    annotation (extent=[22,-6; 36,6]);
  Modelica_Fluid.Interfaces.FluidPort_a CWR(redeclare package Medium = Medium) 
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-122,-10; -102,10]);
  Modelica_Fluid.Interfaces.FluidPort_b CWS(redeclare package Medium = Medium) 
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (extent=[102,-10; 122,10]);
  Modelica.Blocks.Sources.Pulse pulse(
    startTime=86400/2,
    amplitude=-0.90*0,
    period=86400,
    offset=273.15 + 25) 
                     annotation (extent=[-70,3; -54,13]);
  Modelica.Blocks.Math.Gain gain annotation (extent=[-44,1; -32,15]);
equation 
  connect(TOut.y, wetBulTem1.TDryBul) 
                                     annotation (points=[-79.2,83; -72,83;
        -72,68; -63,68],
                 style(color=74, rgbcolor={0,0,127}));
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
  connect(Pipe_CT.port_a, tow1.port_b) 
    annotation (points=[22,0; 8,0], style(color=69, rgbcolor={0,127,255}));
  connect(tow1.port_a, CWR) annotation (points=[-12,0; -112,0],
      style(color=69, rgbcolor={0,127,255}));
  connect(Pipe_CT.port_b, CWS)  annotation (points=[36,0; 112,0],
      style(color=69, rgbcolor={0,127,255}));
  connect(PAtm.y, wetBulTem1.p) annotation (points=[-79.2,60; -63,60], style(
        color=74, rgbcolor={0,0,127}));
  connect(phi.y, wetBulTem1.phi) annotation (points=[-20.9,68; -30,68; -30,
        67; -45,67],
                 style(color=74, rgbcolor={0,0,127}));
  connect(pulse.y, gain.u) annotation (points=[-53.2,8; -45.2,8], style(
        color=74, rgbcolor={0,0,127}));
  connect(gain.y, tow1.T_CWS_in) annotation (points=[-31.4,8; -14,8], style(
        color=74, rgbcolor={0,0,127}));
  connect(wetBulTem1.TWetBul, tow1.TAir) annotation (points=[-45,60; -30,60;
        -30,4; -14,4], style(color=3, rgbcolor={0,0,255}));
end Cooling_Tower2;
