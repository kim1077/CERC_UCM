within Merced.CoolingPlantNew;
model Chiller_Storage_Only_V2_MPC "Building Load Model was replaced"
  package CondensorWater =  Buildings.Media.Water;
  package ChilledWater =  Buildings.Media.Water;
  parameter Real x0=0.7 " initial state of charge";
  parameter Real Tsc=4 " intial temp of cold stroage in C";
  parameter Real Tsh=12 " intial temp of hot stroage in C";

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
    annotation (Placement(transformation(extent={{-20,-2},{0,18}})));
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
    annotation (Placement(transformation(extent={{304,92},{346,134}})));

  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare package Medium1 = CondensorWater,
    redeclare package Medium2 = ChilledWater,
    per=per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    dp1_nominal=dP0,
    dp2_nominal=dP0) "Chiller model"
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
  Modelica.Blocks.Interfaces.RealInput
                                   ChillerON "chilled water flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-42,8})));
  Modelica.Blocks.Interfaces.RealInput
                                   TCHeSP "chilled water flow rate"
                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,64})));
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
    annotation (Placement(transformation(extent={{220,-94},{240,-74}})));
  TankMB_H2            tankMB_H2_1(
    T_startA=273.15 + Tsh,
    T_startB=273.15 + Tsc,
    h_startB=x0*15,
    h_startA=(1 - x0)*15,          redeclare package MediumA = ChilledWater,
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
  Modelica.Blocks.Interfaces.RealInput
                                SP_mCH   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={96,-136})));
  Modelica.Blocks.Math.Gain SP_msup_dummys(k=1/(4200*5)) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={236,82})));
  Modelica.Blocks.Interfaces.RealInput
                                BuildingCoolingLoads
                                        annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={370,-92})));
  Modelica.Blocks.Interfaces.RealOutput Sensor_Height[3]
    annotation (Placement(transformation(extent={{246,-30},{266,-10}})));
  Modelica.Blocks.Interfaces.RealInput ER "electricity rate ($/kWh)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-156,52})));
  Modelica.Blocks.Math.Gain                W2kW(k=1e-3)
    annotation (Placement(transformation(extent={{-144,26},{-136,34}})));
  Modelica.Blocks.Interfaces.RealOutput Output[4] "Cost" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-66,46})));
  Modelica.Blocks.Interfaces.RealInput PnonHVAC "kW" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-146,12})));
  Modelica.Blocks.Interfaces.RealInput Psolarpv "kW" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-146,-2})));
  KPI kPI annotation (Placement(transformation(extent={{-104,26},{-58,62}})));
  Modelica.Blocks.Math.UnitConversions.From_degC c2k
    annotation (Placement(transformation(extent={{-20,60},{-12,68}})));
  Modelica.Blocks.Math.Gain kW2W(k=1e3) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=180,
        origin={350,-92})));
  Buildings.Fluid.Sensors.Temperature Sensor_TCHi(redeclare package Medium =
        ChilledWater)
    annotation (Placement(transformation(extent={{34,-92},{54,-72}})));
