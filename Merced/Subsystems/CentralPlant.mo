within Merced.Subsystems;
model CentralPlant
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
    a=pump1_a,
    b=pump1_b,
    qNorMin_flow=pump1_qNorMin_flow,
    qNorMax_flow=pump1_qNorMax_flow) "P-1: Bell& Gossett HSC3-101212XL"
    annotation (Placement(transformation(extent={{0,14},{12,26}}, rotation=0)));
  parameter Real[:] pump1_a = {208542.283151189,205771.962392144,-1518335.08994192}
    "Polynomial coefficients for pump 1";
  parameter Real[:] pump1_b = {0.0857970011564655,6.68960721072079,-14.2474444944515}
    "Polynomial coefficients for pump 1";
  parameter Real pump1_qNorMin_flow = 0.101276367798246;
  parameter Real pump1_qNorMax_flow = 0.303829103394737;
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
    annotation (Placement(transformation(extent={{30,-65},{-6,-28}}, rotation=0)));
  Modelica_Fluid.Sources.FixedBoundary Boundary_fixed(
    p=3e5,
    T=293,
    redeclare package Medium = MediumCW) annotation (Placement(transformation(
          extent={{86,31},{76,41}}, rotation=0)));
  Modelica.Blocks.Math.Gain pump1_m_flow_gain(k=135)
    annotation (Placement(transformation(extent={{-12,26},{-4,34}}, rotation=0)));
  Modelica.Blocks.Math.Gain pump1_m_flow_gain1(k=560*4/6)
    annotation (Placement(transformation(extent={{88,48},{80,56}}, rotation=0)));
  Components.BaseClasses.m_flow2N m_flow2N1(
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
  Modelica.Blocks.Interfaces.RealInput u[3] "control inputs"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}}, rotation=
            0)));
  Modelica.Blocks.Interfaces.RealOutput y[2] "measurements"
    annotation (Placement(transformation(extent={{96,10},{116,30}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput w[4] "weather"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}}, rotation=
            0)));
  Modelica.Blocks.Interfaces.RealOutput P "power"
    annotation (Placement(transformation(extent={{96,50},{116,70}}, rotation=0)));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(
        origin={10.5,9},
        extent={{-3,-2.5},{3,2.5}},
        rotation=270)));
  Modelica.Blocks.Math.Add add1 annotation (Placement(transformation(
        origin={46.5,43},
        extent={{3,-2.5},{-3,2.5}},
        rotation=270)));
  Modelica.Blocks.Math.Add add2 annotation (Placement(transformation(extent={{
            36,4},{41,10}}, rotation=0)));
  Modelica.Blocks.Math.Add add3 annotation (Placement(transformation(extent={{
            52,66},{57,60}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput T1[2]
    annotation (Placement(transformation(extent={{96,-20},{116,0}}, rotation=0)));
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
         {{12,20},{14.4,20},{14.4,22},{17,22}}, color={0,127,255}));
  connect(CHWR_Primary_Pump.port_a, CHWR_splitter.port_1) annotation (Line(
        points={{0,20},{-6,20},{-6,6.4},{-5,6.4}}, color={0,127,255}));
  connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (Line(
        points={{44,-47},{56,-47},{56,-24.4},{55.5,-24.4}}, color={0,127,255}));
  connect(campus.CHWS, CHWS_Secondary_Pump.port_b) annotation (Line(points={{
          25.68,-46.5},{27.4,-46.5},{27.4,-47},{32,-47}}, color={0,127,255}));
  connect(campus.CHWR, CHWR_splitter.port_2) annotation (Line(points={{-1.32,
          -46.5},{-6,-46.5},{-6,-2.4},{-5,-2.4}}, color={0,127,255}));
  connect(cooling_Tower.CWR, CWR_Pipe.port_b) annotation (Line(points={{17.3,
          57.9},{8,57.9},{8,50}}, color={0,127,255}));
  connect(pump1_m_flow_gain.y, CHWR_Primary_Pump.m_flow_in)
                                                         annotation (Line(
        points={{-3.6,30},{8,30},{8,25.4},{7.8,25.4}}, color={0,0,127}));
  connect(pump12.port_b, Chiller_Plant.CWR) annotation (Line(points={{52,36},{
          45.6,36},{45.6,34},{39,34}}, color={0,127,255}));
  connect(pump12.port_a, Boundary_fixed.port) annotation (Line(points={{64,36},
          {76,36}}, color={0,127,255}));
  connect(m_flow2N1.y, pump12.N_in) annotation (Line(points={{59.4,52},{56,52},
          {56,41.4},{56.2,41.4}}, color={0,0,127}));
  connect(m_flow2N1.u, pump1_m_flow_gain1.y)
                                          annotation (Line(points={{72.6,52},{
          79.6,52}}, color={0,0,127}));
  connect(pump12.port_a, cooling_Tower.CWS) annotation (Line(points={{64,36},{
          64,58},{38.8,58}}, color={0,127,255}));
  connect(campus.m_flow, CHWS_Secondary_Pump.m_flow_in) annotation (Line(points=
         {{-1.86,-53.9},{-10,-53.9},{-10,-58},{36,-58},{36,-52.4},{36.2,-52.4}},
        color={0,0,127}));
  connect(tankMB.z, y) annotation (Line(points={{32.1,-6.4},{69.05,-6.4},{69.05,
          20},{106,20}}, color={0,0,127}));
  connect(w, cooling_Tower.w) annotation (Line(points={{-90,60},{-31.9,60},{
          -31.9,66},{16.2,66}}, color={0,0,127}));
  connect(tankMB.w, w) annotation (Line(points={{13.9,-6.4},{-44.05,-6.4},{
          -44.05,60},{-90,60}}, color={0,0,127}));
  connect(u[1], cooling_Tower.Tref) annotation (Line(points={{-90,13.3333},{-58,
          13.3333},{-58,62},{16,62}}, color={0,0,127}));
  connect(pump1_m_flow_gain.u, u[2])
                                  annotation (Line(points={{-12.8,30},{-58,30},
          {-58,20},{-90,20}}, color={0,0,127}));
  connect(u[2], pump1_m_flow_gain1.u)
                                   annotation (Line(points={{-90,20},{-58,20},{
          -58,76},{92,76},{92,52},{88.8,52}}, color={0,0,127}));
  connect(Chiller_Plant.T_chws_ref, u[3]) annotation (Line(points={{38.9,19},{
          -34.55,19},{-34.55,26.6667},{-90,26.6667}}, color={0,0,127}));
  connect(CHWR_Primary_Pump.P, add.u2) annotation (Line(points={{8.4,15.2},{8,
          12},{9,12.6}}, color={0,0,127}));
  connect(add.u1, Chiller_Plant.P) annotation (Line(points={{12,12.6},{12,15.6},
          {17,15.6},{17,19}}, color={0,0,127}));
  connect(add2.u1, add.y) annotation (Line(points={{35.5,8.8},{21.75,8.8},{
          21.75,5.7},{10.5,5.7}}, color={0,0,127}));
  connect(add2.u2, CHWS_Secondary_Pump.P) annotation (Line(points={{35.5,5.2},{
          35.5,-18.4},{35.6,-18.4},{35.6,-42.2}}, color={0,0,127}));
  connect(add2.y, add1.u2) annotation (Line(points={{41.25,7},{41.25,22.5},{45,
          22.5},{45,39.4}}, color={0,0,127}));
  connect(pump12.P, add1.u1) annotation (Line(points={{55.6,31.2},{51.8,31.2},{
          51.8,39.4},{48,39.4}}, color={0,0,127}));
  connect(add3.u2, cooling_Tower.P) annotation (Line(points={{51.5,64.8},{45.75,
          64.8},{45.75,62.2},{39,62.2}}, color={0,0,127}));
  connect(add3.u1, add1.y) annotation (Line(points={{51.5,61.2},{51.5,53.6},{
          46.5,53.6},{46.5,46.3}}, color={0,0,127}));
  connect(add3.y, P) annotation (Line(points={{57.25,63},{77.625,63},{77.625,60},
          {106,60}}, color={0,0,127}));
  connect(tankMB.T1, T1) annotation (Line(points={{32.1,-10.04},{65.05,-10.04},
          {65.05,-10},{106,-10}}, color={0,0,127}));
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram(graphics),
    Icon(graphics={
        Text(extent={{62,68},{112,54}}, textString=
                                          "P"),
        Text(extent={{64,28},{114,14}}, textString=
                                          "y"),
        Text(extent={{-98,28},{-48,14}}, textString=
                                           "u"),
        Text(extent={{-98,68},{-48,54}}, textString=
                                           "w"),
        Polygon(
          points={{-20,80},{-12,60},{12,60},{20,80},{-20,80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-6,-70},{34,-90}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-6,-90},{-26,-78},{-26,-60},{-6,-70},{-6,-90}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,-60},{14,-60},{34,-70},{-6,-70},{-26,-60}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,-74},{-4,-84},{6,-84},{6,-74},{-4,-74}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={170,213,255}),
        Polygon(
          points={{9,-74},{9,-84},{19,-84},{19,-74},{9,-74}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{22,-74},{22,-84},{32,-84},{32,-74},{22,-74}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,-71},{-12,-81},{-8,-83},{-8,-73},{-12,-71}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-18,-68},{-18,-78},{-14,-80},{-14,-70},{-18,-68}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-24,-65},{-24,-75},{-20,-77},{-20,-67},{-24,-65}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Line(points={{20,-16},{60,-16},{60,-76},{34,-76}}, color={0,0,255}),
        Line(points={{-26,-74},{-56,-74},{-56,-18},{-18,-18}}, color={0,0,255}),
        Line(points={{-18,-18},{-56,-18},{-56,20},{-30,20}}, color={0,0,255}),
        Line(points={{20,-16},{60,-16},{60,20},{30,20}}, color={0,0,255}),
        Line(points={{-30,34},{-56,34},{-56,68},{-16,68}}, color={0,0,255}),
        Line(points={{16,68},{60,68},{60,34},{30,34}}, color={0,0,255}),
        Ellipse(
          extent={{-18,-22},{20,-42}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={170,213,255}),
        Ellipse(
          extent={{-18,7},{20,-13}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Rectangle(
          extent={{-18,-16},{20,-32}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={170,213,255}),
        Ellipse(
          extent={{-18,-4},{20,-24}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Rectangle(
          extent={{-18,-4},{20,-16}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Ellipse(
          extent={{-34,40},{-24,28}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,215,215}),
        Ellipse(
          extent={{22,40},{32,28}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-28,40},{26,28}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,215,215}),
        Ellipse(
          extent={{-34,26},{-24,14}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,215,215}),
        Ellipse(
          extent={{22,26},{32,14}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-28,26},{26,14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,215,215}),
        Text(extent={{64,-2},{114,-16}}, textString=
                                           "T")}));
end CentralPlant;
