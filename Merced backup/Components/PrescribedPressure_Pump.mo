model PrescribedPressure_Pump 
  "Pump with head and efficiency given by a polynomial" 
  extends Merced.Components.BaseClasses.FlowMachinePolynomial;
  parameter Medium.MassFlowRate dp_const(min=0)=3e4 
    "prescribed pressure difference";
  
  Modelica.Blocks.Interfaces.RealInput dp_in(redeclare type SignalType = 
        Modelica.SIunits.Pressure) "prescribed pressure difference" 
    annotation (extent=[20,80; 40,100],    rotation=-90);
  annotation (Icon(
      Text(extent=[-94,102; 30,74], string="dp"),
      Text(
        extent=[-70,-64; 76,-94],
        style(color=3, rgbcolor={0,0,255}),
        string="%name")),                             Diagram);
  
equation 
  dp=-dp_in "mass flow rate";
  if cardinality(dp_in)==0 then
    dp_in = dp_const "Rotational speed provided by parameter";
  end if;
end PrescribedPressure_Pump;
