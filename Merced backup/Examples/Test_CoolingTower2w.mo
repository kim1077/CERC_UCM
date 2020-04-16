model Test_CoolingTower2w 
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram);
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-96,64; -76,84]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX CWR(
    redeclare package Medium = MediumCW,
    p=0,
    T=273 + 5) 
    annotation (extent=[34,20; 26,28], rotation=0);
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX CWS(
    redeclare package Medium = MediumCW,
    m_flow=430,
    T=273.15 + (95 - 32)*5/9) 
    annotation (extent=[-42,18; -30,30]);
  Merced.Subsystems.Cooling_Tower2w cooling_Tower(
                                         redeclare package Medium = MediumCW,
      Nw=4)       annotation (extent=[-16,14; 4,34]);
  Modelica.Blocks.Sources.Pulse pulse(
    startTime=86400/2,
    amplitude=-0.90*0,
    period=86400,
    offset=273.15 + 25) 
                     annotation (extent=[-94,3; -78,13]);
  Modelica.Blocks.Sources.CombiTimeTable weather(
    tableOnFile=true,
    columns=2:5,
    tableName="weather",
    fileName="D:\\Modelica\\Merced\\data.mat",
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    startTime=-90*24*3600) annotation (extent=[-90,24; -70,44]);
equation 
  connect(CWS.port, cooling_Tower.CWR) annotation (points=[-30,24; -17.2,24],
      style(color=69, rgbcolor={0,127,255}));
  connect(cooling_Tower.CWS, CWR.port) annotation (points=[5.2,24; 26,24],
      style(color=69, rgbcolor={0,127,255}));
  connect(pulse.y, cooling_Tower.Tref) annotation (points=[-77.2,8; -48,8; -48,
        28; -18,28], style(color=74, rgbcolor={0,0,127}));
  connect(weather.y, cooling_Tower.w) annotation (points=[-69,34; -44,34; -44,
        32; -17.8,32], style(color=74, rgbcolor={0,0,127}));
end Test_CoolingTower2w;
