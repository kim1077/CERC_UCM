within Merced.Subsystems;
model Pumps_CW
 replaceable package MediumCW = Modelica.Media.Interfaces.PartialMedium
    "CW Fluid"              annotation(choicesAllMatching, Dialog(tab="General",group="CW Fluid"));
  Modelica_Fluid.Interfaces.FluidPort_a CWe(redeclare package Medium =
        MediumCW)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-124,10},{-104,30}}, rotation=
           0)));
  Modelica_Fluid.Interfaces.FluidPort_b CWl(redeclare package Medium =
        MediumCW)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{102,10},{122,30}}, rotation=0)));
public
   Modelica.Blocks.Interfaces.RealInput N_in "Prescribed rotational speed"
    annotation (Placement(transformation(
        origin={50,90},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  parameter Modelica.SIunits.AngularVelocity N_const = 1180
    "constant angular speed";
  Components.PrescribedSpeed_Pump pump12(
    qNorMin_flow=0.106858248388454,
    b={-0.1196,5.6074,-8.4305},
    a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
    qNorMax_flow=0.399530088717547,
    redeclare package Medium = MediumCW,
    scaQ_flow=2) "Bell& Gossett HSCS 14x16x17 E"
                                annotation (Placement(transformation(extent={{
            -40,10},{-20,30}}, rotation=0)));
equation
  if cardinality(N_in)==0 then
  // set inputs from input or parameter values
    N_in = N_const "Rotational speed provided by parameter";
  end if;
  connect(pump12.port_b, CWl) annotation (Line(points={{-20,20},{112,20}},
        color={0,127,255}));
  connect(pump12.port_a, CWe) annotation (Line(points={{-40,20},{-114,20}},
        color={0,127,255}));
  connect(N_in, pump12.N_in) annotation (Line(points={{50,90},{12,90},{12,29},{
          -27,29}}, color={0,0,127}));
  annotation (uses(Modelica_Fluid(version="0.900")),
      Diagram(graphics),
    Icon(graphics={
        Rectangle(
          extent={{-92,22},{-54,14}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,58},{60,-62}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{-40,-46},{-60,-82},{60,-82},{40,-46},{-40,-46}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,191},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,22},{94,14}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,30},{-32,-30},{46,-2},{-32,30}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Text(
          extent={{-44,90},{40,52}},
          lineColor={0,0,255},
          textString=
               "%name"),
        Text(extent={{16,98},{44,78}}, textString=
                                         "N")}));
end Pumps_CW;
