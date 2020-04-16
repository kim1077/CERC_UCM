model Test_CentralPlant 
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram);
   parameter String parameterFileName = "modelicaParameters.txt" 
    "File on which data is present";
  parameter String inputFileName = "modelicaSchedule.txt" 
    "File on which data is present";
  
  parameter String resultFileName = "result.txt" 
    "File on which data is present";
  parameter String header = "Objective function value" "Header for result file";
  parameter Real[:] P1_a = {208542.283151189,205771.962392144,-1518335.08994192} 
    "Polynomial coefficients for pump 1";
  parameter Real[:] P1_b = {0.0857970011564655,6.68960721072079,-14.2474444944515} 
    "Polynomial coefficients for pump 1";
  parameter Real P1_qNorMin_flow = 0.101276367798246;
  parameter Real P1_qNorMax_flow = 0.303829103394737;
  Modelica.Blocks.Sources.CombiTimeTable weather(
    tableOnFile=true,
    columns=2:5,
    tableName="weather",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    startTime=-90.8*24*3600,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName="J:\\work\\SEEDprojects\\Merced\\data.mat") 
                             annotation (extent=[-13,48; 2,58]);
  Modelica.Blocks.Continuous.FirstOrder PT1(      y_start=1, T=300) 
    annotation (extent=[-36,32; -24,40]);
  Modelica.Blocks.Logical.OnOffController onOffController(pre_y_start=true,
      bandwidth=3) annotation (extent=[-78,30; -64,42]);
  Modelica.Blocks.Logical.TriggeredTrapezoid triggeredTrapezoid(
    amplitude=1,
    rising=600,
    falling=600,
    offset=0.0005) 
                 annotation (extent=[-57,31; -43,41]);
  Modelica.Blocks.Sources.Trapezoid trapezoid2(
    period=86400,
    amplitude=-2,
    rising=600,
    width=43000,
    falling=600,
    offset=5,
    startTime=4.1e4) 
                annotation (extent=[-104,34; -88,46]);
  Modelica.Blocks.Sources.Trapezoid trapezoid1(
    period=86400,
    offset=293,
    amplitude=2,
    startTime=4.25e4,
    rising=600,
    width=43000,
    falling=600) 
                annotation (extent=[-36,44; -22,50]);
  Subsystems.CentralPlant centralPlant annotation (extent=[14,8; 62,54]);
  Modelica.Blocks.Routing.Multiplex3 multiplex2_1 
    annotation (extent=[-12,29; 4,43]);
  Modelica.Blocks.Sources.Trapezoid trapezoid3(
    period=86400,
    startTime=4.25e4,
    rising=600,
    width=43000,
    falling=600,
    amplitude=0,
    offset=273.15 + (39 - 32)*5/9) 
                annotation (extent=[-38,20; -22,28]);
  Modelica.Blocks.Continuous.Integrator int1 
    annotation (extent=[80,42; 88,50]);
  Buildings.Utilities.Reports.Printer CT_Tref(
    samplePeriod=3600,
    nin=2,
    fileName="CT_Tref.txt",
    header="") 
           annotation (extent=[58,-36; 78,-16]);
  Modelica.Blocks.Sources.Clock clock annotation (extent=[-80,-56; -70,-46]);
  Buildings.Utilities.Reports.Printer mdot_CHWS(
    samplePeriod=3600,
    nin=2,
    fileName="mdot_CHWS.txt",
    header="") 
           annotation (extent=[58,-60; 78,-40]);
  Buildings.Utilities.Reports.Printer T_CHWS_ref(
    samplePeriod=3600,
    nin=2,
    fileName="T_CHWS_ref.txt",
    header="") 
           annotation (extent=[58,-88; 78,-68]);
initial algorithm 
 if (resultFileName <> "") then
    Modelica.Utilities.Files.removeFile(resultFileName);
  end if;
  Modelica.Utilities.Streams.print(fileName=resultFileName, string=header);
  
equation 
when terminal() then
Modelica.Utilities.Streams.print("f(x) = " +
realString(number=int1.y, minimumWidth=1, precision=16), resultFileName);
end when;
  connect(onOffController.y, triggeredTrapezoid.u) annotation (points=[-63.3,36;
        -62,36; -62,38; -60,38; -60,36; -58.4,36],
                   style(color=5, rgbcolor={255,0,255}));
  connect(PT1.u, triggeredTrapezoid.y) annotation (points=[-37.2,36; -38,36;
        -38,38; -40,38; -40,36; -42.3,36],
      style(color=74, rgbcolor={0,0,127}));
  connect(trapezoid2.y, onOffController.reference) annotation (points=[-87.2,40;
        -84.3,40; -84.3,39.6; -79.4,39.6], style(color=74, rgbcolor={0,0,127}));
  connect(multiplex2_1.y, centralPlant.u) 
    annotation (points=[4.8,36; 8,36; 8,35.6; 16.4,35.6],
                                       style(color=74, rgbcolor={0,0,127}));
  connect(multiplex2_1.u1[1], trapezoid1.y) annotation (points=[-13.6,40.9; -18,
        40.9; -18,47; -21.3,47],
                           style(color=74, rgbcolor={0,0,127}));
  connect(multiplex2_1.u2[1], PT1.y) annotation (points=[-13.6,36; -23.4,36],
      style(color=74, rgbcolor={0,0,127}));
  connect(centralPlant.y[2], onOffController.u) annotation (points=[63.44,36.75;
        74,36.75; 74,-4; -79.4,-4; -79.4,32.4],
                                            style(color=74, rgbcolor={0,0,127}));
  connect(weather.y, centralPlant.w) annotation (points=[2.75,53; 6.7,53; 6.7,
        44.8; 16.4,44.8],
                    style(color=74, rgbcolor={0,0,127}));
  connect(multiplex2_1.u3[1], trapezoid3.y) annotation (points=[-13.6,31.1;
        -13.6,23.55; -21.2,23.55; -21.2,24], style(color=74, rgbcolor={0,0,127}));
  connect(centralPlant.P, int1.u) annotation (points=[63.44,44.8; 71.72,44.8; 71.72,46;
        79.2,46], style(color=74, rgbcolor={0,0,127}));
  connect(clock.y, CT_Tref.x[1]) annotation (points=[-69.5,-51; -63.75,-51;
        -63.75,-27; 56,-27], style(color=74, rgbcolor={0,0,127}));
  connect(trapezoid1.y, CT_Tref.x[2]) annotation (points=[-21.3,47; -13.65,47;
        -13.65,-25; 56,-25], style(color=74, rgbcolor={0,0,127}));
  connect(clock.y, mdot_CHWS.x[1]) annotation (points=[-69.5,-51; 56,-51],
      style(color=74, rgbcolor={0,0,127}));
  connect(PT1.y, mdot_CHWS.x[2]) annotation (points=[-23.4,36; -16,36; -16,-49;
        56,-49], style(color=74, rgbcolor={0,0,127}));
  connect(T_CHWS_ref.x[2], trapezoid3.y) annotation (points=[56,-77; -20,-77;
        -20,24; -21.2,24], style(color=74, rgbcolor={0,0,127}));
  connect(clock.y, T_CHWS_ref.x[1]) annotation (points=[-69.5,-51; -62.75,-51;
        -62.75,-79; 56,-79], style(color=74, rgbcolor={0,0,127}));
end Test_CentralPlant;
