model Test_Pump 
  
  replaceable package Medium = 
      Modelica.Media.Water.ConstantPropertyLiquidWater;
  annotation (Diagram);
  Components.PrescribedSpeed_Pump speedpump(
    redeclare package Medium = Medium,
    a={265534.776168551,157317.088939285,-1045931.5671727},
    b={-0.0734399353605566,5.1386797187811,-7.20622906783169},
    qNorMin_flow=0.104332257676433,
    qNorMax_flow=0.422067104450367) annotation (extent=[-16,-2; 4,18]);
  Modelica_Fluid.Sources.FixedBoundary Source(
    redeclare package Medium = Medium,
    p=3e5,
    T=293) annotation (extent=[-54,-2; -34,18]);
  Modelica_Fluid.Sources.FixedBoundary Sink(
    redeclare package Medium = Medium,
    T=293,
    p=3e5 + (60*12*0.0254*995*9.81)) 
                 annotation (extent=[60,-2; 40,18]);
  Modelica.Blocks.Sources.Constant const(k=1180) 
                                         annotation (extent=[-34,26; -20,36]);
  Components.PrescribedFlow_Pump flowpump(
    redeclare package Medium = Medium,
    a={265534.776168551,157317.088939285,-1045931.5671727},
    b={-0.0734399353605566,5.1386797187811,-7.20622906783169},
    qNorMin_flow=0.104332257676433,
    qNorMax_flow=0.422067104450367) annotation (extent=[-18,-46; 2,-26]);
  Modelica.Blocks.Sources.Constant const1(k=150) 
                                         annotation (extent=[-24,-20; -10,
        -14]);
  Modelica_Fluid.Sources.FixedBoundary Source1(
    redeclare package Medium = Medium,
    p=3e5,
    T=293) annotation (extent=[-58,-72; -38,-52]);
  Modelica_Fluid.Sources.FixedBoundary Sink1(
    redeclare package Medium = Medium,
    T=293,
    p=3e5)       annotation (extent=[56,-72; 36,-52]);
  Buildings.Fluids.FixedResistances.FixedResistanceDpM fixedResistanceDpM(
    redeclare package Medium = Medium,
    m0_flow=150,
    dp0=60*12*0.0254*995*9.81) annotation (extent=[4,-72; 24,-52]);
  Components.PrescribedPressure_Pump pressurepump(
    redeclare package Medium = Medium,
    a={265534.776168551,157317.088939285,-1045931.5671727},
    b={-0.0734399353605566,5.1386797187811,-7.20622906783169},
    qNorMin_flow=0.104332257676433,
    qNorMax_flow=0.422067104450367,
    dp_const=3e4)                   annotation (extent=[-24,-72; -4,-52]);
  Modelica.Blocks.Sources.Constant const2(k=10e4) 
                                         annotation (extent=[-36,-52; -22,
        -46]);
equation 
  connect(Source.port, speedpump.port_a) 
    annotation (points=[-34,8; -16,8], style(color=69, rgbcolor={0,127,255}));
  connect(Sink.port, speedpump.port_b) 
    annotation (points=[40,8; 4,8], style(color=69, rgbcolor={0,127,255}));
  connect(const.y, speedpump.N_in)             annotation (points=[-19.3,31;
        -2.65,31; -2.65,17; -3,17],    style(color=74, rgbcolor={0,0,127}));
  connect(flowpump.port_b, Sink.port) annotation (points=[2,-36; 22,-36; 22,8; 40,
        8], style(color=69, rgbcolor={0,127,255}));
  connect(flowpump.port_a, Source.port) annotation (points=[-18,-36; -26,
        -36; -26,8; -34,8], style(color=69, rgbcolor={0,127,255}));
  connect(const1.y, flowpump.m_flow_in) annotation (points=[-9.3,-17; -9.3,
        -17.5; -5,-17.5; -5,-27], style(color=74, rgbcolor={0,0,127}));
  connect(pressurepump.port_b, fixedResistanceDpM.port_a) annotation (
      points=[-4,-62; 4,-62], style(color=69, rgbcolor={0,127,255}));
  connect(fixedResistanceDpM.port_b, Sink1.port) annotation (points=[24,-62;
        36,-62], style(color=69, rgbcolor={0,127,255}));
  connect(pressurepump.port_a, Source1.port) annotation (points=[-24,-62;
        -38,-62], style(color=69, rgbcolor={0,127,255}));
  connect(const2.y, pressurepump.dp_in) annotation (points=[-21.3,-49; -10.65,
        -49; -10.65,-53; -11,-53],        style(color=74, rgbcolor={0,0,127}));
end Test_Pump;
