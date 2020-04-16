model test_TankMB 
  
  Merced.Components.TankMB fluidTankMB(T_startB=278.15, redeclare package 
      Medium = 
        Modelica.Media.Water.StandardWater) 
                          annotation (extent=[-44,-18; 2,26]);
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX prescribedMassFlowRate_TX1(
      redeclare package Medium = Modelica.Media.Water.StandardWater, T=278) 
                     annotation (extent=[28,-44; 8,-24]);
  Modelica.Blocks.Sources.Sine sine2(
    freqHz=3,
    amplitude=0,
    offset=0) 
    annotation (extent=[10,-62; 28,-50]);
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX prescribedMassFlowRate_TX2(
                redeclare package Medium = 
        Modelica.Media.Water.StandardWater, T=288) 
                                            annotation (extent=[30,28; 10,48]);
  Modelica.Blocks.Sources.Sine sine1(
    freqHz=3,
    amplitude=0,
    offset=0) 
    annotation (extent=[10,58; 28,70]);
  annotation (Diagram);
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-92,74; -72,94]);
  Modelica.Blocks.Sources.Sine sine3(
    amplitude=5,
    freqHz=1/86400,
    offset=293) 
    annotation (extent=[-76,7; -58,19]);
equation 
  connect(prescribedMassFlowRate_TX1.port, fluidTankMB.PortB) annotation (
      points=[8,-34; -20,-34; -20,-13.6; -21,-13.6], style(color=69, rgbcolor=
         {0,127,255}));
  connect(prescribedMassFlowRate_TX2.port, fluidTankMB.PortA) annotation (
      points=[10,38; -20,38; -20,21.16; -21,21.16],style(color=69, rgbcolor={
          0,127,255}));
  connect(sine2.y, prescribedMassFlowRate_TX1.m_flow_in) annotation (points=
       [28.9,-56; 48,-56; 48,-28; 27.3,-28], style(color=74, rgbcolor={0,0,
          127}));
  connect(sine1.y, prescribedMassFlowRate_TX2.m_flow_in) annotation (points=
       [28.9,64; 46,64; 46,44; 29.3,44], style(color=74, rgbcolor={0,0,127}));
  connect(sine3.y, fluidTankMB.Tamb) annotation (points=[-57.1,13; -47.445,13;
        -47.445,12.8; -37.79,12.8], style(color=74, rgbcolor={0,0,127}));
end test_TankMB;
