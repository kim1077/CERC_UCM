model Test_Pipe 
  
  replaceable package Medium = 
      Modelica.Media.Water.ConstantPropertyLiquidWater;
  annotation (Diagram);
  Modelica_Fluid.Sources.FixedBoundary Sink(
    redeclare package Medium = Medium,
    T=293,
    p=3e5)       annotation (extent=[78,-2; 58,18]);
  Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM(
    redeclare package Medium = Medium, frictionType=Modelica_Fluid.Types.FrictionTypes.DetailedFriction) 
                               annotation (extent=[16,-2; 36,18]);
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR1(
    T=273 + 16,
    m_flow=1,
    redeclare package Medium = Medium) 
    annotation (extent=[-36,-1; -16,19]);
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    offset=10,
    height=-10*1) annotation (extent=[-77,7; -61,23]);
equation 
  connect(fixedResistanceDpM.port_b, Sink.port) annotation (points=[36,8;
        58,8], style(color=69, rgbcolor={0,127,255}));
  connect(ramp1.y, FMFR1.m_flow_in) annotation (points=[-60.2,15; -35.3,15],
      style(color=74, rgbcolor={0,0,127}));
  connect(FMFR1.port, fixedResistanceDpM.port_a) annotation (points=[-16,9;
        -5,9; -5,8; 16,8], style(color=69, rgbcolor={0,127,255}));
end Test_Pipe;
