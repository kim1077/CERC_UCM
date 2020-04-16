model CentralPlant 
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram,
    Icon(
      Text(extent=[62,68; 112,54], string="P"),
      Text(extent=[64,28; 114,14], string="y"),
      Text(extent=[-98,28; -48,14], string="u"),
      Text(extent=[-98,68; -48,54], string="w"),
      Polygon(points=[-20,80; -12,60; 12,60; 20,80; -20,80], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=10)),
      Rectangle(extent=[-6,-70; 34,-90], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=1)),
      Polygon(points=[-6,-90; -26,-78; -26,-60; -6,-70; -6,-90], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=1)),
      Polygon(points=[-26,-60; 14,-60; 34,-70; -6,-70; -26,-60], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=1)),
      Polygon(points=[-4,-74; -4,-84; 6,-84; 6,-74; -4,-74], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=68,
          rgbfillColor={170,213,255})),
      Polygon(points=[9,-74; 9,-84; 19,-84; 19,-74; 9,-74], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=68,
          rgbfillColor={170,213,255},
          fillPattern=1)),
      Polygon(points=[22,-74; 22,-84; 32,-84; 32,-74; 22,-74], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=68,
          rgbfillColor={170,213,255},
          fillPattern=1)),
      Polygon(points=[-12,-71; -12,-81; -8,-83; -8,-73; -12,-71], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=68,
          rgbfillColor={170,213,255},
          fillPattern=1)),
      Polygon(points=[-18,-68; -18,-78; -14,-80; -14,-70; -18,-68], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=68,
          rgbfillColor={170,213,255},
          fillPattern=1)),
      Polygon(points=[-24,-65; -24,-75; -20,-77; -20,-67; -24,-65], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=68,
          rgbfillColor={170,213,255},
          fillPattern=1)),
      Line(points=[20,-16; 60,-16; 60,-76; 34,-76], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=68,
          rgbfillColor={170,213,255},
          fillPattern=1)),
      Line(points=[-26,-74; -56,-74; -56,-18; -18,-18], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=68,
          rgbfillColor={170,213,255},
          fillPattern=1)),
      Line(points=[-18,-18; -56,-18; -56,20; -30,20], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=68,
          rgbfillColor={170,213,255},
          fillPattern=1)),
      Line(points=[20,-16; 60,-16; 60,20; 30,20], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=68,
          rgbfillColor={170,213,255},
          fillPattern=1)),
      Line(points=[-30,34; -56,34; -56,68; -16,68], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=68,
          rgbfillColor={170,213,255},
          fillPattern=1)),
      Line(points=[16,68; 60,68; 60,34; 30,34], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=68,
          rgbfillColor={170,213,255},
          fillPattern=1)),
      Ellipse(extent=[-18,-22; 20,-42], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=1,
          fillColor=68,
          rgbfillColor={170,213,255})),
      Ellipse(extent=[-18,7; 20,-13], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=1,
          fillColor=1,
          rgbfillColor={255,0,0})),
      Rectangle(extent=[-18,-16; 20,-32],style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=1,
          fillColor=68,
          rgbfillColor={170,213,255})),
      Ellipse(extent=[-18,-4; 20,-24],style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=1,
          fillColor=1,
          rgbfillColor={255,0,0})),
      Rectangle(extent=[-18,-4; 20,-16],style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=1,
          fillColor=1,
          rgbfillColor={255,0,0})),
      Ellipse(extent=[-34,40; -24,28], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Ellipse(extent=[22,40; 32,28], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Rectangle(extent=[-28,40; 26,28], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Ellipse(extent=[-34,26; -24,14], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Ellipse(extent=[22,26; 32,14], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2,
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Rectangle(extent=[-28,26; 26,14], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Text(extent=[64,-2; 114,-16], string="T")));
  inner Modelica_Fluid.Ambient ambient(default_p_ambient=101325) 
                                       annotation (extent=[-80,-80; -60,-60]);
  Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
        MediumCW, redeclare package MediumCHW = MediumCHW) 
    annotation (extent=[38,18; 18,38]);
  Subsystems.Cooling_Tower3w cooling_Tower(
                                         redeclare package Medium = MediumCW) 
                  annotation (extent=[18,48; 38,68]);
  Components.TankMBw tankMB(
    redeclare package Medium = MediumCHW,
    h_startA=(85*12*0.0254) - 3,
    h_startB=3,
    T_startB=273.15 + (41 - 32)*5/9,
    T_startA=273.15 + (65 - 32)*5/9) 
                         annotation (extent=[10,-22; 36,4]);
  Modelica_Fluid.PressureLosses.PressureDropPipe CHWS_Pipe(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    diameter=24*0.0254,
    redeclare package Medium = MediumCHW,
    from_dp=false,
    length=100,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    dp_nominal=(60*12*.0254)*995*9.81,
    m_flow_nominal=(3750*3.785*0.001/60)*995) 
    annotation (extent=[49,6; 63,-6], rotation=90);
  Modelica_Fluid.Junctions.Splitter CHWS_splitter(redeclare package Medium = 
        MediumCHW) annotation (extent=[60,-24; 51,-16],   rotation=-90);
  Modelica_Fluid.Junctions.Splitter CHWR_splitter(redeclare package Medium = 
        MediumCHW) annotation (extent=[-10,-2; 0,6],rotation=-90);
  Modelica_Fluid.PressureLosses.PressureDropPipe CWR_Pipe(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    redeclare package Medium = MediumCW,
    length=50*12*0.0254,
    diameter=24*0.0254,
    from_dp=false,
    dp_nominal=(52*12*0.0254)*995*9.81,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    m_flow_nominal=(2*3500*3.785*0.001/60)*995) 
    annotation (extent=[1,38; 15,50], rotation=90);
  Components.PrescribedFlow_Pump CHWR_Primary_Pump(
    N_nom=1180,
    redeclare package Medium = MediumCHW,
    a=pump1_a,
    b=pump1_b,
    qNorMin_flow=pump1_qNorMin_flow,
    qNorMax_flow=pump1_qNorMax_flow) "P-1: Bell& Gossett HSC3-101212XL" 
    annotation (extent=[0,14; 12,26]);
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
    annotation (extent=[44,-41; 32,-53]);
  Subsystems.Campus4 campus(
                           redeclare package Medium = MediumCHW) 
    annotation (extent=[30,-65; -6,-28]);
  Modelica_Fluid.Sources.FixedBoundary Boundary_fixed(
    p=3e5,
    T=293,
    redeclare package Medium = MediumCW) annotation (extent=[86,31; 76,41]);
  Modelica.Blocks.Math.Gain pump1_m_flow_gain(k=135) 
    annotation (extent=[-12,26; -4,34]);
  Modelica.Blocks.Math.Gain pump1_m_flow_gain1(k=560*4/6) 
    annotation (extent=[88,48; 80,56]);
  Components.BaseClasses.m_flow2N m_flow2N1(
    q_flow_nom=(3500*2*3.785*0.001/60),
    a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
    qNorMin_flow=2*0.106858248388454,
    qNorMax_flow=2*0.399530088717547,
    scaQ_flow=2) annotation (extent=[72,48; 60,56]);
  Components.PrescribedSpeed_Pump pump12(
    b={-0.1196,5.6074,-8.4305},
    a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
    redeclare package Medium = MediumCW,
    scaQ_flow=2,
    qNorMin_flow=2*0.106858248388454,
    qNorMax_flow=2*0.399530088717547) "Bell& Gossett HSCS 14x16x17 E" 
                                annotation (extent=[64,30; 52,42]);
  Modelica.Blocks.Interfaces.RealInput u[3] "control inputs" 
    annotation (extent=[-100,10; -80,30]);
  Modelica.Blocks.Interfaces.RealOutput y[2] "measurements" 
    annotation (extent=[96,10; 116,30]);
  Modelica.Blocks.Interfaces.RealInput w[4] "weather" 
    annotation (extent=[-100,50; -80,70]);
  Modelica.Blocks.Interfaces.RealOutput P "power" 
    annotation (extent=[96,50; 116,70],    rotation=0);
  Modelica.Blocks.Math.Add add annotation (extent=[8,6; 13,12], rotation=-90);
  Modelica.Blocks.Math.Add add1 annotation (extent=[44,46; 49,40], rotation=-90);
  Modelica.Blocks.Math.Add add2 annotation (extent=[36,4; 41,10], rotation=0);
  Modelica.Blocks.Math.Add add3 annotation (extent=[52,66; 57,60], rotation=0);
  Modelica.Blocks.Interfaces.RealOutput T1[2] 
    annotation (extent=[96,-20; 116,0]);
equation 
  connect(Chiller_Plant.CHWS, CHWS_Pipe.port_a) 
                                               annotation (points=[39,22; 56,22;
        56,6],          style(color=69, rgbcolor={0,127,255}));
  connect(CHWS_Pipe.port_b, CHWS_splitter.port_1) 
                                            annotation (points=[56,-6; 56,-15.6;
        55.5,-15.6],
                style(color=69, rgbcolor={0,127,255}));
  connect(CHWS_splitter.port_3, tankMB.PortB) 
                                         annotation (points=[50.55,-20; 24,-20;
        24,-19.14; 23,-19.14],     style(color=69, rgbcolor={0,127,255}));
  connect(CHWR_splitter.port_3, tankMB.PortA) 
                                          annotation (points=[0.5,2; 22,2; 22,
        1.4; 23,1.4],     style(color=69, rgbcolor={0,127,255}));
  connect(CWR_Pipe.port_a, Chiller_Plant.CWS) annotation (points=[8,38; 8,34;
        17,34],          style(color=69, rgbcolor={0,127,255}));
  connect(CHWR_Primary_Pump.port_b, Chiller_Plant.CHWR) annotation (points=[12,20;
        14.4,20; 14.4,22; 17,22],
                       style(color=69, rgbcolor={0,127,255}));
  connect(CHWR_Primary_Pump.port_a, CHWR_splitter.port_1) annotation (
      points=[0,20; -6,20; -6,6.4; -5,6.4],      style(color=69, rgbcolor={
          0,127,255}));
  connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (
      points=[44,-47; 56,-47; 56,-24.4; 55.5,-24.4],style(color=69,
        rgbcolor={0,127,255}));
  connect(campus.CHWS, CHWS_Secondary_Pump.port_b) annotation (points=[25.68,
        -46.5; 27.4,-46.5; 27.4,-47; 32,-47],           style(color=69,
        rgbcolor={0,127,255}));
  connect(campus.CHWR, CHWR_splitter.port_2) annotation (points=[-1.32,-46.5; 
        -6,-46.5; -6,-2.4; -5,-2.4],  style(color=69, rgbcolor={0,127,255}));
  connect(cooling_Tower.CWR, CWR_Pipe.port_b) annotation (points=[17.3,57.9; 8,
        57.9; 8,50],     style(color=69, rgbcolor={0,127,255}));
  connect(pump1_m_flow_gain.y, CHWR_Primary_Pump.m_flow_in) 
                                                         annotation (points=[-3.6,30; 
        8,30; 8,25.4; 7.8,25.4],                 style(color=74, rgbcolor={
          0,0,127}));
  connect(pump12.port_b, Chiller_Plant.CWR) annotation (points=[52,36; 45.6,36;
        45.6,34; 39,34],
             style(color=69, rgbcolor={0,127,255}));
  connect(pump12.port_a, Boundary_fixed.port) annotation (points=[64,36; 76,36],
             style(color=69, rgbcolor={0,127,255}));
  connect(m_flow2N1.y, pump12.N_in) annotation (points=[59.4,52; 56,52; 56,41.4;
        56.2,41.4],       style(color=74, rgbcolor={0,0,127}));
  connect(m_flow2N1.u, pump1_m_flow_gain1.y) 
                                          annotation (points=[72.6,52; 79.6,52],
             style(color=74, rgbcolor={0,0,127}));
  connect(pump12.port_a, cooling_Tower.CWS) annotation (points=[64,36; 64,58;
        38.8,58],    style(color=69, rgbcolor={0,127,255}));
  connect(campus.m_flow, CHWS_Secondary_Pump.m_flow_in) annotation (points=[-1.86,
        -53.9; -10,-53.9; -10,-58; 36,-58; 36,-52.4; 36.2,-52.4],
      style(color=74, rgbcolor={0,0,127}));
  connect(tankMB.z, y) annotation (points=[32.1,-6.4; 69.05,-6.4; 69.05,20; 106,
        20], style(color=74, rgbcolor={0,0,127}));
  connect(w, cooling_Tower.w) annotation (points=[-90,60; -31.9,60; -31.9,66;
        16.2,66],                                                    style(
        color=74, rgbcolor={0,0,127}));
  connect(tankMB.w, w) annotation (points=[13.9,-6.4; -44.05,-6.4; -44.05,60;
        -90,60],  style(color=74, rgbcolor={0,0,127}));
  connect(u[1], cooling_Tower.Tref) annotation (points=[-90,13.3333; -58,
        13.3333; -58,62; 16,62],
                style(color=74, rgbcolor={0,0,127}));
  connect(pump1_m_flow_gain.u, u[2]) 
                                  annotation (points=[-12.8,30; -58,30; -58,20;
        -90,20],  style(color=74, rgbcolor={0,0,127}));
  connect(u[2], pump1_m_flow_gain1.u) 
                                   annotation (points=[-90,20; -58,20; -58,76;
        92,76; 92,52; 88.8,52], style(color=74, rgbcolor={0,0,127}));
  connect(Chiller_Plant.T_chws_ref, u[3]) annotation (points=[38.9,19; -34.55,
        19; -34.55,26.6667; -90,26.6667], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=44,
      rgbfillColor={255,170,170},
      fillPattern=1));
  connect(CHWR_Primary_Pump.P, add.u2) annotation (points=[8.4,15.2; 8,12; 9,
        12.6], style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(add.u1, Chiller_Plant.P) annotation (points=[12,12.6; 12,15.6; 17,
        15.6; 17,19], style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(add2.u1, add.y) annotation (points=[35.5,8.8; 21.75,8.8; 21.75,5.7;
        10.5,5.7], style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(add2.u2, CHWS_Secondary_Pump.P) annotation (points=[35.5,5.2; 35.5,
        -18.4; 35.6,-18.4; 35.6,-42.2], style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(add2.y, add1.u2) annotation (points=[41.25,7; 41.25,22.5; 45,22.5; 45,
        39.4], style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(pump12.P, add1.u1) annotation (points=[55.6,31.2; 51.8,31.2; 51.8,
        39.4; 48,39.4], style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(add3.u2, cooling_Tower.P) annotation (points=[51.5,64.8; 45.75,64.8;
        45.75,62.2; 39,62.2], style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(add3.u1, add1.y) annotation (points=[51.5,61.2; 51.5,53.6; 46.5,53.6;
        46.5,46.3], style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(add3.y, P) annotation (points=[57.25,63; 77.625,63; 77.625,60; 106,60],
      style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(tankMB.T1, T1) annotation (points=[32.1,-10.04; 65.05,-10.04; 65.05,
        -10; 106,-10], style(color=74, rgbcolor={0,0,127}));
end CentralPlant;
