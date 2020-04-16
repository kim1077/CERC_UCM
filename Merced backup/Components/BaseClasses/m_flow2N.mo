block m_flow2N "calculate speed based on mass flow" 
  parameter Modelica.SIunits.Density rho=995 "fluid density";
  parameter Modelica.SIunits.VolumeFlowRate q_flow_nom=(3500*3.785*0.001/60) 
    "nominal volumetric flow rate";
  parameter Modelica.SIunits.VolumeFlowRate dp_nom=(60*12*0.0254)*995*9.81 
    "nominal pressure difference";
  
  Modelica.Blocks.Interfaces.RealInput u(redeclare type SignalType = 
        Modelica.SIunits.MassFlowRate) "prescribed mass flow rate" 
    annotation (extent=[-120,-10; -100,10],rotation=0);
  Modelica.Blocks.Interfaces.RealOutput y "rotational speed" 
    annotation (extent=[100,-10; 120,10], rotation=0);
  
  parameter Real[3] a "Polynomial coefficients for pressure=p(qNor_flow)";
  parameter Real qNorMin_flow "Lowest valid normalized mass flow rate";
  parameter Real qNorMax_flow "Highest valid normalized mass flow rate";
  parameter Modelica.SIunits.VolumeFlowRate scaQ_flow = 1 
    "Factor used to scale the volume flow rate";
  parameter Modelica.SIunits.Pressure scaDp = 1 
    "Factor used to scale the pressure increase";
  parameter Modelica.SIunits.AngularVelocity N_nom(min=0.1)=1180 
    "nominal rotational speed";
  
//  parameter Modelica.SIunits.MassFlowRate m_flow_units=1;
protected 
  parameter Modelica.SIunits.AngularVelocity N_units=1;
  
equation 
  y = min( N_nom,-u*N_nom/rho / (-a[2] + sqrt( a[2]^2 - 4* (a[3]-rho*dp_nom/q_flow_nom/max(u,1e-6))*a[1])) *(a[3]-rho*dp_nom/q_flow_nom/max(u,1e-6))*2)/N_units;
  annotation (Icon);
end m_flow2N;
