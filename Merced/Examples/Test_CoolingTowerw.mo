within Merced.Examples;
model Test_CoolingTowerw
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  inner Modelica_Fluid.Ambient ambient annotation (Placement(transformation(
          extent={{-96,64},{-76,84}}, rotation=0)));
  Modelica_Fluid.Sources.PrescribedBoundary_pTX CWR(
    redeclare package Medium = MediumCW,
    p=0,
    T=273 + 5)
    annotation (Placement(transformation(extent={{34,24},{26,32}}, rotation=0)));
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX CWS(
    redeclare package Medium = MediumCW,
    m_flow=430,
    T=273.15 + (95 - 32)*5/9)
    annotation (Placement(transformation(extent={{-62,22},{-50,34}}, rotation=0)));
  Subsystems.Cooling_Towerw cooling_Tower(
                                         redeclare package Medium = MediumCW,
      Nw=4)       annotation (Placement(transformation(extent={{-20,8},{16,48}},
          rotation=0)));
  Modelica.Blocks.Sources.Pulse pulse(
    startTime=86400/2,
    amplitude=-0.90*0,
    period=86400,
    offset=0*(273.15 + 25) + 0.5)
                     annotation (Placement(transformation(extent={{-94,3},{-78,
            13}}, rotation=0)));
  Modelica.Blocks.Sources.CombiTimeTable weather(
    tableOnFile=true,
    columns=2:5,
    tableName="weather",
    fileName="D:\\Modelica\\Merced\\data.mat",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    startTime=-90*24*3600) annotation (Placement(transformation(extent={{-90,34},
            {-70,54}}, rotation=0)));
equation
  connect(CWS.port, cooling_Tower.CWR) annotation (Line(points={{-50,28},{
          -22.16,28}}, color={0,127,255}));
  connect(cooling_Tower.CWS, CWR.port) annotation (Line(points={{18.16,28},{26,
          28}}, color={0,127,255}));
  connect(cooling_Tower.w, weather.y) annotation (Line(points={{-23.6,44},{-69,
          44}}, color={0,0,127}));
  connect(pulse.y, cooling_Tower.Fair) annotation (Line(points={{-77.2,8},{
          -51.6,8},{-51.6,36},{-23.6,36}}, color={0,0,127}));
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram(graphics));
end Test_CoolingTowerw;
