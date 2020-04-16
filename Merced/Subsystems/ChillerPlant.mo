within Merced.Subsystems;
model ChillerPlant
  replaceable package MediumCW = Modelica.Media.Interfaces.PartialMedium
    "Fluid 1"              annotation(choicesAllMatching, Dialog(tab="General",group="CW Fluid"));
  replaceable package MediumCHW = Modelica.Media.Interfaces.PartialMedium
    "Fluid 2"              annotation(choicesAllMatching,Dialog(tab="General", group="CHW Fluid"));
  Merced.Components.Chiller Chiller2(
  redeclare package Medium_1 = MediumCW,
  redeclare package Medium_2 = MediumCHW,
    c={0.17149273,0.58820208,0.23737257},
    COP_ref=7,
    a={0.70790824,-0.002006568,-0.00259605,0.030058776,-0.0010564344,
        0.0020457036},
    b={0.5605438,-0.01377927,6.57072e-005,0.013219362,0.000268596,-0.0005011308},
    Qref=1.0*4.2e6)
    annotation (Placement(transformation(extent={{-56,10},{-22,42}}, rotation=0)));
  Modelica_Fluid.PressureLosses.PressureDropPipe pipeCW2(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    redeclare package Medium = MediumCW,
    diameter=0.05,
    length=1.5,
    dp_nominal=CH1cond_dp,
    m_flow_nominal=CH1cond_m_flow,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantTurbulent)
    annotation (Placement(transformation(extent={{-76,30},{-62,42}}, rotation=0)));
  Modelica_Fluid.PressureLosses.PressureDropPipe pipeCW1(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    redeclare package Medium = MediumCW,
    diameter=0.05,
    length=1.5,
    dp_nominal=CH2cond_dp,
    m_flow_nominal=CH2cond_m_flow,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantTurbulent)
    annotation (Placement(transformation(extent={{-46,48},{-32,60}}, rotation=0)));
  Modelica_Fluid.Sensors.Temperature T_CHWR(redeclare package Medium =
        MediumCHW) annotation (Placement(transformation(extent={{80,17},{68,31}},
          rotation=0)));
  Modelica.Blocks.Math.Add subtract(k1=-1)
                               annotation (Placement(transformation(
        origin={-6,-34},
        extent={{-6,-6},{6,6}},
        rotation=90)));
  Modelica.Blocks.Math.Gain gain(k=0.47)
    annotation (Placement(transformation(
        origin={-6,-16},
        extent={{-6,-6},{6,6}},
        rotation=90)));
  Modelica_Fluid.Interfaces.FluidPort_a CWR(redeclare package Medium = MediumCW)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}}, rotation=
           0)));
  Modelica_Fluid.Interfaces.FluidPort_b CWS(redeclare package Medium =
        MediumCHW)
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{100,50},{120,70}}, rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b CHWS(redeclare package Medium =
        MediumCHW)
    "Fluid connector b for medium 2 (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}},
          rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_a CHWR(redeclare package Medium =
        MediumCHW) annotation (Placement(transformation(extent={{100,-70},{120,
            -50}}, rotation=0)));
  inner Modelica_Fluid.Ambient ambient annotation (Placement(transformation(
          extent={{-62,-80},{-42,-60}}, rotation=0)));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(
        origin={-10,4},
        extent={{-6,-6},{6,6}},
        rotation=90)));
  Modelica_Fluid.PressureLosses.PressureDropPipe pipeCHW1(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    redeclare package Medium = MediumCW,
    diameter=0.05,
    length=2.5,
    dp_nominal=CH2evap_dp,
    m_flow_nominal=CH2evap_m_flow)
    annotation (Placement(transformation(extent={{62,18},{48,30}}, rotation=0)));
  Modelica_Fluid.PressureLosses.PressureDropPipe pipeCHW2(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    redeclare package Medium = MediumCW,
    diameter=0.05,
    length=2.5,
    dp_nominal=CH1evap_dp,
    m_flow_nominal=CH1evap_m_flow)
    annotation (Placement(transformation(extent={{-2,11},{-16,23}}, rotation=0)));
parameter Real CH1evap_dp=(29.3*12*0.0254)*995*9.81;
parameter Real CH1evap_m_flow=(3500*3.785*0.001/60)*995;
parameter Real CH1cond_dp=(19.7*12*0.0254)*995*9.81;
parameter Real CH1cond_m_flow=(3500*3.785*0.001/60)*995;
parameter Real CH2evap_dp=(30.0*12*0.0254)*995*9.81;
parameter Real CH2evap_m_flow=(3500*3.785*0.001/60)*995;
parameter Real CH2cond_dp=(19.7*12*0.0254)*995*9.81;
parameter Real CH2cond_m_flow=(3500*3.785*0.001/60)*995;
  Modelica.Blocks.Interfaces.RealOutput P "power"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}},
          rotation=0)));
  Modelica.Blocks.Math.Add add1
                               annotation (Placement(transformation(
        origin={40,-72},
        extent={{6,-6},{-6,6}},
        rotation=90)));
  Modelica.Blocks.Interfaces.RealInput T_chws_ref
    "set point for CHWS temperature"              annotation (Placement(
        transformation(extent={{-118,-100},{-100,-80}}, rotation=0)));
  Merced.Components.Chiller Chiller1(
  redeclare package Medium_1 = MediumCW,
  redeclare package Medium_2 = MediumCHW,
    c={0.17149273,0.58820208,0.23737257},
    COP_ref=7,
    a={0.70790824,-0.002006568,-0.00259605,0.030058776,-0.0010564344,
        0.0020457036},
    b={0.5605438,-0.01377927,6.57072e-005,0.013219362,0.000268596,-0.0005011308},
    Qref=1.0*4.2e6)
    annotation (Placement(transformation(extent={{8,18},{42,50}}, rotation=0)));
