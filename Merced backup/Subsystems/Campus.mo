model Campus 
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Fluid" 
                           annotation(choicesAllMatching, Dialog(tab="General",group="CW Fluid"));
  
  annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
      Diagram,
    Icon(          Text(
        extent=[-52,114; 46,66],
        style(color=3, rgbcolor={0,0,255}),
        string="%name"),
      Bitmap(extent=[-98,118; 102,-100], name="campus.JPG"),
      Line(points=[-38,-10; 88,64], style(
          color=3,
          rgbcolor={0,0,255},
          arrow=1))));
  Modelica_Fluid.Interfaces.FluidPort_a CHWS(redeclare package Medium = 
        Medium) 
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-120,-32; -100,-12]);
  Modelica_Fluid.Interfaces.FluidPort_b CHWR(redeclare package Medium = 
        Medium) 
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (extent=[102,50; 122,70]);
  Modelica_Fluid.Pipes.LumpedPipe pipe(
    redeclare package WallFriction = 
        Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.NoFriction,
    diameter=24*0.0254,
    redeclare package Medium = Medium,
    length=1)                          annotation (extent=[-4,-85; 12,-71]);
  Modelica.Thermal.HeatTransfer.PrescribedHeatFlow prescribedHeatFlow 
    annotation (extent=[-5,-50; 9,-60], rotation=90);
  Modelica_Fluid.PressureLosses.StaticHead CHW_Pipe(
    flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional,
    redeclare package Medium = Medium,
    height_ab=1) 
    annotation (extent=[-25,-72; -11,-84],
                                      rotation=0);
  inner Modelica_Fluid.Ambient ambient annotation (extent=[-60,0; -40,20]);
  Modelica.Blocks.Math.Gain gain(k=140*4.2e3*(65 - 39)*5/9) 
    annotation (extent=[-12,-24; -6,-16]);
  Modelica.Blocks.Sources.Pulse pulse1(
    period=86400,
    startTime=86400/2,
    amplitude=0.9,
    offset=0.1)        annotation (extent=[-28,-23; -18,-17]);
equation 
  connect(CHWS, CHWS) 
                    annotation (points=[-110,-22; -110,-22],
                                                           style(color=69,
        rgbcolor={0,127,255}));
  connect(pipe.port_a, CHW_Pipe.port_b)  annotation (points=[-4,-78; -11,
        -78], style(color=69, rgbcolor={0,127,255}));
  connect(CHW_Pipe.port_a, CHWS)  annotation (points=[-25,-78; -68.5,-78;
        -68.5,-22; -110,-22], style(color=69, rgbcolor={0,127,255}));
  connect(pipe.port_b, CHWR) annotation (points=[12,-78; 61,-78; 61,60; 112,
        60], style(color=69, rgbcolor={0,127,255}));
  connect(pipe.thermalPort, prescribedHeatFlow.port) annotation (points=[4,-74.22;
        4,-60; 2,-60],         style(color=42, rgbcolor={191,0,0}));
  connect(CHWR, CHWR) annotation (points=[112,60; 107,60; 107,60; 112,60],
      style(
      color=69,
      rgbcolor={0,127,255},
      arrow=1));
  connect(pulse1.y, gain.u) annotation (points=[-17.5,-20; -12.6,-20],
      style(color=74, rgbcolor={0,0,127}));
  connect(gain.y, prescribedHeatFlow.Q_flow) annotation (points=[-5.7,-20;
        -2,-20; -2,-50; 2,-50], style(color=74, rgbcolor={0,0,127}));
end Campus;
