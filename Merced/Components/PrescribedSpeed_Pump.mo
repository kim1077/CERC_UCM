within Merced.Components;
model PrescribedSpeed_Pump
  "Pump with head and efficiency given by a quadratic polynomial"
  extends Merced.Components.BaseClasses.FlowMachinePolynomial;
  parameter Modelica.SIunits.AngularVelocity N_const = N_nom
    "constant angular speed";
public
   Modelica.Blocks.Interfaces.RealInput N_in "Prescribed rotational speed"
    annotation (Placement(transformation(
        origin={30,90},
        extent={{-10,-10},{10,10}},
        rotation=270)));
equation
  // set inputs from input or parameter values
  N = N_in "Rotational speed";
  if cardinality(N_in)==0 then
    N_in = N_const "Rotational speed provided by parameter";
  end if;
annotation (Icon(graphics={
        Rectangle(
          extent={{-92,4},{-54,-4}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,2},{94,-6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-58,58},{62,-62}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{-28,30},{-28,-30},{50,-2},{-28,30}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Text(
          extent={{-74,-64},{72,-94}},
          lineColor={0,0,255},
          textString=
               "%name"),
        Text(extent={{-4,94},{24,74}}, textString=
                                         "N")}),
                       Diagram(graphics),
    Documentation(revisions="<html>
<ul>
<li>
October 17, 2008 by Brandon Hencey:<br>
Based off of polynomial machine for use with literature pump curves.
</li>
<li>
March 11, 2008 by Michael Wetter:<br>
Changed to new base class <tt>PartialTwoPortTransformer</tt>.
</li>
<li>
October 18, 2007 by Michael Wetter:<br>
Added scaling factors to allow quickly to scale the fan pressure drop and mass flow rate.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is a model of a flow machine (pump or fan).
</p>
<p>
The normalized pressure difference is computed using a function of the normalized mass flow rate. The function is a polynomial for which a user needs to supply the coefficients and two values that determine for what flow rate the polynomial is linearly extended.
</p>
</html>"));
end PrescribedSpeed_Pump;
