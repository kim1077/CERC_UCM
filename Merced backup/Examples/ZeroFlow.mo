package ZeroFlow "Testing ZeroFlow Component Models" 
  
  block m_flow2N "calculate speed based on mass flow" 
    parameter Modelica.SIunits.Density rho=995 "fluid density";
    parameter Modelica.SIunits.VolumeFlowRate q_flow_nom=(3500*3.785*0.001/60) 
      "nominal volumetric flow rate";
    parameter Modelica.SIunits.VolumeFlowRate dp_nom=(60*12*0.0254)*995*9.81 
      "nominal pressure difference";
    
    Modelica.Blocks.Interfaces.RealInput u(redeclare type SignalType = 
          Modelica.SIunits.MassFlowRate) "prescribed mass flow rate" 
      annotation (extent=[-120,-10; -100,10],rotation=0);
    Modelica.Blocks.Interfaces.RealOutput y "rotational speed" 
      annotation (extent=[100,-10; 120,10], rotation=0);
    
    parameter Real[3] a "Polynomial coefficients for pressure=p(qNor_flow)";
    parameter Real qNorMin_flow "Lowest valid normalized mass flow rate";
    parameter Real qNorMax_flow "Highest valid normalized mass flow rate";
    parameter Modelica.SIunits.VolumeFlowRate scaQ_flow = 1 
      "Factor used to scale the volume flow rate";
    parameter Modelica.SIunits.Pressure scaDp = 1 
      "Factor used to scale the pressure increase";
    parameter Modelica.SIunits.AngularVelocity N_nom(min=0.1)=1180 
      "nominal rotational speed";
    
  //  parameter Modelica.SIunits.MassFlowRate m_flow_units=1;
  protected 
    parameter Modelica.SIunits.AngularVelocity N_units=1;
    
  equation 
    y = min( N_nom,-u*N_nom/rho / (-a[2] + sqrt( a[2]^2 - 4* (a[3]-rho*dp_nom/q_flow_nom/max(u,1e-6))*a[1])) *(a[3]-rho*dp_nom/q_flow_nom/max(u,1e-6))*2)/N_units;
    annotation (Icon);
  end m_flow2N;
  
  model Test_Campus 
      package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    
    annotation (uses(Modelica_Fluid(version="1.0 Beta 2")), Diagram);
    
    Modelica_Fluid.Sources.FixedBoundary Source(
      use_T=true,
      redeclare package Medium = MediumCHW,
      p=101325,
      T=273.15 + (39 - 32)*5/9) 
             annotation (extent=[-76,56; -56,76]);
    inner Modelica_Fluid.Ambient ambient 
      annotation (extent=[-60,-80; -40,-60]);
    Modelica_Fluid.Sources.FixedBoundary Sink(
      use_T=true,
      T=293,
      redeclare package Medium = MediumCHW,
      p=2e5) annotation (extent=[72,62; 52,82]);
    Components.PrescribedFlow_Pump CHWS_Secondary_Pump(
      N_nom=1180,
      redeclare package Medium = MediumCHW,
      a={208542.283151189,205771.962392144,-1518335.08994192},
      b={0.0857970011564655,6.68960721072079,-14.2474444944515},
      qNorMin_flow=0.101276367798246,
      qNorMax_flow=0.303829103394737,
      m_flow_const=10) "P-3: Bell& Gossett HSC3-101212XL" 
      annotation (extent=[-42,60; -30,72]);
    Subsystems.Campus2 campus(
                             redeclare package Medium = MediumCHW) 
      annotation (extent=[-24,60; -8,75]);
    Modelica.Blocks.Math.Gain gain(k=140) 
      annotation (extent=[-44,84; -38,92]);
    Modelica.Blocks.Sources.Ramp y(
      duration=10,
      startTime=10,
      offset=1,
      height=-0.9999) 
                   annotation (extent=[-74,84; -62,92]);
  equation 
    connect(gain.y,CHWS_Secondary_Pump. m_flow_in) annotation (points=[-37.7,88;
          -34,88; -34,71.4; -34.2,71.4],      style(color=74, rgbcolor={0,0,
            127}));
    connect(CHWS_Secondary_Pump.port_b, campus.CHWS) annotation (points=[-30,
          66; -27.4,66; -27.4,65.85; -24.8,65.85], style(color=69, rgbcolor={
            0,127,255}));
    connect(CHWS_Secondary_Pump.port_a, Source.port) annotation (points=[-42,
          66; -56,66], style(color=69, rgbcolor={0,127,255}));
    connect(campus.CHWR, Sink.port) annotation (points=[-7.04,72; 52,72],
        style(color=69, rgbcolor={0,127,255}));
    connect(y.y, gain.u) annotation (points=[-61.4,88; -44.6,88], style(color=
           74, rgbcolor={0,0,127}));
  end Test_Campus;
  
  model Test_Chiller 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    Merced.Components.Chiller Chiller(
    redeclare package Medium_1 = MediumCW,
    redeclare package Medium_2 = MediumCHW) 
      annotation (extent=[-18,-52; 26,-6]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR1(
    redeclare package Medium = MediumCW,
      T=273 + 16,
      m_flow=1) 
      annotation (extent=[-60,-25; -40,-5]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR2(
    redeclare package Medium = MediumCHW,
      T=273 + 16,
      m_flow=1) 
      annotation (extent=[76,-52; 56,-32]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX FixedBC1(
      redeclare package Medium = MediumCW,
      p=0,
      T=273 + 5) 
      annotation (extent=[72,-22; 58,-8]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX FixedBC2(
      redeclare package Medium = MediumCHW,
      p=0,
      T=273 + 5) 
      annotation (extent=[-58,-49; -44,-35]);
    Modelica.Blocks.Sources.Sine Sine1(
      offset=273 + 5,
      freqHz=0.0001,
      amplitude=1) 
      annotation (extent=[-84,-74; -68,-58]);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-94,74; -74,94]);
    Modelica.Blocks.Sources.Ramp ramp(
      duration=10,
      offset=10,
      height=-10*0.999) annotation (extent=[-92,-4; -76,12]);
    Modelica.Blocks.Sources.Ramp ramp1(
      duration=10,
      offset=10,
      height=-10*0.999) annotation (extent=[56,-80; 72,-64]);
  equation 
    connect(FMFR1.port,Chiller.port_a1) 
      annotation (points=[-40,-15; -35.6,-15; -35.6,-15.2; -18,-15.2],
      style(color= 69, rgbcolor={0,127,255}));
    connect(FMFR2.port,Chiller.port_a2) 
      annotation (points=[56,-42; 26,-42; 26,-42.8],
      style(color=69,rgbcolor={0,127,255}));
    connect(FixedBC1.port,Chiller.port_b1) annotation (
        points=[58,-15; 41.6,-15; 41.6,-15.2; 26,-15.2],
        style(color=69, rgbcolor={0,127,255}));
    connect(FixedBC2.port,Chiller. port_b2) annotation (
        points=[-44,-42; -18,-42; -18,-42.8],
        style(color=69, rgbcolor={0,127,255}));
    connect(Sine1.y,Chiller.T_chws_ref) annotation (points=[-67.2,-66; -46.7,
          -66; -46.7,-51.54; -22.4,-51.54],    style(color=74, rgbcolor={0,0,127}));
    connect(ramp.y, FMFR1.m_flow_in) annotation (points=[-75.2,4; -68,4; -68,-9; -59.3,-9],
        style(color=74, rgbcolor={0,0,127}));
    connect(ramp1.y, FMFR2.m_flow_in) annotation (points=[72.8,-72; 86,-72;
          86,-36; 75.3,-36], style(color=74, rgbcolor={0,0,127}));
  end Test_Chiller;
  
  model Test_ChillerPlant 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-80,60; -60,80]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX CHWR(
      redeclare package Medium = MediumCHW,
      T=273 + (60 - 32)*5/9,
      m_flow=0) 
      annotation (extent=[26,12; 14,24]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX CHWS(
      redeclare package Medium = MediumCHW,
      p=0,
      T=273 + 5) 
      annotation (extent=[-50,14; -40,24]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX CWR(
      redeclare package Medium = MediumCW,
      p=0,
      T=273 + 5) 
      annotation (extent=[24,30; 16,38], rotation=0);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX CWS(
      redeclare package Medium = MediumCW,
      T=273.15 + (75 - 32)*5/9,
      m_flow=0) 
      annotation (extent=[-52,28; -40,40]);
    Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
          MediumCW, redeclare package MediumCHW = MediumCHW) 
      annotation (extent=[-20,16; 0,36]);
    Modelica.Blocks.Sources.Ramp ramp(
      duration=10,
      height=-10*0.999,
      offset=10) annotation (extent=[-80,32; -68,42]);
    Modelica.Blocks.Sources.Ramp ramp1(
      duration=10,
      height=-10*0.999,
      offset=10) annotation (extent=[4,-4; 16,6]);
  equation 
    connect(CHWS.port, Chiller_Plant.CHWS) annotation (points=[-40,19; -40,18;
          -21.2,18], style(color=69, rgbcolor={0,127,255}));
    connect(CWR.port, Chiller_Plant.CWS) annotation (points=[16,34; 1,34],
        style(color=69, rgbcolor={0,127,255}));
    connect(CWS.port, Chiller_Plant.CWR) annotation (points=[-40,34; -21.2,34],
        style(color=69, rgbcolor={0,127,255}));
    connect(CHWR.port, Chiller_Plant.CHWR) annotation (points=[14,18; 1.2,18],
        style(color=69, rgbcolor={0,127,255}));
    connect(ramp.y, CWS.m_flow_in) annotation (points=[-67.4,37; -59.7,37;
          -59.7,37.6; -51.58,37.6], style(color=74, rgbcolor={0,0,127}));
    connect(ramp1.y, CHWR.m_flow_in) annotation (points=[16.6,1; 25.58,1;
          25.58,21.6], style(color=74, rgbcolor={0,0,127}));
  end Test_ChillerPlant;
  
  model Test_ChillerTank 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
          MediumCW, redeclare package MediumCHW = MediumCHW) 
      annotation (extent=[0,16; -20,36]);
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
    Modelica_Fluid.Sources.FixedBoundary Boundary_fixed3(
      p=3e5,
      redeclare package Medium = MediumCW,
      T=273.15 + (75 - 32)*5/9)            annotation (extent=[38,29; 28,39]);
    Components.TankMB tankMB(
      redeclare package Medium = MediumCHW,
      tauBuoy=9.81*0.05,
      Radius=60*12*0.0254/2,
      h_startA=(85*12*0.0254) - 3,
      h_startB=3,
      T_startA=273.15 + (75 - 32)*5/9,
      T_startB=273.15 + (41 - 32)*5/9,
      Kwall=1e-1,
      tauJet=3)            annotation (extent=[-18,-30; 8,-4]);
  equation 
    connect(CHWR_Primary_Pump.port_b, Chiller_Plant.CHWR) annotation (points=[-26,18;
          -21.2,18],     style(color=69, rgbcolor={0,127,255}));
    connect(Boundary_fixed4.port, Chiller_Plant.CWS) annotation (points=[-58,
          34; -21,34], style(color=69, rgbcolor={0,127,255}));
    connect(pump11.port_b, Chiller_Plant.CWR) annotation (points=[4,34; 1.2,
          34], style(color=69, rgbcolor={0,127,255}));
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
    connect(Boundary_fixed3.port, pump11.port_a) annotation (points=[28,34; 16,
          34], style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_Primary_Pump.port_a, tankMB.PortA) annotation (points=[-38,
          18; -46,18; -46,-6.86; -5,-6.86], style(color=69, rgbcolor={0,127,
            255}));
    connect(Chiller_Plant.CHWS, tankMB.PortB) annotation (points=[1.2,18; 26,
          18; 26,-27.4; -5,-27.4], style(color=69, rgbcolor={0,127,255}));
  end Test_ChillerTank;
  
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
  
  model Test_CT 
    
  Buildings.HeatExchangers.CoolingTowers.YorkCalc tow1(
      redeclare package Medium = Medium_W,
      TAirInWB0=273.15 + (68 - 32)*5/9,
      TApp0=(75 - 68)*5/9,
      TRan0=(85 - 75)*5/9,
      mWat0_flow=5*(1735*3.785/60),
      PFan0=5*40*745.7)             annotation (extent=[-12,-7; 8,13]);
    
    Modelica.Blocks.Sources.Ramp y(
      offset=1,
      startTime=1,
      duration=5,
      height=-1)   annotation (extent=[-52,4; -38,18]);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-94,76; -74,96]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX CWS(redeclare package 
        Medium = 
          Medium_W,
      T=273.15 + (85 - 32)*5/9,
      m_flow=2*(3500*3.785/60)) 
      annotation (extent=[-54,-91; -34,-71]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX sink(
      T=283.15,
      p=101325,
      redeclare package Medium = Medium_W) 
                            annotation (extent=[78,-73; 58,-53],
                                                               rotation=0);
    Modelica.Blocks.Sources.Constant TWat1(k=273.15 + (85 - 32)*5/9) 
      "Water temperature" 
      annotation (extent=[-94,-91; -74,-71]);
    Modelica.Blocks.Sources.Sine TOut1(
                                      amplitude=10, offset=293.15) 
      "Outside air temperature" annotation (extent=[-50,80; -30,100]);
      Modelica.Blocks.Sources.Constant phi1(
                                           k=0.5) "Relative air humidity" 
        annotation (extent=[10,76; 30,96]);
    Buildings.Utilities.Psychrometrics.WetBulbTemperature wetBulTem1(
        redeclare package Medium = Modelica.Media.Air.MoistAir) 
      "Model for wet bulb temperature" 
      annotation (extent=[-52,50; -32,70]);
      Modelica.Blocks.Sources.Constant PAtm1(
                                            k=101325) "Atmospheric pressure" 
        annotation (extent=[-92,50; -72,70]);
    
    replaceable package Medium_W = 
        Modelica.Media.Water.ConstantPropertyLiquidWater;
    Modelica.Blocks.Sources.Ramp ramp(
      duration=10,
      offset=2*(3500*3.785/60),
      height=-0.999*2*(3500*3.785/60)) 
      annotation (extent=[-92,-56; -76,-40]);
  equation 
    connect(TWat1.y, CWS.T_in)  annotation (points=[-73,-81; -56,-81],
                    style(color=74, rgbcolor={0,0,127}));
    connect(PAtm1.y, wetBulTem1.p) 
      annotation (points=[-71,60; -51,60], style(color=74, rgbcolor={0,0,127}));
    connect(TOut1.y, wetBulTem1.TDryBul) 
                                       annotation (points=[-29,90; -20,90;
          -20,68; -51,68],
                   style(color=74, rgbcolor={0,0,127}));
    connect(phi1.y, wetBulTem1.phi) 
                                  annotation (points=[31,86; 48,86; 48,67;
          -33,67],
        style(color=74, rgbcolor={0,0,127}));
    annotation (Diagram);
    connect(y.y, tow1.y) annotation (points=[-37.3,11; -14,11], style(color=
            74, rgbcolor={0,0,127}));
    connect(tow1.port_a, CWS.port) annotation (points=[-12,3; -24,3; -24,-81;
          -34,-81], style(color=69, rgbcolor={0,127,255}));
    connect(tow1.TAir, wetBulTem1.TWetBul) annotation (points=[-14,7; -24,7;
          -24,60; -33,60], style(color=74, rgbcolor={0,0,127}));
    connect(sink.port, tow1.port_b) annotation (points=[58,-63; 58,3.5; 8,3.5;
          8,3], style(color=69, rgbcolor={0,127,255}));
    connect(ramp.y, CWS.m_flow_in) annotation (points=[-75.2,-48; -66,-48;
          -66,-75; -53.3,-75], style(color=74, rgbcolor={0,0,127}));
  end Test_CT;
  
  model Test_HX 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR1(
    redeclare package Medium = MediumCW,
      T=273 + 16,
      m_flow=1) 
      annotation (extent=[-60,-25; -40,-5]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR2(
    redeclare package Medium = MediumCHW,
      m_flow=1,
      T=273 + 20) 
      annotation (extent=[76,-52; 56,-32]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX FixedBC1(
      redeclare package Medium = MediumCW,
      p=0,
      T=273 + 5) 
      annotation (extent=[72,-22; 58,-8]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX FixedBC2(
      redeclare package Medium = MediumCHW,
      p=0,
      T=273 + 5) 
      annotation (extent=[-58,-49; -44,-35]);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-94,74; -74,94]);
    Modelica.Blocks.Sources.Ramp ramp(
      duration=10,
      offset=10,
      height=-10*1) annotation (extent=[-92,-4; -76,12]);
    Modelica.Blocks.Sources.Ramp ramp1(
      duration=10,
      offset=10,
      height=-10*1) annotation (extent=[56,-80; 72,-64]);
    Buildings.HeatExchangers.ConstantEffectiveness constantEffectiveness(redeclare 
        package Medium_1 = MediumCW, redeclare package Medium_2 = MediumCHW) 
      annotation (extent=[-4,-36; 16,-16]);
  equation 
    connect(ramp.y, FMFR1.m_flow_in) annotation (points=[-75.2,4; -68,4; -68,
          -9; -59.3,-9], style(color=74, rgbcolor={0,0,127}));
    connect(ramp1.y, FMFR2.m_flow_in) annotation (points=[72.8,-72; 86,-72;
          86,-36; 75.3,-36], style(color=74, rgbcolor={0,0,127}));
    connect(constantEffectiveness.port_b1, FixedBC1.port) annotation (points=
          [16,-20; 38,-20; 38,-15; 58,-15], style(color=69, rgbcolor={0,127,
            255}));
    connect(constantEffectiveness.port_a2, FMFR2.port) annotation (points=[16,
          -32; 36,-32; 36,-42; 56,-42], style(color=69, rgbcolor={0,127,255}));
    connect(constantEffectiveness.port_b2, FixedBC2.port) annotation (points=
          [-4,-32; -24,-32; -24,-42; -44,-42], style(color=69, rgbcolor={0,
            127,255}));
    connect(constantEffectiveness.port_a1, FMFR1.port) annotation (points=[-4,
          -20; -22,-20; -22,-15; -40,-15], style(color=69, rgbcolor={0,127,
            255}));
  end Test_HX;
  
  model Test_Pipe 
    
    replaceable package Medium = 
        Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (Diagram);
    Modelica_Fluid.Sources.FixedBoundary Sink(
      redeclare package Medium = Medium,
      T=293,
      p=3e5)       annotation (extent=[78,-2; 58,18]);
    Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM(
      redeclare package Medium = Medium, frictionType=Modelica_Fluid.Types.FrictionTypes.DetailedFriction) 
                                 annotation (extent=[16,-2; 36,18]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR1(
      T=273 + 16,
      m_flow=1,
      redeclare package Medium = Medium) 
      annotation (extent=[-36,-1; -16,19]);
    Modelica.Blocks.Sources.Ramp ramp1(
      duration=10,
      offset=10,
      height=-10*1) annotation (extent=[-77,7; -61,23]);
  equation 
    connect(fixedResistanceDpM.port_b, Sink.port) annotation (points=[36,8;
          58,8], style(color=69, rgbcolor={0,127,255}));
    connect(ramp1.y, FMFR1.m_flow_in) annotation (points=[-60.2,15; -35.3,15],
        style(color=74, rgbcolor={0,0,127}));
    connect(FMFR1.port, fixedResistanceDpM.port_a) annotation (points=[-16,9;
          -5,9; -5,8; 16,8], style(color=69, rgbcolor={0,127,255}));
  end Test_Pipe;
  
  model Test_Pump 
    
    replaceable package Medium = 
        Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (Diagram);
    Components.PrescribedFlow_Pump speedpump(
      redeclare package Medium = Medium,
      a={265534.776168551,157317.088939285,-1045931.5671727},
      b={-0.0734399353605566,5.1386797187811,-7.20622906783169},
      qNorMin_flow=0.104332257676433,
      qNorMax_flow=0.422067104450367) annotation (extent=[-16,-2; 4,18]);
    Modelica_Fluid.Sources.FixedBoundary Source(
      redeclare package Medium = Medium,
      p=3e5,
      T=293) annotation (extent=[-54,-2; -34,18]);
    Modelica_Fluid.Sources.FixedBoundary Sink(
      redeclare package Medium = Medium,
      T=293,
      p=3e5)       annotation (extent=[78,-2; 58,18]);
    Modelica.Blocks.Sources.Ramp ramp(
      duration=10,
      height=-300*0.99,
      offset=300) annotation (extent=[-34,22; -18,38]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM fixedResistanceDpM(
      redeclare package Medium = Medium,
      m0_flow=150,
      dp0=60*12*0.0254*995*9.81) annotation (extent=[16,-2; 36,18]);
    Modelica_Fluid.Pumps.Pump pumps(
      checkValve=true,
      N_nom=1200,
      redeclare function flowCharacteristic = 
          Modelica_Fluid.Pumps.BaseClasses.PumpCharacteristics.quadraticFlow (          q_nom={0,
              0.25,0.5}, head_nom={100,60,0}),
      Np_nom=4,
      M=50,
      T_start=Modelica.SIunits.Conversions.from_degC(20),
      redeclare package Medium = Medium,
      usePowerCharacteristic=false) 
      annotation (extent=[-16,-40; 10,-14]);
    Modelica_Fluid.Sources.FixedBoundary Source1(
      redeclare package Medium = Medium,
      p=3e5,
      T=293) annotation (extent=[-56,-44; -36,-24]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM fixedResistanceDpM1(
      redeclare package Medium = Medium,
      m0_flow=150,
      dp0=60*12*0.0254*995*9.81) annotation (extent=[20,-32; 40,-12]);
    Modelica_Fluid.Sources.FixedBoundary Sink1(
      redeclare package Medium = Medium,
      T=293,
      p=3e5)       annotation (extent=[82,-32; 62,-12]);
    Modelica.Blocks.Sources.Ramp ramp1(
      duration=10,
      offset=1200,
      height=-1200*1) annotation (extent=[-42,-20; -26,-4]);
    Buildings.Fluids.Movers.FlowMachinePolynomial speedpump1(
      redeclare package Medium = Medium,
      b={-0.0734399353605566,5.1386797187811,-7.20622906783169},
      D=1,
      mNorMin_flow=30,
      mNorMax_flow=100,
      a={265534.776168551,157317.088939285,-1045931.5671727},
      scaM_flow=1/50)                 annotation (extent=[-22,46; -2,66]);
    Modelica_Fluid.Sources.FixedBoundary Source2(
      redeclare package Medium = Medium,
      p=3e5,
      T=293) annotation (extent=[-60,46; -40,66]);
    Modelica_Fluid.Sources.FixedBoundary Sink2(
      redeclare package Medium = Medium,
      T=293,
      p=3e5)       annotation (extent=[72,46; 52,66]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM fixedResistanceDpM2(
      redeclare package Medium = Medium,
      m0_flow=150,
      dp0=60*12*0.0254*995*9.81) annotation (extent=[10,46; 30,66]);
    Modelica.Blocks.Sources.Ramp ramp2(
      duration=10,
      offset=1,
      height=-0.99) annotation (extent=[-50,72; -34,88]);
  equation 
    connect(Source.port, speedpump.port_a) 
      annotation (points=[-34,8; -16,8], style(color=69, rgbcolor={0,127,255}));
    connect(ramp.y, speedpump.m_flow_in) annotation (points=[-17.2,30; -3,30; -3,17],
        style(color=74, rgbcolor={0,0,127}));
    connect(fixedResistanceDpM.port_a, speedpump.port_b) 
      annotation (points=[16,8; 4,8], style(color=69, rgbcolor={0,127,255}));
    connect(fixedResistanceDpM.port_b, Sink.port) annotation (points=[36,8;
          58,8], style(color=69, rgbcolor={0,127,255}));
    connect(Source1.port, pumps.inlet) annotation (points=[-36,-34; -26,-34;
          -26,-29.6; -13.4,-29.6], style(color=69, rgbcolor={0,127,255}));
    connect(Sink1.port, fixedResistanceDpM1.port_b) annotation (points=[62,
          -22; 40,-22], style(color=69, rgbcolor={0,127,255}));
    connect(fixedResistanceDpM1.port_a, pumps.outlet) annotation (points=[20,-22;
          12.4,-22; 12.4,-22.84; 4.8,-22.84],      style(color=69, rgbcolor={
            0,127,255}));
    connect(ramp1.y, pumps.N_in) annotation (points=[-25.2,-12; -6,-12; -6,
          -21.28; -6.38,-21.28], style(color=74, rgbcolor={0,0,127}));
    connect(Source2.port, speedpump1.port_a) 
      annotation (points=[-40,56; -22,56],
                                         style(color=69, rgbcolor={0,127,255}));
    connect(fixedResistanceDpM2.port_a, speedpump1.port_b) annotation (points=[10,56;
          -2,56], style(color=69, rgbcolor={0,127,255}));
    connect(fixedResistanceDpM2.port_b, Sink2.port) annotation (points=[30,56;
          52,56], style(color=69, rgbcolor={0,127,255}));
    connect(ramp2.y, speedpump1.N_in) annotation (points=[-33.2,80; -26,80;
          -26,62; -23,62], style(color=74, rgbcolor={0,0,127}));
  end Test_Pump;
  
  model Test_TankCampus 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
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
    Modelica.Blocks.Sources.Ramp y(
      duration=10,
      startTime=10,
      offset=1,
      height=-0.999) 
                   annotation (extent=[-88,26; -76,34]);
    Modelica.Blocks.Math.Gain P1_m_flow_gain(k=140) 
      annotation (extent=[-46,26; -38,34]);
    Components.TankMB tankMB(
      redeclare package Medium = MediumCHW,
      tauBuoy=9.81*0.05,
      Radius=60*12*0.0254/2,
      h_startA=(85*12*0.0254) - 3,
      h_startB=3,
      T_startA=273.15 + (75 - 32)*5/9,
      T_startB=273.15 + (41 - 32)*5/9,
      Kwall=1e-1,
      tauJet=3)            annotation (extent=[-18,-30; 8,-4]);
    Modelica_Fluid.Junctions.Splitter CHWR_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[-48,-4; -38,4],
                                                      rotation=-90);
    Modelica_Fluid.PressureLosses.PressureDropPipe CHWS_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      diameter=24*0.0254,
      redeclare package Medium = MediumCHW,
      from_dp=false,
      length=100,
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
      dp_nominal=(60*12*.0254)*995*9.81,
      m_flow_nominal=(3750*3.785*0.001/60)*995) 
      annotation (extent=[13,10; 27,-2],rotation=90);
    Modelica_Fluid.Junctions.Splitter CHWS_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[25,-38; 16,-30],   rotation=-90);
    Components.PrescribedFlow_Pump CHWS_Secondary_Pump(
      N_nom=1180,
      redeclare package Medium = MediumCHW,
      a={208542.283151189,205771.962392144,-1518335.08994192},
      b={0.0857970011564655,6.68960721072079,-14.2474444944515},
      qNorMin_flow=0.101276367798246,
      qNorMax_flow=0.303829103394737,
      m_flow_const=0.01) "P-3: Bell& Gossett HSC3-101212XL" 
      annotation (extent=[10,-50; -2,-62]);
    Subsystems.Campus2 campus(
                             redeclare package Medium = MediumCHW) 
      annotation (extent=[-10,-62; -26,-47]);
    Modelica.Blocks.Math.Gain P3_m_flow_gain(k=140) 
      annotation (extent=[-10,-75; -2,-67]);
    Modelica.Blocks.Sources.Constant const(k=1.00001) 
      annotation (extent=[-47,-76; -37,-70]);
    Modelica.Blocks.Math.Add add(k1=-1, k2=1) 
                                        annotation (extent=[-28,-75; -20,-67]);
  equation 
    connect(P1_m_flow_gain.u, y.y) annotation (points=[-46.8,30; -75.4,30],
        style(color=74, rgbcolor={0,0,127}));
    connect(P1_m_flow_gain.y, CHWR_Primary_Pump.m_flow_in) annotation (points=
         [-37.6,30; -30,30; -30,23.4; -30.2,23.4], style(color=74, rgbcolor={
            0,0,127}));
    connect(CHWR_Primary_Pump.port_b, CHWS_Pipe.port_a) annotation (points=[
          -26,18; 20,18; 20,10], style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_splitter.port_1, CHWS_Pipe.port_b) annotation (points=[20.5,
          -29.6; 20.5,-18.8; 20,-18.8; 20,-2], style(color=69, rgbcolor={0,
            127,255}));
    connect(CHWS_splitter.port_3, tankMB.PortB) annotation (points=[15.55,-34;
          -4,-34; -4,-27.4; -5,-27.4], style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_Primary_Pump.port_a, CHWR_splitter.port_1) annotation (
        points=[-38,18; -44,18; -44,4.4; -43,4.4], style(color=69, rgbcolor={
            0,127,255}));
    connect(CHWR_splitter.port_3, tankMB.PortA) annotation (points=[-37.5,
          2.69413e-016; -3.75,2.69413e-016; -3.75,-6.86; -5,-6.86], style(
          color=69, rgbcolor={0,127,255}));
    connect(CHWR_splitter.port_2, campus.CHWR) annotation (points=[-43,-4.4;
          -43,-50.2; -26.96,-50.2; -26.96,-50], style(color=69, rgbcolor={0,
            127,255}));
    connect(campus.CHWS, CHWS_Secondary_Pump.port_b) annotation (points=[-9.2,
          -56.15; -5.6,-56.15; -5.6,-56; -2,-56], style(color=69, rgbcolor={0,
            127,255}));
    connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (
        points=[10,-56; 20,-56; 20,-38.4; 20.5,-38.4], style(color=69,
          rgbcolor={0,127,255}));
    connect(P3_m_flow_gain.y, CHWS_Secondary_Pump.m_flow_in) annotation (
        points=[-1.6,-71; 2.2,-71; 2.2,-61.4], style(color=74, rgbcolor={0,0,
            127}));
    connect(const.y, add.u2) annotation (points=[-36.5,-73; -32.85,-73;
          -32.85,-73.4; -28.8,-73.4], style(color=74, rgbcolor={0,0,127}));
    connect(add.u1, y.y) annotation (points=[-28.8,-68.6; -28.8,-68.2; -75.4,
          -68.2; -75.4,30], style(color=74, rgbcolor={0,0,127}));
    connect(add.y, P3_m_flow_gain.u) annotation (points=[-19.6,-71; -10.8,-71],
        style(color=74, rgbcolor={0,0,127}));
  end Test_TankCampus;
end ZeroFlow;
