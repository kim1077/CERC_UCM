within Merced.Subsystems;
model Campus2
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Fluid"
                           annotation(choicesAllMatching, Dialog(tab="General",group="CW Fluid"));
  Modelica_Fluid.Interfaces.FluidPort_a CHWS(redeclare package Medium =
        Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-120,-32},{-100,-12}},
          rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b CHWR(redeclare package Medium =
        Medium)
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{102,50},{122,70}}, rotation=0)));
  Modelica_Fluid.Pipes.LumpedPipe pipe(
    redeclare package WallFriction =
        Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.NoFriction,
    redeclare package Medium = Medium,
    T_start=(65 - 32)*5/9 + 273.15,
    initType=Modelica_Fluid.Types.Init.InitialValues,
    length=100,
    diameter=24*0.0254)                annotation (Placement(transformation(
          extent={{20,5},{36,-9}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(
        origin={28,-17},
        extent={{-5,-7},{5,7}},
        rotation=90)));
  Modelica.Blocks.Math.Gain gain(k=4.3e3)
    annotation (Placement(transformation(extent={{8,-58},{14,-50}}, rotation=0)));
  Modelica.Blocks.Sources.Constant const(k=273.15 + (65 - 32)*5/9)
    annotation (Placement(transformation(extent={{-52,-63},{-38,-51}}, rotation=
           0)));
  Modelica.Blocks.Math.Add add(k1=-1, k2=+1)
                                      annotation (Placement(transformation(
          extent={{-18,-60},{-6,-48}}, rotation=0)));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(
        origin={28,-35},
        extent={{-7,-6},{7,6}},
        rotation=90)));
  Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM(
    m_flow(start=150),
    dp(start=60*12*0.0254*995*9.81),
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    redeclare package Medium = Medium,
    dp_nominal=(80*12*0.0254)*9.81*995/2,
    m_flow_nominal=(3125*3.78*0.001/60)*995)
                        annotation (Placement(transformation(extent={{-77,-7},{
            -66,3}}, rotation=0)));
  inner Modelica_Fluid.Ambient ambient annotation (Placement(transformation(
          extent={{-80,40},{-60,60}}, rotation=0)));
  Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM1(
    m_flow(start=150),
    dp(start=60*12*0.0254*995*9.81),
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    redeclare package Medium = Medium,
    dp_nominal=80*12*0.0254*9.81*995/2,
    m_flow_nominal=(3125*3.78*0.001/60)*995)
                        annotation (Placement(transformation(extent={{65,-7},{
            76,3}}, rotation=0)));
  Modelica_Fluid.Sensors.Temperature T_CHWR(redeclare package Medium =
        Medium)    annotation (Placement(transformation(extent={{-36,-9},{-24,5}},
          rotation=0)));
  Modelica_Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-4,-10},{12,6}},
          rotation=0)));
equation
  connect(CHWS, CHWS)
                    annotation (Line(points={{-110,-22},{-110,-22}}, color={0,
          127,255}));
  connect(CHWR, CHWR) annotation (Line(
      points={{112,60},{107,60},{107,60},{112,60}},
      color={0,127,255},
      arrow={Arrow.None,Arrow.Filled}));
  connect(fixedResistanceDpM1.port_b, CHWR) annotation (Line(points={{76,-2},{
          82,-2},{82,60},{112,60}}, color={0,127,255}));
  connect(fixedResistanceDpM.port_a, CHWS) annotation (Line(points={{-77,-2},{
          -92,-2},{-92,-22},{-110,-22}}, color={0,127,255}));
  connect(pipe.port_b, fixedResistanceDpM1.port_a) annotation (Line(points={{36,
          -2},{50.5,-2},{50.5,-2},{65,-2}}, color={0,127,255}));
  connect(prescribedHeatFlow.Q_flow, product.y) annotation (Line(points={{28,
          -22},{28,-27.3}}, color={0,0,127}));
  connect(pipe.thermalPort, prescribedHeatFlow.port) annotation (Line(points={{
          28,-5.78},{28,-12}}, color={191,0,0}));
  connect(T_CHWR.T, add.u1) annotation (Line(points={{-30,-9.7},{-30,-49.85},{
          -19.2,-49.85},{-19.2,-50.4}}, color={0,0,127}));
  connect(massFlowRate.port_b, pipe.port_a) annotation (Line(points={{12,-2},{
          16,-2},{16,-2},{20,-2}}, color={0,127,255}));
  connect(massFlowRate.port_a, T_CHWR.port_b) annotation (Line(points={{-4,-2},
          {-14,-2},{-14,-2},{-24,-2}}, color={0,127,255}));
  connect(T_CHWR.port_a, fixedResistanceDpM.port_b) annotation (Line(points={{
          -36,-2},{-51,-2},{-51,-2},{-66,-2}}, color={0,127,255}));
  connect(add.u2, const.y) annotation (Line(points={{-19.2,-57.6},{-28.6,-57.6},
          {-28.6,-57},{-37.3,-57}}, color={0,0,127}));
  connect(gain.u, add.y) annotation (Line(points={{7.4,-54},{-5.4,-54}}, color=
          {0,0,127}));
  connect(gain.y, product.u2) annotation (Line(points={{14.3,-54},{32,-54},{32,
          -43.4},{31.6,-43.4}}, color={0,0,127}));
  connect(product.u1, massFlowRate.m_flow) annotation (Line(points={{24.4,-43.4},
          {24.4,-44.7},{4,-44.7},{4,-10.8}}, color={0,0,127}));
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram(graphics),
    Icon(graphics={
        Text(
          extent={{-52,114},{46,66}},
          lineColor={0,0,255},
          textString=
               "%name"),
        Bitmap(extent={{-98,118},{102,-100}}, fileName=
                                              "campus.JPG"),
        Line(
          points={{-38,-10},{88,64}},
          color={0,0,255},
          arrow={Arrow.None,Arrow.Filled})}));
end Campus2;
