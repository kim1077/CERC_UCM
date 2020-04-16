model TankMBw "thermal energy storage tank with weather input" 
  
  annotation (Diagram, Icon(
      Ellipse(extent=[-60,-40; 60,-80], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=1,
          fillColor=68,
          rgbfillColor={170,213,255})),
      Ellipse(extent=[-60,80; 60,40], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=1,
          fillColor=1,
          rgbfillColor={255,0,0})),
      Rectangle(extent=[-60,60; 60,-60], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=1,
          fillColor=68,
          rgbfillColor={170,213,255})),
      Ellipse(extent=[-60,32; 60,-8], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=1,
          fillColor=1,
          rgbfillColor={255,0,0})),
      Rectangle(extent=[-60,60; 58,14], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=1,
          fillColor=1,
          rgbfillColor={255,0,0})),
      Text(
        extent=[-32,-22; 34,-58],
        style(color=3, rgbcolor={0,0,255}),
        string="Node B"),
      Text(
        extent=[-32,54; 34,18],
        style(color=3, rgbcolor={0,0,255}),
        string="Node A"),
      Text(
        extent=[-112,54; -40,28],
        style(color=3, rgbcolor={0,0,255}),
        string="w"),
      Text(
        extent=[54,58; 92,28],
        style(color=3, rgbcolor={0,0,255}),
        string="z"),
      Text(
        extent=[54,-14; 92,-44],
        style(color=3, rgbcolor={0,0,255}), 
        string="T")));
  Modelica_Fluid.Interfaces.FluidPort_a PortA(redeclare package Medium = Medium) 
    annotation (extent=[-10,70; 10,90]);
  Modelica_Fluid.Interfaces.FluidPort_a PortB(redeclare package Medium = Medium) 
    annotation (extent=[-10,-88; 10,-68]);
  TankMB tankMB(
    redeclare package Medium = Medium,
    Radius=60*12*0.0254,
    h_startA=h_startA,
    T_startA=T_startA,
    T_startB=T_startB,
    h_startB=h_startB,
    X_startA=X_startA,
    X_startB=X_startB,
    tauJet=2)   annotation (extent=[-36,-33; 36,43]);
  Modelica.Blocks.Routing.ExtractSignal extractSignal(
    nin=Nw,
    nout=1,
    extract={1}) 
    annotation (extent=[-58,42; -38,62]);
  Modelica.Blocks.Interfaces.RealInput w[Nw] "weather" 
    annotation (extent=[-80,10; -60,30]);
  extends BaseClasses.StartParameter;
  parameter Integer Nw=4 "dimension of weather bus";
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  Modelica.Blocks.Interfaces.RealOutput z[2] "tank height" 
    annotation (extent=[60,10; 80,30]);
  Modelica.Blocks.Interfaces.RealOutput T1[2] annotation (extent=[60,-18; 80,2]);
equation 
  connect(tankMB.PortA, PortA) 
    annotation (points=[0,34.64; 0,80], style(color=69, rgbcolor={0,127,255}));
  connect(tankMB.PortB, PortB) annotation (points=[0,-25.4; 0,-78], style(color=
         69, rgbcolor={0,127,255}));
  connect(extractSignal.u,w) 
    annotation (points=[-60,52; -70,52; -70,20; -70,20],
                                          style(color=74, rgbcolor={0,0,127}));
  connect(extractSignal.y[1], tankMB.Tamb) annotation (points=[-37,52; -29.18,
        52; -29.18,20.2; -26.28,20.2], style(color=74, rgbcolor={0,0,127}));
  connect(z, z) 
    annotation (points=[70,20; 70,20], style(color=74, rgbcolor={0,0,127}));
  connect(tankMB.z, z) annotation (points=[25.2,20.2; 42.6,20.2; 42.6,20; 70,20],
      style(color=74, rgbcolor={0,0,127}));
  connect(tankMB.T, T1) annotation (points=[25.2,-7.16; 45.6,-7.16; 45.6,-8; 70,
        -8], style(color=74, rgbcolor={0,0,127}));
end TankMBw;
