within Merced.Examples;
model Test_ChillerPlant8d
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  inner Modelica_Fluid.Ambient ambient(default_p_ambient=101325)
                                       annotation (Placement(transformation(
          extent={{-80,-80},{-60,-60}}, rotation=0)));
  Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW =
        MediumCW, redeclare package MediumCHW = MediumCHW)
    annotation (Placement(transformation(extent={{38,18},{18,38}}, rotation=0)));
  Subsystems.Cooling_Tower3w cooling_Tower(
                                         redeclare package Medium = MediumCW)
                  annotation (Placement(transformation(extent={{18,48},{38,68}},
          rotation=0)));
  Components.TankMBw tankMB(
    redeclare package Medium = MediumCHW,
    h_startA=(85*12*0.0254) - 3,
    h_startB=3,
    T_startB=273.15 + (41 - 32)*5/9,
    T_startA=273.15 + (65 - 32)*5/9)
                         annotation (Placement(transformation(extent={{10,-22},
            {36,4}}, rotation=0)));
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
        origin={56,0},
        extent={{6,-7},{-6,7}},
        rotation=90)));
  Modelica_Fluid.Junctions.Splitter CHWS_splitter(redeclare package Medium =
        MediumCHW) annotation (Placement(transformation(
        origin={55.5,-20},
        extent={{-4,4.5},{4,-4.5}},
        rotation=270)));
  Modelica_Fluid.Junctions.Splitter CHWR_splitter(redeclare package Medium =
        MediumCHW) annotation (Placement(transformation(
        origin={-5,2},
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
        origin={8,44},
        extent={{-6,-7},{6,7}},
        rotation=90)));
  Components.PrescribedFlow_Pump CHWR_Primary_Pump(
    N_nom=1180,
    redeclare package Medium = MediumCHW,
    a=P1_a,
    b=P1_b,
    qNorMin_flow=P1_qNorMin_flow,
    qNorMax_flow=P1_qNorMax_flow) "P-1: Bell& Gossett HSC3-101212XL"
    annotation (Placement(transformation(extent={{0,14},{12,26}}, rotation=0)));
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
    annotation (Placement(transformation(extent={{44,-41},{32,-53}}, rotation=0)));
  Subsystems.Campus4 campus(
                           redeclare package Medium = MediumCHW)
    annotation (Placement(transformation(extent={{24,-54},{8,-39}}, rotation=0)));
  Modelica_Fluid.Sources.FixedBoundary Boundary_fixed(
    p=3e5,
    T=293,
    redeclare package Medium = MediumCW) annotation (Placement(transformation(
          extent={{86,31},{76,41}}, rotation=0)));
  Modelica.Blocks.Math.Gain P1_m_flow_gain(k=135)
    annotation (Placement(transformation(extent={{-18,26},{-10,34}}, rotation=0)));
  Modelica.Blocks.Math.Gain P1_m_flow_gain1(k=560*4/6)
    annotation (Placement(transformation(extent={{88,48},{80,56}}, rotation=0)));
  ZeroFlow.m_flow2N m_flow2N1(
    q_flow_nom=(3500*2*3.785*0.001/60),
    a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
    qNorMin_flow=2*0.106858248388454,
    qNorMax_flow=2*0.399530088717547,
    scaQ_flow=2) annotation (Placement(transformation(extent={{72,48},{60,56}},
          rotation=0)));
  Components.PrescribedSpeed_Pump pump12(
    b={-0.1196,5.6074,-8.4305},
    a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
    redeclare package Medium = MediumCW,
    scaQ_flow=2,
    qNorMin_flow=2*0.106858248388454,
    qNorMax_flow=2*0.399530088717547) "Bell& Gossett HSCS 14x16x17 E"
                                annotation (Placement(transformation(extent={{
            64,30},{52,42}}, rotation=0)));
  Modelica.Blocks.Sources.CombiTimeTable weather(
    tableOnFile=true,
    columns=2:5,
    tableName="weather",
    fileName="D:\\Modelica\\Merced\\data.mat",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    startTime=-90.8*24*3600) annotation (Placement(transformation(extent={{-52,
            -13},{-36,-1}}, rotation=0)));
  Modelica.Blocks.Sources.Trapezoid trapezoid1(
    period=86400,
    startTime=86400/2,
    rising=3600,
    falling=3600,
    width=66000,
    amplitude=0,
    offset=292) annotation (Placement(transformation(extent={{-52,56},{-36,68}},
          rotation=0)));
  Modelica.Blocks.Continuous.FirstOrder PT1(      y_start=1, T=600)
    annotation (Placement(transformation(extent={{-36,26},{-24,34}}, rotation=0)));
  Modelica.Blocks.Logical.OnOffController onOffController(pre_y_start=true,
      bandwidth=3) annotation (Placement(transformation(extent={{-78,24},{-64,
            36}}, rotation=0)));
  Modelica.Blocks.Logical.TriggeredTrapezoid triggeredTrapezoid(
    amplitude=1,
    offset=0.01,
    rising=600,
    falling=600) annotation (Placement(transformation(extent={{-57,25},{-43,35}},
          rotation=0)));
  Modelica.Blocks.Sources.Trapezoid trapezoid2(
    period=86400,
    amplitude=-2,
    rising=600,
    width=43000,
    falling=600,
    offset=5,
    startTime=4.25e4)
                annotation (Placement(transformation(extent={{-106,28},{-90,40}},
          rotation=0)));
