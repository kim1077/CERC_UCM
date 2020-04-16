within Merced.CWP;
model Twb
  Modelica.Blocks.Routing.DeMultiplex3 deMultiplex3_1
    annotation (Placement(transformation(extent={{40,19},{52,33}}, rotation=0)));
  Buildings.Utilities.Psychrometrics.WetBulbTemperature T_wb(redeclare package
      Medium = Modelica.Media.Air.MoistAir) "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{64,13},{84,33}}, rotation=0)));
  Modelica.Blocks.Routing.ExtractSignal extractSignal(       nout=3,
    extract=1:3,
    nin=4)
    annotation (Placement(transformation(extent={{-8,18},{12,38}}, rotation=0)));
  Modelica.Blocks.Sources.CombiTimeTable weather(
    tableOnFile=true,
    columns=2:5,
    tableName="weather",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName="D:\\Modelica\\Merced\\data2.mat",
    startTime=-90*24*3600)   annotation (Placement(transformation(extent={{-36,
            23},{-21,33}}, rotation=0)));
equation
  connect(T_wb.TDryBul,deMultiplex3_1. y1[1])       annotation (Line(points={{
          65,31},{59,31},{59,30.9},{52.6,30.9}}, color={0,0,255}));
  connect(T_wb.p,deMultiplex3_1. y3[1])       annotation (Line(points={{65,23},
          {60,23},{60,21.1},{52.6,21.1}}, color={0,0,255}));
  connect(deMultiplex3_1.y2[1],T_wb. phi)       annotation (Line(points={{52.6,
          26},{68,26},{68,30},{83,30}}, color={0,0,127}));
  connect(extractSignal.y,deMultiplex3_1. u)
    annotation (Line(points={{13,28},{26,28},{26,26},{38.8,26}}, color={0,0,127}));
  connect(weather.y, extractSignal.u) annotation (Line(points={{-20.25,28},{-10,
          28}}, color={0,0,127}));
  annotation (Diagram(graphics));
end Twb;
