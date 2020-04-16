partial model FlowMachinePolynomial 
  "Pump with head and efficiency given by a non-dimensional polynomial" 
  extends Buildings.Fluids.Interfaces.PartialStaticTwoPortTransformer;
  
annotation (Icon(
      Rectangle(extent=[-92,4; -54,-4], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Rectangle(extent=[56,4; 94,-4], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Ellipse(extent=[-60,60; 60,-60],   style(gradient=3)),
      Polygon(points=[-30,32; -30,-28; 48,0; -30,32],     style(
          pattern=0,
          gradient=2,
          fillColor=7))),
                       Diagram(
      Text(extent=[0,-72; 50,-86], string="P")),
    Documentation(revisions="<html>
<ul>
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
  
  parameter Real[:] a "Polynomial coefficients for pressure=p(qNor_flow)";
  parameter Real[:] b "Polynomial coefficients for etaSha=p(qNor_flow)";
  parameter Real qNorMin_flow "Lowest valid normalized mass flow rate";
  parameter Real qNorMax_flow "Highest valid normalized mass flow rate";
  parameter Modelica.SIunits.VolumeFlowRate scaQ_flow = 1 
    "Factor used to scale the volume flow rate";
  parameter Modelica.SIunits.Pressure scaDp = 1 
    "Factor used to scale the pressure increase";
  parameter Modelica.SIunits.AngularVelocity N_nom(min=0.1)=1180 
    "nominal rotational speed";
  
  Real N_ratio(min=0)=N/N_nom "rotational speed ratio";
  Real pNor(min=0) "Normalized pressure";
  Real qNor_flow(start=qNorMax_flow) "Normalized mass flow rate";
  Real etaSha(min=0, max=1) "Efficiency, flow work divided by shaft power";
  Modelica.SIunits.AngularVelocity N "rotational speed";
  Modelica.Blocks.Interfaces.RealOutput P "power" 
    annotation (extent=[30,-90; 50,-70],   rotation=-90);
protected 
  parameter Modelica.SIunits.Length L=1 "unit length";
  parameter Modelica.SIunits.Time T=1 "unit time";
  parameter Real pNorMin1(fixed=false) 
    "Normalized pressure, used to test slope of polynomial outside [xMin, xMax]";
  parameter Real pNorMin2(fixed=false) 
    "Normalized pressure, used to test slope of polynomial outside [xMin, xMax]";
  parameter Real pNorMax1(fixed=false) 
    "Normalized pressure, used to test slope of polynomial outside [xMin, xMax]";
  parameter Real pNorMax2(fixed=false) 
    "Normalized pressure, used to test slope of polynomial outside [xMin, xMax]";
initial equation 
 // check slope of polynomial outside the domain [qNorMin_flow, qNorMax_flow]
 pNorMin1 = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=qNorMin_flow/2, xMin=qNorMin_flow, xMax=qNorMax_flow);
 pNorMin2 = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=qNorMin_flow, xMin=qNorMin_flow, xMax=qNorMax_flow);
 pNorMax1 = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=qNorMax_flow, xMin=qNorMin_flow, xMax=qNorMax_flow);
 pNorMax2 = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=qNorMax_flow*2, xMin=qNorMin_flow, xMax=qNorMax_flow);
 assert(pNorMin1>pNorMin2,
    "Slope of pump pressure polynomial is non-negative for qNor_flow < qNorMin_flow. Check parameter a.");
 assert(pNorMax1>pNorMax2,
    "Slope of pump pressure polynomial is non-negative for qNorMax_flow < qNor_flow. Check parameter a.");
equation 
  -dp = N_ratio*N_ratio * scaDp * pNor;
  m_flow = N_ratio * scaQ_flow * qNor_flow * medium_a.d;
  pNor = Buildings.Fluids.Utilities.extendedPolynomial(
                                        c=a, x=qNor_flow, xMin=qNorMin_flow, xMax=qNorMax_flow);
  etaSha = max(0.1, Buildings.Fluids.Utilities.polynomial(
                                                      c=b, x=qNor_flow));
                                                                // for OpenModelica 1.4.3 sum(qNor_flow^(i - 1)*b[i] for i in 1:size(b,1));
  etaSha * P = -dp * m_flow / medium_a.d; // dp<0 and m_flow>0 for normal operation
  
  // interface ports and state conservation equations
  port_a.H_flow + port_b.H_flow + P = 0;
  port_a.m_flow + port_b.m_flow = 0;
  port_a.mXi_flow + port_b.mXi_flow = zeros(Medium.nXi);
end FlowMachinePolynomial;
