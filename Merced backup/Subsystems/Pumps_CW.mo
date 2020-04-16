model Pumps_CW 
 replaceable package MediumCW = Modelica.Media.Interfaces.PartialMedium 
    "CW Fluid"              annotation(choicesAllMatching, Dialog(tab="General",group="CW Fluid"));
  annotation (uses(Modelica_Fluid(version="0.900")),
      Diagram,
    Icon(
      Rectangle(extent=[-92,22; -54,14],style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Ellipse(extent=[-60,58; 60,-62],   style(gradient=3)),
      Polygon(points=[-40,-46; -60,-82; 60,-82; 40,-46; -40,-46],
          style(pattern=0, fillColor=74)),
      Rectangle(extent=[56,22; 94,14],style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Polygon(points=[-32,30; -32,-30; 46,-2; -32,30],    style(
          pattern=0,
          gradient=2,
          fillColor=7)),
      Text(
        extent=[-44,90; 40,52],
        style(color=3, rgbcolor={0,0,255}),
        string="%name"),
      Text(extent=[16,98; 44,78], string="N")));
  Modelica_Fluid.Interfaces.FluidPort_a CWe(redeclare package Medium = 
        MediumCW) 
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-124,10; -104,30]);
  Modelica_Fluid.Interfaces.FluidPort_b CWl(redeclare package Medium = 
        MediumCW) 
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (extent=[102,10; 122,30]);
public 
   Modelica.Blocks.Interfaces.RealInput N_in(redeclare type SignalType = 
        Modelica.SIunits.AngularVelocity) "Prescribed rotational speed" 
    annotation (extent=[40,80; 60,100],    rotation=-90);
  parameter Modelica.SIunits.AngularVelocity N_const = 1180 
    "constant angular speed";
  Components.PrescribedSpeed_Pump pump12(
    qNorMin_flow=0.106858248388454,
    b={-0.1196,5.6074,-8.4305},
    a=9.81*995*{24.5962937908532,2.18716906353477,-89.7833035568017},
    qNorMax_flow=0.399530088717547,
    redeclare package Medium = MediumCW,
    scaQ_flow=2) "Bell& Gossett HSCS 14x16x17 E" 
                                annotation (extent=[-40,10; -20,30]);
equation 
  if cardinality(N_in)==0 then
  // set inputs from input or parameter values
    N_in = N_const "Rotational speed provided by parameter";
  end if;
  connect(pump12.port_b, CWl) annotation (points=[-20,20; 112,20], style(
        color=69, rgbcolor={0,127,255}));
  connect(pump12.port_a, CWe) annotation (points=[-40,20; -114,20], style(
        color=69, rgbcolor={0,127,255}));
  connect(N_in, pump12.N_in) annotation (points=[50,90; 12,90; 12,29; -27,
        29], style(color=74, rgbcolor={0,0,127}));
end Pumps_CW;
