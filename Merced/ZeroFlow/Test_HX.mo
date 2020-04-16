within Merced.ZeroFlow;
model Test_HX
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR1(
  redeclare package Medium = MediumCW,
    T=273 + 16,
    m_flow=1)
    annotation (Placement(transformation(extent={{-60,-25},{-40,-5}}, rotation=
            0)));
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR2(
  redeclare package Medium = MediumCHW,
    m_flow=1,
    T=273 + 20)
    annotation (Placement(transformation(extent={{76,-52},{56,-32}}, rotation=0)));
  Modelica_Fluid.Sources.PrescribedBoundary_pTX FixedBC1(
    redeclare package Medium = MediumCW,
    p=0,
    T=273 + 5)
    annotation (Placement(transformation(extent={{72,-22},{58,-8}}, rotation=0)));
  Modelica_Fluid.Sources.PrescribedBoundary_pTX FixedBC2(
    redeclare package Medium = MediumCHW,
    p=0,
    T=273 + 5)
    annotation (Placement(transformation(extent={{-58,-49},{-44,-35}}, rotation=
           0)));
  inner Modelica_Fluid.Ambient ambient annotation (Placement(transformation(
          extent={{-94,74},{-74,94}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    offset=10,
    height=-10*1) annotation (Placement(transformation(extent={{-92,-4},{-76,12}},
          rotation=0)));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    offset=10,
    height=-10*1) annotation (Placement(transformation(extent={{56,-80},{72,-64}},
          rotation=0)));
  Buildings.HeatExchangers.ConstantEffectiveness constantEffectiveness(redeclare
      package Medium_1 = MediumCW, redeclare package Medium_2 = MediumCHW)
    annotation (Placement(transformation(extent={{-4,-36},{16,-16}}, rotation=0)));
equation
  connect(ramp.y, FMFR1.m_flow_in) annotation (Line(points={{-75.2,4},{-68,4},{
          -68,-9},{-59.3,-9}}, color={0,0,127}));
  connect(ramp1.y, FMFR2.m_flow_in) annotation (Line(points={{72.8,-72},{86,-72},
          {86,-36},{75.3,-36}}, color={0,0,127}));
  connect(constantEffectiveness.port_b1, FixedBC1.port) annotation (Line(points=
         {{16,-20},{38,-20},{38,-15},{58,-15}}, color={0,127,255}));
  connect(constantEffectiveness.port_a2, FMFR2.port) annotation (Line(points={{
          16,-32},{36,-32},{36,-42},{56,-42}}, color={0,127,255}));
  connect(constantEffectiveness.port_b2, FixedBC2.port) annotation (Line(points=
         {{-4,-32},{-24,-32},{-24,-42},{-44,-42}}, color={0,127,255}));
  connect(constantEffectiveness.port_a1, FMFR1.port) annotation (Line(points={{
          -4,-20},{-22,-20},{-22,-15},{-40,-15}}, color={0,127,255}));
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram(graphics));
end Test_HX;
