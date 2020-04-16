within Merced.ZeroFlow;
model Test_TankCampus
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
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
  Modelica.Blocks.Sources.Ramp y(
    duration=10,
    startTime=10,
    offset=1,
    height=-0.999)
                 annotation (Placement(transformation(extent={{-88,26},{-76,34}},
          rotation=0)));
  Modelica.Blocks.Math.Gain P1_m_flow_gain(k=140)
    annotation (Placement(transformation(extent={{-46,26},{-38,34}}, rotation=0)));
  Components.TankMB tankMB(
    redeclare package Medium = MediumCHW,
    tauBuoy=9.81*0.05,
    Radius=60*12*0.0254/2,
    h_startA=(85*12*0.0254) - 3,
    h_startB=3,
    T_startA=273.15 + (75 - 32)*5/9,
    T_startB=273.15 + (41 - 32)*5/9,
    Kwall=1e-1,
    tauJet=3)            annotation (Placement(transformation(extent={{-18,-30},
            {8,-4}}, rotation=0)));
  Modelica_Fluid.Junctions.Splitter CHWR_splitter(redeclare package Medium =
        MediumCHW) annotation (Placement(transformation(
        origin={-43,0},
        extent={{-4,-5},{4,5}},
        rotation=270)));
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
        origin={20,4},
        extent={{6,-7},{-6,7}},
        rotation=90)));
  Modelica_Fluid.Junctions.Splitter CHWS_splitter(redeclare package Medium =
        MediumCHW) annotation (Placement(transformation(
        origin={20.5,-34},
        extent={{-4,4.5},{4,-4.5}},
        rotation=270)));
  Components.PrescribedFlow_Pump CHWS_Secondary_Pump(
    N_nom=1180,
    redeclare package Medium = MediumCHW,
    a={208542.283151189,205771.962392144,-1518335.08994192},
    b={0.0857970011564655,6.68960721072079,-14.2474444944515},
    qNorMin_flow=0.101276367798246,
    qNorMax_flow=0.303829103394737,
    m_flow_const=0.01) "P-3: Bell& Gossett HSC3-101212XL"
    annotation (Placement(transformation(extent={{10,-50},{-2,-62}}, rotation=0)));
  Subsystems.Campus2 campus(
                           redeclare package Medium = MediumCHW)
    annotation (Placement(transformation(extent={{-10,-62},{-26,-47}}, rotation=
           0)));
  Modelica.Blocks.Math.Gain P3_m_flow_gain(k=140)
    annotation (Placement(transformation(extent={{-10,-75},{-2,-67}}, rotation=
            0)));
  Modelica.Blocks.Sources.Constant const(k=1.00001)
    annotation (Placement(transformation(extent={{-47,-76},{-37,-70}}, rotation=
           0)));
  Modelica.Blocks.Math.Add add(k1=-1, k2=1)
                                      annotation (Placement(transformation(
          extent={{-28,-75},{-20,-67}}, rotation=0)));
equation
  connect(P1_m_flow_gain.u, y.y) annotation (Line(points={{-46.8,30},{-75.4,30}},
        color={0,0,127}));
  connect(P1_m_flow_gain.y, CHWR_Primary_Pump.m_flow_in) annotation (Line(
        points={{-37.6,30},{-30,30},{-30,23.4},{-30.2,23.4}}, color={0,0,127}));
  connect(CHWR_Primary_Pump.port_b, CHWS_Pipe.port_a) annotation (Line(points={
          {-26,18},{20,18},{20,10}}, color={0,127,255}));
  connect(CHWS_splitter.port_1, CHWS_Pipe.port_b) annotation (Line(points={{
          20.5,-29.6},{20.5,-18.8},{20,-18.8},{20,-2}}, color={0,127,255}));
  connect(CHWS_splitter.port_3, tankMB.PortB) annotation (Line(points={{15.55,
          -34},{-4,-34},{-4,-27.4},{-5,-27.4}}, color={0,127,255}));
  connect(CHWR_Primary_Pump.port_a, CHWR_splitter.port_1) annotation (Line(
        points={{-38,18},{-44,18},{-44,4.4},{-43,4.4}}, color={0,127,255}));
  connect(CHWR_splitter.port_3, tankMB.PortA) annotation (Line(points={{-37.5,
          2.69413e-16},{-3.75,2.69413e-16},{-3.75,-6.86},{-5,-6.86}}, color={0,
          127,255}));
  connect(CHWR_splitter.port_2, campus.CHWR) annotation (Line(points={{-43,-4.4},
          {-43,-50.2},{-26.96,-50.2},{-26.96,-50}}, color={0,127,255}));
  connect(campus.CHWS, CHWS_Secondary_Pump.port_b) annotation (Line(points={{
          -9.2,-56.15},{-5.6,-56.15},{-5.6,-56},{-2,-56}}, color={0,127,255}));
  connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (Line(
        points={{10,-56},{20,-56},{20,-38.4},{20.5,-38.4}}, color={0,127,255}));
  connect(P3_m_flow_gain.y, CHWS_Secondary_Pump.m_flow_in) annotation (Line(
        points={{-1.6,-71},{2.2,-71},{2.2,-61.4}}, color={0,0,127}));
  connect(const.y, add.u2) annotation (Line(points={{-36.5,-73},{-32.85,-73},{
          -32.85,-73.4},{-28.8,-73.4}}, color={0,0,127}));
  connect(add.u1, y.y) annotation (Line(points={{-28.8,-68.6},{-28.8,-68.2},{
          -75.4,-68.2},{-75.4,30}}, color={0,0,127}));
  connect(add.y, P3_m_flow_gain.u) annotation (Line(points={{-19.6,-71},{-10.8,
          -71}}, color={0,0,127}));
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram(graphics));
end Test_TankCampus;
