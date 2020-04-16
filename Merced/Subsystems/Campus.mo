within Merced.Subsystems;
model Campus
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
    diameter=24*0.0254,
    redeclare package Medium = Medium,
    length=1)                          annotation (Placement(transformation(
          extent={{-4,-85},{12,-71}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(
        origin={2,-55},
        extent={{5,-7},{-5,7}},
        rotation=90)));
  Modelica_Fluid.PressureLosses.StaticHead CHW_Pipe(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    redeclare package Medium = Medium,
    height_ab=1)
    annotation (Placement(transformation(extent={{-25,-72},{-11,-84}}, rotation=
           0)));
  inner Modelica_Fluid.Ambient ambient annotation (Placement(transformation(
          extent={{-60,0},{-40,20}}, rotation=0)));
  Modelica.Blocks.Math.Gain gain(k=140*4.2e3*(65 - 39)*5/9)
    annotation (Placement(transformation(extent={{-12,-24},{-6,-16}}, rotation=
            0)));
  Modelica.Blocks.Sources.Pulse pulse1(
    period=86400,
    startTime=86400/2,
    amplitude=0.9,
    offset=0.1)        annotation (Placement(transformation(extent={{-28,-23},{
            -18,-17}}, rotation=0)));
equation
  connect(CHWS, CHWS)
                    annotation (Line(points={{-110,-22},{-110,-22}}, color={0,
          127,255}));
  connect(pipe.port_a, CHW_Pipe.port_b)  annotation (Line(points={{-4,-78},{-11,
          -78}}, color={0,127,255}));
  connect(CHW_Pipe.port_a, CHWS)  annotation (Line(points={{-25,-78},{-68.5,-78},
          {-68.5,-22},{-110,-22}}, color={0,127,255}));
  connect(pipe.port_b, CHWR) annotation (Line(points={{12,-78},{61,-78},{61,60},
          {112,60}}, color={0,127,255}));
  connect(pipe.thermalPort, prescribedHeatFlow.port) annotation (Line(points={{
          4,-74.22},{4,-60},{2,-60}}, color={191,0,0}));
  connect(CHWR, CHWR) annotation (Line(
      points={{112,60},{107,60},{107,60},{112,60}},
      color={0,127,255},
      arrow={Arrow.None,Arrow.Filled}));
  connect(pulse1.y, gain.u) annotation (Line(points={{-17.5,-20},{-12.6,-20}},
        color={0,0,127}));
  connect(gain.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-5.7,-20},
          {-2,-20},{-2,-50},{2,-50}}, color={0,0,127}));
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
end Campus;