equation
  connect(chi.on,greaterThreshold. y) annotation (Line(
      points={{7,-30},{8,-30},{8,8},{1,8}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(sou1.ports[1], chi.port_a1) annotation (Line(points={{-68,-30},{-34,-30},
          {-34,-32},{4,-32}}, color={0,127,255}));
  connect(chi.port_b1, res1.port_a) annotation (Line(points={{4,-52},{-2,-52},{-2,
          -86},{-8,-86}}, color={0,127,255}));
  connect(res1.port_b, sin1.ports[1]) annotation (Line(points={{-8,-106},{-34,-106},
          {-34,-106},{-60,-106}}, color={0,127,255}));
  connect(TCWSSP.y, sou1.T_in)
    annotation (Line(points={{-111,-26},{-90,-26}}, color={0,0,127}));
  connect(Sensor_mS.port_b, tankMB_H2_1.PortB)
    annotation (Line(points={{100,-36},{100,-62},{134,-62}},
                                                          color={0,127,255}));
  connect(Pump_CHW_Secondary.port_b, Sensor_msup.port_a)
    annotation (Line(points={{182,20},{198,20}}, color={0,127,255}));
  connect(Sensor_msup.port_b, res2.port_a)
    annotation (Line(points={{218,20},{230,20}},         color={0,127,255}));
  connect(Pump_CHW_Primary.port_b,Sensor_mCHi. port_a)
    annotation (Line(points={{52,-94},{16,-94},{16,-84}}, color={0,127,255}));
  connect(Sensor_mCHi.port_b, chi.port_a2)
    annotation (Line(points={{16,-64},{16,-52}}, color={0,127,255}));
  connect(junSu.port_3, Sensor_mS.port_a)
    annotation (Line(points={{98,10},{98,-16},{100,-16}},
                                                        color={0,127,255}));
  connect(junSu.port_2, Pump_CHW_Secondary.port_a)
    annotation (Line(points={{108,20},{162,20}},
                                               color={0,127,255}));
  connect(chi.port_b2, junSu.port_1)
    annotation (Line(points={{16,-32},{16,20},{88,20}}, color={0,127,255}));
  connect(chi.port_b2, Sensor_TCHe.port)
    annotation (Line(points={{16,-32},{16,48},{26,48}}, color={0,127,255}));
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
  connect(chi.port_b2, Sensor_pCHe.port)
    annotation (Line(points={{16,-32},{16,20},{26,20}}, color={0,127,255}));
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
  connect(ChillerON, greaterThreshold.u) annotation (Line(points={{-42,8},{-22,8}},
                               color={0,0,127}));
  connect(SP_mCH, Pump_CHW_Primary.m_flow_in)
    annotation (Line(points={{96,-136},{62,-136},{62,-106}}, color={0,0,127}));
  connect(chi.P, W2kW.u) annotation (Line(points={{1,-53},{1,-56},{-158,-56},{
          -158,30},{-144.8,30}},
                          color={0,0,127}));
  connect(ER, kPI.ER) annotation (Line(points={{-156,52},{-130,52},{-130,51.92},
          {-99.4,51.92}},
                        color={0,0,127}));
  connect(W2kW.y, kPI.PHVAC) annotation (Line(points={{-135.6,30},{-112,30},{-112,
          47.6},{-99.4,47.6}}, color={0,0,127}));
  connect(kPI.y, Output) annotation (Line(points={{-82.84,45.8},{-84,45.8},{-84,
          46},{-66,46}},
                     color={0,0,127}));
  connect(TCHeSP, c2k.u)
    annotation (Line(points={{-40,64},{-20.8,64}}, color={0,0,127}));
  connect(c2k.y, chi.TSet) annotation (Line(points={{-11.6,64},{12,64},{12,-30},
          {13,-30}}, color={0,0,127}));
  connect(BuildingCoolingLoads, kW2W.u)
    annotation (Line(points={{370,-92},{354.8,-92}}, color={0,0,127}));
  connect(kW2W.y, buildingReturnCal.QCL) annotation (Line(points={{345.6,-92},{
          322,-92},{322,-91.48},{300.3,-91.48}}, color={0,0,127}));
  connect(kW2W.y, SP_msup_dummys.u) annotation (Line(points={{345.6,-92},{338,
          -92},{338,82},{248,82}}, color={0,0,127}));
  connect(PnonHVAC, kPI.PnonHVAC) annotation (Line(points={{-146,12},{-126,12},{
          -126,43.28},{-99.4,43.28}},
                                    color={0,0,127}));
  connect(Psolarpv, kPI.Psolarpv) annotation (Line(points={{-146,-2},{-134,-2},{
          -134,-4},{-118,-4},{-118,38.96},{-99.4,38.96}},
                                                        color={0,0,127}));
  connect(kPI.mr, Sensor_msup.m_flow);
  connect(kPI.mCH, Sensor_mCHi.m_flow);
  connect(kPI.TCHi, Sensor_TCHi.T);
  connect(kPI.TCHe, Sensor_TCHe.T);
  connect(kPI.Ts[:], tankMB_H2_1.T[:]);
  connect(kPI.Tr, Sensor_TCHWR.T);
  connect(Sensor_TCHi.port, Pump_CHW_Primary.port_b) annotation (Line(points={{44,
          -92},{46,-92},{46,-94},{52,-94}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,
            -160},{380,100}}),
                         graphics={Text(
          extent={{-84,38},{106,-92}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="CHL")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},{380,
            100}}),
        graphics={Text(
          extent={{-112,112},{-52,66}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.None,
          textString="Norminal Cap: 1000 ton
Norminal Water Flows: 2gpm/ton for evap, 3 gpm /to for comp (~5oC DTW).")}));
end Chiller_Storage_Only_V2_MPC;
