model Campus2 
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Fluid" 
                           annotation(choicesAllMatching, Dialog(tab="General",group="CW Fluid"));
  
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram,
    Icon(          Text(
        extent=[-52,114; 46,66],
        style(color=3, rgbcolor={0,0,255}),
        string="%name"),
      Bitmap(extent=[-98,118; 102,-100], name="campus.JPG"),
      Line(points=[-38,-10; 88,64], style(
          color=3,
          rgbcolor={0,0,255},
          arrow=1))));
  Modelica_Fluid.Interfaces.FluidPort_a CHWS(redeclare package Medium = 
        Medium) 
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-120,-32; -100,-12]);
  Modelica_Fluid.Interfaces.FluidPort_b CHWR(redeclare package Medium = 
        Medium) 
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (extent=[102,50; 122,70]);
  Modelica_Fluid.Pipes.LumpedPipe pipe(
    redeclare package WallFriction = 
        Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.NoFriction,
    redeclare package Medium = Medium,
    T_start=(65 - 32)*5/9 + 273.15,
    initType=Modelica_Fluid.Types.Init.InitialValues,
    length=100,
    diameter=24*0.0254)                annotation (extent=[20,5; 36,-9]);
  Modelica.Thermal.HeatTransfer.PrescribedHeatFlow prescribedHeatFlow 
    annotation (extent=[21,-22; 35,-12],rotation=90);
  Modelica.Blocks.Math.Gain gain(k=4.3e3) 
    annotation (extent=[8,-58; 14,-50]);
  Modelica.Blocks.Sources.Constant const(k=273.15 + (65 - 32)*5/9) 
    annotation (extent=[-52,-63; -38,-51]);
  Modelica.Blocks.Math.Add add(k1=-1, k2=+1) 
                                      annotation (extent=[-18,-60; -6,-48]);
  Modelica.Blocks.Math.Product product 
    annotation (extent=[22,-42; 34,-28], rotation=90);
  Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM(
    m_flow(start=150),
    dp(start=60*12*0.0254*995*9.81),
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    redeclare package Medium = Medium,
    dp_nominal=(80*12*0.0254)*9.81*995/2,
    m_flow_nominal=(3125*3.78*0.001/60)*995) 
                        annotation (extent=[-77,-7; -66,3]);
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-80,40; -60,60]);
  Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM1(
    m_flow(start=150),
    dp(start=60*12*0.0254*995*9.81),
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    redeclare package Medium = Medium,
    dp_nominal=80*12*0.0254*9.81*995/2,
    m_flow_nominal=(3125*3.78*0.001/60)*995) 
                        annotation (extent=[65,-7; 76,3]);
  Modelica_Fluid.Sensors.Temperature T_CHWR(redeclare package Medium = 
        Medium)    annotation (extent=[-36,-9; -24,5]);
  Modelica_Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium = 
        Medium) annotation (extent=[-4,-10; 12,6]);
equation 
  connect(CHWS, CHWS) 
                    annotation (points=[-110,-22; -110,-22],
                                                           style(color=69,
        rgbcolor={0,127,255}));
  connect(CHWR, CHWR) annotation (points=[112,60; 107,60; 107,60; 112,60],
      style(
      color=69,
      rgbcolor={0,127,255},
      arrow=1));
  connect(fixedResistanceDpM1.port_b, CHWR) annotation (points=[76,-2; 82,
        -2; 82,60; 112,60],
                        style(color=69, rgbcolor={0,127,255}));
  connect(fixedResistanceDpM.port_a, CHWS) annotation (points=[-77,-2; -92,
        -2; -92,-22; -110,-22], style(color=69, rgbcolor={0,127,255}));
  connect(pipe.port_b, fixedResistanceDpM1.port_a) annotation (points=[36,-2;
        50.5,-2; 50.5,-2; 65,-2],     style(color=69, rgbcolor={0,127,255}));
  connect(prescribedHeatFlow.Q_flow, product.y) annotation (points=[28,-22; 28,
        -27.3],    style(color=74, rgbcolor={0,0,127}));
  connect(pipe.thermalPort, prescribedHeatFlow.port) annotation (points=[28,-5.78;
        28,-12],        style(color=42, rgbcolor={191,0,0}));
  connect(T_CHWR.T, add.u1) annotation (points=[-30,-9.7; -30,-49.85; -19.2,
        -49.85; -19.2,-50.4], style(color=74, rgbcolor={0,0,127}));
  connect(massFlowRate.port_b, pipe.port_a) annotation (points=[12,-2; 16,-2;
        16,-2; 20,-2],     style(color=69, rgbcolor={0,127,255}));
  connect(massFlowRate.port_a, T_CHWR.port_b) annotation (points=[-4,-2; -14,-2;
        -14,-2; -24,-2],         style(color=69, rgbcolor={0,127,255}));
  connect(T_CHWR.port_a, fixedResistanceDpM.port_b) annotation (points=[-36,-2;
        -51,-2; -51,-2; -66,-2],     style(color=69, rgbcolor={0,127,255}));
  connect(add.u2, const.y) annotation (points=[-19.2,-57.6; -28.6,-57.6;
        -28.6,-57; -37.3,-57], style(color=74, rgbcolor={0,0,127}));
  connect(gain.u, add.y) annotation (points=[7.4,-54; -5.4,-54], style(
        color=74, rgbcolor={0,0,127}));
  connect(gain.y, product.u2) annotation (points=[14.3,-54; 32,-54; 32,-43.4;
        31.6,-43.4],        style(color=74, rgbcolor={0,0,127}));
  connect(product.u1, massFlowRate.m_flow) annotation (points=[24.4,-43.4;
        24.4,-44.7; 4,-44.7; 4,-10.8], style(color=74, rgbcolor={0,0,127}));
end Campus2;
