within Merced.Examples;
model Test_Campus
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  Modelica_Fluid.Sources.FixedBoundary Source(
    use_T=true,
    T=293,
    redeclare package Medium = MediumCHW,
    p=101325)
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
  Subsystems.Campus campus(redeclare package Medium = MediumCHW)
    annotation (Placement(transformation(extent={{-24,60},{-8,75}}, rotation=0)));
  Modelica.Blocks.Sources.Pulse pulse1(
    period=86400,
    startTime=86400/2,
    amplitude=0.90,
    offset=0.1) annotation (Placement(transformation(extent={{-64,85},{-54,91}},
          rotation=0)));
  Modelica.Blocks.Math.Gain gain(k=140)
    annotation (Placement(transformation(extent={{-44,84},{-38,92}}, rotation=0)));
  Subsystems.ChillerPlant Chiller_Plant(
                  redeclare package MediumCHW = MediumCHW, redeclare package
      MediumCW =         MediumCHW)
    annotation (Placement(transformation(extent={{-22,-2},{-2,18}}, rotation=0)));
  Modelica_Fluid.Sources.FixedBoundary Source1(
    use_T=true,
    T=293,
    redeclare package Medium = MediumCHW,
    p=3e5) annotation (Placement(transformation(extent={{-76,-40},{-56,-20}},
          rotation=0)));
  Components.PrescribedFlow_Pump CHWS_Secondary_Pump1(
    N_nom=1180,
    redeclare package Medium = MediumCHW,
    a={208542.283151189,205771.962392144,-1518335.08994192},
    b={0.0857970011564655,6.68960721072079,-14.2474444944515},
    qNorMin_flow=0.101276367798246,
    qNorMax_flow=0.303829103394737,
    m_flow_const=10) "P-3: Bell& Gossett HSC3-101212XL"
    annotation (Placement(transformation(extent={{-42,-36},{-30,-24}}, rotation=
           0)));
  Subsystems.Campus2 campus1(
                           redeclare package Medium = MediumCHW)
    annotation (Placement(transformation(extent={{-24,-36},{-8,-21}}, rotation=
            0)));
  Modelica.Blocks.Sources.Pulse pulse2(
    period=86400,
    startTime=86400/2,
    amplitude=-1,
    offset=1)   annotation (Placement(transformation(extent={{-84,-11},{-74,-5}},
          rotation=0)));
  Modelica.Blocks.Math.Gain gain1(
                                 k=140)
    annotation (Placement(transformation(
        origin={-34,-18},
        extent={{4,-3},{-4,3}},
        rotation=90)));
  Modelica_Fluid.Sources.FixedBoundary Source2(
    use_T=true,
    T=293,
    redeclare package Medium = MediumCHW,
    p=3e5) annotation (Placement(transformation(extent={{-70,6},{-50,26}},
          rotation=0)));
  Modelica_Fluid.Sources.FixedBoundary Sink2(
    use_T=true,
    T=293,
    redeclare package Medium = MediumCHW,
    p=3e5) annotation (Placement(transformation(extent={{44,6},{24,26}},
          rotation=0)));
  Components.PrescribedFlow_Pump CWS(
    N_nom=1180,
    redeclare package Medium = MediumCHW,
    a={208542.283151189,205771.962392144,-1518335.08994192},
    b={0.0857970011564655,6.68960721072079,-14.2474444944515},
    qNorMin_flow=0.101276367798246,
    qNorMax_flow=0.303829103394737,
    m_flow_const=10,
    scaQ_flow=2) "P-3: Bell& Gossett HSC3-101212XL"
    annotation (Placement(transformation(extent={{-42,22},{-30,10}}, rotation=0)));
  Modelica.Blocks.Math.Gain gain2(k=400)
    annotation (Placement(transformation(
        origin={-34,4},
        extent={{-4,-3},{4,3}},
        rotation=90)));
equation
  connect(pulse1.y,gain. u) annotation (Line(points={{-53.5,88},{-46,88},{-46,
          90},{-44,90},{-44,88},{-44.6,88}}, color={0,0,127}));
  connect(gain.y,CHWS_Secondary_Pump. m_flow_in) annotation (Line(points={{
          -37.7,88},{-34,88},{-34,71.4},{-34.2,71.4}}, color={0,0,127}));
  connect(CHWS_Secondary_Pump.port_b, campus.CHWS) annotation (Line(points={{
          -30,66},{-27.4,66},{-27.4,65.85},{-24.8,65.85}}, color={0,127,255}));
  connect(CHWS_Secondary_Pump.port_a, Source.port) annotation (Line(points={{
          -42,66},{-56,66}}, color={0,127,255}));
  connect(campus.CHWR, Sink.port) annotation (Line(points={{-7.04,72},{52,72}},
        color={0,127,255}));
  connect(gain1.y, CHWS_Secondary_Pump1.m_flow_in)
                                                 annotation (Line(points={{-34,
          -22.4},{-34,-24.6},{-34.2,-24.6}}, color={0,0,127}));
  connect(CHWS_Secondary_Pump1.port_b, campus1.CHWS) annotation (Line(points={{
          -30,-30},{-27.4,-30},{-27.4,-30.15},{-24.8,-30.15}}, color={0,127,255}));
  connect(CHWS_Secondary_Pump1.port_a, Source1.port) annotation (Line(points={{
          -42,-30},{-56,-30}}, color={0,127,255}));
  connect(campus1.CHWR, Chiller_Plant.CHWR) annotation (Line(points={{-7.04,-24},
          {14,-24},{14,2},{-1,2}}, color={0,127,255}));
  connect(Chiller_Plant.CHWS, CHWS_Secondary_Pump1.port_a) annotation (Line(
        points={{-23,2},{-48,2},{-48,-30},{-42,-30}}, color={0,127,255}));
  connect(Sink2.port, Chiller_Plant.CWS) annotation (Line(points={{24,16},{11.5,
          16},{11.5,14},{-1,14}}, color={0,127,255}));
  connect(gain1.u, pulse2.y) annotation (Line(points={{-34,-13.2},{-34,-8},{
          -73.5,-8}}, color={0,0,127}));
  connect(CWS.port_a, Source2.port) annotation (Line(points={{-42,16},{-50,16}},
        color={0,127,255}));
  connect(CWS.port_b, Chiller_Plant.CWR) annotation (Line(points={{-30,16},{
          -26.5,16},{-26.5,14},{-23,14}}, color={0,127,255}));
  connect(gain2.y, CWS.m_flow_in) annotation (Line(points={{-34,8.4},{-34,10.6},
          {-34.2,10.6}}, color={0,0,127}));
  connect(gain2.u, pulse2.y) annotation (Line(points={{-34,-0.8},{-34,-8},{
          -73.5,-8}}, color={0,0,127}));
  annotation (uses(Modelica_Fluid(version="1.0 Beta 2")), Diagram(graphics));
end Test_Campus;
