model dumbChiller 
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Fluid" 
                           annotation(choicesAllMatching, Dialog(tab="General",group="CW Fluid"));
  
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram,
    Icon(          Text(
        extent=[-52,114; 46,66],
        style(color=3, rgbcolor={0,0,255}),
        string="%name"), Rectangle(extent=[-86,62; 92,-72], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=30,
          rgbfillColor={215,215,215}))));
  Modelica_Fluid.Interfaces.FluidPort_a CHWS(redeclare package Medium = 
        Medium) 
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-120,-10; -100,10]);
  Modelica_Fluid.Interfaces.FluidPort_b CHWR(redeclare package Medium = 
        Medium) 
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (extent=[100,-10; 120,10]);
  Modelica_Fluid.Pipes.LumpedPipe pipe(
    redeclare package WallFriction = 
        Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.NoFriction,
    diameter=24*0.0254,
    redeclare package Medium = Medium,
    length=1)                          annotation (extent=[-12,5; 4,-9]);
  Modelica.Thermal.HeatTransfer.PrescribedHeatFlow prescribedHeatFlow 
    annotation (extent=[-11,-22; 3,-12],rotation=90);
  Modelica.Blocks.Math.Gain gain(k=4300) 
    annotation (extent=[-22,-62; -16,-54]);
  Modelica_Fluid.Sensors.Temperature T_CHWR(redeclare package Medium = 
        Medium)    annotation (extent=[-88,-9; -76,5]);
  Modelica.Blocks.Sources.Constant const(k=273.15 + (39 - 32)*5/9) 
    annotation (extent=[-76,-60; -62,-48]);
  Modelica_Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium = 
        Medium) annotation (extent=[-58,-10; -42,6]);
  Modelica.Blocks.Math.Add add(k2=-1) annotation (extent=[-48,-64; -36,-52]);
  Modelica.Blocks.Math.Product product 
    annotation (extent=[2,-40; -10,-26], rotation=90);
  Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM(
    m_flow(start=150),
    dp(start=60*12*0.0254*995*9.81),
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    dp_nominal=60*12*0.0254*9.81*995,
    m_flow_nominal=150,
    redeclare package Medium = Medium) 
                        annotation (extent=[-35,-7; -24,3]);
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-80,40; -60,60]);
equation 
  connect(CHWS, CHWS) 
                    annotation (points=[-110,0; -110,0],   style(color=69,
        rgbcolor={0,127,255}));
  connect(CHWR, CHWR) annotation (points=[110,0; 107,0; 107,0; 110,0],
      style(
      color=69,
      rgbcolor={0,127,255},
      arrow=1));
  connect(add.u1, const.y) annotation (points=[-49.2,-54.4; -53.6,-54.4;
        -53.6,-54; -61.3,-54], style(color=74, rgbcolor={0,0,127}));
  connect(prescribedHeatFlow.port, pipe.thermalPort) annotation (points=[-4,-12;
        -4,-8.89; -4,-5.78; -4,-5.78],      style(color=42, rgbcolor={191,0,
          0}));
  connect(product.y, prescribedHeatFlow.Q_flow) annotation (points=[-4,-25.3;
        -4,-26; -3,-24; -4,-24; -4,-22],        style(color=74, rgbcolor={0,
          0,127}));
  connect(product.u2, massFlowRate.m_flow) annotation (points=[-7.6,-41.4;
        -7.6,-46.7; -50,-46.7; -50,-10.8],
                                         style(color=74, rgbcolor={0,0,127}));
  connect(add.y, gain.u) annotation (points=[-35.4,-58; -22.6,-58], style(
        color=74, rgbcolor={0,0,127}));
  connect(T_CHWR.T, add.u2) annotation (points=[-82,-9.7; -82,-70; -49.2,
        -70; -49.2,-61.6],
                      style(color=74, rgbcolor={0,0,127}));
  connect(fixedResistanceDpM.port_a, pipe.port_a) annotation (points=[-35,-2;
        -18,-2; -18,-2; -12,-2],     style(color=69, rgbcolor={0,127,255}));
  connect(massFlowRate.port_b, fixedResistanceDpM.port_a) annotation (points=[-42,
        -2; -35,-2], style(color=69, rgbcolor={0,127,255}));
  connect(T_CHWR.port_b, massFlowRate.port_a) annotation (points=[-76,-2;
        -67,-2; -67,-2; -58,-2], style(color=69, rgbcolor={0,127,255}));
  connect(T_CHWR.port_a, CHWS) annotation (points=[-88,-2; -95.5,-2; -95.5,
        0; -103,0; -103,0; -110,0], style(color=69, rgbcolor={0,127,255}));
  connect(pipe.port_b, CHWR) annotation (points=[4,-2; 32,-2; 32,0; 60,0;
        60,0; 110,0], style(color=69, rgbcolor={0,127,255}));
  connect(product.u1, gain.y) annotation (points=[-0.4,-41.4; -0.4,-57.7;
        -15.7,-57.7; -15.7,-58], style(color=74, rgbcolor={0,0,127}));
end dumbChiller;
