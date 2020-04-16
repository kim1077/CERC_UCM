within Merced.CoolingPlantNew;
model Dummytest
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-70,6},{-30,46}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{26,16},{46,36}})));
  parameter Real a=3;
equation
  connect(u, y) annotation (Line(points={{-50,26},{36,26}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dummytest;
