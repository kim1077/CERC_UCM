within Merced.Subsystems;
model pump_control_m_flow
  "For a prescribed mass flow rate, calculate pump speed for a pump modeled by a quadratic polynomial"
  extends Buildings.Fluids.Interfaces.PartialStaticTwoPortTransformer;
/*  Modelica.Blocks.Interfaces.RealInput N_in(redeclare type SignalType = 
        Modelica.SIunits.AngularVelocity) "Prescribed rotational speed" 
    annotation (extent=[-120,50; -100,70], rotation=0);*/
  parameter Medium.MassFlowRate m_flow_ref=145 "prescribed mass flow rate";
  parameter Real[:] a "Polynomial coefficients for pressure=p(qNor_flow)";
  parameter Real[:] b "Polynomial coefficients for etaSha=p(qNor_flow)";
  parameter Real qMin_flow "Lowest valid volumetric flow rate";
  parameter Real qMax_flow "Highest valid volumetric flow rate";
  parameter Real N_nom = 1185 "nominal speed";
  Real N_ratio(min=0)=N/N_nom "Speed ratio to nominal speed";
  Real pNor(min=0) "Normalized pressure";
  Real qNor_flow(start=qMax_flow) "Normalized mass flow rate";
protected
  parameter Real pNorMin1(fixed=false)
    "Normalized pressure, used to test slope of polynomial outside [xMin, xMax]";
  parameter Real pNorMin2(fixed=false)
    "Normalized pressure, used to test slope of polynomial outside [xMin, xMax]";
  parameter Real pNorMax1(fixed=false)
    "Normalized pressure, used to test slope of polynomial outside [xMin, xMax]";
  parameter Real pNorMax2(fixed=false)
    "Normalized pressure, used to test slope of polynomial outside [xMin, xMax]";
public
  Modelica.Blocks.Interfaces.RealOutput N(unit="rev/min")
    "prescribed pump speed"
    annotation (Placement(transformation(
        origin={48,-58},
        extent={{-10,-10},{10,10}},
        rotation=270)));
initial equation
 // check slope of polynomial outside the domain [qMin_flow, qMax_flow]
 pNorMin1 = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=qMin_flow/2, xMin=qMin_flow, xMax=qMax_flow);
 pNorMin2 = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=qMin_flow, xMin=qMin_flow, xMax=qMax_flow);
 pNorMax1 = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=qMax_flow, xMin=qMin_flow, xMax=qMax_flow);
 pNorMax2 = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=qMax_flow*2, xMin=qMin_flow, xMax=qMax_flow);
assert(pNorMin1>pNorMin2,
    "Slope of pump pressure polynomial is non-negative for qNor_flow < qMin_flow. Check parameter a.");
assert(pNorMax1>pNorMax2,
    "Slope of pump pressure polynomial is non-negative for qMax_flow < qNor_flow. Check parameter a.");
equation
  -dp = pNor * N_ratio^2;
  m_flow_ref = qNor_flow * N_ratio * medium_a.d;
  pNor = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=qNor_flow, xMin=qMin_flow, xMax=qMax_flow);
  m_flow=0;
  // interface ports and state conservation equations
//  port_a.H_flow = 0;
//  port_b.H_flow = 0;
//  port_a.m_flow = 0;
//  port_b.m_flow = 0;
//  port_a.mXi_flow = zeros(Medium.nXi);
//  port_b.mXi_flow = zeros(Medium.nXi);
  port_a.H_flow + port_b.H_flow = 0;
  port_a.m_flow + port_b.m_flow = 0;
  port_a.mXi_flow + port_b.mXi_flow = zeros(Medium.nXi);
  connect(N, N) annotation (Line(points={{48,-58},{48,-58}}, color={0,0,127}));
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
        Text(
          extent={{-72,76},{74,46}},
          lineColor={0,0,255},
          textString=
               "%name"),
        Rectangle(
          extent={{-52,40},{52,-40}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{36,-24},{-42,24}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString=
               "K")}), Diagram(graphics),
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
end pump_control_m_flow;
