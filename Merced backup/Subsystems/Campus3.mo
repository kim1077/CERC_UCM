model Campus3 
  
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram,
    Icon(          Text(
        extent=[-52,114; 46,66],
        style(color=3, rgbcolor={0,0,255}),
        string="%name"),
      Bitmap(extent=[-100,118; 100,-100],name="campus.JPG"),
      Line(points=[-38,-10; 88,64], style(
          color=3,
          rgbcolor={0,0,255},
          arrow=1))));
  Modelica_Fluid.Pipes.LumpedPipe pipe(
    redeclare package WallFriction = 
        Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.NoFriction,
    diameter=24*0.0254,
    redeclare package Medium = Medium,
    T_start=(65 - 32)*5/9 + 273.15,
    initType=Modelica_Fluid.Types.Init.InitialValues,
    length=100)                        annotation (extent=[20,7; 36,-7]);
  Modelica.Thermal.HeatTransfer.PrescribedHeatFlow prescribedHeatFlow 
    annotation (extent=[21,-22; 35,-12],rotation=90);
  Modelica.Blocks.Math.Gain gain(k=1.75e3) 
    annotation (extent=[50,-72; 44,-64]);
  Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM(
    m_flow(start=150),
    dp(start=60*12*0.0254*995*9.81),
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    redeclare package Medium = Medium,
    dp_nominal=(80*12*0.0254)*9.81*995/2,
    m_flow_nominal=(3125*3.78*0.001/60)*995) 
                        annotation (extent=[-3,-5; 8,5]);
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-80,40; -60,60]);
  Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM1(
    m_flow(start=150),
    dp(start=60*12*0.0254*995*9.81),
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    redeclare package Medium = Medium,
    dp_nominal=80*12*0.0254*9.81*995/2,
    m_flow_nominal=(3125*3.78*0.001/60)*995) 
                        annotation (extent=[43,-5; 54,5]);
  Components.BuildingLoad COB(
    timeSeriesLength=24*3600,
    tableName="LoadData",
    directoryName=
        "S:\\Carrier\\15_IBECS\\HiPerBric\\SeedProjects\\MPC\\Data\\Loads\\Loads2.mat") 
    annotation (extent=[96,-62; 76,-42]);
  Components.BuildingLoad Library(
    timeSeriesLength=24*3600,
    tableName="LoadData",
    directoryName=
        "S:\\Carrier\\15_IBECS\\HiPerBric\\SeedProjects\\MPC\\Data\\Loads\\Loads2.mat",
    cols={3}) 
    annotation (extent=[96,-74; 76,-54]);
  
  Components.BuildingLoad SE(
    timeSeriesLength=24*3600,
    tableName="LoadData",
    directoryName=
        "S:\\Carrier\\15_IBECS\\HiPerBric\\SeedProjects\\MPC\\Data\\Loads\\Loads2.mat",
    cols={4}) 
    annotation (extent=[96,-88; 76,-68]);
  
  Modelica.Blocks.Math.Add3 add3_1(k3=+1) 
                                   annotation (extent=[64,-72; 56,-64]);
  Modelica.Blocks.Math.Gain Cp(k=4.3e3) 
    annotation (extent=[-11,-54; -17,-46], rotation=0);
  Modelica.Blocks.Math.Division division 
    annotation (extent=[-17,-40; -26,-30], rotation=90);
  Modelica.Blocks.Sources.Constant delta_T(k=(60 - 39)*5/9) 
    annotation (extent=[10,-55; -4,-45]);
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=200, uMin=2) 
    annotation (extent=[-26,-24; -18,-14], rotation=90);
  Modelica_Fluid.Interfaces.FluidPort_a CHWS(redeclare package Medium = 
        Medium) 
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-120,-10; -100,10]);
  Modelica_Fluid.Interfaces.FluidPort_b CHWR(redeclare package Medium = 
        Medium) 
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (extent=[100,-10; 120,10]);
  Modelica.Blocks.Interfaces.RealOutput m_flow 
    annotation (extent=[100,-54; 126,-26]);
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=1e7, uMin=0.01*1e7) 
    annotation (extent=[30,-71; 22,-64],   rotation=0);
equation 
  connect(pipe.thermalPort, prescribedHeatFlow.port) annotation (points=[28,-3.78;
        28,-12],        style(color=42, rgbcolor={191,0,0}));
  connect(delta_T.y, Cp.u) annotation (points=[-4.7,-50; -10.4,-50], style(
        color=74, rgbcolor={0,0,127}));
  connect(Cp.y, division.u2) annotation (points=[-17.3,-50; -26,-50; -26,
        -41; -24.2,-41], style(color=74, rgbcolor={0,0,127}));
  connect(Library.q[1], add3_1.u2) annotation (points=[75,-63.8; 70.5,-63.8;
        70.5,-68; 64.8,-68], style(color=74, rgbcolor={0,0,127}));
  connect(COB.q[1], add3_1.u1) annotation (points=[75,-51.8; 75,-59.9; 64.8,
        -59.9; 64.8,-64.8], style(color=74, rgbcolor={0,0,127}));
  connect(SE.q[1], add3_1.u3) annotation (points=[75,-77.8; 75,-75.9; 64.8,
        -75.9; 64.8,-71.2], style(color=74, rgbcolor={0,0,127}));
  connect(add3_1.y, gain.u) annotation (points=[55.6,-68; 50.6,-68], style(
        color=74, rgbcolor={0,0,127}));
  connect(division.y, limiter.u) annotation (points=[-21.5,-29.5; -21.5,
        -25.75; -22,-25.75; -22,-25], style(color=74, rgbcolor={0,0,127}));
  connect(fixedResistanceDpM1.port_b, CHWR) annotation (points=[54,0; 110,0],
                          style(color=69, rgbcolor={0,127,255}));
  connect(limiter.y, m_flow) annotation (points=[-22,-13.5; 38,-13.5; 38,
        -40; 113,-40], style(color=74, rgbcolor={0,0,127}));
  connect(fixedResistanceDpM.port_a, CHWS) annotation (points=[-3,0; -110,0],
                            style(color=69, rgbcolor={0,127,255}));
  connect(fixedResistanceDpM.port_b, pipe.port_a) annotation (points=[8,0; 14,0;
        14,-8.88178e-016; 20,-8.88178e-016],       style(color=69, rgbcolor=
         {0,127,255}));
  connect(pipe.port_b, fixedResistanceDpM1.port_a) annotation (points=[36,
        -8.88178e-016; 40,-8.88178e-016; 40,0; 43,0], style(color=69,
        rgbcolor={0,127,255}));
  connect(limiter1.u, gain.y) annotation (points=[30.8,-67.5; 36,-67.5; 36,
        -68; 43.7,-68], style(color=74, rgbcolor={0,0,127}));
  connect(limiter1.y, prescribedHeatFlow.Q_flow) annotation (points=[21.6,
        -67.5; 21.6,-45.75; 28,-45.75; 28,-22], style(color=74, rgbcolor={0,
          0,127}));
  connect(limiter1.y, division.u1) annotation (points=[21.6,-67.5; 13.8,
        -67.5; 13.8,-41; -18.8,-41], style(color=74, rgbcolor={0,0,127}));
end Campus3;
