within Merced.CWP;
model Test_ChilledPlant
  package MediumCW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  package MediumCHW=Modelica.Media.Water.ConstantPropertyLiquidWater;
  output Modelica.Blocks.Sources.Constant mdot(k=2310/3750) "\\dot{m}"
                annotation (Placement(transformation(extent={{-36,34},{-24,40}},
          rotation=0)));
  output Modelica.Blocks.Sources.Constant T_CWS(k=(75 - 32)*5/9 + 273.15) "T_CWS"
                annotation (Placement(transformation(extent={{-36,44},{-22,50}},
          rotation=0)));
  ChilledPlant centralPlant            annotation (Placement(transformation(
          extent={{14,8},{62,54}}, rotation=0)));
  Modelica.Blocks.Routing.Multiplex4 multiplex2_1
    annotation (Placement(transformation(extent={{-12,21},{-6,48}}, rotation=0)));
  output Modelica.Blocks.Sources.Constant T_CHWS(k=(39 - 32)*5/9 + 273.15) "T_CHWS"
                annotation (Placement(transformation(extent={{-36,24},{-22,30}},
          rotation=0)));
  output Modelica.Blocks.Sources.Constant T_CHWR(k=(65 - 32)*5/9 + 273.15) "T_CHWR"
                annotation (Placement(transformation(extent={{-36,12},{-22,18}},
          rotation=0)));
  output Modelica.Blocks.Sources.Constant Twb(k=274)
                annotation (Placement(transformation(extent={{-36,58},{-22,64}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput P "power"
    annotation (Placement(transformation(extent={{100,35},{120,55}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput TCHWS "Tchws"
    annotation (Placement(transformation(extent={{100,21},{120,41}}, rotation=0)));
equation
  connect(multiplex2_1.y, centralPlant.u)
    annotation (Line(points={{-5.7,34.5},{8,34.5},{8,35.6},{16.4,35.6}}, color=
          {0,0,127}));
  connect(multiplex2_1.u4[1], T_CHWR.y)     annotation (Line(points={{-12.6,
          22.35},{-18.3,22.35},{-18.3,15},{-21.3,15}}, color={0,0,127}));
  connect(Twb.y, centralPlant.Twb) annotation (Line(points={{-21.3,61},{-1.65,
          61},{-1.65,46.18},{16.4,46.18}}, color={0,0,127}));
  connect(T_CWS.y, multiplex2_1.u1[1])      annotation (Line(points={{-21.3,47},
          {-17.65,47},{-17.65,46.65},{-12.6,46.65}}, color={0,0,127}));
  connect(mdot.y, multiplex2_1.u2[1])       annotation (Line(points={{-23.4,37},
          {-18.7,37},{-18.7,38.55},{-12.6,38.55}}, color={0,0,127}));
  connect(T_CHWS.y, multiplex2_1.u3[1])     annotation (Line(points={{-21.3,27},
          {-17.65,27},{-17.65,30.45},{-12.6,30.45}}, color={0,0,127}));
  connect(centralPlant.P, P) annotation (Line(points={{63.44,44.8},{82.72,44.8},
          {82.72,45},{110,45}}, color={0,0,127}));
  connect(centralPlant.y[1], TCHWS) annotation (Line(points={{63.44,34.45},{
          82.72,34.45},{82.72,31},{110,31}}, color={0,0,127}));
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram(graphics));
end Test_ChilledPlant;
