model ModelValidDymola 
  extends Subsystems;
  Modelica.Blocks.Sources.CombiTimeTable weather(
    tableOnFile=true,
    columns=2:5,
    tableName="weather",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    startTime=-90.8*24*3600,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName="J:\\work\\SEEDprojects\\Merced\\data.mat") 
                             annotation (extent=[-55,34; -40,44]);
  Subsystems.CentralPlant centralPlant annotation (extent=[-10,-20; 38,26]);
  Modelica.Blocks.Sources.CombiTimeTable ControlInput(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    tableName="input",
    fileName="J:\\work\\SEEDprojects\\Merced\\ModelValidation\\input.mat",
    columns=2:4,
    startTime=0) "CT_Tref//mdot_CHWS//T_CHWS_ref" 
                             annotation (extent=[-71,2; -56,12]);
equation 
  connect(weather.y,centralPlant. w) annotation (points=[-39.25,39; -17.3,39; 
        -17.3,16.8; -7.6,16.8],
                    style(color=74, rgbcolor={0,0,127}));
  annotation (Diagram);
  connect(ControlInput.y, centralPlant.u) annotation (points=[-55.25,7; -29.625,
        7; -29.625,7.6; -7.6,7.6], style(color=74, rgbcolor={0,0,127}));
end ModelValidDymola;
