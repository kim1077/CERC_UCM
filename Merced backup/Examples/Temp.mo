package Temp 
  model test_TankMBw "test TankMB with input for weather" 
    
    Components.TankMBw fluidTankMB(                       redeclare package 
        Medium = 
          Modelica.Media.Water.StandardWater) 
                            annotation (extent=[-44,-18; 2,26]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX prescribedMassFlowRate_TX1
      ( redeclare package Medium = Modelica.Media.Water.StandardWater, T=278) 
                       annotation (extent=[28,-44; 8,-24]);
    Modelica.Blocks.Sources.Sine sine2(
      freqHz=3,
      amplitude=0,
      offset=0) 
      annotation (extent=[10,-62; 28,-50]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX prescribedMassFlowRate_TX2
      (           redeclare package Medium = 
          Modelica.Media.Water.StandardWater, T=288) 
                                              annotation (extent=[30,28; 10,48]);
    Modelica.Blocks.Sources.Sine sine1(
      freqHz=3,
      amplitude=0,
      offset=0) 
      annotation (extent=[10,58; 28,70]);
    annotation (Diagram);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-92,74; -72,94]);
    Modelica.Blocks.Sources.CombiTimeTable weather(
      tableOnFile=true,
      columns=2:5,
      tableName="weather",
      fileName="D:\\Modelica\\Merced\\data.mat",
      startTime=-90*24*3600) annotation (extent=[-80,-2; -60,18]);
  equation 
    connect(prescribedMassFlowRate_TX1.port, fluidTankMB.PortB) annotation (
        points=[8,-34; -20,-34; -20,-13.16; -21,-13.16],
                                                       style(color=69, rgbcolor=
           {0,127,255}));
    connect(prescribedMassFlowRate_TX2.port, fluidTankMB.PortA) annotation (
        points=[10,38; -20,38; -20,21.6; -21,21.6],  style(color=69, rgbcolor={
            0,127,255}));
    connect(sine2.y, prescribedMassFlowRate_TX1.m_flow_in) annotation (points=
         [28.9,-56; 48,-56; 48,-28; 27.3,-28], style(color=74, rgbcolor={0,0,
            127}));
    connect(sine1.y, prescribedMassFlowRate_TX2.m_flow_in) annotation (points=
         [28.9,64; 46,64; 46,44; 29.3,44], style(color=74, rgbcolor={0,0,127}));
    connect(weather.y, fluidTankMB.w) annotation (points=[-59,8; -49.2,8; -49.2,
          8.4; -37.1,8.4],
                      style(color=74, rgbcolor={0,0,127}));
  end test_TankMBw;
  
  model test_TankMB_height 
    
    Merced.Components.TankMB fluidTankMB(T_startB=278.15, redeclare package 
        Medium = 
          Modelica.Media.Water.StandardWater,
      h_startA=12,
      h_startB=3)           annotation (extent=[-44,-18; 2,26]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX prescribedMassFlowRate_TX1
      ( redeclare package Medium = Modelica.Media.Water.StandardWater, T=278) 
                       annotation (extent=[28,-44; 8,-24]);
    Modelica.Blocks.Sources.Sine sine2(freqHz=1/86400, offset=-50) 
      annotation (extent=[96,-40; 78,-28]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX prescribedMassFlowRate_TX2
      (           redeclare package Medium = 
          Modelica.Media.Water.StandardWater, T=288) 
                                              annotation (extent=[30,48; 10,68]);
    annotation (Diagram);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-92,74; -72,94]);
    Modelica.Blocks.Sources.Sine sine3(
      amplitude=5,
      freqHz=1/86400,
      offset=293) 
      annotation (extent=[-80,7; -62,19]);
    Modelica.Blocks.Math.Add add(k1=1) annotation (extent=[64,-38; 44,-18]);
    Modelica.Blocks.Math.Gain gain(k=-1) 
      annotation (extent=[32,-6; 44,6], rotation=90);
    Modelica.Blocks.Logical.OnOffController onOffController(pre_y_start=true,
        bandwidth=5) annotation (extent=[14,10; 34,30]);
    Modelica.Blocks.Logical.TriggeredTrapezoid triggeredTrapezoid(
      amplitude=100,
      rising=1800,
      falling=1800,
      offset=0) annotation (extent=[44,10; 64,30]);
    Modelica.Blocks.Sources.Sine sine4(
      freqHz=1/86400,
      amplitude=0,
      offset=5) 
      annotation (extent=[-6,20; 6,32]);
    Modelica.Blocks.Continuous.FirstOrder PT1(y_start=10, T=1) 
      annotation (extent=[74,10; 94,30]);
  equation 
    connect(prescribedMassFlowRate_TX1.port, fluidTankMB.PortB) annotation (
        points=[8,-34; -20,-34; -20,-13.6; -21,-13.6], style(color=69, rgbcolor=
           {0,127,255}));
    connect(prescribedMassFlowRate_TX2.port, fluidTankMB.PortA) annotation (
        points=[10,58; -20,58; -20,21.16; -21,21.16],style(color=69, rgbcolor={
            0,127,255}));
    connect(sine3.y, fluidTankMB.Tamb) annotation (points=[-61.1,13; -47.445,13;
          -47.445,12.8; -37.79,12.8], style(color=74, rgbcolor={0,0,127}));
    connect(add.u2, sine2.y) annotation (points=[66,-34; 77.1,-34], style(color=
            74, rgbcolor={0,0,127}));
    connect(add.y, prescribedMassFlowRate_TX1.m_flow_in) annotation (points=[43,
          -28; 27.3,-28], style(color=74, rgbcolor={0,0,127}));
    connect(gain.u, add.y) annotation (points=[38,-7.2; 38,-28; 43,-28], style(
          color=74, rgbcolor={0,0,127}));
    connect(gain.y, prescribedMassFlowRate_TX2.m_flow_in) annotation (points=[
          38,6.6; 38,64; 29.3,64], style(color=74, rgbcolor={0,0,127}));
    connect(sine4.y, onOffController.reference) 
      annotation (points=[6.6,26; 12,26], style(color=74, rgbcolor={0,0,127}));
    connect(triggeredTrapezoid.u, onOffController.y) 
      annotation (points=[42,20; 35,20], style(color=5, rgbcolor={255,0,255}));
    connect(PT1.u, triggeredTrapezoid.y) 
      annotation (points=[72,20; 65,20], style(color=74, rgbcolor={0,0,127}));
    connect(PT1.y, add.u1) annotation (points=[95,20; 95,-22; 66,-22], style(
          color=74, rgbcolor={0,0,127}));
    connect(onOffController.u, fluidTankMB.z[2]) annotation (points=[12,14;
          3.55,14; 3.55,13.9; -4.9,13.9], style(color=74, rgbcolor={0,0,127}));
  end test_TankMB_height;
  
  model Test_PrescribedFlow_Pump 
    
    annotation (uses(Modelica_Fluid(version="1.0 Beta 2")), Diagram);
    
    Modelica_Fluid.Sources.FixedBoundary Boundary_fixed(
      use_T=true,
      T=293,
      redeclare package Medium = 
          Modelica.Media.Water.ConstantPropertyLiquidWater,
      p=3e5) annotation (extent=[-72,-6; -52,14]);
    inner Modelica_Fluid.Ambient ambient 
      annotation (extent=[-60,-80; -40,-60]);
    Modelica_Fluid.Sources.FixedBoundary Boundary_fixed1(
      use_T=true,
      T=293,
      redeclare package Medium = 
          Modelica.Media.Water.ConstantPropertyLiquidWater,
      p=3e5 + 60*12*0.0254*9.81*995) 
             annotation (extent=[76,-6; 56,14]);
    Components.PrescribedSpeed_Pump speedpump(
      redeclare package Medium = 
          Modelica.Media.Water.ConstantPropertyLiquidWater,
      a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
      b={-0.1196,5.6074,-8.4305},
      qNorMin_flow=0.106858248388454,
      qNorMax_flow=0.399530088717547,
      N_nom=1180)       annotation (extent=[-26,-6; -8,14]);
    Subsystems.pump_control_m_flow pump_control_m_flow(
      redeclare package Medium = 
          Modelica.Media.Water.ConstantPropertyLiquidWater,
      a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
      b={-0.1196,5.6074,-8.4305},
      qMin_flow=0.106858248388454,
      qMax_flow=0.399530088717547,
      N_nom=1180) annotation (extent=[-26,18; -10,34]);
  equation 
    connect(pump_control_m_flow.port_a, flowMachineQuadratic1.port_a) 
      annotation (points=[-26,26; -26,4],    style(color=69, rgbcolor={0,127,
            255}));
    connect(pump_control_m_flow.port_b, flowMachineQuadratic1.port_b) 
      annotation (points=[-10,26; -10,4],  style(color=69, rgbcolor={0,127,
            255}));
    connect(speedpump.port_b, Boundary_fixed1.port) annotation (points=[-8,4;
          56,4], style(color=69, rgbcolor={0,127,255}));
    connect(speedpump.port_a, Boundary_fixed.port) annotation (points=[-26,4;
          -52,4], style(color=69, rgbcolor={0,127,255}));
    connect(speedpump.N_in, pump_control_m_flow.N) annotation (points=[-14.3,
          13; -14.3,17.55; -14.16,17.55; -14.16,21.36], style(color=74,
          rgbcolor={0,0,127}));
  end Test_PrescribedFlow_Pump;
  
  model Test_Loop4 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram(Text(
          extent=[-56,92; 46,66],
          style(color=3, rgbcolor={0,0,255}),
          string="nonliner equation system size {2,2}"), Text(
          extent=[-70,-66; 84,-72],
          style(color=3, rgbcolor={0,0,255}),
          string=
              "note singularity when primary and secondary pump flow rates are equal")));
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
      m_flow_const=10,
      m_flow(start=150),
      dp(start=60*12*0.0254*995*9.81)) "P-3: Bell& Gossett HSC3-101212XL" 
      annotation (extent=[6,-30; -6,-42]);
    Modelica.Blocks.Sources.Pulse pulse1(
      period=86400,
      startTime=86400/2,
      amplitude=0.99,
      offset=0.01) 
                  annotation (extent=[-26,-51; -16,-45]);
    Modelica.Blocks.Math.Gain gain(k=138) 
      annotation (extent=[-10,-52; -4,-44]);
    Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM1(
      redeclare package Medium = MediumCHW,
      m_flow(start=150),
      dp(start=60*12*0.0254*995*9.81),
      dp_nominal=60*12*0.0254*9.81*995,
      m_flow_nominal=150,
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar) 
      annotation (extent=[10,15; 18,26], rotation=-90);
    Modelica.Blocks.Sources.Pulse pulse2(
      period=86400,
      startTime=86400/2,
      amplitude=-0.99,
      offset=1)   annotation (extent=[-50,13; -40,19]);
    Modelica.Blocks.Math.Gain gain1(k=140) 
      annotation (extent=[-34,12; -28,20]);
    Components.TankMB tankMB(
      redeclare package Medium = MediumCHW,
      Radius=60*12*0.0254/2,
      h_startA=(85*12*0.0254) - 3,
      h_startB=3,
      T_startA=273.15 + (75 - 32)*5/9,
      T_startB=273.15 + (41 - 32)*5/9,
      Kwall=1e-1,
      tauBuoy=9.81*0.05,
      tauJet=1,
      delta=0.2)           annotation (extent=[-26,-22; 0,4]);
    Components.PrescribedFlow_Pump CHWR_Primary_Pump(
      N_nom=1180,
      redeclare package Medium = MediumCHW,
      a=P1_a,
      b=P1_b,
      qNorMin_flow=P1_qNorMin_flow,
      qNorMax_flow=P1_qNorMax_flow) "P-1: Bell& Gossett HSC3-101212XL" 
      annotation (extent=[-30,36; -18,24]);
    Modelica_Fluid.Junctions.Splitter CHWR_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[-54,-3; -44,5],
                                                      rotation=-90);
    Modelica_Fluid.Junctions.Splitter CHWS_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[18,-23; 9,-15],    rotation=-90);
    Subsystems.dumbChiller dumbChiller(redeclare package Medium = MediumCHW) 
      annotation (extent=[-12,20; 8,40]);
    Subsystems.Campus2 campus2_1(redeclare package Medium = MediumCHW) 
      annotation (extent=[-34,-44; -54,-24]);
  equation 
    connect(pulse1.y, gain.u) annotation (points=[-15.5,-48; -10.6,-48],
        style(color=74, rgbcolor={0,0,127}));
    connect(pulse2.y, gain1.u) 
                              annotation (points=[-39.5,16; -34.6,16],
        style(color=74, rgbcolor={0,0,127}));
    connect(CHWR_splitter.port_3, tankMB.PortA) annotation (points=[-43.5,1;
          -27.75,1; -27.75,1.14; -13,1.14], style(color=69, rgbcolor={0,127,
            255}));
    connect(CHWR_splitter.port_1, CHWR_Primary_Pump.port_a) annotation (
        points=[-49,5.4; -49.5,5.4; -49.5,30; -30,30], style(color=69,
          rgbcolor={0,127,255}));
    connect(fixedResistanceDpM1.port_b, CHWS_splitter.port_1) annotation (
        points=[14,15; 14,-14.6; 13.5,-14.6], style(color=69, rgbcolor={0,127,
            255}));
    connect(CHWS_splitter.port_3, tankMB.PortB) annotation (points=[8.55,-19;
          0,-19; 0,-19.4; -13,-19.4], style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (
        points=[6,-36; 12,-36; 12,-23.4; 13.5,-23.4], style(color=69,
          rgbcolor={0,127,255}));
    connect(gain.y, CHWS_Secondary_Pump.m_flow_in) annotation (points=[-3.7,-48;
          -1.8,-48; -1.8,-41.4],      style(color=74, rgbcolor={0,0,127}));
    connect(gain1.y, CHWR_Primary_Pump.m_flow_in) annotation (points=[-27.7,16;
          -22,16; -22,24.6; -22.2,24.6],     style(color=74, rgbcolor={0,0,
            127}));
    connect(dumbChiller.CHWS, CHWR_Primary_Pump.port_b) annotation (points=[
          -13,30; -18,30], style(color=69, rgbcolor={0,127,255}));
    connect(dumbChiller.CHWR, fixedResistanceDpM1.port_a) annotation (points=
          [9,30; 14,30; 14,26], style(color=69, rgbcolor={0,127,255}));
    connect(campus2_1.CHWR, CHWR_splitter.port_2) annotation (points=[-55.2,-28;
          -70,-28; -70,-3.4; -49,-3.4],      style(color=69, rgbcolor={0,127,
            255}));
    connect(campus2_1.CHWS, CHWS_Secondary_Pump.port_b) annotation (points=[
          -33,-36.2; -19.5,-36.2; -19.5,-36; -6,-36], style(color=69,
          rgbcolor={0,127,255}));
  end Test_Loop4;
  
  model Test_Loop3 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram(Text(
          extent=[-56,92; 46,66],
          style(color=3, rgbcolor={0,0,255}),
          string="nonliner equation system size {2,2}"), Text(
          extent=[-70,-66; 84,-72],
          style(color=3, rgbcolor={0,0,255}),
          string=
              "note singularity when primary and secondary pump flow rates are equal")));
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
      m_flow_const=10,
      m_flow(start=150),
      dp(start=60*12*0.0254*995*9.81)) "P-3: Bell& Gossett HSC3-101212XL" 
      annotation (extent=[6,-30; -6,-42]);
    Modelica.Blocks.Sources.Pulse pulse1(
      period=86400,
      startTime=86400/2,
      amplitude=0.99,
      offset=0.01) 
                  annotation (extent=[-26,-51; -16,-45]);
    Modelica.Blocks.Math.Gain gain(k=139) 
      annotation (extent=[-10,-52; -4,-44]);
    Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM(
      redeclare package Medium = MediumCHW,
      m_flow(start=150),
      dp(start=60*12*0.0254*995*9.81),
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
      dp_nominal=60*12*0.0254*9.81*995,
      m_flow_nominal=150) annotation (extent=[-14,-41; -25,-31]);
    Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM1(
      redeclare package Medium = MediumCHW,
      m_flow(start=150),
      dp(start=60*12*0.0254*995*9.81),
      dp_nominal=60*12*0.0254*9.81*995,
      m_flow_nominal=150,
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar) 
      annotation (extent=[10,15; 18,26], rotation=-90);
    Modelica.Blocks.Sources.Pulse pulse2(
      period=86400,
      startTime=86400/2,
      amplitude=-0.99,
      offset=1)   annotation (extent=[-50,13; -40,19]);
    Modelica.Blocks.Math.Gain gain1(k=140) 
      annotation (extent=[-34,12; -28,20]);
    Components.TankMB tankMB(
      redeclare package Medium = MediumCHW,
      tauBuoy=9.81*0.05,
      Radius=60*12*0.0254/2,
      h_startA=(85*12*0.0254) - 3,
      h_startB=3,
      T_startA=273.15 + (75 - 32)*5/9,
      T_startB=273.15 + (41 - 32)*5/9,
      Kwall=1e-1)          annotation (extent=[-26,-22; 0,4]);
    Components.PrescribedFlow_Pump CHWR_Primary_Pump(
      N_nom=1180,
      redeclare package Medium = MediumCHW,
      a=P1_a,
      b=P1_b,
      qNorMin_flow=P1_qNorMin_flow,
      qNorMax_flow=P1_qNorMax_flow) "P-1: Bell& Gossett HSC3-101212XL" 
      annotation (extent=[-30,36; -18,24]);
    Modelica_Fluid.Junctions.Splitter CHWR_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[-54,-3; -44,5],
                                                      rotation=-90);
    Modelica_Fluid.Junctions.Splitter CHWS_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[18,-23; 9,-15],    rotation=-90);
    Subsystems.dumbChiller dumbChiller(redeclare package Medium = MediumCHW) 
      annotation (extent=[-12,20; 8,40]);
  equation 
    connect(pulse1.y, gain.u) annotation (points=[-15.5,-48; -10.6,-48],
        style(color=74, rgbcolor={0,0,127}));
    connect(fixedResistanceDpM.port_a, CHWS_Secondary_Pump.port_b) 
      annotation (points=[-14,-36; -6,-36], style(color=69, rgbcolor={0,127,
            255}));
    connect(pulse2.y, gain1.u) 
                              annotation (points=[-39.5,16; -34.6,16],
        style(color=74, rgbcolor={0,0,127}));
    connect(CHWR_splitter.port_2, fixedResistanceDpM.port_b) annotation (
        points=[-49,-3.4; -49,-36.2; -25,-36.2; -25,-36], style(color=69,
          rgbcolor={0,127,255}));
    connect(CHWR_splitter.port_3, tankMB.PortA) annotation (points=[-43.5,1;
          -27.75,1; -27.75,1.14; -13,1.14], style(color=69, rgbcolor={0,127,
            255}));
    connect(CHWR_splitter.port_1, CHWR_Primary_Pump.port_a) annotation (
        points=[-49,5.4; -49.5,5.4; -49.5,30; -30,30], style(color=69,
          rgbcolor={0,127,255}));
    connect(fixedResistanceDpM1.port_b, CHWS_splitter.port_1) annotation (
        points=[14,15; 14,-14.6; 13.5,-14.6], style(color=69, rgbcolor={0,127,
            255}));
    connect(CHWS_splitter.port_3, tankMB.PortB) annotation (points=[8.55,-19;
          0,-19; 0,-19.4; -13,-19.4], style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (
        points=[6,-36; 12,-36; 12,-23.4; 13.5,-23.4], style(color=69,
          rgbcolor={0,127,255}));
    connect(gain.y, CHWS_Secondary_Pump.m_flow_in) annotation (points=[-3.7,-48;
          -1.8,-48; -1.8,-41.4],      style(color=74, rgbcolor={0,0,127}));
    connect(gain1.y, CHWR_Primary_Pump.m_flow_in) annotation (points=[-27.7,16;
          -22,16; -22,24.6; -22.2,24.6],     style(color=74, rgbcolor={0,0,
            127}));
    connect(dumbChiller.CHWS, CHWR_Primary_Pump.port_b) annotation (points=[
          -13,30; -18,30], style(color=69, rgbcolor={0,127,255}));
    connect(dumbChiller.CHWR, fixedResistanceDpM1.port_a) annotation (points=
          [9,30; 14,30; 14,26], style(color=69, rgbcolor={0,127,255}));
  end Test_Loop3;
  
  model Test_Loop2 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram(Text(
          extent=[-56,92; 46,66],
          style(color=3, rgbcolor={0,0,255}),
          string="nonliner equation system size {2,2}"), Text(
          extent=[-70,-66; 84,-72],
          style(color=3, rgbcolor={0,0,255}),
          string=
              "note singularity when primary and secondary pump flow rates are equal")));
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
      m_flow_const=10,
      m_flow(start=150),
      dp(start=60*12*0.0254*995*9.81)) "P-3: Bell& Gossett HSC3-101212XL" 
      annotation (extent=[6,-30; -6,-42]);
    Modelica.Blocks.Sources.Pulse pulse1(
      period=86400,
      startTime=86400/2,
      amplitude=0.99,
      offset=0.01) 
                  annotation (extent=[-26,-51; -16,-45]);
    Modelica.Blocks.Math.Gain gain(k=139) 
      annotation (extent=[-10,-52; -4,-44]);
    Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM(
      redeclare package Medium = MediumCHW,
      m_flow(start=150),
      dp(start=60*12*0.0254*995*9.81),
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
      dp_nominal=60*12*0.0254*9.81*995,
      m_flow_nominal=150) annotation (extent=[-14,-41; -25,-31]);
    Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM1(
      redeclare package Medium = MediumCHW,
      m_flow(start=150),
      dp(start=60*12*0.0254*995*9.81),
      dp_nominal=60*12*0.0254*9.81*995,
      m_flow_nominal=150,
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar) 
      annotation (extent=[10,15; 18,26], rotation=-90);
    Modelica.Blocks.Sources.Pulse pulse2(
      period=86400,
      startTime=86400/2,
      amplitude=0.99,
      offset=0.01) 
                  annotation (extent=[-42,13; -32,19]);
    Modelica.Blocks.Math.Gain gain1(k=140) 
      annotation (extent=[-26,12; -20,20]);
    Components.TankMB tankMB(
      redeclare package Medium = MediumCHW,
      tauBuoy=9.81*0.05,
      Radius=60*12*0.0254/2,
      h_startA=(85*12*0.0254) - 3,
      h_startB=3,
      T_startA=273.15 + (75 - 32)*5/9,
      T_startB=273.15 + (41 - 32)*5/9,
      Kwall=1e-1)          annotation (extent=[-26,-22; 0,4]);
    Components.PrescribedFlow_Pump CHWR_Primary_Pump(
      N_nom=1180,
      redeclare package Medium = MediumCHW,
      a=P1_a,
      b=P1_b,
      qNorMin_flow=P1_qNorMin_flow,
      qNorMax_flow=P1_qNorMax_flow) "P-1: Bell& Gossett HSC3-101212XL" 
      annotation (extent=[-22,36; -10,24]);
    Modelica_Fluid.Junctions.Splitter CHWR_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[-54,-3; -44,5],
                                                      rotation=-90);
    Modelica_Fluid.Junctions.Splitter CHWS_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[18,-23; 9,-15],    rotation=-90);
  equation 
    connect(pulse1.y, gain.u) annotation (points=[-15.5,-48; -10.6,-48],
        style(color=74, rgbcolor={0,0,127}));
    connect(fixedResistanceDpM.port_a, CHWS_Secondary_Pump.port_b) 
      annotation (points=[-14,-36; -6,-36], style(color=69, rgbcolor={0,127,
            255}));
    connect(pulse2.y, gain1.u) 
                              annotation (points=[-31.5,16; -26.6,16],
        style(color=74, rgbcolor={0,0,127}));
    connect(CHWR_Primary_Pump.port_b, fixedResistanceDpM1.port_a) annotation (
       points=[-10,30; 14,30; 14,26], style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_splitter.port_2, fixedResistanceDpM.port_b) annotation (
        points=[-49,-3.4; -49,-36.2; -25,-36.2; -25,-36], style(color=69,
          rgbcolor={0,127,255}));
    connect(CHWR_splitter.port_3, tankMB.PortA) annotation (points=[-43.5,1;
          -27.75,1; -27.75,1.14; -13,1.14], style(color=69, rgbcolor={0,127,
            255}));
    connect(CHWR_splitter.port_1, CHWR_Primary_Pump.port_a) annotation (
        points=[-49,5.4; -49.5,5.4; -49.5,30; -22,30], style(color=69,
          rgbcolor={0,127,255}));
    connect(fixedResistanceDpM1.port_b, CHWS_splitter.port_1) annotation (
        points=[14,15; 14,-14.6; 13.5,-14.6], style(color=69, rgbcolor={0,127,
            255}));
    connect(CHWS_splitter.port_3, tankMB.PortB) annotation (points=[8.55,-19;
          0,-19; 0,-19.4; -13,-19.4], style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (
        points=[6,-36; 12,-36; 12,-23.4; 13.5,-23.4], style(color=69,
          rgbcolor={0,127,255}));
    connect(gain.y, CHWS_Secondary_Pump.m_flow_in) annotation (points=[-3.7,-48;
          -1.8,-48; -1.8,-41.4],      style(color=74, rgbcolor={0,0,127}));
    connect(gain1.y, CHWR_Primary_Pump.m_flow_in) annotation (points=[-19.7,
          16; -14,16; -14,24.6; -14.2,24.6], style(color=74, rgbcolor={0,0,
            127}));
  end Test_Loop2;
  
  model Test_Loop1 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram(Text(
          extent=[-56,92; 46,44],
          style(color=3, rgbcolor={0,0,255}),
          string="nonliner equation system size {1,2}")));
    Components.TankMB tankMB(
      redeclare package Medium = MediumCHW,
      tauBuoy=9.81*0.05,
      Radius=60*12*0.0254/2,
      T_startA=273.15 + (75 - 32)*5/9,
      T_startB=273.15 + (41 - 32)*5/9,
      Kwall=1e-1,
      h_startA=3,
      h_startB=(85*12*0.0254) - 3) 
                           annotation (extent=[-28,-24; -2,2]);
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
      annotation (extent=[6,-54; -6,-42]);
    Modelica.Blocks.Sources.Pulse pulse1(
      period=86400,
      startTime=86400/2,
      amplitude=0.90,
      offset=0.1) annotation (extent=[-28,-35; -18,-29]);
    Modelica.Blocks.Math.Gain gain(k=140) 
      annotation (extent=[-12,-36; -6,-28]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM fixedResistanceDpM(
      m0_flow=150,
      dp0=60*12*0.0254*995*9.81,
      redeclare package Medium = MediumCHW) 
      annotation (extent=[-11,-57; -29,-40]);
  equation 
    connect(pulse1.y, gain.u) annotation (points=[-17.5,-32; -12.6,-32],
        style(color=74, rgbcolor={0,0,127}));
    connect(gain.y, CHWS_Secondary_Pump.m_flow_in) annotation (points=[-5.7,-32;
          -2,-32; -2,-42.6; -1.8,-42.6],      style(color=74, rgbcolor={0,0,
            127}));
    connect(tankMB.PortB, CHWS_Secondary_Pump.port_a) annotation (points=[-15,
          -21.4; -15,-20.7; 6,-20.7; 6,-48], style(color=69, rgbcolor={0,127,
            255}));
    connect(fixedResistanceDpM.port_a, CHWS_Secondary_Pump.port_b) 
      annotation (points=[-11,-48.5; -11,-48; -6,-48], style(color=69,
          rgbcolor={0,127,255}));
    connect(fixedResistanceDpM.port_b, tankMB.PortA) annotation (points=[-29,
          -48.5; -42,-48.5; -42,-0.86; -15,-0.86], style(color=69, rgbcolor={
            0,127,255}));
  end Test_Loop1;
  
  model Test_Chiller2 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-94,74; -74,94]);
    Merced.Components.Chiller Chiller1(
    redeclare package Medium_1 = MediumCW,
    redeclare package Medium_2 = MediumCHW) 
      annotation (extent=[4,18; 38,50]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR2(
    redeclare package Medium = MediumCHW,
      T=273 + (60 - 32)*5/9,
      m_flow=140) 
      annotation (extent=[58,18; 46,30]);
    Merced.Components.Chiller Chiller2(
    redeclare package Medium_1 = MediumCW,
    redeclare package Medium_2 = MediumCHW) 
      annotation (extent=[-44,10; -10,42]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX FixedBC2(
      redeclare package Medium = MediumCHW,
      p=0,
      T=273 + 5) 
      annotation (extent=[-66,10; -52,24]);
    Modelica.Blocks.Sources.Sine Sine1(
      offset=273.15 + (39 - 32)*5/9,
      amplitude=1,
      freqHz=2) 
      annotation (extent=[-78,-6; -64,4]);
    Modelica.Blocks.Sources.Sine Sine2(
      offset=273.15 + (39/2 + 60/2 - 32)*5/9,
      amplitude=1,
      freqHz=2) 
      annotation (extent=[-22,-2; -8,8]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX FixedBC1(
      redeclare package Medium = MediumCW,
      p=0,
      T=273 + 5) 
      annotation (extent=[24,72; 16,80], rotation=-90);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR1(
      redeclare package Medium = MediumCW,
      T=273.15 + (75 - 32)*5/9,
      m_flow=430) 
      annotation (extent=[-10,76; -22,88]);
    Modelica_Fluid.PressureLosses.WallFrictionAndGravity pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      diameter=1,
      p_start=ambient.default_p_ambient,
      redeclare package WallFriction = 
          Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.QuadraticTurbulent,
      use_nominal=true,
      length=1,
      redeclare package Medium = MediumCW,
      height_ab=0) 
      annotation (extent=[-64,30; -50,42]);
    Modelica_Fluid.PressureLosses.WallFrictionAndGravity pipe1(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      diameter=1,
      p_start=ambient.default_p_ambient,
      redeclare package WallFriction = 
          Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.QuadraticTurbulent,
      use_nominal=true,
      length=1,
      redeclare package Medium = MediumCW,
      height_ab=0) 
      annotation (extent=[-28,52; -14,64], rotation=-90);
  equation 
    connect(FMFR2.port, Chiller1.port_a2) annotation (points=[46,24; 46,24.4;
          38,24.4], style(color=69, rgbcolor={0,127,255}));
    connect(Chiller2.port_a2, Chiller1.port_b2) annotation (points=[-10,16.4;
          -4,16; -4,24.4; 4,24.4], style(color=69, rgbcolor={0,127,255}));
    connect(FixedBC2.port, Chiller2.port_b2) annotation (points=[-52,17; -52,
          16.4; -44,16.4], style(color=69, rgbcolor={0,127,255}));
    connect(Sine1.y, Chiller2.T_chws_ref) annotation (points=[-63.3,-1; -58,-1;
          -58,10.32; -47.4,10.32],     style(color=74, rgbcolor={0,0,127}));
    connect(Sine2.y, Chiller1.T_chws_ref) annotation (points=[-7.3,3; -7.3,3.5;
          0.6,3.5; 0.6,18.32],      style(color=74, rgbcolor={0,0,127}));
    connect(pipe.port_b, Chiller2.port_a1) annotation (points=[-50,36; -51,36;
          -51,35.6; -44,35.6], style(color=69, rgbcolor={0,127,255}));
    connect(pipe.port_a, FMFR1.port) annotation (points=[-64,36; -70,36; -70,
          82; -22,82], style(color=69, rgbcolor={0,127,255}));
    connect(FixedBC1.port, Chiller2.port_b1) annotation (points=[20,72; 6,72;
          6,35.6; -10,35.6], style(color=69, rgbcolor={0,127,255}));
    connect(FixedBC1.port, Chiller1.port_b1) annotation (points=[20,72; 30,72;
          30,43.6; 38,43.6], style(color=69, rgbcolor={0,127,255}));
    connect(Chiller1.port_a1, pipe1.port_b) annotation (points=[4,43.6; -8,
          43.6; -8,52; -21,52], style(color=69, rgbcolor={0,127,255}));
    connect(pipe1.port_a, FMFR1.port) annotation (points=[-21,64; -22,64; -22,
          82], style(color=69, rgbcolor={0,127,255}));
  end Test_Chiller2;
  
  model Test_ChillerPlant3 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-80,-22; -60,-2]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX CHWR(
      redeclare package Medium = MediumCHW,
      T=273 + (60 - 32)*5/9,
      m_flow=0.8*140) 
      annotation (extent=[26,12; 14,24]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX CHWS(
      redeclare package Medium = MediumCHW,
      p=0,
      T=273 + 5) 
      annotation (extent=[-50,14; -40,24]);
    Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
          MediumCW, redeclare package MediumCHW = MediumCHW) 
      annotation (extent=[-20,16; 0,36]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX CWS(
      redeclare package Medium = MediumCW,
      T=273.15 + (75 - 32)*5/9,
      p=101325) 
      annotation (extent=[-74,30; -66,38],
                                         rotation=0);
    Subsystems.Pumps_CW pumps_CW(redeclare package MediumCW = MediumCW) 
      annotation (extent=[-52,26; -38,40]);
    Subsystems.Cooling_Tower CooTow(redeclare package Medium = MediumCW) 
                    annotation (extent=[0,56; -20,76]);
    Modelica_Fluid.PressureLosses.PressureDropPipe CWR_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      redeclare package Medium = MediumCW,
      diameter=0.05,
      length=2.25,
      m_flow_nominal=(3500*3.78*0.001)*995,
      dp_nominal=(50*12*0.0254)*995*9.81,
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar) 
      annotation (extent=[19,46; 5,58], rotation=90);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX CWR(
      redeclare package Medium = MediumCW,
      T=273 + 5,
      p=101325) 
      annotation (extent=[-42,62; -34,70],
                                         rotation=0);
    Modelica.Blocks.Sources.Pulse pulse(
      period=86400,
      startTime=86400/2,
      amplitude=-1*140,
      offset=140)          annotation (extent=[49,17; 33,27]);
    Modelica.Blocks.Sources.Pulse pulse1(
      period=86400,
      startTime=86400/2,
      amplitude=-1180*.9,
      offset=1180)         annotation (extent=[-21,47; -37,57]);
  equation 
    connect(CHWS.port, Chiller_Plant.CHWS) annotation (points=[-40,19; -40,18;
          -21.2,18], style(color=69, rgbcolor={0,127,255}));
    connect(CHWR.port, Chiller_Plant.CHWR) annotation (points=[14,18; 1.2,18],
        style(color=69, rgbcolor={0,127,255}));
    connect(pumps_CW.CWe, CWS.port) annotation (points=[-52.98,34.4; -66,34.4;
          -66,34],         style(color=69, rgbcolor={0,127,255}));
    connect(pumps_CW.CWl, Chiller_Plant.CWR) annotation (points=[-37.16,34.4;
          -30,34.4; -30,34; -21.2,34], style(color=69, rgbcolor={0,127,255}));
    connect(CWR.port, CooTow.CWS)        annotation (points=[-34,66; -21.2,66],
        style(color=69, rgbcolor={0,127,255}));
    connect(Chiller_Plant.CWS, CWR_Pipe.port_a) annotation (points=[1,34; 12,
          34; 12,46], style(color=69, rgbcolor={0,127,255}));
    connect(CWR_Pipe.port_b, CooTow.CWR)        annotation (points=[12,58; 12,
          66; 1.2,66], style(color=69, rgbcolor={0,127,255}));
    connect(pulse.y, CHWR.m_flow_in) annotation (points=[32.2,22; 32.2,21.5;
          25.58,21.5; 25.58,21.6], style(color=74, rgbcolor={0,0,127}));
    connect(pulse1.y, pumps_CW.N_in) annotation (points=[-37.8,52; -42,52;
          -42,39.3; -41.5,39.3], style(color=74, rgbcolor={0,0,127}));
  end Test_ChillerPlant3;
  
  model Test_ChillerPlant4 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-80,-22; -60,-2]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX CHWR(
      redeclare package Medium = MediumCHW,
      T=273 + (60 - 32)*5/9,
      m_flow=0.8*140) 
      annotation (extent=[26,12; 14,24]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX CHWS(
      redeclare package Medium = MediumCHW,
      p=0,
      T=273 + 5) 
      annotation (extent=[-50,13; -40,23]);
    Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
          MediumCW, redeclare package MediumCHW = MediumCHW) 
      annotation (extent=[-20,16; 0,36]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX CWS(
      redeclare package Medium = MediumCW,
      T=273.15 + (75 - 32)*5/9,
      p=3e5) 
      annotation (extent=[-72,35; -64,43],
                                         rotation=0);
    Subsystems.Pumps_CW pumps_CW(redeclare package MediumCW = MediumCW) 
      annotation (extent=[-52,31; -38,45]);
    Subsystems.Cooling_Tower cooling_Tower(redeclare package Medium = 
          MediumCW) annotation (extent=[0,56; -20,76]);
    Modelica_Fluid.PressureLosses.PressureDropPipe CWR_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      redeclare package Medium = MediumCW,
      length=50*12*0.0254,
      diameter=24*0.0254,
      dp_nominal=(50*12*0.0254)*995*9.81,
      m_flow_nominal=(7000*3.78*.001)*995) 
      annotation (extent=[19,46; 5,58], rotation=90);
    Modelica.Blocks.Sources.Pulse pulse(
      period=86400,
      startTime=86400/2,
      offset=140,
      amplitude=-0.0*140)  annotation (extent=[57,17; 41,27]);
    Modelica.Blocks.Sources.Pulse pulse1(
      period=86400,
      startTime=86400/2,
      amplitude=-0.0*1180,
      offset=1180)         annotation (extent=[-21,47; -37,57]);
  equation 
    connect(CHWS.port, Chiller_Plant.CHWS) annotation (points=[-40,18; -21.2,18],
                     style(color=69, rgbcolor={0,127,255}));
    connect(CHWR.port, Chiller_Plant.CHWR) annotation (points=[14,18; 1.2,18],
        style(color=69, rgbcolor={0,127,255}));
    connect(pumps_CW.CWe, CWS.port) annotation (points=[-52.98,39.4; -64,39.4;
          -64,39],         style(color=69, rgbcolor={0,127,255}));
    connect(pumps_CW.CWl, Chiller_Plant.CWR) annotation (points=[-37.16,39.4;
          -30,39.4; -30,34; -21.2,34], style(color=69, rgbcolor={0,127,255}));
    connect(Chiller_Plant.CWS, CWR_Pipe.port_a) annotation (points=[1,34; 12,34; 12,
          46], style(color=69, rgbcolor={0,127,255}));
    connect(CWR_Pipe.port_b, cooling_Tower.CWR) annotation (points=[12,58; 12,
          66; 1.2,66], style(color=69, rgbcolor={0,127,255}));
    connect(cooling_Tower.CWS, pumps_CW.CWe) annotation (points=[-21.2,66; -60,
          66; -60,39.4; -52.98,39.4],     style(color=69, rgbcolor={0,127,255}));
    connect(pulse.y, CHWR.m_flow_in) annotation (points=[40.2,22; 34,22; 34,21.6; 25.58,
          21.6], style(color=74, rgbcolor={0,0,127}));
    connect(pulse1.y, pumps_CW.N_in) annotation (points=[-37.8,52; -38,52;
          -38,44.3; -41.5,44.3], style(color=74, rgbcolor={0,0,127}));
  end Test_ChillerPlant4;
  
  model Test_ChillerPlant5 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-80,-80; -60,-60]);
    Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
          MediumCW, redeclare package MediumCHW = MediumCHW) 
      annotation (extent=[-20,16; 0,36]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX CWS(
      redeclare package Medium = MediumCW,
      T=273.15 + (75 - 32)*5/9,
      p=101325) 
      annotation (extent=[-72,30; -64,38],
                                         rotation=0);
    Subsystems.Pumps_CW pumps_CW(redeclare package MediumCW = MediumCW) 
      annotation (extent=[-52,27; -40,39]);
    Subsystems.Cooling_Tower cooling_Tower(redeclare package Medium = 
          MediumCW) annotation (extent=[0,56; -20,76]);
    Modelica_Fluid.PressureLosses.WallFrictionAndGravity CWR_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      p_start=ambient.default_p_ambient,
      use_nominal=true,
      redeclare package Medium = MediumCW,
      d_nominal=995,
      redeclare package WallFriction = 
          Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.Laminar,
      length=50*12*0.0254,
      diameter=24*0.0254,
      height_ab=60*12*0.0254,
      eta_nominal=1e-3,
      from_dp=false) 
      annotation (extent=[19,46; 5,58], rotation=90);
    Components.TankMB tankMB(
      redeclare package Medium = MediumCHW,
      T_startB=273.15 + 6) annotation (extent=[-22,-18; 4,8]);
    Components.FlowMachineQuadratic pump_CHR_Primary(
      redeclare package Medium = MediumCHW,
      a={208542.283151189,205771.962392144,-1518335.08994192},
      b={0.0857970011564655,6.68960721072079,-14.2474444944515},
      qNorMin_flow=0.101276367798246,
      qNorMax_flow=0.303829103394737,
      N_nom=1180,
      N=1180) "pump1: Bell& Gossett HSC3-101212XL" 
                                  annotation (extent=[24,12; 12,24]);
    Modelica_Fluid.PressureLosses.WallFrictionAndGravity CHR_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      p_start=ambient.default_p_ambient,
      use_nominal=true,
      d_nominal=995,
      redeclare package WallFriction = 
          Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.Laminar,
      diameter=24*0.0254,
      redeclare package Medium = MediumCHW,
      length=1,
      eta_nominal=1e-3,
      from_dp=false,
      height_ab=55*12*0.0254) 
      annotation (extent=[-25,6; -39,-6],
                                        rotation=90);
    Modelica.Blocks.Sources.Pulse pulse1(
      period=86400,
      startTime=86400/2,
      amplitude=-0.0*1180,
      offset=1180)         annotation (extent=[-18,48; -29,53]);
  equation 
    connect(pumps_CW.CWe, CWS.port) annotation (points=[-52.84,34.2; -64,34.2;
          -64,34],         style(color=69, rgbcolor={0,127,255}));
    connect(pumps_CW.CWl, Chiller_Plant.CWR) annotation (points=[-39.28,34.2;
          -30,34.2; -30,34; -21.2,34], style(color=69, rgbcolor={0,127,255}));
    connect(Chiller_Plant.CWS, CWR_Pipe.port_a) annotation (points=[1,34; 12,34; 12,
          46], style(color=69, rgbcolor={0,127,255}));
    connect(CWR_Pipe.port_b, cooling_Tower.CWR) annotation (points=[12,58; 12,
          66; 1.2,66], style(color=69, rgbcolor={0,127,255}));
    connect(cooling_Tower.CWS, pumps_CW.CWe) annotation (points=[-21.2,66; -60,
          66; -60,34.2; -52.84,34.2],     style(color=69, rgbcolor={0,127,255}));
    connect(pump_CHR_Primary.port_b, Chiller_Plant.CHWR) annotation (points=[12,18;
          1.2,18],
               style(color=69, rgbcolor={0,127,255}));
    connect(Chiller_Plant.CHWS, CHR_Pipe.port_a) annotation (points=[-21.2,18;
          -32,18; -32,6], style(color=69, rgbcolor={0,127,255}));
    connect(CHR_Pipe.port_b, tankMB.PortB) annotation (points=[-32,-6; -32,
          -15.4; -9,-15.4], style(color=69, rgbcolor={0,127,255}));
    connect(pump_CHR_Primary.port_a, tankMB.PortA) annotation (points=[24,18;
          30,18; 30,5.14; -9,5.14], style(color=69, rgbcolor={0,127,255}));
    connect(CHR_Pipe.port_b, tankMB.PortB) annotation (points=[-32,-6; -32,
          -15.4; -9,-15.4], style(color=69, rgbcolor={0,127,255}));
    connect(CHR_Pipe.port_b, tankMB.PortB) annotation (points=[-32,-6; -32,
          -15.4; -9,-15.4], style(color=69, rgbcolor={0,127,255}));
    connect(pulse1.y, pumps_CW.N_in) annotation (points=[-29.55,50.5; -35.775,
          50.5; -35.775,38.4; -43,38.4], style(color=74, rgbcolor={0,0,127}));
  end Test_ChillerPlant5;
  
  model Test_ChillerPlant6 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-80,-80; -60,-60]);
    Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
          MediumCW, redeclare package MediumCHW = MediumCHW) 
      annotation (extent=[0,16; -20,36]);
    Subsystems.Pumps_CW CW_Pumps(redeclare package MediumCW = MediumCW) 
      annotation (extent=[22,24; 6,41]);
    Subsystems.Cooling_Tower cooling_Tower(redeclare package Medium = 
          MediumCW) annotation (extent=[-20,42; 0,62]);
    Components.TankMB tankMB(
      redeclare package Medium = MediumCHW,
      T_startB=273.15 + 6,
      tauBuoy=9.81*0.05,
      Radius=60*12*0.0254/2,
      h_startA=(85*12*0.0254) - 3,
      h_startB=3)          annotation (extent=[-28,-24; -2,2]);
    Modelica_Fluid.PressureLosses.WallFrictionAndGravity CHWS_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      p_start=ambient.default_p_ambient,
      use_nominal=true,
      d_nominal=995,
      redeclare package WallFriction = 
          Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.Laminar,
      diameter=24*0.0254,
      redeclare package Medium = MediumCHW,
      eta_nominal=1e-3,
      from_dp=false,
      height_ab=45*12*0.0254,
      length=100) 
      annotation (extent=[11,4; 25,-8], rotation=90);
    Components.PrescribedFlow_Pump CHWS_Secondary_Pump(
      redeclare package Medium = MediumCHW,
      a={208542.283151189,205771.962392144,-1518335.08994192},
      b={0.0857970011564655,6.68960721072079,-14.2474444944515},
      qNorMin_flow=0.101276367798246,
      qNorMax_flow=0.303829103394737,
      N_nom=1180) "P-3: Bell& Gossett HSC3-101212XL" 
                                  annotation (extent=[12,-53; 0,-41]);
    Modelica_Fluid.Junctions.Splitter CHWS_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[22,-26; 13,-18],   rotation=-90);
    Modelica_Fluid.Junctions.Splitter CHWR_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[-48,-4; -38,4],
                                                      rotation=-90);
    Subsystems.Campus campus(redeclare package Medium = MediumCHW) 
      annotation (extent=[-6,-55; -26,-35]);
    Modelica_Fluid.PressureLosses.WallFrictionAndGravity CWR_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      p_start=ambient.default_p_ambient,
      use_nominal=true,
      redeclare package Medium = MediumCW,
      d_nominal=995,
      redeclare package WallFriction = 
          Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.Laminar,
      length=50*12*0.0254,
      diameter=24*0.0254,
      height_ab=60*12*0.0254,
      eta_nominal=1e-3,
      from_dp=false) 
      annotation (extent=[-37,36; -23,48],
                                        rotation=90);
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
    Modelica.Blocks.Sources.Pulse pulse1(
      period=86400,
      startTime=86400/2,
      amplitude=-0.0*1180,
      offset=1180)         annotation (extent=[47,43; 31,53]);
  equation 
    connect(Chiller_Plant.CHWS, CHWS_Pipe.port_a) 
                                                 annotation (points=[1.2,18; 18,
          18; 18,4],      style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_Pipe.port_b, CHWS_splitter.port_1) 
                                              annotation (points=[18,-8; 18,
          -17.6; 17.5,-17.6],
                  style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_splitter.port_3, tankMB.PortB) 
                                           annotation (points=[12.55,-22; -14,
          -22; -14,-21.4; -15,-21.4],style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_splitter.port_3, tankMB.PortA) 
                                            annotation (points=[-37.5,
          2.69413e-016; -16,2.69413e-016; -16,-0.86; -15,-0.86],
                            style(color=69, rgbcolor={0,127,255}));
    connect(campus.CHWR, CHWR_splitter.port_2) annotation (points=[-27.2,-39;
          -27.2,-39.5; -43,-39.5; -43,-4.4], style(color=69, rgbcolor={0,127,
            255}));
    connect(CHWS_Secondary_Pump.port_b, campus.CHWS) annotation (points=[0,-47; 0,
          -47.2; -5,-47.2],         style(color=69, rgbcolor={0,127,255}));
    connect(Chiller_Plant.CWR, CW_Pumps.CWl) annotation (points=[1.2,34; 9.24,
          34; 9.24,34.2; 5.04,34.2], style(color=69, rgbcolor={0,127,255}));
    connect(CWR_Pipe.port_a, Chiller_Plant.CWS) annotation (points=[-30,36;
          -30,34; -21,34], style(color=69, rgbcolor={0,127,255}));
    connect(CWR_Pipe.port_b, cooling_Tower.CWR) annotation (points=[-30,48; -30,
          52; -21.2,52],     style(color=69, rgbcolor={0,127,255}));
    connect(cooling_Tower.CWS, CW_Pumps.CWe) annotation (points=[1.2,52; 26,52;
          26,34.2; 23.12,34.2],     style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (points=
          [12,-47; 18,-47; 18,-26.4; 17.5,-26.4], style(color=69, rgbcolor={0,
            127,255}));
    connect(CHWR_Primary_Pump.port_b, Chiller_Plant.CHWR) annotation (points=[-26,18;
          -21.2,18],          style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_Primary_Pump.port_a, CHWR_splitter.port_1) annotation (
        points=[-38,18; -44,18; -44,4.4; -43,4.4], style(color=69, rgbcolor={
            0,127,255}));
    connect(pulse1.y, CW_Pumps.N_in) annotation (points=[30.2,48; 20,48; 20,
          40.15; 10,40.15], style(color=74, rgbcolor={0,0,127}));
  end Test_ChillerPlant6;
  
  model Test_ChillerPlant8 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    inner Modelica_Fluid.Ambient ambient(default_p_ambient=101325) 
                                         annotation (extent=[-80,-80; -60,-60]);
    Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
          MediumCW, redeclare package MediumCHW = MediumCHW) 
      annotation (extent=[0,16; -20,36]);
    Subsystems.Pumps_CW CW_Pumps(redeclare package MediumCW = MediumCW) 
      annotation (extent=[22,25; 6,40]);
    Merced.Subsystems.Cooling_Tower2 cooling_Tower(
                                           redeclare package Medium = MediumCW) 
                    annotation (extent=[-20,46; 0,66]);
    Components.TankMB tankMB(
      redeclare package Medium = MediumCHW,
      tauBuoy=9.81*0.05,
      Radius=60*12*0.0254/2,
      h_startA=(85*12*0.0254) - 3,
      h_startB=3,
      T_startA=273.15 + (75 - 32)*5/9,
      T_startB=273.15 + (41 - 32)*5/9,
      Kwall=1e-1,
      tauJet=3)            annotation (extent=[-28,-24; -2,2]);
    Modelica_Fluid.PressureLosses.PressureDropPipe CHWS_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      diameter=24*0.0254,
      redeclare package Medium = MediumCHW,
      from_dp=false,
      length=100,
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
      dp_nominal=(60*12*.0254)*995*9.81,
      m_flow_nominal=(3750*3.785*0.001/60)*995) 
      annotation (extent=[11,4; 25,-8], rotation=90);
    Modelica_Fluid.Junctions.Splitter CHWS_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[22,-26; 13,-18],   rotation=-90);
    Modelica_Fluid.Junctions.Splitter CHWR_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[-48,-4; -38,4],
                                                      rotation=-90);
    Modelica_Fluid.PressureLosses.PressureDropPipe CWR_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      redeclare package Medium = MediumCW,
      length=50*12*0.0254,
      diameter=24*0.0254,
      from_dp=false,
      dp_nominal=(52*12*0.0254)*995*9.81,
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
      m_flow_nominal=(2*3500*3.785*0.001/60)*995) 
      annotation (extent=[-37,36; -23,48],
                                        rotation=90);
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
    Components.PrescribedFlow_Pump CHWS_Secondary_Pump(
      N_nom=1180,
      redeclare package Medium = MediumCHW,
      a={208542.283151189,205771.962392144,-1518335.08994192},
      b={0.0857970011564655,6.68960721072079,-14.2474444944515},
      qNorMin_flow=0.101276367798246,
      qNorMax_flow=0.303829103394737,
      m_flow_const=10) "P-3: Bell& Gossett HSC3-101212XL" 
      annotation (extent=[6,-42; -6,-54]);
    Subsystems.Campus2 campus(
                             redeclare package Medium = MediumCHW) 
      annotation (extent=[-14,-54; -30,-39]);
    Modelica.Blocks.Sources.Pulse pulse(
      period=86400,
      startTime=86400/2,
      amplitude=-0.99,
      offset=1)           annotation (extent=[-72,25; -60,31]);
    Modelica.Blocks.Sources.Pulse pulse1(
      period=86400,
      startTime=86400/2,
      amplitude=0.85,
      offset=0.15) 
                  annotation (extent=[-26,-65; -16,-59]);
    Modelica.Blocks.Math.Gain gain(k=140) 
      annotation (extent=[-10,-66; -4,-58]);
    Modelica.Blocks.Sources.Pulse pulse2(
      period=86400,
      startTime=86400/2,
      amplitude=-0.7*1180,
      offset=1180)        annotation (extent=[28,45; 16,51]);
    Modelica_Fluid.Sources.FixedBoundary Boundary_fixed(
      p=3e5,
      T=293,
      redeclare package Medium = MediumCW) annotation (extent=[48,29; 38,39]);
    Modelica.Blocks.Math.Gain P1_m_flow_gain(k=140) 
      annotation (extent=[-54,24; -46,32]);
  equation 
    connect(Chiller_Plant.CHWS, CHWS_Pipe.port_a) 
                                                 annotation (points=[1.2,18; 18,
          18; 18,4],      style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_Pipe.port_b, CHWS_splitter.port_1) 
                                              annotation (points=[18,-8; 18,
          -17.6; 17.5,-17.6],
                  style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_splitter.port_3, tankMB.PortB) 
                                           annotation (points=[12.55,-22; -14,
          -22; -14,-21.4; -15,-21.4],style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_splitter.port_3, tankMB.PortA) 
                                            annotation (points=[-37.5,
          2.69413e-016; -16,2.69413e-016; -16,-0.86; -15,-0.86],
                            style(color=69, rgbcolor={0,127,255}));
    connect(Chiller_Plant.CWR, CW_Pumps.CWl) annotation (points=[1.2,34; 5.04,
          34],                       style(color=69, rgbcolor={0,127,255}));
    connect(CWR_Pipe.port_a, Chiller_Plant.CWS) annotation (points=[-30,36;
          -30,34; -21,34], style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_Primary_Pump.port_b, Chiller_Plant.CHWR) annotation (points=[-26,18;
          -21.2,18],     style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_Primary_Pump.port_a, CHWR_splitter.port_1) annotation (
        points=[-38,18; -44,18; -44,4.4; -43,4.4], style(color=69, rgbcolor={
            0,127,255}));
    connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (
        points=[6,-48; 18,-48; 18,-26.4; 17.5,-26.4], style(color=69,
          rgbcolor={0,127,255}));
    connect(campus.CHWS, CHWS_Secondary_Pump.port_b) annotation (points=[-13.2,
          -48.15; -10.6,-48.15; -10.6,-48; -6,-48],       style(color=69,
          rgbcolor={0,127,255}));
    connect(campus.CHWR, CHWR_splitter.port_2) annotation (points=[-30.96,-42;
          -44,-42; -44,-4.4; -43,-4.4], style(color=69, rgbcolor={0,127,255}));
    connect(pulse1.y, gain.u) annotation (points=[-15.5,-62; -10.6,-62],
        style(color=74, rgbcolor={0,0,127}));
    connect(gain.y, CHWS_Secondary_Pump.m_flow_in) annotation (points=[-3.7,-62;
          -2,-62; -2,-53.4; -1.8,-53.4],      style(color=74, rgbcolor={0,0,
            127}));
    connect(cooling_Tower.CWR, CWR_Pipe.port_b) annotation (points=[-21.2,56;
          -30,56; -30,48], style(color=69, rgbcolor={0,127,255}));
    connect(pulse2.y, CW_Pumps.N_in) annotation (points=[15.4,48; 10,48; 10,
          39.25], style(color=74, rgbcolor={0,0,127}));
    connect(CW_Pumps.CWe, cooling_Tower.CWS) annotation (points=[23.12,34; 32,
          34; 32,56; 1.2,56], style(color=69, rgbcolor={0,127,255}));
    connect(Boundary_fixed.port, CW_Pumps.CWe) annotation (points=[38,34;
          23.12,34], style(color=69, rgbcolor={0,127,255}));
    connect(P1_m_flow_gain.u, pulse.y) annotation (points=[-54.8,28; -59.4,28],
        style(color=74, rgbcolor={0,0,127}));
    connect(P1_m_flow_gain.y, CHWR_Primary_Pump.m_flow_in) annotation (points=
         [-45.6,28; -30,28; -30,23.4; -30.2,23.4], style(color=74, rgbcolor={
            0,0,127}));
  end Test_ChillerPlant8;
  
  model Test_ChillerPlant9 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    inner Modelica_Fluid.Ambient ambient(default_p_ambient=101325) 
                                         annotation (extent=[-80,-80; -60,-60]);
    Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
          MediumCW, redeclare package MediumCHW = MediumCHW) 
      annotation (extent=[0,16; -20,36]);
    Subsystems.Pumps_CW CW_Pumps(redeclare package MediumCW = MediumCW) 
      annotation (extent=[22,25; 6,40]);
    Subsystems.Cooling_Tower cooling_Tower(redeclare package Medium = MediumCW) 
                    annotation (extent=[-20,46; 0,66]);
    Components.TankMB tankMB(
      redeclare package Medium = MediumCHW,
      tauBuoy=9.81*0.05,
      Radius=60*12*0.0254/2,
      h_startA=(85*12*0.0254) - 3,
      h_startB=3,
      T_startA=273.15 + (75 - 32)*5/9,
      T_startB=273.15 + (41 - 32)*5/9,
      Kwall=1e-1,
      tauJet=3)            annotation (extent=[-28,-24; -2,2]);
    Modelica_Fluid.PressureLosses.PressureDropPipe CHWS_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      diameter=24*0.0254,
      redeclare package Medium = MediumCHW,
      from_dp=false,
      length=100,
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
      dp_nominal=(60*12*.0254)*995*9.81,
      m_flow_nominal=(3750*3.785*0.001/60)*995) 
      annotation (extent=[11,4; 25,-8], rotation=90);
    Modelica_Fluid.Junctions.Splitter CHWS_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[22,-26; 13,-18],   rotation=-90);
    Modelica_Fluid.Junctions.Splitter CHWR_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[-48,-4; -38,4],
                                                      rotation=-90);
    Modelica_Fluid.PressureLosses.PressureDropPipe CWR_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      redeclare package Medium = MediumCW,
      length=50*12*0.0254,
      diameter=24*0.0254,
      from_dp=false,
      dp_nominal=(52*12*0.0254)*995*9.81,
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
      m_flow_nominal=(2*3500*3.785*0.001/60)*995) 
      annotation (extent=[-37,36; -23,48],
                                        rotation=90);
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
    Components.PrescribedFlow_Pump CHWS_Secondary_Pump(
      N_nom=1180,
      redeclare package Medium = MediumCHW,
      a={208542.283151189,205771.962392144,-1518335.08994192},
      b={0.0857970011564655,6.68960721072079,-14.2474444944515},
      qNorMin_flow=0.101276367798246,
      qNorMax_flow=0.303829103394737,
      m_flow_const=10) "P-3: Bell& Gossett HSC3-101212XL" 
      annotation (extent=[6,-42; -6,-54]);
    Subsystems.Campus2 campus(
                             redeclare package Medium = MediumCHW) 
      annotation (extent=[-14,-54; -30,-39]);
    Modelica.Blocks.Sources.Pulse pulse(
      period=86400,
      offset=140,
      startTime=86400/2,
      amplitude=-0.9*140) annotation (extent=[-60,25; -48,31]);
    Modelica.Blocks.Sources.Pulse pulse1(
      period=86400,
      startTime=86400/2,
      amplitude=0.90,
      offset=0.1) annotation (extent=[-26,-65; -16,-59]);
    Modelica.Blocks.Math.Gain gain(k=140) 
      annotation (extent=[-10,-66; -4,-58]);
    Modelica.Blocks.Sources.Pulse pulse2(
      period=86400,
      startTime=86400/2,
      amplitude=-0.7*1180,
      offset=1180)        annotation (extent=[28,45; 16,51]);
    Modelica_Fluid.Sources.FixedBoundary Boundary_fixed(
      p=3e5,
      T=293,
      redeclare package Medium = MediumCW) annotation (extent=[48,29; 38,39]);
  equation 
    connect(Chiller_Plant.CHWS, CHWS_Pipe.port_a) 
                                                 annotation (points=[1.2,18; 18,
          18; 18,4],      style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_Pipe.port_b, CHWS_splitter.port_1) 
                                              annotation (points=[18,-8; 18,
          -17.6; 17.5,-17.6],
                  style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_splitter.port_3, tankMB.PortB) 
                                           annotation (points=[12.55,-22; -14,
          -22; -14,-21.4; -15,-21.4],style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_splitter.port_3, tankMB.PortA) 
                                            annotation (points=[-37.5,
          2.69413e-016; -16,2.69413e-016; -16,-0.86; -15,-0.86],
                            style(color=69, rgbcolor={0,127,255}));
    connect(Chiller_Plant.CWR, CW_Pumps.CWl) annotation (points=[1.2,34; 5.04,
          34],                       style(color=69, rgbcolor={0,127,255}));
    connect(CWR_Pipe.port_a, Chiller_Plant.CWS) annotation (points=[-30,36;
          -30,34; -21,34], style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_Primary_Pump.port_b, Chiller_Plant.CHWR) annotation (points=[-26,18;
          -21.2,18],     style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_Primary_Pump.port_a, CHWR_splitter.port_1) annotation (
        points=[-38,18; -44,18; -44,4.4; -43,4.4], style(color=69, rgbcolor={
            0,127,255}));
    connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (
        points=[6,-48; 18,-48; 18,-26.4; 17.5,-26.4], style(color=69,
          rgbcolor={0,127,255}));
    connect(campus.CHWS, CHWS_Secondary_Pump.port_b) annotation (points=[-13.2,
          -48.15; -10.6,-48.15; -10.6,-48; -6,-48],       style(color=69,
          rgbcolor={0,127,255}));
    connect(campus.CHWR, CHWR_splitter.port_2) annotation (points=[-30.96,-42;
          -44,-42; -44,-4.4; -43,-4.4], style(color=69, rgbcolor={0,127,255}));
    connect(pulse.y, CHWR_Primary_Pump.m_flow_in) annotation (points=[-47.4,
          28; -29.6,28; -29.6,23.4; -30.2,23.4], style(color=74, rgbcolor={0,
            0,127}));
    connect(pulse1.y, gain.u) annotation (points=[-15.5,-62; -10.6,-62],
        style(color=74, rgbcolor={0,0,127}));
    connect(gain.y, CHWS_Secondary_Pump.m_flow_in) annotation (points=[-3.7,-62;
          -2,-62; -2,-53.4; -1.8,-53.4],      style(color=74, rgbcolor={0,0,
            127}));
    connect(cooling_Tower.CWR, CWR_Pipe.port_b) annotation (points=[-21.2,56;
          -30,56; -30,48], style(color=69, rgbcolor={0,127,255}));
    connect(pulse2.y, CW_Pumps.N_in) annotation (points=[15.4,48; 10,48; 10,
          39.25], style(color=74, rgbcolor={0,0,127}));
    connect(CW_Pumps.CWe, cooling_Tower.CWS) annotation (points=[23.12,34; 32,
          34; 32,56; 1.2,56], style(color=69, rgbcolor={0,127,255}));
    connect(Boundary_fixed.port, CW_Pumps.CWe) annotation (points=[38,34;
          23.12,34], style(color=69, rgbcolor={0,127,255}));
  end Test_ChillerPlant9;
  
  model Test_TS1 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    inner Modelica_Fluid.Ambient ambient(default_p_ambient=101325) 
                                         annotation (extent=[-80,-80; -60,-60]);
    Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
          MediumCW, redeclare package MediumCHW = MediumCHW) 
      annotation (extent=[0,16; -20,36]);
    Subsystems.Pumps_CW CW_Pumps(redeclare package MediumCW = MediumCW) 
      annotation (extent=[22,25; 6,40]);
    Merced.Subsystems.Cooling_Tower2 cooling_Tower(
                                           redeclare package Medium = MediumCW) 
                    annotation (extent=[-20,46; 0,66]);
    Components.TankMB tankMB(
      redeclare package Medium = MediumCHW,
      tauBuoy=9.81*0.05,
      Radius=60*12*0.0254/2,
      h_startA=(85*12*0.0254) - 3,
      h_startB=3,
      T_startA=273.15 + (75 - 32)*5/9,
      T_startB=273.15 + (41 - 32)*5/9,
      Kwall=1e-1,
      tauJet=3)            annotation (extent=[-28,-24; -2,2]);
    Modelica_Fluid.PressureLosses.PressureDropPipe CHWS_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      diameter=24*0.0254,
      redeclare package Medium = MediumCHW,
      from_dp=false,
      length=100,
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
      dp_nominal=(60*12*.0254)*995*9.81,
      m_flow_nominal=(3750*3.785*0.001/60)*995) 
      annotation (extent=[11,4; 25,-8], rotation=90);
    Modelica_Fluid.Junctions.Splitter CHWS_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[22,-26; 13,-18],   rotation=-90);
    Modelica_Fluid.Junctions.Splitter CHWR_splitter(redeclare package Medium = 
          MediumCHW) annotation (extent=[-48,-4; -38,4],
                                                      rotation=-90);
    Modelica_Fluid.PressureLosses.PressureDropPipe CWR_Pipe(
      flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
      redeclare package Medium = MediumCW,
      length=50*12*0.0254,
      diameter=24*0.0254,
      from_dp=false,
      dp_nominal=(52*12*0.0254)*995*9.81,
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
      m_flow_nominal=(2*3500*3.785*0.001/60)*995) 
      annotation (extent=[-37,36; -23,48],
                                        rotation=90);
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
    Components.PrescribedFlow_Pump CHWS_Secondary_Pump(
      N_nom=1180,
      redeclare package Medium = MediumCHW,
      a={208542.283151189,205771.962392144,-1518335.08994192},
      b={0.0857970011564655,6.68960721072079,-14.2474444944515},
      qNorMin_flow=0.101276367798246,
      qNorMax_flow=0.303829103394737,
      m_flow_const=10) "P-3: Bell& Gossett HSC3-101212XL" 
      annotation (extent=[6,-42; -6,-54]);
    Subsystems.Campus2 campus(
                             redeclare package Medium = MediumCHW) 
      annotation (extent=[-14,-54; -30,-39]);
    Modelica.Blocks.Sources.Pulse pulse(
      period=86400,
      startTime=86400/2,
      offset=140,
      amplitude=-1.0*140) annotation (extent=[-60,25; -48,31]);
    Modelica.Blocks.Sources.Pulse pulse1(
      period=86400,
      startTime=86400/2,
      amplitude=0.85,
      offset=0.15) 
                  annotation (extent=[-26,-65; -16,-59]);
    Modelica.Blocks.Math.Gain gain(k=140) 
      annotation (extent=[-10,-66; -4,-58]);
    Modelica.Blocks.Sources.Pulse pulse2(
      period=86400,
      startTime=86400/2,
      amplitude=-0.7*1180,
      offset=1180)        annotation (extent=[28,45; 16,51]);
    Modelica_Fluid.Sources.FixedBoundary Boundary_fixed(
      p=3e5,
      T=293,
      redeclare package Medium = MediumCW) annotation (extent=[48,29; 38,39]);
  equation 
    connect(Chiller_Plant.CHWS, CHWS_Pipe.port_a) 
                                                 annotation (points=[1.2,18; 18,
          18; 18,4],      style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_Pipe.port_b, CHWS_splitter.port_1) 
                                              annotation (points=[18,-8; 18,
          -17.6; 17.5,-17.6],
                  style(color=69, rgbcolor={0,127,255}));
    connect(CHWS_splitter.port_3, tankMB.PortB) 
                                           annotation (points=[12.55,-22; -14,
          -22; -14,-21.4; -15,-21.4],style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_splitter.port_3, tankMB.PortA) 
                                            annotation (points=[-37.5,
          2.69413e-016; -16,2.69413e-016; -16,-0.86; -15,-0.86],
                            style(color=69, rgbcolor={0,127,255}));
    connect(Chiller_Plant.CWR, CW_Pumps.CWl) annotation (points=[1.2,34; 5.04,
          34],                       style(color=69, rgbcolor={0,127,255}));
    connect(CWR_Pipe.port_a, Chiller_Plant.CWS) annotation (points=[-30,36;
          -30,34; -21,34], style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_Primary_Pump.port_b, Chiller_Plant.CHWR) annotation (points=[-26,18;
          -21.2,18],     style(color=69, rgbcolor={0,127,255}));
    connect(CHWR_Primary_Pump.port_a, CHWR_splitter.port_1) annotation (
        points=[-38,18; -44,18; -44,4.4; -43,4.4], style(color=69, rgbcolor={
            0,127,255}));
    connect(CHWS_Secondary_Pump.port_a, CHWS_splitter.port_2) annotation (
        points=[6,-48; 18,-48; 18,-26.4; 17.5,-26.4], style(color=69,
          rgbcolor={0,127,255}));
    connect(campus.CHWS, CHWS_Secondary_Pump.port_b) annotation (points=[-13.2,
          -48.15; -10.6,-48.15; -10.6,-48; -6,-48],       style(color=69,
          rgbcolor={0,127,255}));
    connect(campus.CHWR, CHWR_splitter.port_2) annotation (points=[-30.96,-42;
          -44,-42; -44,-4.4; -43,-4.4], style(color=69, rgbcolor={0,127,255}));
    connect(pulse.y, CHWR_Primary_Pump.m_flow_in) annotation (points=[-47.4,
          28; -29.6,28; -29.6,23.4; -30.2,23.4], style(color=74, rgbcolor={0,
            0,127}));
    connect(pulse1.y, gain.u) annotation (points=[-15.5,-62; -10.6,-62],
        style(color=74, rgbcolor={0,0,127}));
    connect(gain.y, CHWS_Secondary_Pump.m_flow_in) annotation (points=[-3.7,-62;
          -2,-62; -2,-53.4; -1.8,-53.4],      style(color=74, rgbcolor={0,0,
            127}));
    connect(cooling_Tower.CWR, CWR_Pipe.port_b) annotation (points=[-21.2,56;
          -30,56; -30,48], style(color=69, rgbcolor={0,127,255}));
    connect(pulse2.y, CW_Pumps.N_in) annotation (points=[15.4,48; 10,48; 10,
          39.25], style(color=74, rgbcolor={0,0,127}));
    connect(CW_Pumps.CWe, cooling_Tower.CWS) annotation (points=[23.12,34; 32,
          34; 32,56; 1.2,56], style(color=69, rgbcolor={0,127,255}));
    connect(Boundary_fixed.port, CW_Pumps.CWe) annotation (points=[38,34;
          23.12,34], style(color=69, rgbcolor={0,127,255}));
  end Test_TS1;
  
  model Test_CoolingTower 
    package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-96,64; -76,84]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX CWR(
      redeclare package Medium = MediumCW,
      p=0,
      T=273 + 5) 
      annotation (extent=[34,20; 26,28], rotation=0);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX CWS(
      redeclare package Medium = MediumCW,
      m_flow=430,
      T=273.15 + (95 - 32)*5/9) 
      annotation (extent=[-42,18; -30,30]);
    Subsystems.Cooling_Tower cooling_Tower(redeclare package Medium = MediumCW) 
                    annotation (extent=[-16,14; 4,34]);
  equation 
    connect(CWS.port, cooling_Tower.CWR) annotation (points=[-30,24; -17.2,24],
        style(color=69, rgbcolor={0,127,255}));
    connect(cooling_Tower.CWS, CWR.port) annotation (points=[5.2,24; 26,24],
        style(color=69, rgbcolor={0,127,255}));
  end Test_CoolingTower;
end Temp;