equation
  connect(pipeCW2.port_b, Chiller2.port_a1)
                                         annotation (Line(points={{-62,36},{-63,
          36},{-63,35.6},{-56,35.6}}, color={0,127,255}));
  connect(Chiller1.port_a1, pipeCW1.port_b)
                                          annotation (Line(points={{8,43.6},{
          -24,43.6},{-24,54},{-32,54}}, color={0,127,255}));
  connect(subtract.u2, T_CHWR.T)
                            annotation (Line(points={{-2.4,-41.2},{74,-41.2},{
          74,16.3}}, color={0,0,127}));
  connect(gain.u, subtract.y)
    annotation (Line(points={{-6,-23.2},{-6,-27.4}}, color={0,0,127}));
  connect(pipeCW2.port_a, CWR) annotation (Line(points={{-76,36},{-92,36},{-92,
          60},{-110,60}}, color={0,127,255}));
  connect(Chiller1.port_b1, CWS) annotation (Line(points={{42,43.6},{70,43.6},{
          70,60},{110,60}}, color={0,127,255}));
  connect(Chiller2.port_b2, CHWS) annotation (Line(points={{-56,16.4},{-86,16.4},
          {-86,-60},{-110,-60}}, color={0,127,255}));
  connect(CHWS, CHWS) annotation (Line(points={{-110,-60},{-110,-60}}, color={0,
          127,255}));
  connect(CWR, CWR) annotation (Line(points={{-110,60},{-110,60}}, color={0,127,
          255}));
  connect(T_CHWR.port_a, CHWR) annotation (Line(points={{80,24},{98,24},{98,-60},
          {110,-60}}, color={0,127,255}));
  connect(pipeCW1.port_a, CWR) annotation (Line(points={{-46,54},{-70,54},{-70,
          60},{-110,60}}, color={0,127,255}));
  connect(Chiller2.port_b1, CWS) annotation (Line(points={{-22,35.6},{-8,35.6},
          {-8,60},{110,60}}, color={0,127,255}));
  connect(add.u2, gain.y) annotation (Line(points={{-6.4,-3.2},{-6.6,-3.2},{
          -6.6,-9.4},{-6,-9.4}}, color={0,0,127}));
  connect(add.y, Chiller1.T_chws_ref) annotation (Line(points={{-10,10.6},{6.47,
          10.6},{6.47,19.92}}, color={0,0,127}));
  connect(pipeCHW1.port_a, T_CHWR.port_b) annotation (Line(points={{62,24},{68,
          24}}, color={0,127,255}));
  connect(pipeCHW1.port_b, Chiller1.port_a2) annotation (Line(points={{48,24},{
          45.5,24},{45.5,24.4},{42,24.4}}, color={0,127,255}));
  connect(pipeCHW2.port_a, Chiller1.port_b2) annotation (Line(points={{-2,17},{
          4,17},{4,24.4},{8,24.4}}, color={0,127,255}));
  connect(pipeCHW2.port_b, Chiller2.port_a2) annotation (Line(points={{-16,17},
          {-18,17},{-18,16.4},{-22,16.4}}, color={0,127,255}));
  connect(Chiller2.P, add1.u1) annotation (Line(points={{-20.3,11.6},{-20.3,
          -51.2},{36.4,-51.2},{36.4,-64.8}}, color={0,0,127}));
  connect(add1.u2, Chiller1.P) annotation (Line(points={{43.6,-64.8},{43.6,
          -23.4},{43.7,-23.4},{43.7,19.6}}, color={0,0,127}));
  connect(add1.y, P) annotation (Line(points={{40,-78.6},{40,-90},{110,-90}},
        color={0,0,127}));
  connect(T_chws_ref, Chiller2.T_chws_ref) annotation (Line(points={{-109,-90},
          {-84,-90},{-84,11.92},{-57.53,11.92}}, color={0,0,127}));
  connect(add.u1, T_chws_ref) annotation (Line(points={{-13.6,-3.2},{-57.8,-3.2},
          {-57.8,-90},{-109,-90}}, color={0,0,127}));
  connect(subtract.u1, T_chws_ref) annotation (Line(points={{-9.6,-41.2},{-55.8,
          -41.2},{-55.8,-90},{-109,-90}}, color={0,0,127}));
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram(graphics),
    Icon(graphics={
        Text(
          extent={{-36,148},{62,100}},
          lineColor={0,0,255},
          textString=
               "%name"),
        Rectangle(
          extent={{-68,80},{72,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,65},{101,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-58,60},{62,60}},
          color={255,0,0},
          thickness=1,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-58,-60},{62,-60}},
          color={0,0,255},
          thickness=1,
          arrow={Arrow.Filled,Arrow.None}),
        Bitmap(extent={{-54,42},{62,-44}}, fileName=
                                           "chiller.jpg"),
        Text(extent={{70,-84},{120,-98}}, textString=
                                          "P"),
        Text(extent={{-102,-84},{-56,-96}}, textString=
                                              "T_CHWS")}));
end ChillerPlant;
