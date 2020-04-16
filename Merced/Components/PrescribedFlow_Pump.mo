within Merced.Components;
model PrescribedFlow_Pump
  "Pump with head and efficiency given by a quadratic polynomial"
  extends Merced.Components.BaseClasses.FlowMachinePolynomial;
  parameter Medium.MassFlowRate m_flow_const(min=0)=3e4
    "prescribed pressure difference";
  Modelica.Blocks.Interfaces.RealInput m_flow_in
    "prescribed pressure difference"
    annotation (Placement(transformation(
        origin={30,90},
        extent={{-10,-10},{10,10}},
        rotation=270)));
equation
  m_flow=m_flow_in "mass flow rate";
  if cardinality(m_flow_in)==0 then
    m_flow_in = m_flow_const "Rotational speed provided by parameter";
  end if;
  annotation (Icon(graphics={Text(extent={{-24,98},{26,84}}, textString=
                                          "m_flow"), Text(
          extent={{-70,-54},{76,-84}},
          lineColor={0,0,255},
          textString=
               "%name")}),                            Diagram(graphics));
end PrescribedFlow_Pump;
