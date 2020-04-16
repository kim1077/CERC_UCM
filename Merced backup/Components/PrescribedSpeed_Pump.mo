model PrescribedSpeed_Pump 
  "Pump with head and efficiency given by a quadratic polynomial" 
  extends Merced.Components.BaseClasses.FlowMachinePolynomial;
  
annotation (Icon(
      Rectangle(extent=[-92,4; -54,-4], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Rectangle(extent=[56,2; 94,-6], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Ellipse(extent=[-58,58; 62,-62],   style(gradient=3)),
      Polygon(points=[-28,30; -28,-30; 50,-2; -28,30],    style(
          pattern=0,
          gradient=2,
          fillColor=7)),
      Text(
        extent=[-74,-64; 72,-94],
        style(color=3, rgbcolor={0,0,255}),
        string="%name"),
      Text(extent=[-4,94; 24,74], string="N")),
                       Diagram,
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
  
  parameter Modelica.SIunits.AngularVelocity N_const = N_nom 
    "constant angular speed";
  
public 
   Modelica.Blocks.Interfaces.RealInput N_in(redeclare type SignalType = 
        Modelica.SIunits.AngularVelocity) "Prescribed rotational speed" 
    annotation (extent=[20,80; 40,100],    rotation=-90);
  
equation 
  // set inputs from input or parameter values
  N = N_in "Rotational speed";
  if cardinality(N_in)==0 then
    N_in = N_const "Rotational speed provided by parameter";
  end if;
end PrescribedSpeed_Pump;
