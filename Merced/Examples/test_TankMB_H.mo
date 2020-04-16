within Merced.Examples;
model test_TankMB_H
  extends Modelica.Icons.Example;
  package Water = Buildings.Media.Water;
  //package Water =         Modelica.Media.Water.StandardWater;
  Components.TankMB_H tankMB_H(redeclare package MediumA=Water, redeclare
      package MediumB =                                                                   Water)
    annotation (Placement(transformation(extent={{-10,-40},{30,0}})));
  Modelica.Fluid.Sources.FixedBoundary downstream(
    redeclare package Medium = Water,
    p=100000,
    T=283.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-94,-14},{-74,6}})));
  Modelica.Fluid.Pipes.StaticPipe pipe(redeclare package Medium =Water,
    length=1,
    diameter=1)
    annotation (Placement(transformation(extent={{40,-64},{60,-44}})));
  Modelica.Fluid.Sources.FixedBoundary upstream(
    redeclare package Medium = Water,
    p=100000,
    T=323.15,
    nPorts=1) annotation (Placement(transformation(extent={{-44,28},{-24,48}})));
  Modelica.Fluid.Machines.PrescribedPump pump1(N_nominal=3600,
    redeclare function flowCharacteristic =
        Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow (
          V_flow_nominal={0,0.25,0.5}, head_nominal={100,60,0}),
    use_N_in=true,
    nParallel=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V(displayUnit="l") = 0.05,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare package Medium = Water,
    p_b_start=600000,
    T_start=system.T_start)
    annotation (Placement(transformation(extent={{-42,-14},{-22,6}})));
  Modelica.Blocks.Continuous.LimPID PID(
    k=2,
    Ti=10,
    Td=0,
    yMax=2,                                     yMin=0)
    annotation (Placement(transformation(extent={{-68,-50},{-48,-30}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=0.9)
    annotation (Placement(transformation(extent={{-102,-50},{-82,-30}})));
  Modelica.Fluid.Pipes.StaticPipe pipe1(
    redeclare package Medium = Water,
    length=1,
    diameter=1)
    annotation (Placement(transformation(extent={{-8,20},{12,40}})));
  Modelica.Blocks.Math.Gain gain(k=3600)
    annotation (Placement(transformation(extent={{-58,2},{-50,10}})));
equation
  connect(tankMB_H.PortB, pipe.port_a)
    annotation (Line(points={{10,-36},{10,-54},{40,-54}}, color={0,127,255}));
  connect(realExpression.y, PID.u_s)
    annotation (Line(points={{-81,-40},{-70,-40}}, color={0,0,127}));
  connect(tankMB_H.z[3], PID.u_m) annotation (Line(points={{24,-10.6667},{24,
          -52},{-58,-52}},    color={0,0,127}));
  connect(upstream.ports[1], pipe1.port_a) annotation (Line(points={{-24,38},{
          -18,38},{-18,30},{-8,30}}, color={0,127,255}));
  connect(pipe1.port_b, tankMB_H.PortA)
    annotation (Line(points={{12,30},{12,-4.4},{10,-4.4}},
                                                         color={0,127,255}));
  connect(downstream.ports[1], pump1.port_a)
    annotation (Line(points={{-74,-4},{-42,-4}}, color={0,127,255}));
  connect(pump1.port_b, pipe.port_b) annotation (Line(points={{-22,-4},{70,-4},
          {70,-54},{60,-54}}, color={0,127,255}));
  connect(PID.y, gain.u) annotation (Line(points={{-47,-40},{-64,-40},{-64,6},{
          -58.8,6}}, color={0,0,127}));
  connect(gain.y, pump1.N_in)
    annotation (Line(points={{-49.6,6},{-32,6}}, color={0,0,127}));
  connect(pump1.port_b, tankMB_H.PortA) annotation (Line(points={{-22,-4},{-6,
          -4},{-6,-4.4},{10,-4.4}}, color={0,127,255}));
end test_TankMB_H;
