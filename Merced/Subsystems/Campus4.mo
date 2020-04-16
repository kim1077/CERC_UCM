within Merced.Subsystems;
model Campus4
  Modelica_Fluid.Pipes.LumpedPipe pipe(
    redeclare package WallFriction =
        Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.NoFriction,
    diameter=24*0.0254,
    redeclare package Medium = Medium,
    T_start=(65 - 32)*5/9 + 273.15,
    initType=Modelica_Fluid.Types.Init.InitialValues,
    length=100)                        annotation (Placement(transformation(
          extent={{20,7},{36,-7}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(
        origin={28,-17},
        extent={{-5,-7},{5,7}},
        rotation=90)));
  Modelica.Blocks.Math.Gain gain(k=1.75e3)
    annotation (Placement(transformation(extent={{50,-72},{44,-64}}, rotation=0)));
  Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM(
    m_flow(start=150),
    dp(start=60*12*0.0254*995*9.81),
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    redeclare package Medium = Medium,
    dp_nominal=(80*12*0.0254)*9.81*995/2,
    m_flow_nominal=(3125*3.78*0.001/60)*995)
                        annotation (Placement(transformation(extent={{-3,-5},{8,
            5}}, rotation=0)));
  inner Modelica_Fluid.Ambient ambient annotation (Placement(transformation(
          extent={{-80,40},{-60,60}}, rotation=0)));
  Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM1(
    m_flow(start=150),
    dp(start=60*12*0.0254*995*9.81),
    frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
    redeclare package Medium = Medium,
    dp_nominal=80*12*0.0254*9.81*995/2,
    m_flow_nominal=(3125*3.78*0.001/60)*995)
                        annotation (Placement(transformation(extent={{43,-5},{
            54,5}}, rotation=0)));
  Components.BuildingLoad COB(
    timeSeriesLength=24*3600,
    tableName="LoadData",
    directoryName="J:\\work\\SEEDprojects\\Merced\\Loads2.mat")
    annotation (Placement(transformation(extent={{96,-62},{76,-42}}, rotation=0)));
  Components.BuildingLoad Library(
    timeSeriesLength=24*3600,
    tableName="LoadData",
    cols={3},
    directoryName="J:\\work\\SEEDprojects\\Merced\\Loads2.mat")
    annotation (Placement(transformation(extent={{96,-74},{76,-54}}, rotation=0)));
  Components.BuildingLoad SE(
    timeSeriesLength=24*3600,
    tableName="LoadData",
    cols={4},
    directoryName="J:\\work\\SEEDprojects\\Merced\\Loads2.mat")
    annotation (Placement(transformation(extent={{96,-88},{76,-68}}, rotation=0)));
  Modelica.Blocks.Math.Add3 add3_1(k3=+1)
                                   annotation (Placement(transformation(extent=
            {{64,-72},{56,-64}}, rotation=0)));
  Modelica.Blocks.Math.Gain Cp(k=4.3e3)
    annotation (Placement(transformation(extent={{-15,-49},{-9,-41}}, rotation=
            0)));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(
        origin={-1.5,-33},
        extent={{-5,4.5},{5,-4.5}},
        rotation=90)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=200,
    limitsAtInit=true,
    uMin=4)
    annotation (Placement(transformation(
        origin={-2,-17},
        extent={{-5,-4},{5,4}},
        rotation=90)));
  Modelica_Fluid.Interfaces.FluidPort_a CHWS(redeclare package Medium =
        Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-86,-10},{-66,10}}, rotation=
            0)));
  Modelica_Fluid.Interfaces.FluidPort_b CHWR(redeclare package Medium =
        Medium)
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{64,-10},{84,10}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow
    annotation (Placement(transformation(extent={{64,-54},{90,-26}}, rotation=0)));
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  Modelica.Blocks.Math.Add add(k1=-1, k2=+1)
    annotation (Placement(transformation(
        origin={-43,-23},
        extent={{-5,-5},{5,5}},
        rotation=270)));
  Modelica.Blocks.Sources.Constant T_CHWR(k=(65 - 32)*5/9 + 273.15)
    annotation (Placement(transformation(extent={{-72,-15},{-58,-5}}, rotation=
            0)));
  Modelica_Fluid.Sensors.Temperature T_CHWS(redeclare package Medium =
        Medium)    annotation (Placement(transformation(extent={{-46,-7},{-34,7}},
          rotation=0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=40, uMin=5)
    annotation (Placement(transformation(extent={{-34,-49},{-26,-41}}, rotation=
           0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(uMax=1e7, uMin=0.01*1e7)
    annotation (Placement(transformation(extent={{38,-71},{30,-64}}, rotation=0)));
equation
  connect(pipe.thermalPort, prescribedHeatFlow.port) annotation (Line(points={{
          28,-3.78},{28,-12}}, color={191,0,0}));
  connect(Library.q[1], add3_1.u2) annotation (Line(points={{75,-63.8},{70.5,
          -63.8},{70.5,-68},{64.8,-68}}, color={0,0,127}));
  connect(COB.q[1], add3_1.u1) annotation (Line(points={{75,-51.8},{75,-59.9},{
          64.8,-59.9},{64.8,-64.8}}, color={0,0,127}));
  connect(SE.q[1], add3_1.u3) annotation (Line(points={{75,-77.8},{75,-75.9},{
          64.8,-75.9},{64.8,-71.2}}, color={0,0,127}));
  connect(add3_1.y, gain.u) annotation (Line(points={{55.6,-68},{50.6,-68}},
        color={0,0,127}));
  connect(division.y, limiter.u) annotation (Line(points={{-1.5,-27.5},{-1.5,
          -23.75},{-2,-23.75},{-2,-23}}, color={0,0,127}));
  connect(limiter.y, m_flow) annotation (Line(points={{-2,-11.5},{58,-11.5},{58,
          -40},{77,-40}}, color={0,0,127}));
  connect(fixedResistanceDpM.port_b, pipe.port_a) annotation (Line(points={{8,0},
          {14,0},{14,-8.88178e-16},{20,-8.88178e-16}}, color={0,127,255}));
  connect(pipe.port_b, fixedResistanceDpM1.port_a) annotation (Line(points={{36,
          -8.88178e-16},{40,-8.88178e-16},{40,0},{43,0}}, color={0,127,255}));
  connect(T_CHWS.port_b, fixedResistanceDpM.port_a) annotation (Line(points={{
          -34,8.88178e-16},{-8,8.88178e-16},{-8,0},{-3,0}}, color={0,127,255}));
  connect(T_CHWS.port_a, CHWS) annotation (Line(points={{-46,8.88178e-16},{-64,
          8.88178e-16},{-64,0},{-76,0}}, color={0,127,255}));
  connect(fixedResistanceDpM1.port_b, CHWR)
    annotation (Line(points={{54,0},{74,0}}, color={0,127,255}));
  connect(T_CHWR.y, add.u2) annotation (Line(points={{-57.3,-10},{-46,-10},{-46,
          -17}}, color={0,0,127}));
  connect(T_CHWS.T, add.u1) annotation (Line(points={{-40,-7.7},{-40,-17}},
        color={0,0,127}));
  connect(limiter1.y, Cp.u) annotation (Line(points={{-25.6,-45},{-15.6,-45}},
        color={0,0,127}));
  connect(limiter1.u, add.y) annotation (Line(points={{-34.8,-45},{-34.8,-45.5},
          {-43,-45.5},{-43,-28.5}}, color={0,0,127}));
  connect(Cp.y, division.u2) annotation (Line(points={{-8.7,-45},{-8.7,-44.5},{
          -4.2,-44.5},{-4.2,-39}}, color={0,0,127}));
  connect(limiter2.u, gain.y) annotation (Line(points={{38.8,-67.5},{42.4,-67.5},
          {42.4,-68},{43.7,-68}}, color={0,0,127}));
  connect(limiter2.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{29.6,
          -67.5},{29.6,-44.75},{28,-44.75},{28,-22}}, color={0,0,127}));
  connect(limiter2.y, division.u1) annotation (Line(points={{29.6,-67.5},{1.8,
          -67.5},{1.8,-39},{1.2,-39}}, color={0,0,127}));
  connect(CHWS, CHWS)
    annotation (Line(points={{-76,0},{-76,0}}, color={0,127,255}));
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram(graphics),
    Icon(graphics={
        Text(
          extent={{-56,76},{42,28}},
          lineColor={0,0,255},
          textString=
               "%name"),
        Rectangle(
          extent={{-20,0},{60,-40}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-40},{-60,-20},{-60,20},{-20,0},{-20,-40}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,20},{20,20},{60,0},{-20,0},{-60,20}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-16,-4},{-16,-28},{6,-28},{6,-4},{-16,-4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={170,213,255}),
        Polygon(
          points={{-33,3},{-33,-21},{-23,-26},{-23,-2},{-33,3}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{10,-4},{10,-28},{32,-28},{32,-4},{10,-4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={170,213,255}),
        Polygon(
          points={{35,-4},{35,-28},{57,-28},{57,-4},{35,-4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={170,213,255}),
        Polygon(
          points={{-46,9},{-46,-15},{-36,-20},{-36,4},{-46,9}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-58,15},{-58,-9},{-48,-14},{-48,10},{-58,15}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}));
end Campus4;