equation
  connect(Chiller_Plant.CHWS, CHWS_Pipe.port_a)
                                               annotation (Line(points={{39,22},
          {56,22},{56,6}}, color={0,127,255}));
  connect(CHWS_Pipe.port_b, CHWS_splitter.port_1)
                                            annotation (Line(points={{56,-6},{
          56,-15.6},{55.5,-15.6}}, color={0,127,255}));
  connect(CHWS_splitter.port_3, tankMB.PortB)
                                         annotation (Line(points={{50.55,-20},{
          24,-20},{24,-19.14},{23,-19.14}}, color={0,127,255}));
  connect(CHWR_splitter.port_3, tankMB.PortA)
                                          annotation (Line(points={{0.5,2},{22,
          2},{22,1.4},{23,1.4}}, color={0,127,255}));
  connect(CWR_Pipe.port_a, Chiller_Plant.CWS) annotation (Line(points={{8,38},{
          8,34},{17,34}}, color={0,127,255}));
  connect(CHWR_Primary_Pump.port_b, Chiller_Plant.CHWR) annotation (Line(points=
         {{12,20},{14.5,20},{14.5,22},{17,22}}, color={0,127,255}));
  connect(CHWR_Primary_Pump.port_a, CHWR_splitter.port_1) annotation (Line(
        points={{0,20},{-6,20},{-6,6.4},{-5,6.4}}, color={0,127,255}));
  connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (Line(
        points={{44,-47},{56,-47},{56,-24.4},{55.5,-24.4}}, color={0,127,255}));
  connect(campus.CHWS, CHWS_Secondary_Pump.port_b) annotation (Line(points={{
          22.08,-46.5},{27.4,-46.5},{27.4,-47},{32,-47}}, color={0,127,255}));
  connect(campus.CHWR, CHWR_splitter.port_2) annotation (Line(points={{10.08,
          -46.5},{-6,-46.5},{-6,-2.4},{-5,-2.4}}, color={0,127,255}));
  connect(cooling_Tower.CWR, CWR_Pipe.port_b) annotation (Line(points={{17.3,
          57.9},{8,57.9},{8,50}}, color={0,127,255}));
  connect(P1_m_flow_gain.y, CHWR_Primary_Pump.m_flow_in) annotation (Line(
        points={{-9.6,30},{8,30},{8,25.4},{7.8,25.4}}, color={0,0,127}));
  connect(pump12.port_b, Chiller_Plant.CWR) annotation (Line(points={{52,36},{
          45.5,36},{45.5,34},{39,34}}, color={0,127,255}));
  connect(pump12.port_a, Boundary_fixed.port) annotation (Line(points={{64,36},
          {76,36}}, color={0,127,255}));
  connect(m_flow2N1.y, pump12.N_in) annotation (Line(points={{59.4,52},{56,52},
          {56,41.4},{56.2,41.4}}, color={0,0,127}));
  connect(m_flow2N1.u, P1_m_flow_gain1.y) annotation (Line(points={{72.6,52},{
          79.6,52}}, color={0,0,127}));
  connect(pump12.port_a, cooling_Tower.CWS) annotation (Line(points={{64,36},{
          64,58},{38.8,58}}, color={0,127,255}));
  connect(campus.m_flow, CHWS_Secondary_Pump.m_flow_in) annotation (Line(points=
         {{9.84,-49.5},{2,-49.5},{2,-58},{36,-58},{36,-52.4},{36.2,-52.4}},
        color={0,0,127}));
  connect(weather.y, tankMB.w) annotation (Line(points={{-35.2,-7},{0,-7},{0,
          -6.4},{13.9,-6.4}}, color={0,0,127}));
  connect(cooling_Tower.w, weather.y) annotation (Line(points={{16.2,66},{-10,
          66},{-10,-7},{-35.2,-7}}, color={0,0,127}));
  connect(trapezoid1.y, cooling_Tower.Tref) annotation (Line(points={{-35.2,62},
          {16,62}}, color={0,0,127}));
  connect(PT1.y, P1_m_flow_gain.u) annotation (Line(points={{-23.4,30},{-18.8,
          30}}, color={0,0,127}));
  connect(PT1.y, P1_m_flow_gain1.u) annotation (Line(points={{-23.4,30},{-22,30},
          {-22,78},{96,78},{96,52},{88.8,52}}, color={0,0,127}));
  connect(onOffController.y, triggeredTrapezoid.u) annotation (Line(points={{
          -63.3,30},{-58.4,30}}, color={255,0,255}));
  connect(tankMB.z[2], onOffController.u) annotation (Line(points={{32.1,-5.75},
          {34,-6},{36,-6},{36,10},{-79.4,10},{-79.4,26.4}}, color={0,0,127}));
  connect(PT1.u, triggeredTrapezoid.y) annotation (Line(points={{-37.2,30},{
          -42.3,30}}, color={0,0,127}));
  connect(trapezoid2.y, onOffController.reference) annotation (Line(points={{
          -89.2,34},{-84.3,34},{-84.3,33.6},{-79.4,33.6}}, color={0,0,127}));
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram(graphics));
end Test_ChillerPlant8d;
