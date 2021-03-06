within UCMerced;
model ChillerV1 "Test model for chiller electric EIR"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric(
      P_nominal=-per.QEva_flow_nominal/per.COP_nominal,
      mEva_flow_nominal=per.mEva_flow_nominal,
      mCon_flow_nominal=per.mCon_flow_nominal,
    sou1(nPorts=1),
    sou2(nPorts=1),
    TSet(height=0),
    TCon_in(height=0),
    pulse(period(displayUnit="d") = 864000, startTime(displayUnit="d") = 0));

  parameter
    Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
    per(
    QEva_flow_nominal=-4.2*1e6,
    COP_nominal=7,
    PLRMax=1,
    PLRMinUnl=0.4,
    capFunT={0.70790824,-0.002006568,-0.00259605,0.030058776,-0.0010564344,
        0.0020457036},
    EIRFunT={0.5605438,-0.01377927,6.57072e-005,0.013219362,0.000268596,-0.0005011308},

    EIRFunPLR={0.17149273,0.58820208,0.23737257}) "Chiller performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  Buildings.Fluid.Chillers.ElectricEIR chi(
       redeclare package Medium1 = Medium1,
       redeclare package Medium2 = Medium2,
       per=per,
       energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
       dp1_nominal=6000,
       dp2_nominal=6000) "Chiller model"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

equation
  connect(sou1.ports[1], chi.port_a1) annotation (Line(
      points={{-40,16},{0,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b1, res1.port_a) annotation (Line(
      points={{20,16},{26,16},{26,40},{32,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], chi.port_a2) annotation (Line(
      points={{40,4},{20,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b2, res2.port_a) annotation (Line(
      points={{0,4},{-10,4},{-10,-20},{-20,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.on, greaterThreshold.y) annotation (Line(
      points={{-2,13},{-10,13},{-10,90},{-19,90}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(chi.TSet, TSet.y) annotation (Line(
      points={{-2,7},{-30,7},{-30,60},{-59,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(Tolerance=1e-6, StopTime=14400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/ElectricEIR.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that simulates a chiller whose efficiency is computed based on the
condenser entering and evaporator leaving fluid temperature.
A bicubic polynomial is used to compute the chiller part load performance.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, 2008, by Brandon Hencey:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerV1;
