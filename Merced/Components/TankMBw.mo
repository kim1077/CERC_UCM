within Merced.Components;
model TankMBw "thermal energy storage tank with weather input"
  Modelica_Fluid.Interfaces.FluidPort_a PortA(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,70},{10,90}}, rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_a PortB(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-88},{10,-68}}, rotation=
            0)));
  TankMB tankMB(
    redeclare package Medium = Medium,
    Radius=60*12*0.0254,
    h_startA=h_startA,
    T_startA=T_startA,
    T_startB=T_startB,
    h_startB=h_startB,
    X_startA=X_startA,
    X_startB=X_startB,
    tauJet=2)   annotation (Placement(transformation(extent={{-36,-33},{36,43}},
          rotation=0)));
  Modelica.Blocks.Routing.ExtractSignal extractSignal(
    nin=Nw,
    nout=1,
    extract={1})
    annotation (Placement(transformation(extent={{-58,42},{-38,62}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput w[Nw] "weather"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}}, rotation=0)));
  extends BaseClasses.StartParameter;
  parameter Integer Nw=4 "dimension of weather bus";
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  Modelica.Blocks.Interfaces.RealOutput z[2] "tank height"
    annotation (Placement(transformation(extent={{60,10},{80,30}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput T1[2] annotation (Placement(
        transformation(extent={{60,-18},{80,2}}, rotation=0)));
equation
  connect(tankMB.PortA, PortA)
    annotation (Line(points={{0,34.64},{0,80}}, color={0,127,255}));
  connect(tankMB.PortB, PortB) annotation (Line(points={{0,-25.4},{0,-78}},
        color={0,127,255}));
  connect(extractSignal.u,w)
    annotation (Line(points={{-60,52},{-70,52},{-70,20},{-70,20}}, color={0,0,
          127}));
  connect(extractSignal.y[1], tankMB.Tamb) annotation (Line(points={{-37,52},{
          -29.18,52},{-29.18,20.2},{-26.28,20.2}}, color={0,0,127}));
  connect(z, z)
    annotation (Line(points={{70,20},{70,20}}, color={0,0,127}));
  connect(tankMB.z, z) annotation (Line(points={{25.2,20.2},{42.6,20.2},{42.6,
          20},{70,20}}, color={0,0,127}));
  connect(tankMB.T, T1) annotation (Line(points={{25.2,-7.16},{45.6,-7.16},{
          45.6,-8},{70,-8}}, color={0,0,127}));
  annotation (         Icon(graphics={
        Ellipse(
          extent={{-60,-40},{60,-80}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={170,213,255}),
        Ellipse(
          extent={{-60,80},{60,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={170,213,255}),
        Ellipse(
          extent={{-60,32},{60,-8}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Rectangle(
          extent={{-60,60},{58,14}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Text(
          extent={{-32,-22},{34,-58}},
          lineColor={0,0,255},
          textString=
               "Node B"),
        Text(
          extent={{-32,54},{34,18}},
          lineColor={0,0,255},
          textString=
               "Node A"),
        Text(
          extent={{-112,54},{-40,28}},
          lineColor={0,0,255},
          textString=
               "w"),
        Text(
          extent={{54,58},{92,28}},
          lineColor={0,0,255},
          textString=
               "z"),
        Text(
          extent={{54,-14},{92,-44}},
          lineColor={0,0,255},
          textString=
               "T")}));
end TankMBw;
