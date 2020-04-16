within Merced.Subsystems;
model Cooling_Tower2w
Components.YorkCalc_PrescribedTemp tow1(
    TAirInWB0=273.15 + (68 - 32)*5/9,
    TApp0=(75 - 68)*5/9,
    TRan0=(85 - 75)*5/9,
    redeclare package Medium = Medium,
    mWat0_flow=5*(1735*3.785/60),
    PFan0=5*40*745.7)             annotation (Placement(transformation(extent={
            {-12,-10},{8,10}}, rotation=0)));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  //replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  Modelica_Fluid.PressureLosses.PressureDropPipe Pipe_CT(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    diameter=0.05,
    redeclare package Medium = Medium,
    length=1,
    from_dp=false,
    dp_nominal=1*995*9.81,
    m_flow_nominal=(2*3500*3.785*0.001/60)*995,
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar)
    annotation (Placement(transformation(extent={{22,-6},{36,6}}, rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_a CWR(redeclare package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-122,-10},{-102,10}},
          rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b CWS(redeclare package Medium = Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{102,-10},{122,10}}, rotation=
            0)));
  Modelica.Blocks.Routing.DeMultiplex3 deMultiplex3_1
    annotation (Placement(transformation(extent={{0,70},{20,90}}, rotation=0)));
  Buildings.Utilities.Psychrometrics.WetBulbTemperature wetBulTem2(
      redeclare package Medium = Modelica.Media.Air.MoistAir)
    "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{30,68},{50,88}}, rotation=0)));
  Modelica.Blocks.Routing.ExtractSignal extractSignal(       nout=3,
    extract=1:3,
    nin=Nw)
    annotation (Placement(transformation(extent={{-42,70},{-22,90}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput w[Nw] "weather data"
    annotation (Placement(transformation(extent={{-138,60},{-98,100}}, rotation=
           0)));
  parameter Integer Nw=4 "dimension of weather bus";
  Modelica.Blocks.Interfaces.RealInput Tref "CWS temperature set point"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}, rotation=
           0)));
equation
  connect(Pipe_CT.port_a, tow1.port_b)
    annotation (Line(points={{22,0},{8,0}}, color={0,127,255}));
  connect(tow1.port_a, CWR) annotation (Line(points={{-12,0},{-112,0}}, color={
          0,127,255}));
  connect(Pipe_CT.port_b, CWS)  annotation (Line(points={{36,0},{112,0}}, color=
         {0,127,255}));
  connect(wetBulTem2.TDryBul, deMultiplex3_1.y1[1]) annotation (Line(points={{
          31,86},{25,86},{25,87},{21,87}}, color={0,0,255}));
  connect(wetBulTem2.p, deMultiplex3_1.y3[1]) annotation (Line(points={{31,78},
          {26,78},{26,73},{21,73}}, color={0,0,255}));
  connect(deMultiplex3_1.y2[1], wetBulTem2.phi) annotation (Line(points={{21,80},
          {34,80},{34,85},{49,85}}, color={0,0,127}));
  connect(wetBulTem2.TWetBul, tow1.TAir) annotation (Line(points={{49,78},{58,
          78},{58,58},{-22,58},{-22,4},{-14,4}}, color={0,0,255}));
  connect(extractSignal.y, deMultiplex3_1.u)
    annotation (Line(points={{-21,80},{-2,80}}, color={0,0,127}));
  connect(extractSignal.u, w)
    annotation (Line(points={{-44,80},{-118,80}}, color={0,0,127}));
  connect(tow1.T_CWS_in,Tref) annotation (Line(points={{-14,8},{-57,8},{-57,40},
          {-120,40}}, color={0,0,127}));
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
          arrow={Arrow.Filled,Arrow.None})}));
end Cooling_Tower2w;
