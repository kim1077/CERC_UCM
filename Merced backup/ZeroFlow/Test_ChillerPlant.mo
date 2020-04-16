model Test_ChillerPlant 
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram);
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-80,60; -60,80]);
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX CHWR(
    redeclare package Medium = MediumCHW,
    T=273 + (60 - 32)*5/9,
    m_flow=0) 
    annotation (extent=[26,12; 14,24]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX CHWS(
    redeclare package Medium = MediumCHW,
    p=0,
    T=273 + 5) 
    annotation (extent=[-50,14; -40,24]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX CWR(
    redeclare package Medium = MediumCW,
    p=0,
    T=273 + 5) 
    annotation (extent=[24,30; 16,38], rotation=0);
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX CWS(
    redeclare package Medium = MediumCW,
    T=273.15 + (75 - 32)*5/9,
    m_flow=0) 
    annotation (extent=[-52,28; -40,40]);
  Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
        MediumCW, redeclare package MediumCHW = MediumCHW) 
    annotation (extent=[-20,16; 0,36]);
  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    height=-10*0.999,
    offset=10) annotation (extent=[-80,32; -68,42]);
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    height=-10*0.999,
    offset=10) annotation (extent=[4,-4; 16,6]);
equation 
  connect(CHWS.port, Chiller_Plant.CHWS) annotation (points=[-40,19; -40,18;
        -21.2,18], style(color=69, rgbcolor={0,127,255}));
  connect(CWR.port, Chiller_Plant.CWS) annotation (points=[16,34; 1,34],
      style(color=69, rgbcolor={0,127,255}));
  connect(CWS.port, Chiller_Plant.CWR) annotation (points=[-40,34; -21.2,34],
      style(color=69, rgbcolor={0,127,255}));
  connect(CHWR.port, Chiller_Plant.CHWR) annotation (points=[14,18; 1.2,18],
      style(color=69, rgbcolor={0,127,255}));
  connect(ramp.y, CWS.m_flow_in) annotation (points=[-67.4,37; -59.7,37;
        -59.7,37.6; -51.58,37.6], style(color=74, rgbcolor={0,0,127}));
  connect(ramp1.y, CHWR.m_flow_in) annotation (points=[16.6,1; 25.58,1;
        25.58,21.6], style(color=74, rgbcolor={0,0,127}));
end Test_ChillerPlant;
