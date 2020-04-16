within Merced.Examples;
model Test_ChillerPlant8c
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  inner Modelica_Fluid.Ambient ambient(default_p_ambient=101325)
                                       annotation (Placement(transformation(
          extent={{-80,-80},{-60,-60}}, rotation=0)));
  Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW =
        MediumCW, redeclare package MediumCHW = MediumCHW)
    annotation (Placement(transformation(extent={{0,16},{-20,36}}, rotation=0)));
  Subsystems.Cooling_Tower3w cooling_Tower(
                                         redeclare package Medium = MediumCW)
                  annotation (Placement(transformation(extent={{-20,46},{0,66}},
          rotation=0)));
  Components.TankMBw tankMB(
    redeclare package Medium = MediumCHW,
    h_startA=(85*12*0.0254) - 3,
    h_startB=3,
    T_startB=273.15 + (41 - 32)*5/9,
    T_startA=273.15 + (65 - 32)*5/9)
                         annotation (Placement(transformation(extent={{-28,-24},
            {-2,2}}, rotation=0)));
  Modelica_Fluid.PressureLosses.PressureDropPipe CHWS_Pipe(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    diameter=24*0.0254,
    redeclare package Medium = MediumCHW,
    from_dp=false,
    length=100,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    dp_nominal=(60*12*0.0254)
                            *995*9.81,
    m_flow_nominal=(3750*3.785*0.001/60)*995)
    annotation (Placement(transformation(
        origin={18,-2},
        extent={{6,-7},{-6,7}},
        rotation=90)));
  Modelica_Fluid.Junctions.Splitter CHWS_splitter(redeclare package Medium =
        MediumCHW) annotation (Placement(transformation(
        origin={17.5,-22},
        extent={{-4,4.5},{4,-4.5}},
        rotation=270)));
  Modelica_Fluid.Junctions.Splitter CHWR_splitter(redeclare package Medium =
        MediumCHW) annotation (Placement(transformation(
        origin={-43,0},
        extent={{-4,-5},{4,5}},
        rotation=270)));
  Modelica_Fluid.PressureLosses.PressureDropPipe CWR_Pipe(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    redeclare package Medium = MediumCW,
    length=50*12*0.0254,
    diameter=24*0.0254,
    from_dp=false,
    dp_nominal=(52*12*0.0254)*995*9.81,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    m_flow_nominal=(2*3500*3.785*0.001/60)*995)
    annotation (Placement(transformation(
        origin={-30,42},
        extent={{-6,-7},{6,7}},
        rotation=90)));
  Components.PrescribedFlow_Pump CHWR_Primary_Pump(
    N_nom=1180,
    redeclare package Medium = MediumCHW,
    a=P1_a,
    b=P1_b,
    qNorMin_flow=P1_qNorMin_flow,
    qNorMax_flow=P1_qNorMax_flow) "P-1: Bell& Gossett HSC3-101212XL"
    annotation (Placement(transformation(extent={{-38,12},{-26,24}}, rotation=0)));
  parameter Real[:] P1_a = {208542.283151189,205771.962392144,-1518335.08994192}
    "Polynomial coefficients for pump 1";
  parameter Real[:] P1_b = {0.0857970011564655,6.68960721072079,-14.2474444944515}
    "Polynomial coefficients for pump 1";
  parameter Real P1_qNorMin_flow = 0.101276367798246;
  parameter Real P1_qNorMax_flow = 0.303829103394737;
  Components.PrescribedFlow_Pump CHWS_Secondary_Pump(
    N_nom=1180,
    redeclare package Medium = MediumCHW,
    a={208542.283151189,205771.962392144,-1518335.08994192},
    b={0.0857970011564655,6.68960721072079,-14.2474444944515},
    qNorMin_flow=0.101276367798246,
    qNorMax_flow=0.303829103394737,
    m_flow_const=10) "P-3: Bell& Gossett HSC3-101212XL"
    annotation (Placement(transformation(extent={{6,-43},{-6,-55}}, rotation=0)));
  Subsystems.Campus4 campus(
                           redeclare package Medium = MediumCHW)
    annotation (Placement(transformation(extent={{-14,-56},{-30,-41}}, rotation=
           0)));
  Modelica_Fluid.Sources.FixedBoundary Boundary_fixed(
    p=3e5,
    T=293,
    redeclare package Medium = MediumCW) annotation (Placement(transformation(
          extent={{48,29},{38,39}}, rotation=0)));
  Modelica.Blocks.Math.Gain P1_m_flow_gain(k=135)
    annotation (Placement(transformation(extent={{-56,24},{-48,32}}, rotation=0)));
  Modelica.Blocks.Math.Gain P1_m_flow_gain1(k=560*5/6)
    annotation (Placement(transformation(extent={{50,46},{42,54}}, rotation=0)));
  ZeroFlow.m_flow2N m_flow2N1(
    q_flow_nom=(3500*2*3.785*0.001/60),
    a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
    qNorMin_flow=2*0.106858248388454,
    qNorMax_flow=2*0.399530088717547,
    scaQ_flow=2) annotation (Placement(transformation(extent={{34,46},{22,54}},
          rotation=0)));
  Components.PrescribedSpeed_Pump pump12(
    b={-0.1196,5.6074,-8.4305},
    a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
    redeclare package Medium = MediumCW,
    scaQ_flow=2,
    qNorMin_flow=2*0.106858248388454,
    qNorMax_flow=2*0.399530088717547) "Bell& Gossett HSCS 14x16x17 E"
                                annotation (Placement(transformation(extent={{
            26,28},{14,40}}, rotation=0)));
  Modelica.Blocks.Sources.CombiTimeTable weather(
    tableOnFile=true,
    columns=2:5,
    tableName="weather",
    fileName="D:\\Modelica\\Merced\\data.mat",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    startTime=-90.8*24*3600) annotation (Placement(transformation(extent={{-90,
            -14},{-74,-2}}, rotation=0)));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    offset=1,
    period=86400,
    startTime=86400/2,
    rising=3600,
    falling=3600,
    amplitude=-0.999999,
    width=60000)       annotation (Placement(transformation(extent={{-88,22},{
            -72,34}}, rotation=0)));
  Modelica.Blocks.Sources.Trapezoid trapezoid1(
    period=86400,
    startTime=86400/2,
    rising=3600,
    falling=3600,
    width=66000,
    amplitude=0,
    offset=292) annotation (Placement(transformation(extent={{-90,54},{-74,66}},
          rotation=0)));
