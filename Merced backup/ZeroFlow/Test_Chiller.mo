model Test_Chiller 
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram);
  Merced.Components.Chiller Chiller(
  redeclare package Medium_1 = MediumCW,
  redeclare package Medium_2 = MediumCHW) 
    annotation (extent=[-18,-52; 26,-6]);
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR1(
  redeclare package Medium = MediumCW,
    T=273 + 16,
    m_flow=1) 
    annotation (extent=[-60,-25; -40,-5]);
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX FMFR2(
  redeclare package Medium = MediumCHW,
    T=273 + 16,
    m_flow=1) 
    annotation (extent=[76,-52; 56,-32]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX FixedBC1(
    redeclare package Medium = MediumCW,
    p=0,
    T=273 + 5) 
    annotation (extent=[72,-22; 58,-8]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX FixedBC2(
    redeclare package Medium = MediumCHW,
    p=0,
    T=273 + 5) 
    annotation (extent=[-58,-49; -44,-35]);
  Modelica.Blocks.Sources.Sine Sine1(
    offset=273 + 5,
    freqHz=0.0001,
    amplitude=1) 
    annotation (extent=[-84,-74; -68,-58]);
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-94,74; -74,94]);
  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    offset=10,
    height=-10*0.999) annotation (extent=[-92,-4; -76,12]);
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    offset=10,
    height=-10*0.999) annotation (extent=[56,-80; 72,-64]);
equation 
  connect(FMFR1.port,Chiller.port_a1) 
    annotation (points=[-40,-15; -35.6,-15; -35.6,-15.2; -18,-15.2],
    style(color= 69, rgbcolor={0,127,255}));
  connect(FMFR2.port,Chiller.port_a2) 
    annotation (points=[56,-42; 26,-42; 26,-42.8],
    style(color=69,rgbcolor={0,127,255}));
  connect(FixedBC1.port,Chiller.port_b1) annotation (
      points=[58,-15; 41.6,-15; 41.6,-15.2; 26,-15.2],
      style(color=69, rgbcolor={0,127,255}));
  connect(FixedBC2.port,Chiller. port_b2) annotation (
      points=[-44,-42; -18,-42; -18,-42.8],
      style(color=69, rgbcolor={0,127,255}));
  connect(Sine1.y,Chiller.T_chws_ref) annotation (points=[-67.2,-66; -46.7,
        -66; -46.7,-51.54; -22.4,-51.54],    style(color=74, rgbcolor={0,0,127}));
  connect(ramp.y, FMFR1.m_flow_in) annotation (points=[-75.2,4; -68,4; -68,-9; -59.3,-9],
      style(color=74, rgbcolor={0,0,127}));
  connect(ramp1.y, FMFR2.m_flow_in) annotation (points=[72.8,-72; 86,-72;
        86,-36; 75.3,-36], style(color=74, rgbcolor={0,0,127}));
end Test_Chiller;
