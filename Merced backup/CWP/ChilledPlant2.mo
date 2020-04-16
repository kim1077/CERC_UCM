model ChilledPlant2 
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram,
    Icon(
      Text(extent=[62,68; 112,54], string="z"),
      Text(extent=[64,28; 114,14], string="y"),
      Text(extent=[-98,28; -48,14], string="u"),
      Text(extent=[-98,68; -48,54], string="Twb"),
      Polygon(points=[-20,80; -12,60; 12,60; 20,80; -20,80], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=30,
          rgbfillColor={215,215,215},
          fillPattern=10)),
      Line(points=[-56,-18; -56,-20; -56,20; -30,20], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=68,
          rgbfillColor={170,213,255},
          fillPattern=1)),
      Line(points=[60,-16; 60,-20; 60,20; 30,20], style(
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
      Rectangle(extent=[-27,40; 27,28], style(
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
      Rectangle(extent=[-27,26; 27,14], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=2,
          fillColor=30,
          rgbfillColor={215,215,215})),
      Ellipse(extent=[-66,-20; -46,-40], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=3,
          fillColor=3,
          rgbfillColor={0,0,255})),
      Ellipse(extent=[50,-20; 70,-40], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=3,
          fillColor=3,
          rgbfillColor={0,0,255}))));
  inner Modelica_Fluid.Ambient ambient(default_p_ambient=101325) 
                                       annotation (extent=[-80,-80; -60,-60]);
  ChillerPlant Chiller_Plant(                  redeclare package MediumCW = 
        MediumCW, redeclare package MediumCHW = MediumCHW) 
    annotation (extent=[38,18; 18,38]);
  Cooling_Tower2 cooling_Tower(
                              redeclare package Medium = MediumCW) 
                  annotation (extent=[12,48; 32,68]);
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
  Modelica_Fluid.PressureLosses.PressureDropPipe CWR_Pipe(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    redeclare package Medium = MediumCW,
    length=50*12*0.0254,
    diameter=24*0.0254,
    from_dp=false,
    dp_nominal=(52*12*0.0254)*995*9.81,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    m_flow_nominal=(2*3500*3.785*0.001/60)*995) 
    annotation (extent=[-13,38; 1,50],rotation=90);
  Merced.Components.PrescribedFlow_Pump CHWR_Primary_Pump(
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
  Modelica_Fluid.Sources.FixedBoundary Boundary_fixed(
    p=3e5,
    T=293,
    redeclare package Medium = MediumCW) annotation (extent=[86,31; 76,41]);
  Modelica.Blocks.Math.Gain pump1_m_flow_gain(k=135) 
    annotation (extent=[-12,26; -4,34]);
  Modelica.Blocks.Math.Gain pump1_m_flow_gain1(k=560) 
    annotation (extent=[88,48; 80,56]);
  Merced.Components.BaseClasses.m_flow2N m_flow2N1(
    q_flow_nom=(3500*2*3.785*0.001/60),
    a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
    qNorMin_flow=2*0.106858248388454,
    qNorMax_flow=2*0.399530088717547,
    scaQ_flow=2) annotation (extent=[72,48; 60,56]);
  Merced.Components.PrescribedSpeed_Pump pump12(
    b={-0.1196,5.6074,-8.4305},
    a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
    redeclare package Medium = MediumCW,
    scaQ_flow=2,
    qNorMin_flow=2*0.106858248388454,
    qNorMax_flow=2*0.399530088717547) "Bell& Gossett HSCS 14x16x17 E" 
                                annotation (extent=[64,30; 52,42]);
  Modelica.Blocks.Interfaces.RealInput u[4] "control inputs" 
    annotation (extent=[-100,10; -80,30]);
  Modelica.Blocks.Interfaces.RealOutput y[2] "measurements" 
    annotation (extent=[96,10; 116,30]);
  Modelica.Blocks.Interfaces.RealInput Twb "weather" 
    annotation (extent=[-100,50; -80,70]);
  Modelica.Blocks.Interfaces.RealOutput P "power" 
    annotation (extent=[96,50; 116,70],    rotation=0);
  Modelica.Blocks.Math.Add add annotation (extent=[8,6; 13,12], rotation=-90);
  Modelica.Blocks.Math.Add add1 annotation (extent=[44,46; 49,40], rotation=-90);
  Modelica.Blocks.Math.Add add3 annotation (extent=[52,68; 57,62], rotation=0);
  Modelica_Fluid.Sources.FixedBoundary Boundary_fixed1(
    p=3e5,
    T=293,
    redeclare package Medium = MediumCW) annotation (extent=[74,-21; 64,-11]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX Boundary_fixed2(
    p=3e5,
    T=293,
    redeclare package Medium = MediumCW) annotation (extent=[-20,-21; -10,-11]);
  Modelica_Fluid.Sensors.Temperature T_CHWS(redeclare package Medium = 
        MediumCHW) annotation (extent=[52,18; 44,26]);
equation 
  connect(CWR_Pipe.port_a, Chiller_Plant.CWS) annotation (points=[-6,38; -6,34; 
        17,34],          style(color=69, rgbcolor={0,127,255}));
  connect(CHWR_Primary_Pump.port_b, Chiller_Plant.CHWR) annotation (points=[12,20;
        14.4,20; 14.4,22; 17,22],
                       style(color=69, rgbcolor={0,127,255}));
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
  connect(u[1], cooling_Tower.Tref) annotation (points=[-90,12.5; -58,12.5; -58,
        62; 10,62],
                style(color=74, rgbcolor={0,0,127}));
  connect(pump1_m_flow_gain.u, u[2]) 
                                  annotation (points=[-12.8,30; -58,30; -58,
        17.5; -90,17.5],
                  style(color=74, rgbcolor={0,0,127}));
  connect(u[2], pump1_m_flow_gain1.u) 
                                   annotation (points=[-90,17.5; -58,17.5; -58,
        76; 92,76; 92,52; 88.8,52],
                                style(color=74, rgbcolor={0,0,127}));
  connect(Chiller_Plant.T_chws_ref, u[3]) annotation (points=[38.9,19; -34.55,
        19; -34.55,22.5; -90,22.5],       style(
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
  connect(pump12.P, add1.u1) annotation (points=[55.6,31.2; 51.8,31.2; 51.8,
        39.4; 48,39.4], style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(add3.u2, cooling_Tower.P) annotation (points=[51.5,66.8; 45.75,66.8;
        45.75,62.2; 33,62.2], style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(add3.u1, add1.y) annotation (points=[51.5,63.2; 51.5,49.6; 46.5,49.6;
        46.5,46.3], style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(add3.y, P) annotation (points=[57.25,65; 77.625,65; 77.625,60; 106,60],
      style(
      color=74,
      rgbcolor={0,0,127},
      gradient=3,
      fillColor=30,
      rgbfillColor={215,215,215}));
  connect(add.y, add1.u2) annotation (points=[10.5,5.7; 42.25,5.7; 42.25,39.4;
        45,39.4], style(color=74, rgbcolor={0,0,127}));
  connect(Boundary_fixed1.port, CHWS_Pipe.port_b) annotation (points=[64,-16;
        56,-16; 56,-6], style(color=69, rgbcolor={0,127,255}));
  connect(Boundary_fixed2.port, CHWR_Primary_Pump.port_a) annotation (points=[
        -10,-16; -4,-16; -4,20; 0,20], style(color=69, rgbcolor={0,127,255}));
  connect(Boundary_fixed2.T_in, u[4]) annotation (points=[-21,-16; -53.5,-16;
        -53.5,27.5; -90,27.5], style(color=74, rgbcolor={0,0,127}));
  connect(T_CHWS.port_b, Chiller_Plant.CHWS) 
    annotation (points=[44,22; 39,22], style(color=69, rgbcolor={0,127,255}));
  connect(T_CHWS.port_a, CHWS_Pipe.port_a) annotation (points=[52,22; 56,22; 56,
        6], style(color=69, rgbcolor={0,127,255}));
  connect(T_CHWS.T, y[1]) annotation (points=[48,17.6; 75.5,17.6; 75.5,15; 106,
        15], style(color=74, rgbcolor={0,0,127}));
  connect(Twb, cooling_Tower.Twb) annotation (points=[-90,60; -40,60; -40,66;
        10.2,66], style(color=74, rgbcolor={0,0,127}));
  connect(cooling_Tower.CWS, pump12.port_a) annotation (points=[32.8,58; 64,58;
        64,36], style(color=69, rgbcolor={0,127,255}));
  connect(cooling_Tower.CWR, CWR_Pipe.port_b) annotation (points=[11.3,57.9; 
        -5.35,57.9; -5.35,50; -6,50], style(color=69, rgbcolor={0,127,255}));
end ChilledPlant2;