equation
  connect(Chiller_Plant.CHWS, CHWS_Pipe.port_a)
                                               annotation (Line(points={{1,20},
          {18,20},{18,4}}, color={0,127,255}));
  connect(CHWS_Pipe.port_b, CHWS_splitter.port_1)
                                            annotation (Line(points={{18,-8},{
          18,-17.6},{17.5,-17.6}}, color={0,127,255}));
  connect(CHWS_splitter.port_3, tankMB.PortB)
                                         annotation (Line(points={{12.55,-22},{
          -14,-22},{-14,-21.14},{-15,-21.14}}, color={0,127,255}));
  connect(CHWR_splitter.port_3, tankMB.PortA)
                                          annotation (Line(points={{-37.5,
          2.69413e-16},{-16,2.69413e-16},{-16,-0.6},{-15,-0.6}}, color={0,127,
          255}));
  connect(CWR_Pipe.port_a, Chiller_Plant.CWS) annotation (Line(points={{-30,36},
          {-30,32},{-21,32}}, color={0,127,255}));
  connect(CHWR_Primary_Pump.port_b, Chiller_Plant.CHWR) annotation (Line(points=
         {{-26,18},{-23.5,18},{-23.5,20},{-21,20}}, color={0,127,255}));
  connect(CHWR_Primary_Pump.port_a, CHWR_splitter.port_1) annotation (Line(
        points={{-38,18},{-44,18},{-44,4.4},{-43,4.4}}, color={0,127,255}));
  connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (Line(
        points={{6,-49},{18,-49},{18,-26.4},{17.5,-26.4}}, color={0,127,255}));
  connect(campus.CHWS, CHWS_Secondary_Pump.port_b) annotation (Line(points={{
          -15.92,-48.5},{-10.6,-48.5},{-10.6,-49},{-6,-49}}, color={0,127,255}));
  connect(campus.CHWR, CHWR_splitter.port_2) annotation (Line(points={{-27.92,
          -48.5},{-44,-48.5},{-44,-4.4},{-43,-4.4}}, color={0,127,255}));
  connect(cooling_Tower.CWR, CWR_Pipe.port_b) annotation (Line(points={{-20.7,
          55.9},{-30,55.9},{-30,48}}, color={0,127,255}));
  connect(P1_m_flow_gain.y, CHWR_Primary_Pump.m_flow_in) annotation (Line(
        points={{-47.6,28},{-30,28},{-30,23.4},{-30.2,23.4}}, color={0,0,127}));
  connect(pump12.port_b, Chiller_Plant.CWR) annotation (Line(points={{14,34},{
          7.5,34},{7.5,32},{1,32}}, color={0,127,255}));
  connect(pump12.port_a, Boundary_fixed.port) annotation (Line(points={{26,34},
          {38,34}}, color={0,127,255}));
  connect(m_flow2N1.y, pump12.N_in) annotation (Line(points={{21.4,50},{18,50},
          {18,39.4},{18.2,39.4}}, color={0,0,127}));
  connect(m_flow2N1.u, P1_m_flow_gain1.y) annotation (Line(points={{34.6,50},{
          41.6,50}}, color={0,0,127}));
  connect(pump12.port_a, cooling_Tower.CWS) annotation (Line(points={{26,34},{
          26,56},{0.8,56}}, color={0,127,255}));
  connect(campus.m_flow, CHWS_Secondary_Pump.m_flow_in) annotation (Line(points=
         {{-28.16,-51.5},{-36,-51.5},{-36,-60},{-2,-60},{-2,-54.4},{-1.8,-54.4}},
        color={0,0,127}));
  connect(weather.y, tankMB.w) annotation (Line(points={{-73.2,-8},{-38,-8},{
          -38,-8.4},{-24.1,-8.4}}, color={0,0,127}));
  connect(cooling_Tower.w, weather.y) annotation (Line(points={{-21.8,64},{-48,
          64},{-48,-8},{-73.2,-8}}, color={0,0,127}));
  connect(trapezoid.y, P1_m_flow_gain.u) annotation (Line(points={{-71.2,28},{
          -56.8,28}}, color={0,0,127}));
  connect(P1_m_flow_gain1.u, trapezoid.y) annotation (Line(points={{50.8,50},{
          56,50},{56,74},{-66,74},{-66,28},{-71.2,28}}, color={0,0,127}));
  connect(trapezoid1.y, cooling_Tower.Tref) annotation (Line(points={{-73.2,60},
          {-22,60}}, color={0,0,127}));
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram(graphics));
end Test_ChillerPlant8c;
