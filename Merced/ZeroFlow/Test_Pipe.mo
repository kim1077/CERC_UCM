within Merced.ZeroFlow;
model Test_Pipe
  replaceable package Medium =
      Modelica.Media.Water.ConstantPropertyLiquidWater;
  Modelica_Fluid.Sources.FixedBoundary Sink(
    redeclare package Medium = Medium,
    T=293,
    p=3e5)       annotation (Placement(transformation(extent={{78,-2},{58,18}},
          rotation=0)));
  Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM(
    redeclare package Medium = Medium, frictionType=Modelica_Fluid.Types.FrictionTypes.DetailedFriction)
                               annotation (Placement(transformation(extent={{16,
            -2},{36,18}}, rotation=0)));
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR1(
    T=273 + 16,
    m_flow=1,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-36,-1},{-16,19}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    offset=10,
    height=-10*1) annotation (Placement(transformation(extent={{-77,7},{-61,23}},
          rotation=0)));
equation
  connect(fixedResistanceDpM.port_b, Sink.port) annotation (Line(points={{36,8},
          {58,8}}, color={0,127,255}));
  connect(ramp1.y, FMFR1.m_flow_in) annotation (Line(points={{-60.2,15},{-35.3,
          15}}, color={0,0,127}));
  connect(FMFR1.port, fixedResistanceDpM.port_a) annotation (Line(points={{-16,
          9},{-5,9},{-5,8},{16,8}}, color={0,127,255}));
  annotation (Diagram(graphics));
end Test_Pipe;
