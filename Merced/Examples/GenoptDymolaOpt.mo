within Merced.Examples;
model GenoptDymolaOpt
  parameter String resultFileName = "result.txt"
    "File on which data is present";
  parameter String header = "Objective function value" "Header for result file";
  Modelica.Blocks.Sources.CombiTimeTable weather(
    tableOnFile=true,
    columns=2:5,
    tableName="weather",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    startTime=-90.8*24*3600,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName="J:\\work\\SEEDprojects\\Merced\\data.mat")
                             annotation (Placement(transformation(extent={{-47,
            80},{-32,90}}, rotation=0)));
  Subsystems.CentralPlant centralPlant(tankMB(h_startA=(85*12*0.0254) - 1.466,
        h_startB=1.466))               annotation (Placement(transformation(
          extent={{-16,18},{32,64}}, rotation=0)));
  Modelica.Blocks.Continuous.Integrator int
    annotation (Placement(transformation(extent={{58,48},{70,60}}, rotation=0)));
  Modelica.Blocks.Sources.CombiTimeTable CT_Tref(
    tableOnFile=true,
    fileName="modelicaSchedule.txt",
    tableName="tab1") "control input read from txt file"
    annotation (Placement(transformation(extent={{-92,10},{-72,30}}, rotation=0)));
  Modelica.Blocks.Sources.CombiTimeTable mdot_CHWS(
    tableOnFile=true,
    fileName="modelicaSchedule.txt",
    tableName="tab2") "control input read from txt file"
    annotation (Placement(transformation(extent={{-92,36},{-72,56}}, rotation=0)));
  Modelica.Blocks.Sources.CombiTimeTable T_CHWS_ref(
    tableOnFile=true,
    fileName="modelicaSchedule.txt",
    tableName="tab3") "control input read from txt file"
    annotation (Placement(transformation(extent={{-92,62},{-72,82}}, rotation=0)));
initial algorithm
 if (resultFileName <> "") then
    Modelica.Utilities.Files.removeFile(resultFileName);
  end if;
  Modelica.Utilities.Streams.print(fileName=resultFileName, string=header);
equation
when terminal() then
Modelica.Utilities.Streams.print("f(x) = " +
realString(number=int.y, minimumWidth=1, precision=16), resultFileName);
end when;
  connect(weather.y,centralPlant. w) annotation (Line(points={{-31.25,85},{
          -23.3,85},{-23.3,54.8},{-13.6,54.8}}, color={0,0,127}));
  connect(CT_Tref.y[1], centralPlant.u[1])
                                      annotation (Line(points={{-71,20},{-39.3,
          20},{-39.3,44.0667},{-13.6,44.0667}}, color={0,0,127}));
  connect(mdot_CHWS.y[1], centralPlant.u[2])
                                      annotation (Line(points={{-71,46},{-40,46},
          {-40,45.6},{-13.6,45.6}}, color={0,0,127}));
  connect(T_CHWS_ref.y[1], centralPlant.u[3])
                                      annotation (Line(points={{-71,72},{-40,72},
          {-40,47.1333},{-13.6,47.1333}}, color={0,0,127}));
  connect(centralPlant.P, int.u) annotation (Line(points={{33.44,54.8},{43.72,
          54.8},{43.72,54},{56.8,54}}, color={0,0,127}));
  annotation (Diagram(graphics));
end GenoptDymolaOpt;
