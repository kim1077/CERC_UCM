within Merced.Examples;
model ModelValidMex
  extends Subsystems;
  Modelica.Blocks.Sources.CombiTimeTable weather(
    tableOnFile=true,
    columns=2:5,
    tableName="weather",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    startTime=-90.8*24*3600,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    fileName="J:\\work\\SEEDprojects\\Merced\\data.mat")
                             annotation (Placement(transformation(extent={{-15,
            34},{0,44}}, rotation=0)));
  Subsystems.CentralPlant centralPlant annotation (Placement(transformation(
          extent={{-10,-20},{38,26}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput CT_Tref "control inputs"
    annotation (Placement(transformation(extent={{-96,36},{-56,76}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput mdot_CHWS "control inputs"
    annotation (Placement(transformation(extent={{-94,-12},{-54,28}}, rotation=
            0)));
  Modelica.Blocks.Interfaces.RealInput T_CHWS_ref "control inputs"
    annotation (Placement(transformation(extent={{-96,-60},{-56,-20}}, rotation=
           0)));
  Modelica.Blocks.Interfaces.RealOutput Power "power"
    annotation (Placement(transformation(extent={{90,22},{110,42}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput TankHeight[2] "measurements"
    annotation (Placement(transformation(extent={{90,-18},{110,2}}, rotation=0)));
equation
  connect(weather.y,centralPlant. w) annotation (Line(points={{0.75,39},{-17.3,
          39},{-17.3,16.8},{-7.6,16.8}}, color={0,0,127}));
  connect(centralPlant.P,Power)  annotation (Line(points={{39.44,16.8},{64.72,
          16.8},{64.72,32},{100,32}}, color={0,0,127}));
  connect(centralPlant.u[1],CT_Tref)  annotation (Line(points={{-7.6,6.06667},{
          -30.8,6.06667},{-30.8,56},{-76,56}}, color={0,0,127}));
  connect(centralPlant.u[2],mdot_CHWS)  annotation (Line(points={{-7.6,7.6},{
          -30.8,7.6},{-30.8,8},{-74,8}}, color={0,0,127}));
  connect(centralPlant.u[3],T_CHWS_ref)  annotation (Line(points={{-7.6,9.13333},
          {-30.8,9.13333},{-30.8,-40},{-76,-40}}, color={0,0,127}));
  connect(centralPlant.y,TankHeight)  annotation (Line(points={{39.44,7.6},{
          62.72,7.6},{62.72,-8},{100,-8}}, color={0,0,127}));
end ModelValidMex;
