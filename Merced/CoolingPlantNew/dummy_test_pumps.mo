within Merced.CoolingPlantNew;
model dummy_test_pumps
  package CondensorWater =  Buildings.Media.Water;
  package ChilledWater =  Buildings.Media.Water;

  parameter Modelica.SIunits.Power P_nominal=-per.QEva_flow_nominal/per.COP_nominal
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
    "Nominal mass flow rate at evaporator";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
    "Nominal mass flow rate at condenser";

  Buildings.Fluid.Movers.FlowControlled_m_flow CHWP(
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    tau=30,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Pump for chilled water loop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={16,-94})));
  Modelica.Blocks.Sources.Constant mCHW(k=1*mEva_flow_nominal)
    "chilled water flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={104,-140})));
  Buildings.Fluid.MixingVolumes.MixingVolume Building(
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nPorts=4,
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    V=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={128,-46})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixHeaFlo1(Q_flow(
        displayUnit="kW") = 0)    "Fixed heat flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,-62})));
  Buildings.Fluid.Sources.FixedBoundary refP(
    redeclare package Medium = ChilledWater,
    use_T=false,
    nPorts=1) "Expansion vessel" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={166,-12})));
  Buildings.Fluid.Sensors.Temperature TCHWR(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{92,-72},{112,-52}})));
  Modelica.Blocks.Sources.Constant SPmSbypass(k=0.1*mEva_flow_nominal)
    "chilled water flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,42})));
  Buildings.Fluid.FixedResistances.Junction junRe(redeclare package Medium =
        ChilledWater,
    m_flow_nominal={0.9*mEva_flow_nominal,-mEva_flow_nominal,0.1*
        mEva_flow_nominal},
    dp_nominal={0,0,0})                                                                annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={46,-94})));
  Buildings.Fluid.Sensors.MassFlowRate Sensor_mS(redeclare package Medium =
        ChilledWater)                                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={44,-26})));
  Buildings.Fluid.Sensors.MassFlowRate Sensor_msup(redeclare package Medium =
        ChilledWater)                                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={96,20})));
  Buildings.Fluid.Movers.FlowControlled_m_flow CHWP_secondary(
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    tau=30,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Pump for chilled water loop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,20})));
  Buildings.Fluid.FixedResistances.Junction junSu(redeclare package Medium =
        ChilledWater,
    m_flow_nominal={mEva_flow_nominal,-0.9*mEva_flow_nominal,-0.1*
        mEva_flow_nominal},
    dp_nominal={0,0,0})                         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={44,20})));
  Buildings.Fluid.FixedResistances.PressureDrop res(redeclare package Medium =
        ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=6000)                                                                       annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-32})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(redeclare package Medium =
        ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=6000)                                                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,-56})));
  Buildings.Fluid.Sensors.MassFlowRate Sensor_mtot(redeclare package Medium =
        ChilledWater)                                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,0})));
  parameter
    Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
    per(
    QEva_flow_nominal(displayUnit="kW") = -3000000,
    COP_nominal=7,
    PLRMax=1,
    PLRMinUnl=0.4,
    mEva_flow_nominal=1000*2*0.06,
    mCon_flow_nominal=1000*3*0.06,
    capFunT={0.70790824,-0.002006568,-0.00259605,0.030058776,-0.0010564344,0.0020457036},
    EIRFunT={0.5605438,-0.01377927,6.57072e-005,0.013219362,0.000268596,-0.0005011308},
    EIRFunPLR={0.17149273,0.58820208,0.23737257}) "Chiller performance data"
    annotation (Placement(transformation(extent={{136,38},{178,80}})));

  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=6000)                                                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={116,8})));
equation
  connect(mCHW.y, CHWP.m_flow_in)
    annotation (Line(points={{93,-140},{16,-140},{16,-106}}, color={0,0,127}));
  connect(fixHeaFlo1.port, Building.heatPort)
    annotation (Line(points={{160,-52},{160,-36},{128,-36}},color={191,0,0}));
  connect(refP.ports[1], Building.ports[1]) annotation (Line(points={{156,-12},{
          116,-12},{116,-43},{118,-43}},
                                      color={0,127,255}));
  connect(Building.ports[2], TCHWR.port)
    annotation (Line(points={{118,-45},{118,-72},{102,-72}},
                                                          color={0,127,255}));
  connect(Building.ports[3], junRe.port_1) annotation (Line(points={{118,-47},{118,
          -94},{56,-94}},  color={0,127,255}));
  connect(junRe.port_2, CHWP.port_a)
    annotation (Line(points={{36,-94},{26,-94}}, color={0,127,255}));
  connect(CHWP_secondary.port_b, Sensor_msup.port_a)
    annotation (Line(points={{80,20},{86,20}}, color={0,127,255}));
  connect(SPmSbypass.y, CHWP_secondary.m_flow_in)
    annotation (Line(points={{61,42},{70,42},{70,32}}, color={0,0,127}));
  connect(CHWP_secondary.port_a, junSu.port_2)
    annotation (Line(points={{60,20},{54,20}}, color={0,127,255}));
  connect(junSu.port_3, Sensor_mS.port_a)
    annotation (Line(points={{44,10},{44,-16}}, color={0,127,255}));
  connect(CHWP.port_b, res.port_a)
    annotation (Line(points={{6,-94},{-20,-94},{-20,-42}}, color={0,127,255}));
  connect(Sensor_mS.port_b, res1.port_a)
    annotation (Line(points={{44,-36},{46,-36},{46,-46}}, color={0,127,255}));
  connect(res1.port_b, junRe.port_3)
    annotation (Line(points={{46,-66},{46,-84}}, color={0,127,255}));
  connect(res.port_b, Sensor_mtot.port_a)
    annotation (Line(points={{-20,-22},{-20,-10}}, color={0,127,255}));
  connect(Sensor_mtot.port_b, junSu.port_1)
    annotation (Line(points={{-20,10},{-20,20},{34,20}}, color={0,127,255}));
  connect(Sensor_msup.port_b, res2.port_a)
    annotation (Line(points={{106,20},{116,20},{116,18}}, color={0,127,255}));
  connect(res2.port_b, Building.ports[4]) annotation (Line(points={{116,-2},{116,
          -44},{118,-44},{118,-49}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},
            {180,100}}), graphics={Text(
          extent={{-84,38},{106,-92}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="CHL")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{180,100}}),
        graphics={Text(
          extent={{-112,112},{-52,66}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="Norminal Cap: 1000 ton
Norminal Water Flows: 2gpm/ton for evap, 3 gpm /to for comp (~5oC DTW).")}));
end dummy_test_pumps;
