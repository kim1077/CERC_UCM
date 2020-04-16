within Merced.Subsystems;
model dumbChiller
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Fluid"
                           annotation(choicesAllMatching, Dialog(tab="General",group="CW Fluid"));
  Modelica_Fluid.Interfaces.FluidPort_a CHWS(redeclare package Medium =
        Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}},
          rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b CHWR(redeclare package Medium =
        Medium)
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}, rotation=
            0)));
  Modelica_Fluid.Pipes.LumpedPipe pipe(
    redeclare package WallFriction =
        Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.NoFriction,
    diameter=24*0.0254,
    redeclare package Medium = Medium,
    length=1)                          annotation (Placement(transformation(
          extent={{-12,5},{4,-9}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(
        origin={-4,-17},
        extent={{-5,-7},{5,7}},
        rotation=90)));
  Modelica.Blocks.Math.Gain gain(k=4300)
    annotation (Placement(transformation(extent={{-22,-62},{-16,-54}}, rotation=
           0)));
  Modelica_Fluid.Sensors.Temperature T_CHWR(redeclare package Medium =
        Medium)    annotation (Placement(transformation(extent={{-88,-9},{-76,5}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant const(k=273.15 + (39 - 32)*5/9)
    annotation (Placement(transformation(extent={{-76,-60},{-62,-48}}, rotation=
           0)));
  Modelica_Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-58,-10},{-42,6}},
          rotation=0)));
  Modelica.Blocks.Math.Add add(k2=-1) annotation (Placement(transformation(
          extent={{-48,-64},{-36,-52}}, rotation=0)));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(
        origin={-4,-33},
        extent={{-7,6},{7,-6}},
        rotation=90)));
  Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM(
    m_flow(start=150),
    dp(start=60*12*0.0254*995*9.81),
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    dp_nominal=60*12*0.0254*9.81*995,
    m_flow_nominal=150,
    redeclare package Medium = Medium)
                        annotation (Placement(transformation(extent={{-35,-7},{
            -24,3}}, rotation=0)));
  inner Modelica_Fluid.Ambient ambient annotation (Placement(transformation(
          extent={{-80,40},{-60,60}}, rotation=0)));
equation
  connect(CHWS, CHWS)
                    annotation (Line(points={{-110,0},{-110,0}}, color={0,127,
          255}));
  connect(CHWR, CHWR) annotation (Line(
      points={{110,0},{107,0},{107,0},{110,0}},
      color={0,127,255},
      arrow={Arrow.None,Arrow.Filled}));
  connect(add.u1, const.y) annotation (Line(points={{-49.2,-54.4},{-53.6,-54.4},
          {-53.6,-54},{-61.3,-54}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, pipe.thermalPort) annotation (Line(points={{
          -4,-12},{-4,-8.89},{-4,-5.78},{-4,-5.78}}, color={191,0,0}));
  connect(product.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-4,
          -25.3},{-4,-26},{-3,-24},{-4,-24},{-4,-22}}, color={0,0,127}));
  connect(product.u2, massFlowRate.m_flow) annotation (Line(points={{-7.6,-41.4},
          {-7.6,-46.7},{-50,-46.7},{-50,-10.8}}, color={0,0,127}));
  connect(add.y, gain.u) annotation (Line(points={{-35.4,-58},{-22.6,-58}},
        color={0,0,127}));
  connect(T_CHWR.T, add.u2) annotation (Line(points={{-82,-9.7},{-82,-70},{
          -49.2,-70},{-49.2,-61.6}}, color={0,0,127}));
  connect(fixedResistanceDpM.port_a, pipe.port_a) annotation (Line(points={{-35,
          -2},{-18,-2},{-18,-2},{-12,-2}}, color={0,127,255}));
  connect(massFlowRate.port_b, fixedResistanceDpM.port_a) annotation (Line(
        points={{-42,-2},{-35,-2}}, color={0,127,255}));
  connect(T_CHWR.port_b, massFlowRate.port_a) annotation (Line(points={{-76,-2},
          {-67,-2},{-67,-2},{-58,-2}}, color={0,127,255}));
  connect(T_CHWR.port_a, CHWS) annotation (Line(points={{-88,-2},{-95.5,-2},{
          -95.5,0},{-103,0},{-103,0},{-110,0}}, color={0,127,255}));
  connect(pipe.port_b, CHWR) annotation (Line(points={{4,-2},{32,-2},{32,0},{60,
          0},{60,0},{110,0}}, color={0,127,255}));
  connect(product.u1, gain.y) annotation (Line(points={{-0.4,-41.4},{-0.4,-57.7},
          {-15.7,-57.7},{-15.7,-58}}, color={0,0,127}));
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram(graphics),
    Icon(graphics={Text(
          extent={{-52,114},{46,66}},
          lineColor={0,0,255},
          textString=
               "%name"), Rectangle(
          extent={{-86,62},{92,-72}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}));
end dumbChiller;
