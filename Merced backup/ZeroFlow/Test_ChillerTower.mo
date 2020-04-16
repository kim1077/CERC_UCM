model Test_ChillerTower 
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram);
  Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
        MediumCW, redeclare package MediumCHW = MediumCHW) 
    annotation (extent=[0,16; -20,36]);
  Subsystems.Cooling_Tower cooling_Tower(redeclare package Medium = MediumCW) 
                  annotation (extent=[-20,46; 0,66]);
  Components.PrescribedFlow_Pump CHWR_Primary_Pump(
    N_nom=1180,
    redeclare package Medium = MediumCHW,
    a=P1_a,
    b=P1_b,
    qNorMin_flow=P1_qNorMin_flow,
    qNorMax_flow=P1_qNorMax_flow) "P-1: Bell& Gossett HSC3-101212XL" 
    annotation (extent=[-38,12; -26,24]);
  parameter Real[:] P1_a = {208542.283151189,205771.962392144,-1518335.08994192} 
    "Polynomial coefficients for pump 1";
  parameter Real[:] P1_b = {0.0857970011564655,6.68960721072079,-14.2474444944515} 
    "Polynomial coefficients for pump 1";
  parameter Real P1_qNorMin_flow = 0.101276367798246;
  parameter Real P1_qNorMax_flow = 0.303829103394737;
  Modelica_Fluid.Sources.FixedBoundary Boundary_fixed1(
    p=3e5,
    redeclare package Medium = MediumCW,
    T=273.15 + (65 - 32)*5/9)            annotation (extent=[32,13; 22,23]);
  Modelica_Fluid.Sources.FixedBoundary Boundary_fixed2(
    p=3e5,
    redeclare package Medium = MediumCW,
    T=273.15 + (65 - 32)*5/9)            annotation (extent=[-68,13; -58,23]);
  Modelica.Blocks.Sources.Ramp y(
    startTime=1,
    duration=10,
    height=-0.9999*.75,
    offset=.75)  annotation (extent=[-88,26; -76,34]);
  Modelica_Fluid.Sources.FixedBoundary Boundary_fixed4(
    p=3e5,
    redeclare package Medium = MediumCW,
    T=273.15 + (85 - 32)*5/9)            annotation (extent=[-68,29; -58,39]);
  Components.PrescribedSpeed_Pump pump11(
    qNorMin_flow=0.106858248388454,
    qNorMax_flow=0.399530088717547,
    redeclare package Medium = MediumCW,
    a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
    b={-0.1196,5.6074,-8.4305},
    scaQ_flow=2) "Bell& Gossett HSCS 14x16x17 E" 
                                annotation (extent=[16,28; 4,40]);
  Modelica_Fluid.PressureLosses.PressureDropPipe CWR_Pipe(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    redeclare package Medium = MediumCW,
    length=50*12*0.0254,
    diameter=24*0.0254,
    from_dp=false,
    dp_nominal=(52*12*0.0254)*995*9.81,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    m_flow_nominal=(2*3500*3.785*0.001/60)*995) 
    annotation (extent=[-37,40; -23,52],
                                      rotation=90);
  Modelica.Blocks.Math.Gain P1_m_flow_gain(k=220) 
    annotation (extent=[-46,26; -38,34]);
  m_flow2N m_flow2N1(
    q_flow_nom=(3500*2*3.785*0.001/60),
    a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
    qNorMin_flow=2*0.106858248388454,
    qNorMax_flow=2*0.399530088717547,
    scaQ_flow=2) annotation (extent=[34,40; 22,48]);
  Modelica.Blocks.Math.Gain P1_m_flow_gain1(k=560) 
    annotation (extent=[50,40; 42,48]);
equation 
  connect(CHWR_Primary_Pump.port_b, Chiller_Plant.CHWR) annotation (points=[-26,18;
        -21.2,18],     style(color=69, rgbcolor={0,127,255}));
  connect(Boundary_fixed1.port, Chiller_Plant.CHWS) annotation (points=[22,18;
        1.2,18],     style(color=69, rgbcolor={0,127,255}));
  connect(Boundary_fixed2.port, CHWR_Primary_Pump.port_a) annotation (
      points=[-58,18; -38,18], style(color=69, rgbcolor={0,127,255}));
  connect(Boundary_fixed4.port, Chiller_Plant.CWS) annotation (points=[-58,
        34; -21,34], style(color=69, rgbcolor={0,127,255}));
  connect(pump11.port_b, Chiller_Plant.CWR) annotation (points=[4,34; 1.2,
        34], style(color=69, rgbcolor={0,127,255}));
  connect(pump11.port_a, cooling_Tower.CWS) annotation (points=[16,34; 18,
        34; 18,56; 1.2,56], style(color=69, rgbcolor={0,127,255}));
  connect(cooling_Tower.CWR, CWR_Pipe.port_b) annotation (points=[-21.2,56;
        -30,56; -30,52], style(color=69, rgbcolor={0,127,255}));
  connect(Chiller_Plant.CWS, CWR_Pipe.port_a) annotation (points=[-21,34;
        -30,34; -30,40], style(color=69, rgbcolor={0,127,255}));
  connect(P1_m_flow_gain.u, y.y) annotation (points=[-46.8,30; -75.4,30],
      style(color=74, rgbcolor={0,0,127}));
  connect(P1_m_flow_gain.y, CHWR_Primary_Pump.m_flow_in) annotation (points=
       [-37.6,30; -30,30; -30,23.4; -30.2,23.4], style(color=74, rgbcolor={
          0,0,127}));
  connect(m_flow2N1.y, pump11.N_in) annotation (points=[21.4,44; 7.75,44;
        7.75,39.4; 8.2,39.4], style(color=74, rgbcolor={0,0,127}));
  connect(P1_m_flow_gain1.y, m_flow2N1.u) annotation (points=[41.6,44; 34.6,
        44], style(color=74, rgbcolor={0,0,127}));
  connect(P1_m_flow_gain1.u, y.y) annotation (points=[50.8,44; 68,44; 68,74;
        -48,74; -48,30; -75.4,30], style(color=74, rgbcolor={0,0,127}));
end Test_ChillerTower;
