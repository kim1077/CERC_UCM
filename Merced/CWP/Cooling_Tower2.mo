within Merced.CWP;
model Cooling_Tower2
YorkCalc_PrescribedTemp2 tow(
    TAirInWB0=273.15 + (68 - 32)*5/9,
    TApp0=(75 - 68)*5/9,
    TRan0=(85 - 75)*5/9,
    redeclare package Medium = Medium,
    mWat0_flow=5*(1735*3.785/60),
    PFan0=5*40*745.7,
    Q_flow(nominal=-2E7, start=-3E7),
    dTMin=10)                     annotation (Placement(transformation(extent={
            {-12,-10},{8,10}}, rotation=0)));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  //replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Real TAppMin=2 "Minimum Approach Temperature [K]";
  Modelica_Fluid.PressureLosses.PressureDropPipe Pipe_CT(
    diameter=0.05,
    redeclare package Medium = Medium,
    length=1,
    from_dp=false,
    dp_nominal=1*995*9.81,
    m_flow_nominal=(2*3500*3.785*0.001/60)*995,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    flowDirection=Modelica_Fluid.Types.FlowDirection.Unidirectional,
    m_flow(start=(2*3500*3.785*0.001/60)*995),
    dp(start=1*995*9.81))
    annotation (Placement(transformation(extent={{22,-6},{36,6}}, rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_a CWR(redeclare package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-117,-11},{-97,9}}, rotation=
            0)));
  Modelica_Fluid.Interfaces.FluidPort_b CWS(redeclare package Medium = Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{98,-10},{118,10}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput Twb "weather data"
    annotation (Placement(transformation(extent={{-138,60},{-98,100}}, rotation=
           0)));
  parameter Integer Nw=4 "dimension of weather bus";
  Modelica.Blocks.Interfaces.RealInput Tref "CWS temperature set point"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}, rotation=
           0)));
  Modelica.Blocks.Interfaces.RealOutput P "power"
    annotation (Placement(transformation(extent={{100,32},{120,52}}, rotation=0)));
equation
  connect(Pipe_CT.port_a, tow.port_b)
    annotation (Line(points={{22,0},{8,0}}, color={0,127,255}));
  connect(Pipe_CT.port_b, CWS)
    annotation (Line(points={{36,0},{108,0}}, color={0,127,255}));
  connect(tow.P, P) annotation (Line(points={{8.2,4},{52,4},{52,42},{110,42}},
        color={0,0,127}));
  connect(tow.TAir, Twb) annotation (Line(points={{-14,4},{-58,4},{-58,80},{
          -118,80}}, color={0,0,127}));
  connect(Tref, tow.T_CWS_in) annotation (Line(points={{-120,40},{-68,40},{-68,
          8},{-14,8}}, color={0,0,127}));
  connect(CWR, tow.port_a) annotation (Line(points={{-107,-1},{-59.5,-1},{-59.5,
          0},{-12,0}}, color={0,127,255}));
  annotation (Diagram(graphics),
                       Icon(graphics={
        Polygon(
          points={{-80,60},{80,60},{40,-80},{-40,-80},{-80,60}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,72},{0,62}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,72},{80,62}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,100},{-60,20}},
          color={0,0,255},
          pattern=LinePattern.Dot,
          arrow={Arrow.Filled,Arrow.None}),
        Rectangle(
          extent={{-100,6},{100,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-84,0},{84,0}},
          color={255,0,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-20,100},{-20,20}},
          color={0,0,255},
          pattern=LinePattern.Dot,
          arrow={Arrow.Filled,Arrow.None}),
        Line(
          points={{20,100},{20,20}},
          color={0,0,255},
          pattern=LinePattern.Dot,
          arrow={Arrow.Filled,Arrow.None}),
        Line(
          points={{60,100},{60,20}},
          color={0,0,255},
          pattern=LinePattern.Dot,
          arrow={Arrow.Filled,Arrow.None}),
        Text(extent={{66,50},{116,36}}, textString=
                                          "P")}));
end Cooling_Tower2;
