within Merced.ZeroFlow;
model Test_Pump
  replaceable package Medium =
      Modelica.Media.Water.ConstantPropertyLiquidWater;
  Components.PrescribedFlow_Pump speedpump(
    redeclare package Medium = Medium,
    a={265534.776168551,157317.088939285,-1045931.5671727},
    b={-0.0734399353605566,5.1386797187811,-7.20622906783169},
    qNorMin_flow=0.104332257676433,
    qNorMax_flow=0.422067104450367) annotation (Placement(transformation(extent=
           {{-16,-2},{4,18}}, rotation=0)));
  Modelica_Fluid.Sources.FixedBoundary Source(
    redeclare package Medium = Medium,
    p=3e5,
    T=293) annotation (Placement(transformation(extent={{-54,-2},{-34,18}},
          rotation=0)));
  Modelica_Fluid.Sources.FixedBoundary Sink(
    redeclare package Medium = Medium,
    T=293,
    p=3e5)       annotation (Placement(transformation(extent={{78,-2},{58,18}},
          rotation=0)));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    height=-300*0.99,
    offset=300) annotation (Placement(transformation(extent={{-34,22},{-18,38}},
          rotation=0)));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM fixedResistanceDpM(
    redeclare package Medium = Medium,
    m0_flow=150,
    dp0=60*12*0.0254*995*9.81) annotation (Placement(transformation(extent={{16,
            -2},{36,18}}, rotation=0)));
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
    annotation (Placement(transformation(extent={{-16,-40},{10,-14}}, rotation=
            0)));
  Modelica_Fluid.Sources.FixedBoundary Source1(
    redeclare package Medium = Medium,
    p=3e5,
    T=293) annotation (Placement(transformation(extent={{-56,-44},{-36,-24}},
          rotation=0)));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM fixedResistanceDpM1(
    redeclare package Medium = Medium,
    m0_flow=150,
    dp0=60*12*0.0254*995*9.81) annotation (Placement(transformation(extent={{20,
            -32},{40,-12}}, rotation=0)));
  Modelica_Fluid.Sources.FixedBoundary Sink1(
    redeclare package Medium = Medium,
    T=293,
    p=3e5)       annotation (Placement(transformation(extent={{82,-32},{62,-12}},
          rotation=0)));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    offset=1200,
    height=-1200*1) annotation (Placement(transformation(extent={{-42,-20},{-26,
            -4}}, rotation=0)));
  Buildings.Fluids.Movers.FlowMachinePolynomial speedpump1(
    redeclare package Medium = Medium,
    b={-0.0734399353605566,5.1386797187811,-7.20622906783169},
    D=1,
    mNorMin_flow=30,
    mNorMax_flow=100,
    a={265534.776168551,157317.088939285,-1045931.5671727},
    scaM_flow=1/50)                 annotation (Placement(transformation(extent=
           {{-22,46},{-2,66}}, rotation=0)));
  Modelica_Fluid.Sources.FixedBoundary Source2(
    redeclare package Medium = Medium,
    p=3e5,
    T=293) annotation (Placement(transformation(extent={{-60,46},{-40,66}},
          rotation=0)));
  Modelica_Fluid.Sources.FixedBoundary Sink2(
    redeclare package Medium = Medium,
    T=293,
    p=3e5)       annotation (Placement(transformation(extent={{72,46},{52,66}},
          rotation=0)));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM fixedResistanceDpM2(
    redeclare package Medium = Medium,
    m0_flow=150,
    dp0=60*12*0.0254*995*9.81) annotation (Placement(transformation(extent={{10,
            46},{30,66}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=10,
    offset=1,
    height=-0.99) annotation (Placement(transformation(extent={{-50,72},{-34,88}},
          rotation=0)));
equation
  connect(Source.port, speedpump.port_a)
    annotation (Line(points={{-34,8},{-16,8}}, color={0,127,255}));
  connect(ramp.y, speedpump.m_flow_in) annotation (Line(points={{-17.2,30},{-3,
          30},{-3,17}}, color={0,0,127}));
  connect(fixedResistanceDpM.port_a, speedpump.port_b)
    annotation (Line(points={{16,8},{4,8}}, color={0,127,255}));
  connect(fixedResistanceDpM.port_b, Sink.port) annotation (Line(points={{36,8},
          {58,8}}, color={0,127,255}));
  connect(Source1.port, pumps.inlet) annotation (Line(points={{-36,-34},{-26,
          -34},{-26,-29.6},{-13.4,-29.6}}, color={0,127,255}));
  connect(Sink1.port, fixedResistanceDpM1.port_b) annotation (Line(points={{62,
          -22},{40,-22}}, color={0,127,255}));
  connect(fixedResistanceDpM1.port_a, pumps.outlet) annotation (Line(points={{
          20,-22},{12.4,-22},{12.4,-22.84},{4.8,-22.84}}, color={0,127,255}));
  connect(ramp1.y, pumps.N_in) annotation (Line(points={{-25.2,-12},{-6,-12},{
          -6,-21.28},{-6.38,-21.28}}, color={0,0,127}));
  connect(Source2.port, speedpump1.port_a)
    annotation (Line(points={{-40,56},{-22,56}}, color={0,127,255}));
  connect(fixedResistanceDpM2.port_a, speedpump1.port_b) annotation (Line(
        points={{10,56},{-2,56}}, color={0,127,255}));
  connect(fixedResistanceDpM2.port_b, Sink2.port) annotation (Line(points={{30,
          56},{52,56}}, color={0,127,255}));
  connect(ramp2.y, speedpump1.N_in) annotation (Line(points={{-33.2,80},{-26,80},
          {-26,62},{-23,62}}, color={0,0,127}));
  annotation (Diagram(graphics));
end Test_Pump;
