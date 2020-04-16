within Merced.Examples;
model test_TankMB
  package Water =         Modelica.Media.Water.StandardWater;

  Merced.Components.TankMB fluidTankMB(T_startB=278.15, redeclare package
      Medium =Water)      annotation (Placement(transformation(extent={{-44,-18},
            {2,26}}, rotation=0)));
  Modelica.Blocks.Sources.Sine sine3(
    amplitude=5,
    freqHz=1/86400,
    offset=293)
    annotation (Placement(transformation(extent={{-76,7},{-58,19}}, rotation=0)));
  Modelica.Fluid.Sources.MassFlowSource_T boundary1(nPorts=1,redeclare package
      Medium =Water)
    annotation (Placement(transformation(extent={{-74,-60},{-54,-40}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary2(nPorts=1,redeclare package
      Medium =Water)
    annotation (Placement(transformation(extent={{-92,60},{-72,80}})));
equation
  connect(sine3.y, fluidTankMB.Tamb) annotation (Line(points={{-57.1,13},{
          -47.445,13},{-47.445,12.8},{-37.79,12.8}}, color={0,0,127}));
  connect(boundary2.ports[1], fluidTankMB.PortA) annotation (Line(points={{-72,70},
          {-22,70},{-22,21.16},{-21,21.16}}, color={0,127,255}));
  connect(boundary1.ports[1], fluidTankMB.PortB) annotation (Line(points={{-54,-50},
          {-18,-50},{-18,-13.6},{-21,-13.6}}, color={0,127,255}));
end test_TankMB;
