within Merced.CoolingPlantNew;
model Chiller_Only
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
  parameter Modelica.SIunits.AbsolutePressure dP0=1280 "Pascal";

  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = CondensorWater,
    use_T_in=true,
    m_flow=mCon_flow_nominal,
    T=298.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-88,-40},{-68,-20}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=0)
    annotation (Placement(transformation(extent={{-68,-2},{-48,18}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = CondensorWater,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=6000) "Flow resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-8,-96})));
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
    annotation (Placement(transformation(extent={{154,66},{196,108}})));

  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare package Medium1 = CondensorWater,
    redeclare package Medium2 = ChilledWater,
    per=per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    dp1_nominal(displayUnit="kPa") = dP0,
    dp2_nominal(displayUnit="kPa") = dP0)
                         "Chiller model"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={10,-42})));
  Buildings.Fluid.Movers.FlowControlled_m_flow Pump_CHW(
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    tau=30,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Pump for chilled water loop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={46,-96})));
  Buildings.Fluid.Sources.FixedBoundary sin1(redeclare package Medium =
        CondensorWater, nPorts=1)       annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={-70,-106},
        rotation=180)));
  Modelica.Blocks.Sources.Constant ChilledWaterPump(k=mEva_flow_nominal)
    "chilled water flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={104,-140})));
  Buildings.Fluid.Sources.FixedBoundary refP(
    redeclare package Medium = ChilledWater,
    use_T=false,
    nPorts=1) "Expansion vessel" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={188,20})));
  Modelica.Blocks.Sources.Constant ChillerON(k=1) "chilled water flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-104,8})));
  Modelica.Blocks.Sources.Constant TCHWSP(k=273.15 + 4)
    "chilled water flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-28,62})));
  Modelica.Blocks.Sources.Constant TCWSSP(k=273.15 + 10)
    "chilled water flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-122,-26})));
  Buildings.Fluid.Sensors.Temperature Sensor_TCHWR(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{64,-96},{84,-76}})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal(displayUnit="kPa") = dP0)                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={78,20})));
  Buildings.Fluid.Sensors.MassFlowRate Sensor_msup(redeclare package Medium =
        ChilledWater)                                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={46,20})));
  Buildings.Fluid.Sensors.Temperature Sensor_TCHWS(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{118,20},{138,40}})));
  Buildings.Fluid.Sources.Boundary_pT ReturnFromBuilding(
    redeclare package Medium = ChilledWater,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={112,-96})));
  BuildingReturnCal buildingReturnCal annotation (Placement(transformation(
        extent={{-15,11},{15,-11}},
        rotation=180,
        origin={151,-95})));
  Modelica.Blocks.Sources.Constant BuildingCoolingLoad(k=500*3*1e3) annotation (
     Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={204,-90})));
equation
  connect(chi.on,greaterThreshold. y) annotation (Line(
      points={{7,-30},{8,-30},{8,8},{-47,8}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(sou1.ports[1], chi.port_a1) annotation (Line(points={{-68,-30},{-34,-30},
          {-34,-32},{4,-32}}, color={0,127,255}));
  connect(chi.port_b1, res1.port_a) annotation (Line(points={{4,-52},{-2,-52},{-2,
          -86},{-8,-86}}, color={0,127,255}));
  connect(res1.port_b, sin1.ports[1]) annotation (Line(points={{-8,-106},{-34,-106},
          {-34,-106},{-60,-106}}, color={0,127,255}));
  connect(ChilledWaterPump.y, Pump_CHW.m_flow_in)
    annotation (Line(points={{93,-140},{46,-140},{46,-108}}, color={0,0,127}));
  connect(Pump_CHW.port_b, chi.port_a2)
    annotation (Line(points={{36,-96},{16,-96},{16,-52}}, color={0,127,255}));
  connect(ChillerON.y, greaterThreshold.u)
    annotation (Line(points={{-93,8},{-70,8}}, color={0,0,127}));
  connect(TCHWSP.y, chi.TSet) annotation (Line(points={{-17,62},{14,62},{14,-30},
          {13,-30}}, color={0,0,127}));
  connect(TCWSSP.y, sou1.T_in)
    annotation (Line(points={{-111,-26},{-90,-26}}, color={0,0,127}));
  connect(chi.port_b2, Sensor_msup.port_a) annotation (Line(points={{16,-32},{26,
          -32},{26,20},{36,20}}, color={0,127,255}));
  connect(Sensor_msup.port_b, res2.port_a)
    annotation (Line(points={{56,20},{68,20}},         color={0,127,255}));
  connect(Sensor_TCHWR.port, Pump_CHW.port_a)
    annotation (Line(points={{74,-96},{56,-96}}, color={0,127,255}));
  connect(ReturnFromBuilding.ports[1], Sensor_TCHWR.port)
    annotation (Line(points={{102,-96},{74,-96}}, color={0,127,255}));
  connect(BuildingCoolingLoad.y, buildingReturnCal.QCL) annotation (Line(points=
         {{193,-90},{176,-90},{176,-91.48},{160.3,-91.48}}, color={0,0,127}));
  connect(Sensor_msup.m_flow, buildingReturnCal.msup) annotation (Line(points={
          {46,31},{46,54},{172,54},{172,-100.72},{160.3,-100.72}}, color={0,0,
          127}));
  connect(res2.port_b, refP.ports[1])
    annotation (Line(points={{88,20},{178,20}}, color={0,127,255}));
  connect(Sensor_TCHWS.port, res2.port_b)
    annotation (Line(points={{128,20},{88,20}}, color={0,127,255}));
  connect(Sensor_TCHWS.T, buildingReturnCal.Tsup) annotation (Line(points={{135,
          30},{152,30},{152,32},{168,32},{168,-96.54},{160.3,-96.54}}, color={0,
          0,127}));
  connect(buildingReturnCal.Tret, ReturnFromBuilding.T_in) annotation (Line(
        points={{143.2,-93.02},{133.6,-93.02},{133.6,-92},{124,-92}}, color={0,
          0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -160},{220,100}}),
                         graphics={Text(
          extent={{-84,38},{106,-92}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="CHL")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{220,
            100}}),
        graphics={Text(
          extent={{-112,112},{-52,66}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="Norminal Cap: 1000 ton
Norminal Water Flows: 2gpm/ton for evap, 3 gpm /to for comp (~5oC DTW).")}));
end Chiller_Only;