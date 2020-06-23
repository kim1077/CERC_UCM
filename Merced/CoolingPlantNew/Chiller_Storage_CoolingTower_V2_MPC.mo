within Merced.CoolingPlantNew;
model Chiller_Storage_CoolingTower_V2_MPC "Put another chiller"
  package CondensorWater =  Buildings.Media.Water;
  package ChilledWater =  Buildings.Media.Water;

  parameter Real H_par_x0=0.7 " initial state of charge";
  parameter Modelica.SIunits.Temp_C H_par_Tsc=4 " intial temp of cold stroage in C";
  parameter Modelica.SIunits.Temp_C H_par_Tsh=12 " intial temp of hot stroage in C";
  parameter Real H_par_QCHL_ton = 1400;
  parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal = H_par_QCHL_ton*3.5*1e3;
  parameter Real H_par_COP_nominal= 7;

  parameter Modelica.SIunits.Power P_nominal= QEva_flow_nominal/ H_par_COP_nominal
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal= 2*(2*H_par_QCHL_ton)*0.06
    "Nominal mass flow rate at evaporator";

  parameter Modelica.SIunits.AbsolutePressure dP0=740;
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal= 3*(2*H_par_QCHL_ton)*0.06
    "Nominal mass flow rate at condenser";

    Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=0)
    annotation (Placement(transformation(extent={{-92,118},{-72,138}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = CondensorWater,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=dP0)  "Flow resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-8,-96})));
  parameter
    Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
    per(
    QEva_flow_nominal= -1*QEva_flow_nominal,
    COP_nominal=H_par_COP_nominal,
    PLRMax=1,
    PLRMinUnl=0.4,
    mEva_flow_nominal=mEva_flow_nominal,
    mCon_flow_nominal=mCon_flow_nominal,
    capFunT={0.70790824,-0.002006568,-0.00259605,0.030058776,-0.0010564344,0.0020457036},
    EIRFunT={0.5605438,-0.01377927,6.57072e-005,0.013219362,0.000268596,-0.0005011308},
    EIRFunPLR={0.17149273,0.58820208,0.23737257}) "Chiller performance data"
    annotation (Placement(transformation(extent={{304,92},{346,134}})));

  Buildings.Fluid.Chillers.ElectricEIR chi1(
    redeclare package Medium1 = CondensorWater,
    redeclare package Medium2 = ChilledWater,
    per=per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    dp1_nominal=dP0,
    dp2_nominal=dP0) "Chiller model" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
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
  Buildings.Fluid.Sensors.Temperature Sensor_TCHe(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{-8,20},{12,40}})));
  Buildings.Fluid.Sensors.Temperature Sensor_TCHWR(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{220,-94},{240,-74}})));
  Components.TankMB_H3 tankMB_H2_1(T_startA=273.15 + H_par_Tsh,
    T_startB=273.15 + H_par_Tsc,
    h_startB=H_par_x0*15,
    h_startA=(1 - H_par_x0)*15,     redeclare package MediumA = ChilledWater,
      redeclare package MediumB = ChilledWater)
    annotation (Placement(transformation(extent={{114,-66},{154,-26}})));
  Buildings.Fluid.Sensors.MassFlowRate Sensor_mS(redeclare package Medium =
        ChilledWater)                                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={100,-26})));
  Buildings.Fluid.Movers.FlowControlled_m_flow Pump_CHW_Secondary(
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    tau=30,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Pump for chilled water loop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={172,20})));
  Buildings.Fluid.Sensors.MassFlowRate Sensor_msup(redeclare package Medium =
        ChilledWater)                                                                     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={208,20})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    redeclare package Medium = ChilledWater,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=dP0)                                                                         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={240,20})));
  Buildings.Fluid.Sensors.MassFlowRate Sensor_mCHi(redeclare package Medium =
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
        origin={98,20})));
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
        origin={170,-42})));
  Buildings.Fluid.Sensors.Pressure Sensor_pSupper(redeclare package Medium =
        ChilledWater) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={110,0})));
  Buildings.Fluid.Sensors.Pressure Sensor_pSdown(redeclare package Medium =
        ChilledWater)                                                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={196,-62})));
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
    annotation (Placement(transformation(extent={{134,20},{154,40}})));
  Buildings.Fluid.Sensors.Temperature Sensor_TCHWS(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{110,22},{130,42}})));
  Modelica.Blocks.Math.UnitConversions.To_degC Sensor_Tstorage[2]
    annotation (Placement(transformation(extent={{224,-60},{244,-40}})));
  Buildings.Fluid.Sources.FixedBoundary refP1(
    redeclare package Medium = ChilledWater,
    use_T=false,
    nPorts=1) "Expansion vessel" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={278,20})));
  Buildings.Fluid.Sources.Boundary_pT ReturnFromBuilding(
    redeclare package Medium = ChilledWater,
    use_T_in=true,
    nPorts=2) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={254,-96})));
  BuildingReturnCal buildingReturnCal annotation (Placement(transformation(
        extent={{-15,11},{15,-11}},
        rotation=180,
        origin={291,-95})));
  Modelica.Blocks.Math.Gain SP_msup_dummys(k=1/(4200*5)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={236,82})));
  Modelica.Blocks.Interfaces.RealOutput Sensor_Height[3]
    annotation (Placement(transformation(extent={{246,-30},{266,-10}})));
  Buildings.Fluid.Chillers.ElectricEIR chi2(
    redeclare package Medium1 = CondensorWater,
    redeclare package Medium2 = ChilledWater,
    per=per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    dp1_nominal=dP0,
    dp2_nominal=dP0) "Chiller model"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,-12})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow(
    redeclare package Medium = CondensorWater,
    m_flow_nominal=mCon_flow_nominal,
    PFan_nominal=6000,
    TAirInWB_nominal(displayUnit="degC") = 283.15,
    TApp_nominal=6,
    dp_nominal=3*dP0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Cooling tower"                                   annotation (Placement(
        transformation(
        extent={{-29,-30},{29,30}},
        origin={-241,14})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(
    redeclare package Medium = CondensorWater,
    m_flow_nominal=mCon_flow_nominal,
    dp(start=dP0),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Condenser water pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-164,14})));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(redeclare package Medium =
        CondensorWater, V_start=1)
    annotation (Placement(transformation(extent={{-50,-107},{-30,-87}})));
  Modelica.Blocks.Sources.Constant Twb(k=273.15 + 10) "chilled water flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-346,26})));
  Buildings.Fluid.Sensors.MassFlowRate Sensor_mCW(redeclare package Medium =
        CondensorWater)                                                                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-96,14})));
  Buildings.Fluid.Sensors.Temperature Sensor_TCWS(redeclare package Medium =
        CondensorWater)
    annotation (Placement(transformation(extent={{-56,14},{-36,34}})));
  Buildings.Fluid.Sensors.Temperature Sensor_TCWR(redeclare package Medium =
        CondensorWater)
    annotation (Placement(transformation(extent={{-168,-106},{-148,-86}})));
  Modelica.Blocks.Math.Gain SP_mCWS(k=mCon_flow_nominal/mEva_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-154,-48})));
  Modelica.Blocks.Continuous.LimPID PID(yMax=1, yMin=0)
    annotation (Placement(transformation(extent={{-336,56},{-316,76}})));
  Modelica.Blocks.Sources.Constant SP_TCWS(k=273.15 + 10)
    "chilled water flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-386,46})));
  Modelica.Blocks.Interfaces.RealInput
                                   TCHeSP "chilled water flow rate"
                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-76,172})));
  Modelica.Blocks.Math.UnitConversions.From_degC c2k
    annotation (Placement(transformation(extent={{-56,168},{-48,176}})));
  Modelica.Blocks.Interfaces.RealInput ChillerON "chilled water flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-144,128})));
  Modelica.Blocks.Interfaces.RealInput SP_mCH annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={96,-174})));
  Modelica.Blocks.Math.Gain kW2W(k=1e3) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=180,
        origin={336,-136})));
  Modelica.Blocks.Interfaces.RealInput BuildingCoolingLoads annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={370,-136})));
  Modelica.Blocks.Math.Gain                W2kW(k=1e-3)
    annotation (Placement(transformation(extent={{-294,186},{-286,194}})));
  KPI kPI annotation (Placement(transformation(extent={{-254,186},{-208,222}})));
  Modelica.Blocks.Interfaces.RealInput ER "electricity rate ($/kWh)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-306,212})));
  Modelica.Blocks.Interfaces.RealOutput Output[4] "Cost" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-216,206})));
  Modelica.Blocks.Interfaces.RealInput PnonHVAC "kW" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-296,172})));
  Modelica.Blocks.Interfaces.RealInput Psolarpv "kW" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-296,158})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=plantpower)
    annotation (Placement(transformation(extent={{-366,148},{-346,168}})));
  Real plantpower;
  Buildings.Fluid.Sensors.Temperature Sensor_TCHi(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{34,-74},{54,-54}})));
