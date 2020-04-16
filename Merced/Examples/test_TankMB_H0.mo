within Merced.Examples;
model test_TankMB_H0
  extends Modelica.Icons.Example;
  package Water = Buildings.Media.Water;
  //package Water =         Modelica.Media.Water.StandardWater;
  H_Fluid.TankMB_H tankMB_H(redeclare package MediumA = Water, redeclare
      package MediumB = Water)
    annotation (Placement(transformation(extent={{14,18},{54,58}})));
  Modelica.Fluid.Pipes.StaticPipe pipe(redeclare package Medium =Water,
    length=1,
    diameter=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-26,-26})));
  Modelica.Fluid.Pipes.StaticPipe pipe1(
    redeclare package Medium = Water,
    length=1,
    diameter=1)
    annotation (Placement(transformation(extent={{-88,78},{-108,98}})));
  Modelica.Fluid.Sources.FixedBoundary CWR(
    redeclare package Medium = Water,
    p=0,
    T=293.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-176,76},{-156,96}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-184,108},{-164,128}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear RV(
    redeclare package Medium = Water,
    m_flow_nominal=1,
    dpValve_nominal=1e-3)
    annotation (Placement(transformation(extent={{34,74},{14,94}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear SV(
    redeclare package Medium = Water,
    m_flow_nominal=1,
    dpValve_nominal=1e-3)
    annotation (Placement(transformation(extent={{16,-16},{36,-36}})));
  Modelica.Fluid.Sensors.Pressure BRp(redeclare package Medium = Water)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={8,58})));
  Modelica.Fluid.Sensors.Pressure BSp(redeclare package Medium = Water)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={2,-2})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow CoolingLoad(
    Q_flow=1.6e3,
    T_ref=293.15,
    alpha=-0.5) annotation (Placement(transformation(
        extent={{-17,17},{17,-17}},
        rotation=90,
        origin={141,-21})));
  Modelica.Fluid.Pipes.DynamicPipe Building(
    redeclare package Medium = Water,
    use_T_start=true,
    T_start=Modelica.SIunits.Conversions.from_degC(80),
    length=2,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    diameter=1,
    nNodes=1,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.DetailedPipeFlow,
    use_HeatTransfer=true,
    modelStructure=Modelica.Fluid.Types.ModelStructure.a_v_b,
    p_a_start=130000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={116,18})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=0.1)
    annotation (Placement(transformation(extent={{-26,-70},{-6,-50}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=0.1)
    annotation (Placement(transformation(extent={{-28,100},{-8,120}})));
  Modelica.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Water,
    use_m_flow_in=false,
    use_T_in=false,
    m_flow=3.14*20^2*1/10,
    T=283.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-148,-36},{-128,-16}})));
equation
  connect(tankMB_H.PortA, RV.port_3) annotation (Line(points={{34,53.6},{34,64},
          {24,64},{24,74}}, color={0,127,255}));
  connect(RV.port_2, pipe1.port_a) annotation (Line(points={{14,84},{-38,84},{-38,
          88},{-88,88}}, color={0,127,255}));
  connect(pipe1.port_b, CWR.ports[1]) annotation (Line(points={{-108,88},{-132,
          88},{-132,86},{-156,86}}, color={0,127,255}));
  connect(SV.port_1, pipe.port_b)
    annotation (Line(points={{16,-26},{-16,-26}}, color={0,127,255}));
  connect(SV.port_3, tankMB_H.PortB)
    annotation (Line(points={{26,-16},{26,22},{34,22}}, color={0,127,255}));
  connect(CoolingLoad.port, Building.heatPorts[1]) annotation (Line(points={{
          141,-4},{141,18.1},{120.4,18.1}}, color={191,0,0}));
  connect(SV.port_2, Building.port_a)
    annotation (Line(points={{36,-26},{116,-26},{116,8}}, color={0,127,255}));
  connect(Building.port_b, RV.port_1)
    annotation (Line(points={{116,28},{116,84},{34,84}}, color={0,127,255}));
  connect(realExpression2.y, RV.y) annotation (Line(points={{-7,110},{8,110},{8,
          96},{24,96}}, color={0,0,127}));
  connect(realExpression1.y, SV.y) annotation (Line(points={{-5,-60},{12,-60},{
          12,-38},{26,-38}}, color={0,0,127}));
  connect(SV.port_1, BSp.port) annotation (Line(points={{16,-26},{9,-26},{9,-12},
          {2,-12}}, color={0,127,255}));
  connect(RV.port_2, BRp.port)
    annotation (Line(points={{14,84},{8,84},{8,68}}, color={0,127,255}));
  connect(boundary.ports[1], pipe.port_a)
    annotation (Line(points={{-128,-26},{-36,-26}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-200,-100},{160,140}})), Icon(
        coordinateSystem(extent={{-200,-100},{160,140}})));
end test_TankMB_H0;
