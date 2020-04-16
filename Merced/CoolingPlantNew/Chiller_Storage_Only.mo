within Merced.CoolingPlantNew;
model Chiller_Storage_Only
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
  parameter Modelica.SIunits.AbsolutePressure dP0=1280;
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
    annotation (Placement(transformation(extent={{162,38},{204,80}})));

  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare package Medium1 = CondensorWater,
    redeclare package Medium2 = ChilledWater,
    per=per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    dp1_nominal=dP0,
    dp2_nominal=dP0)     "Chiller model"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={10,-42})));
  Buildings.Fluid.Movers.FlowControlled_m_flow Pump_CHW_Primary(
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    tau=30,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Pump for chilled water loop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={62,-94})));
  Buildings.Fluid.Sources.FixedBoundary sin1(redeclare package Medium =
        CondensorWater, nPorts=1)       annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={-70,-106},
        rotation=180)));
  Modelica.Blocks.Sources.Constant mCHW(k=0.5*mEva_flow_nominal)
    "chilled water flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={104,-140})));
  Buildings.Fluid.MixingVolumes.MixingVolume Building(
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nPorts=5,
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    V=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={154,-46})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixHeaFlo1(Q_flow(
        displayUnit="kW") = 500*3*1e3)
                                  "Fixed heat flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={186,-62})));
  Buildings.Fluid.Sources.FixedBoundary refP(
    redeclare package Medium = ChilledWater,
    use_T=false,
    nPorts=1) "Expansion vessel" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={160,-72})));
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
  Buildings.Fluid.Sensors.Temperature Sensor_TCHe(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{16,48},{36,68}})));
  Buildings.Fluid.Sensors.Temperature Sensor_TCHWR(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{118,-58},{138,-38}})));
  Components.TankMB_H2 tankMB_H2_1(redeclare package MediumA = ChilledWater,
      redeclare package MediumB = ChilledWater)
    annotation (Placement(transformation(extent={{58,-66},{98,-26}})));
  Buildings.Fluid.Sensors.MassFlowRate Sensor_mS(redeclare package Medium =
        ChilledWater)                                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={44,-26})));
  Buildings.Fluid.Movers.FlowControlled_m_flow Pump_CHW_Secondary(
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    tau=30,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Pump for chilled water loop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={96,20})));
  Buildings.Fluid.Sensors.MassFlowRate Sensor_msup(redeclare package Medium =
        ChilledWater)                                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={122,20})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=dP0)                                                                         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={142,-4})));
  Buildings.Fluid.Sensors.MassFlowRate Sensor_mtot(redeclare package Medium =
        ChilledWater)                                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={16,-74})));
  Buildings.Fluid.FixedResistances.Junction junSu(
    redeclare package Medium = ChilledWater,
    m_flow_nominal={mEva_flow_nominal,-0.9*mEva_flow_nominal,-0.1*
        mEva_flow_nominal},
    dp_nominal={0,0,0})                         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={42,20})));
  Buildings.Fluid.FixedResistances.Junction junRe(
    redeclare package Medium = ChilledWater,
    m_flow_nominal={0.9*mEva_flow_nominal,-mEva_flow_nominal,0.1*
        mEva_flow_nominal},
    dp_nominal={0,0,0})                                                                annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={114,-94})));
  Buildings.Fluid.FixedResistances.PressureDrop res3(
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=dP0)                                                                         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={114,-42})));
    Modelica.Blocks.Sources.Ramp SP_mCHWS(
    offset=0.1*mEva_flow_nominal,
    height=mEva_flow_nominal,
    duration=1000,
    startTime=1000) "Ramp pressure signal"
    annotation (Placement(transformation(extent={{54,74},{74,94}})));
  Buildings.Fluid.Sensors.Pressure Sensor_p_re(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{126,-94},{146,-74}})));
  Buildings.Fluid.Sensors.Pressure Sensor_pSupper(redeclare package Medium =
        ChilledWater) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={54,0})));
  Buildings.Fluid.Sensors.Pressure Sensor_psup_Discharge(redeclare package
      Medium = ChilledWater)
    annotation (Placement(transformation(extent={{128,20},{148,40}})));
  Buildings.Fluid.Sensors.Pressure Sensor_pSdown(redeclare package Medium =
        ChilledWater)                                                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={124,-68})));
  Buildings.Fluid.Sensors.Pressure Sensor_pCHe(redeclare package Medium =
        ChilledWater)                                                                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={26,30})));
  Buildings.Fluid.Sensors.Pressure Sensor_pCHi(redeclare package Medium =
        ChilledWater)                                         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-104})));
  Buildings.Fluid.Sensors.Pressure Sensor_psub_Suction(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{68,20},{88,40}})));
  Buildings.Fluid.Sensors.Temperature Sensor_TCHWS(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{50,20},{70,40}})));
  Modelica.Blocks.Math.UnitConversions.To_degC Sensor_TS
    annotation (Placement(transformation(extent={{164,-22},{184,-2}})));
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
  connect(mCHW.y, Pump_CHW_Primary.m_flow_in)
    annotation (Line(points={{93,-140},{62,-140},{62,-106}}, color={0,0,127}));
  connect(fixHeaFlo1.port, Building.heatPort)
    annotation (Line(points={{186,-52},{186,-36},{154,-36}},color={191,0,0}));
  connect(ChillerON.y, greaterThreshold.u)
    annotation (Line(points={{-93,8},{-70,8}}, color={0,0,127}));
  connect(TCHWSP.y, chi.TSet) annotation (Line(points={{-17,62},{14,62},{14,-30},
          {13,-30}}, color={0,0,127}));
  connect(TCWSSP.y, sou1.T_in)
    annotation (Line(points={{-111,-26},{-90,-26}}, color={0,0,127}));
  connect(Building.ports[1], Sensor_TCHWR.port) annotation (Line(points={{144,
          -42.8},{144,-58},{128,-58}}, color={0,127,255}));
  connect(Sensor_mS.port_b, tankMB_H2_1.PortB)
    annotation (Line(points={{44,-36},{44,-62},{78,-62}}, color={0,127,255}));
  connect(Pump_CHW_Secondary.port_b, Sensor_msup.port_a)
    annotation (Line(points={{106,20},{112,20}}, color={0,127,255}));
  connect(Sensor_msup.port_b, res2.port_a)
    annotation (Line(points={{132,20},{142,20},{142,6}}, color={0,127,255}));
  connect(Pump_CHW_Primary.port_b, Sensor_mtot.port_a)
    annotation (Line(points={{52,-94},{16,-94},{16,-84}}, color={0,127,255}));
  connect(Sensor_mtot.port_b, chi.port_a2)
    annotation (Line(points={{16,-64},{16,-52}}, color={0,127,255}));
  connect(junSu.port_3, Sensor_mS.port_a)
    annotation (Line(points={{42,10},{44,10},{44,-16}}, color={0,127,255}));
  connect(junSu.port_2, Pump_CHW_Secondary.port_a)
    annotation (Line(points={{52,20},{86,20}}, color={0,127,255}));
  connect(chi.port_b2, junSu.port_1)
    annotation (Line(points={{16,-32},{16,20},{32,20}}, color={0,127,255}));
  connect(chi.port_b2, Sensor_TCHe.port)
    annotation (Line(points={{16,-32},{16,48},{26,48}}, color={0,127,255}));
  connect(junRe.port_2, Pump_CHW_Primary.port_a)
    annotation (Line(points={{104,-94},{72,-94}}, color={0,127,255}));
  connect(Building.ports[2], junRe.port_1) annotation (Line(points={{144,-44.4},
          {144,-94},{124,-94}},color={0,127,255}));
  connect(tankMB_H2_1.PortA, res3.port_a) annotation (Line(points={{78,-30.4},{78,
          -14},{114,-14},{114,-32}},
                                   color={0,127,255}));
  connect(res3.port_b, junRe.port_3)
    annotation (Line(points={{114,-52},{114,-84}},
                                                 color={0,127,255}));
  connect(res2.port_b, Building.ports[3]) annotation (Line(points={{142,-14},{144,
          -14},{144,-46}},     color={0,127,255}));
  connect(refP.ports[1], Building.ports[4]) annotation (Line(points={{150,-72},{
          150,-47.6},{144,-47.6}},
                                color={0,127,255}));
  connect(SP_mCHWS.y, Pump_CHW_Secondary.m_flow_in)
    annotation (Line(points={{75,84},{96,84},{96,32}}, color={0,0,127}));
  connect(Building.ports[5], Sensor_p_re.port) annotation (Line(points={{144,-49.2},
          {144,-94},{136,-94}}, color={0,127,255}));
  connect(Sensor_msup.port_b, Sensor_psup_Discharge.port)
    annotation (Line(points={{132,20},{138,20}}, color={0,127,255}));
  connect(junSu.port_3, Sensor_pSupper.port) annotation (Line(points={{42,10},{44,
          10},{44,1.77636e-15}}, color={0,127,255}));
  connect(res3.port_b, Sensor_pSdown.port)
    annotation (Line(points={{114,-52},{114,-68}}, color={0,127,255}));
  connect(chi.port_b2, Sensor_pCHe.port)
    annotation (Line(points={{16,-32},{16,20},{26,20}}, color={0,127,255}));
  connect(Pump_CHW_Primary.port_b, Sensor_pCHi.port)
    annotation (Line(points={{52,-94},{30,-94}}, color={0,127,255}));
  connect(junSu.port_2, Sensor_psub_Suction.port)
    annotation (Line(points={{52,20},{78,20}}, color={0,127,255}));
  connect(junSu.port_2, Sensor_TCHWS.port)
    annotation (Line(points={{52,20},{60,20}}, color={0,127,255}));
  connect(tankMB_H2_1.T[2], Sensor_TS.u) annotation (Line(points={{92,-51.4},{
          98,-51.4},{98,-12},{162,-12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},
            {220,100}}), graphics={Text(
          extent={{-84,38},{106,-92}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="CHL")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{220,100}}),
        graphics={Text(
          extent={{-112,112},{-52,66}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="Norminal Cap: 1000 ton
Norminal Water Flows: 2gpm/ton for evap, 3 gpm /to for comp (~5oC DTW).")}));
end Chiller_Storage_Only;