equation

  connect(chi1.on, greaterThreshold.y) annotation (Line(
      points={{7,-30},{8,-30},{8,128},{-71,128}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(chi1.port_b1, res1.port_a) annotation (Line(points={{4,-52},{-2,-52},
          {-2,-86},{-8,-86}}, color={0,127,255}));
  connect(Sensor_mS.port_b,tankMB_H2_1. PortB)
    annotation (Line(points={{100,-36},{100,-62},{134,-62}},
                                                          color={0,127,255}));
  connect(Pump_CHW_Secondary.port_b, Sensor_msup.port_a)
    annotation (Line(points={{182,20},{198,20}}, color={0,127,255}));
  connect(Sensor_msup.port_b, res2.port_a)
    annotation (Line(points={{218,20},{230,20}},         color={0,127,255}));
  connect(Pump_CHW_Primary.port_b,Sensor_mCHi. port_a)
    annotation (Line(points={{52,-94},{16,-94},{16,-84}}, color={0,127,255}));
  connect(Sensor_mCHi.port_b, chi1.port_a2)
    annotation (Line(points={{16,-64},{16,-52}}, color={0,127,255}));
  connect(junSu.port_3, Sensor_mS.port_a)
    annotation (Line(points={{98,10},{98,-16},{100,-16}},
                                                        color={0,127,255}));
  connect(junSu.port_2, Pump_CHW_Secondary.port_a)
    annotation (Line(points={{108,20},{162,20}},
                                               color={0,127,255}));
  connect(junRe.port_2, Pump_CHW_Primary.port_a)
    annotation (Line(points={{104,-94},{72,-94}}, color={0,127,255}));
  connect(tankMB_H2_1.PortA, res3.port_a) annotation (Line(points={{134,-30.4},
          {134,-14},{170,-14},{170,-32}},
                                   color={0,127,255}));
  connect(res3.port_b, junRe.port_3)
    annotation (Line(points={{170,-52},{170,-84},{114,-84}},
                                                 color={0,127,255}));
  connect(junSu.port_3, Sensor_pSupper.port) annotation (Line(points={{98,10},{
          98,1.77636e-15},{100,1.77636e-15}},
                                 color={0,127,255}));
  connect(res3.port_b, Sensor_pSdown.port)
    annotation (Line(points={{170,-52},{170,-62},{186,-62}},
                                                   color={0,127,255}));
  connect(Pump_CHW_Primary.port_b, Sensor_pCHi.port)
    annotation (Line(points={{52,-94},{30,-94}}, color={0,127,255}));
  connect(junSu.port_2, Sensor_psub_Suction.port)
    annotation (Line(points={{108,20},{144,20}},
                                               color={0,127,255}));
  connect(junSu.port_2, Sensor_TCHWS.port)
    annotation (Line(points={{108,20},{120,20},{120,22}},
                                               color={0,127,255}));
  connect(res2.port_b, refP1.ports[1])
    annotation (Line(points={{250,20},{268,20}}, color={0,127,255}));
  connect(Sensor_msup.m_flow, buildingReturnCal.msup) annotation (Line(points={
          {208,31},{208,54},{312,54},{312,-100.72},{300.3,-100.72}}, color={0,0,
          127}));
  connect(ReturnFromBuilding.ports[1], junRe.port_1) annotation (Line(points={{
          244,-94},{184,-94},{184,-94},{124,-94}}, color={0,127,255}));
  connect(ReturnFromBuilding.ports[2], Sensor_TCHWR.port) annotation (Line(
        points={{244,-98},{238,-98},{238,-94},{230,-94}}, color={0,127,255}));
  connect(SP_msup_dummys.y, Pump_CHW_Secondary.m_flow_in)
    annotation (Line(points={{225,82},{172,82},{172,32}}, color={0,0,127}));
  connect(Sensor_TCHWS.T, buildingReturnCal.Tsup) annotation (Line(points={{127,
          32},{128,32},{128,58},{322,58},{322,-96.54},{300.3,-96.54}}, color={0,
          0,127}));
  connect(buildingReturnCal.Tret, ReturnFromBuilding.T_in) annotation (Line(
        points={{283.2,-93.02},{275.6,-93.02},{275.6,-92},{266,-92}}, color={0,
          0,127}));
  connect(tankMB_H2_1.z, Sensor_Height) annotation (Line(points={{148,-38},{200,
          -38},{200,-20},{256,-20}}, color={0,0,127}));
  connect(tankMB_H2_1.T, Sensor_Tstorage.u) annotation (Line(points={{148,-52.4},
          {186,-52.4},{186,-50},{222,-50}}, color={0,0,127}));
  connect(chi1.port_a1, chi2.port_b1)
    annotation (Line(points={{4,-32},{-16,-32},{-16,-22}}, color={0,127,255}));
  connect(chi1.port_b2, chi2.port_a2) annotation (Line(points={{16,-32},{16,-26},
          {-4,-26},{-4,-22}}, color={0,127,255}));
  connect(chi2.port_b2, Sensor_pCHe.port)
    annotation (Line(points={{-4,-2},{-4,20},{26,20}}, color={0,127,255}));
  connect(Sensor_pCHe.port, junSu.port_1)
    annotation (Line(points={{26,20},{88,20}}, color={0,127,255}));
  connect(chi2.port_b2, Sensor_TCHe.port)
    annotation (Line(points={{-4,-2},{-4,20},{2,20}}, color={0,127,255}));
  connect(greaterThreshold.y, chi2.on) annotation (Line(points={{-71,128},{-12,128},
          {-12,6},{-13,6},{-13,0}},     color={255,0,255}));
  connect(res1.port_b, expVesChi.port_a) annotation (Line(points={{-8,-106},{
          -40,-106},{-40,-107}}, color={0,127,255}));
  connect(cooTow.port_b, pumCW.port_a)
    annotation (Line(points={{-212,14},{-174,14}}, color={0,127,255}));
  connect(Twb.y, cooTow.TAir)
    annotation (Line(points={{-335,26},{-275.8,26}}, color={0,0,127}));
  connect(pumCW.port_b, Sensor_mCW.port_a)
    annotation (Line(points={{-154,14},{-106,14}}, color={0,127,255}));
  connect(Sensor_mCW.port_b, chi2.port_a1)
    annotation (Line(points={{-86,14},{-16,14},{-16,-2}}, color={0,127,255}));
  connect(expVesChi.port_a, cooTow.port_a) annotation (Line(points={{-40,-107},
          {-188,-107},{-188,-108},{-324,-108},{-324,14},{-270,14}}, color={0,
          127,255}));
  connect(Sensor_mCW.port_b, Sensor_TCWS.port)
    annotation (Line(points={{-86,14},{-46,14}}, color={0,127,255}));
  connect(expVesChi.port_a, Sensor_TCWR.port) annotation (Line(points={{-40,
          -107},{-99,-107},{-99,-106},{-158,-106}}, color={0,127,255}));
  connect(SP_mCWS.y, pumCW.m_flow_in) annotation (Line(points={{-165,-48},{-166,
          -48},{-166,2},{-164,2}}, color={0,0,127}));
  connect(PID.y, cooTow.y) annotation (Line(points={{-315,66},{-302,66},{-302,
          38},{-275.8,38}}, color={0,0,127}));
  connect(SP_TCWS.y, PID.u_m)
    annotation (Line(points={{-375,46},{-326,46},{-326,54}}, color={0,0,127}));
  connect(Sensor_TCWS.T, PID.u_s) annotation (Line(points={{-39,24},{-36,24},{
          -36,86},{-346,86},{-346,66},{-338,66}}, color={0,0,127}));
  connect(TCHeSP, c2k.u)
    annotation (Line(points={{-76,172},{-56.8,172}}, color={0,0,127}));
  connect(c2k.y, chi2.TSet) annotation (Line(points={{-47.6,172},{-8,172},{-8,0},
          {-7,0}}, color={0,0,127}));
  connect(ChillerON, greaterThreshold.u)
    annotation (Line(points={{-144,128},{-94,128}}, color={0,0,127}));
  connect(c2k.y, chi1.TSet)
    annotation (Line(points={{-47.6,172},{13,172},{13,-30}}, color={0,0,127}));
  connect(SP_mCH, Pump_CHW_Primary.m_flow_in)
    annotation (Line(points={{96,-174},{62,-174},{62,-106}}, color={0,0,127}));
  connect(SP_mCH, SP_mCWS.u) annotation (Line(points={{96,-174},{6,-174},{6,-172},
          {-100,-172},{-100,-48},{-142,-48}}, color={0,0,127}));
  connect(BuildingCoolingLoads, kW2W.u) annotation (Line(points={{370,-136},{
          356,-136},{356,-136},{340.8,-136}}, color={0,0,127}));
  connect(kW2W.y, buildingReturnCal.QCL) annotation (Line(points={{331.6,-136},{
          332,-136},{332,-91.48},{300.3,-91.48}}, color={0,0,127}));
  connect(SP_msup_dummys.u, kW2W.y) annotation (Line(points={{248,82},{340,82},{
          340,-136},{331.6,-136}}, color={0,0,127}));
  connect(ER,kPI. ER) annotation (Line(points={{-306,212},{-280,212},{-280,211.92},
          {-249.4,211.92}},
                        color={0,0,127}));
  connect(W2kW.y,kPI. PHVAC) annotation (Line(points={{-285.6,190},{-262,190},{-262,
          207.6},{-249.4,207.6}},
                               color={0,0,127}));
  connect(kPI.y,Output)  annotation (Line(points={{-232.84,205.8},{-234,205.8},{
          -234,206},{-216,206}},
                     color={0,0,127}));
  connect(PnonHVAC,kPI. PnonHVAC) annotation (Line(points={{-296,172},{-276,172},
          {-276,203.28},{-249.4,203.28}},
                                    color={0,0,127}));
  connect(Psolarpv,kPI. Psolarpv) annotation (Line(points={{-296,158},{-284,158},
          {-284,156},{-268,156},{-268,198.96},{-249.4,198.96}},
                                                        color={0,0,127}));
  connect(kPI.mr, Sensor_msup.m_flow);
  connect(kPI.mCH, Sensor_mCHi.m_flow);
  connect(kPI.TCHi, Sensor_TCHi.T);
  connect(kPI.TCHe, Sensor_TCHe.T);
  connect(kPI.Ts[:],tankMB_H2_1. T[:]);
  connect(kPI.Tr, Sensor_TCHWR.T);
  plantpower = chi1.P + chi2.P + Pump_CHW_Primary.P + Pump_CHW_Secondary.P +
    pumCW.P + cooTow.PFan;

  connect(realExpression.y, W2kW.u) annotation (Line(points={{-345,158},{-322,158},
          {-322,190},{-294.8,190}}, color={0,0,127}));
  connect(Sensor_TCHi.port, Pump_CHW_Primary.port_b) annotation (Line(points={{44,
          -74},{48,-74},{48,-94},{52,-94}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-400,
            -200},{380,120}}),
                         graphics={Text(
          extent={{-84,38},{106,-92}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="CHL")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-400,-200},{380,
            120}}),
        graphics={Text(
          extent={{-114,126},{-54,80}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="Norminal Cap: 1000 ton
Norminal Water Flows: 2gpm/ton for evap, 3 gpm /to for comp (~5oC DTW).")}));
end Chiller_Storage_CoolingTower_V2_MPC;
