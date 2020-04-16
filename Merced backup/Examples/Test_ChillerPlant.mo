model Test_ChillerPlant 
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram);
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-106,74; -86,94]);
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX CHWR(
    redeclare package Medium = MediumCHW,
    T=273 + (60 - 32)*5/9,
    m_flow=0.8*140) 
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
    m_flow=430) 
    annotation (extent=[-52,28; -40,40]);
  Subsystems.ChillerPlant Chiller_Plant(redeclare package MediumCW = 
        MediumCW, redeclare package MediumCHW = MediumCHW) 
    annotation (extent=[-20,16; 0,36]);
equation 
  connect(CHWS.port, Chiller_Plant.CHWS) annotation (points=[-40,19; -40,20;
        -21,20],   style(color=69, rgbcolor={0,127,255}));
  connect(CWR.port, Chiller_Plant.CWS) annotation (points=[16,34; 8.5,34; 8.5,
        32; 1,32],
      style(color=69, rgbcolor={0,127,255}));
  connect(CWS.port, Chiller_Plant.CWR) annotation (points=[-40,34; -30.5,34;
        -30.5,32; -21,32],
      style(color=69, rgbcolor={0,127,255}));
  connect(CHWR.port, Chiller_Plant.CHWR) annotation (points=[14,18; 7.5,18; 7.5,
        20; 1,20],
      style(color=69, rgbcolor={0,127,255}));
end Test_ChillerPlant;
