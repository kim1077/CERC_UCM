within Merced.ZeroFlow;
model Test_Campus
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  Modelica_Fluid.Sources.FixedBoundary Source(
    use_T=true,
    redeclare package Medium = MediumCHW,
    p=101325,
    T=273.15 + (39 - 32)*5/9)
           annotation (Placement(transformation(extent={{-76,56},{-56,76}},
          rotation=0)));
  inner Modelica_Fluid.Ambient ambient
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}}, rotation=
           0)));
  Modelica_Fluid.Sources.FixedBoundary Sink(
    use_T=true,
    T=293,
    redeclare package Medium = MediumCHW,
    p=2e5) annotation (Placement(transformation(extent={{72,62},{52,82}},
          rotation=0)));
  Components.PrescribedFlow_Pump CHWS_Secondary_Pump(
    N_nom=1180,
    redeclare package Medium = MediumCHW,
    a={208542.283151189,205771.962392144,-1518335.08994192},
    b={0.0857970011564655,6.68960721072079,-14.2474444944515},
    qNorMin_flow=0.101276367798246,
    qNorMax_flow=0.303829103394737,
    m_flow_const=10) "P-3: Bell& Gossett HSC3-101212XL"
    annotation (Placement(transformation(extent={{-42,60},{-30,72}}, rotation=0)));
  Subsystems.Campus2 campus(
                           redeclare package Medium = MediumCHW)
    annotation (Placement(transformation(extent={{-24,60},{-8,75}}, rotation=0)));
  Modelica.Blocks.Math.Gain gain(k=140)
    annotation (Placement(transformation(extent={{-44,84},{-38,92}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp y(
    duration=10,
    startTime=10,
    offset=1,
    height=-0.9999)
                 annotation (Placement(transformation(extent={{-74,84},{-62,92}},
          rotation=0)));
equation
  connect(gain.y,CHWS_Secondary_Pump. m_flow_in) annotation (Line(points={{
          -37.7,88},{-34,88},{-34,71.4},{-34.2,71.4}}, color={0,0,127}));
  connect(CHWS_Secondary_Pump.port_b, campus.CHWS) annotation (Line(points={{
          -30,66},{-27.4,66},{-27.4,65.85},{-24.8,65.85}}, color={0,127,255}));
  connect(CHWS_Secondary_Pump.port_a, Source.port) annotation (Line(points={{
          -42,66},{-56,66}}, color={0,127,255}));
  connect(campus.CHWR, Sink.port) annotation (Line(points={{-7.04,72},{52,72}},
        color={0,127,255}));
  connect(y.y, gain.u) annotation (Line(points={{-61.4,88},{-44.6,88}}, color={
          0,0,127}));
  annotation (uses(Modelica_Fluid(version="1.0 Beta 2")), Diagram(graphics));
end Test_Campus;
