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
