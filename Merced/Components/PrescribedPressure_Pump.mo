within Merced.Components;
model PrescribedPressure_Pump
  "Pump with head and efficiency given by a polynomial"
  extends Merced.Components.BaseClasses.FlowMachinePolynomial;
  parameter Medium.MassFlowRate dp_const(min=0)=3e4
    "prescribed pressure difference";
  Modelica.Blocks.Interfaces.RealInput dp_in "prescribed pressure difference"
    annotation (Placement(transformation(
        origin={30,90},
        extent={{-10,-10},{10,10}},
        rotation=270)));
equation
  dp=-dp_in "mass flow rate";
  if cardinality(dp_in)==0 then
    dp_in = dp_const "Rotational speed provided by parameter";
  end if;
  annotation (Icon(graphics={Text(extent={{-94,102},{30,74}}, textString=
                                           "dp"), Text(
          extent={{-70,-64},{76,-94}},
          lineColor={0,0,255},
          textString=
               "%name")}),                            Diagram(graphics));
end PrescribedPressure_Pump;
