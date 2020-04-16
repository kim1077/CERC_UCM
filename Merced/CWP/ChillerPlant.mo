within Merced.CWP;
model ChillerPlant
  replaceable package MediumCW = Modelica.Media.Interfaces.PartialMedium
    "Fluid 1"              annotation(choicesAllMatching, Dialog(tab="General",group="CW Fluid"));
  replaceable package MediumCHW = Modelica.Media.Interfaces.PartialMedium
    "Fluid 2"              annotation(choicesAllMatching,Dialog(tab="General", group="CHW Fluid"));
  Chiller Chiller1(
  redeclare package Medium_1 = MediumCW,
  redeclare package Medium_2 = MediumCHW,
    COP_ref=7,
    PLR_max=1.04,
    PLR_Min=0.4,
    a={4.084496E-01,-4.396326E-02,-2.112120E-03,8.225310E-02,-3.066058E-03,
        5.257550E-03},
    flowDirection_1=Modelica_Fluid.Types.FlowDirection.Unidirectional,
    flowDirection_2=Modelica_Fluid.Types.FlowDirection.Unidirectional,
    m_flow_1(start=195.6),
    m_flow_2(start=246),
    b={5.214788E-01,-8.218594E-03,-3.068358E-05,2.152332E-02,1.203908E-04,-7.167755E-04},
    c={3.771252E-01,2.854188E-02,5.928670E-01},
    Qref=3.99e6)
    annotation (Placement(transformation(extent={{8,18},{42,50}}, rotation=0)));
  Chiller Chiller2(
  redeclare package Medium_1 = MediumCW,
  redeclare package Medium_2 = MediumCHW,
    COP_ref=7,
    PLR_max=1.04,
    PLR_Min=0.4,
    a={4.084496E-01,-4.396326E-02,-2.112120E-03,8.225310E-02,-3.066058E-03,
        5.257550E-03},
    b={5.214788E-01,-8.218594E-03,-3.068358E-05,2.152332E-02,1.203908E-04,-7.167755E-04},
    c={3.771252E-01,2.854188E-02,5.928670E-01},
    m_flow_1(start=195.6),
    m_flow_2(start=246),
    Qref=4.8e6)
    annotation (Placement(transformation(extent={{-56,10},{-22,42}}, rotation=0)));
  Modelica_Fluid.PressureLosses.PressureDropPipe pipeCW2(
    redeclare package Medium = MediumCW,
    diameter=0.05,
    length=1.5,
    dp_nominal=CH1cond_dp,
    m_flow_nominal=CH1cond_m_flow,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantTurbulent,
    flowDirection=Modelica_Fluid.Types.FlowDirection.Unidirectional,
    from_dp=false,
    m_flow(start=CH1cond_m_flow,nominal=CH1cond_m_flow),
    dp(start=CH1cond_dp,nominal=CH1cond_dp))
    annotation (Placement(transformation(extent={{-76,30},{-62,42}}, rotation=0)));
  Modelica_Fluid.PressureLosses.PressureDropPipe pipeCW1(
    redeclare package Medium = MediumCW,
    diameter=0.05,
    length=1.5,
    dp_nominal=CH2cond_dp,
    m_flow_nominal=CH2cond_m_flow,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantTurbulent,
    flowDirection=Modelica_Fluid.Types.FlowDirection.Unidirectional,
    from_dp=false,
    m_flow(start=CH2cond_m_flow,nominal=CH2cond_m_flow),
    dp(start=CH2cond_dp,nominal=CH2cond_dp))
    annotation (Placement(transformation(extent={{-46,48},{-32,60}}, rotation=0)));
  Modelica_Fluid.Sensors.Temperature T_CHWR(redeclare package Medium =
        MediumCHW) annotation (Placement(transformation(extent={{80,17},{68,31}},
          rotation=0)));
  Modelica.Blocks.Math.Add subtract(k1=-1)
                               annotation (Placement(transformation(
        origin={-6,-34},
        extent={{-6,-6},{6,6}},
        rotation=90)));
  Modelica.Blocks.Math.Gain gain(k=0.5)
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
          extent={{-60,-80},{-40,-60}}, rotation=0)));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(
        origin={-10,4},
        extent={{-6,-6},{6,6}},
        rotation=90)));
  Modelica_Fluid.PressureLosses.PressureDropPipe pipeCHW1(
    redeclare package Medium = MediumCW,
    diameter=0.05,
    length=2.5,
    dp_nominal=CH2evap_dp,
    m_flow_nominal=CH2evap_m_flow,
    flowDirection=Modelica_Fluid.Types.FlowDirection.Unidirectional,
    from_dp=false,
    m_flow(start=CH2evap_m_flow,nominal=CH2evap_m_flow),
    dp(start=CH2evap_dp,nominal=CH2evap_dp))
    annotation (Placement(transformation(extent={{62,18},{48,30}}, rotation=0)));
  Modelica_Fluid.PressureLosses.PressureDropPipe pipeCHW2(
    redeclare package Medium = MediumCW,
    diameter=0.05,
    length=2.5,
    dp_nominal=CH1evap_dp,
    m_flow_nominal=CH1evap_m_flow,
    flowDirection=Modelica_Fluid.Types.FlowDirection.Unidirectional,
    from_dp=false,
    m_flow(start=CH1evap_m_flow,nominal=CH1evap_m_flow),
    dp(start=CH1evap_dp,nominal=CH1evap_dp))
    annotation (Placement(transformation(extent={{-2,11},{-16,23}}, rotation=0)));
parameter Real CH1evap_dp=(10.6*12*0.0254)*995*9.81;
parameter Real CH1evap_m_flow=(2310*3.7854e-3/60)*995;
parameter Real CH1cond_dp=(8*12*0.0254)*995*9.81;
parameter Real CH1cond_m_flow=(3500*3.7854e-3/60)*995;
parameter Real CH2evap_dp=(10.6*12*0.0254)*995*9.81;
parameter Real CH2evap_m_flow=(2310*3.7854e-3/60)*995;
parameter Real CH2cond_dp=(8*12*0.0254)*995*9.81;
parameter Real CH2cond_m_flow=(3500*3.7854e-3/60)*995;
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
  connect(add.u1, T_chws_ref) annotation (Line(points={{-13.6,-3.2},{-59.8,-3.2},
          {-59.8,-90},{-109,-90}}, color={0,0,127}));
  connect(subtract.u1, T_chws_ref) annotation (Line(points={{-9.6,-41.2},{-59.8,
          -41.2},{-59.8,-90},{-109,-90}}, color={0,0,127}));
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
