model PrescribedFlow_Pump 
  "Pump with head and efficiency given by a quadratic polynomial" 
  extends Merced.Components.BaseClasses.FlowMachinePolynomial(
  N_ratio(start=0,nominal=1),
  qNor_flow(start=0,nominal=qNorMax_flow));
  parameter Medium.MassFlowRate m_flow_const(min=0)=3e4 
    "prescribed pressure difference";
  
  Modelica.Blocks.Interfaces.RealInput m_flow_in(redeclare type SignalType = 
        Modelica.SIunits.Pressure) "prescribed pressure difference" 
    annotation (extent=[20,80; 40,100],    rotation=-90);
  annotation (Icon(
      Text(extent=[-24,98; 26,84], string="m_flow"),
      Text(
        extent=[-70,-54; 76,-84],
        style(color=3, rgbcolor={0,0,255}),
        string="%name")),                             Diagram);
  
equation 
  m_flow=m_flow_in "mass flow rate";
  if cardinality(m_flow_in)==0 then
    m_flow_in = m_flow_const "Rotational speed provided by parameter";
  end if;
end PrescribedFlow_Pump;
