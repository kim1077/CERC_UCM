block m_flow_CW "scale chiller pump flow to condenser pump flow" 
  
  Modelica.Blocks.Interfaces.RealInput u(redeclare type SignalType = 
        Modelica.SIunits.MassFlowRate) "normalized mass flow rate" 
    annotation (extent=[-120,-10; -100,10],rotation=0);
  Modelica.Blocks.Interfaces.RealOutput y "mass flow rate" 
    annotation (extent=[100,-10; 120,10], rotation=0);
  
  Modelica.Blocks.Math.Gain pump1_m_flow_gain1(k=2*3500*3.7854e-3/60*995) 
    annotation (extent=[20,-4; 28,4]);
  Modelica.Blocks.Math.Gain pump1_m_flow_gain2(k=235/135) 
    annotation (extent=[-28,-4; -20,4]);
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin=0) 
    annotation (extent=[-10,-10; 10,10]);
equation 
  connect(pump1_m_flow_gain2.u, u) 
    annotation (points=[-28.8,0; -110,0], style(color=74, rgbcolor={0,0,127}));
  connect(limiter.u, pump1_m_flow_gain2.y) 
    annotation (points=[-12,0; -19.6,0], style(color=74, rgbcolor={0,0,127}));
  connect(limiter.y, pump1_m_flow_gain1.u) 
    annotation (points=[11,0; 19.2,0], style(color=74, rgbcolor={0,0,127}));
  connect(pump1_m_flow_gain1.y, y) 
    annotation (points=[28.4,0; 110,0], style(color=74, rgbcolor={0,0,127}));
  annotation (Diagram);
end m_flow_CW;
