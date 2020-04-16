import "C:/Users/Administrator/Documents/Dymola/Buildings/package.mo";
import "C:/Users/Administrator/Documents/Dymola/Modelica_Fluid 1.0 Beta 2/package.mo";


package InverseModel 
  "Contains a simple inverse model of a building, along with a module used in calibration" 
  model GainsConverter 
    "Calculates the solar and internal loads of the building" 
    
    annotation (
      uses(Modelica(version="2.2.1")),
      Diagram,
      Icon(
        Rectangle(extent=[-100,100; 100,-100],
                                           style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Ellipse(extent=[24,76; 70,34], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0})),
        Line(points=[46,80; 46,92], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0},
            fillPattern=1)),
        Line(points=[58,78; 64,90], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0},
            fillPattern=1)),
        Line(points=[68,70; 80,78], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0},
            fillPattern=1)),
        Line(points=[74,54; 88,54], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0},
            fillPattern=1)),
        Line(points=[70,42; 84,32], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0},
            fillPattern=1)),
        Line(points=[62,34; 70,22], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0},
            fillPattern=1)),
        Line(points=[48,30; 48,16], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0},
            fillPattern=1)),
        Line(points=[38,32; 30,20], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0},
            fillPattern=1)),
        Line(points=[26,42; 12,32], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0},
            fillPattern=1)),
        Line(points=[22,54; 6,54], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0},
            fillPattern=1)),
        Line(points=[24,66; 12,74], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0},
            fillPattern=1)),
        Line(points=[34,76; 26,88], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=6,
            rgbfillColor={255,255,0},
            fillPattern=1)),
        Ellipse(extent=[40,-28; 54,-42], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Polygon(points=[32,-44; 62,-44; 48,-78; 32,-44], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Rectangle(extent=[42,-62; 54,-88], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Text(
          extent=[-90,82; -28,58],
          style(color=3, rgbcolor={0,0,255}),
          string="CloudCover"),
        Text(
          extent=[-88,40; -28,10],
          style(color=3, rgbcolor={0,0,255}),
          string="DayOfYear"),
        Text(
          extent=[-86,-56; -28,-88],
          style(color=3, rgbcolor={0,0,255}),
          string="TimeOfDay"),
        Text(
          extent=[-86,-6; -26,-36],
          style(color=3, rgbcolor={0,0,255}),
          string="DayOfWeek")));
    Modelica.Blocks.Interfaces.RealInput TimeOfDay 
      annotation (extent=[-140,-92; -100,-52]);
    Modelica.Blocks.Interfaces.RealOutput Qsolar 
      annotation (extent=[102,40; 122,60]);
    Modelica.Blocks.Interfaces.RealOutput Qinternal 
      annotation (extent=[102,-60; 122,-40]);
    Modelica.Blocks.Interfaces.RealInput CloudCover 
      annotation (extent=[-140,52; -100,92]);
    Modelica.Blocks.Interfaces.RealInput DayOfYear 
      annotation (extent=[-140,4; -100,44]);
    
    parameter Real bldgSolarQperExtratHoriz=5004.69;
    parameter Real clearSky=1;
    parameter Real fewClouds=0.175;
    parameter Real skatteredClouds=0.6;
    parameter Real brokenClouds=0.4;
    parameter Real overcast=0.2;
    
    parameter Real occDayStart=6;
    parameter Real occDayEnd=20;
    parameter Real QintOccupied=113919.18;
    parameter Real QintOccupiedWeekend=0;
    parameter Real QintBaseline=29129.373;
    
    parameter Real latitude=37.302*3.1412/180;
    
    Real solarHour;
    Real solarDec;
    Real extraterrHorizSolar;
    Real cloudImpact;
    Real pi=3.1412;
    
    Modelica.Blocks.Interfaces.RealInput DayOfWeek 
      annotation (extent=[-140,-42; -100,-2]);
  equation 
    
    solarHour = (TimeOfDay - 12) * 15*pi/180;
    solarDec = (-23.45*pi/180) * cos( (2*pi/365) * (DayOfYear+10));
    extraterrHorizSolar = max( cos(solarHour) * cos(solarDec) * cos(latitude) + sin(solarDec) * sin(latitude),  0);
    cloudImpact = if (CloudCover <= -1) then 0 else if (CloudCover <= 0) then clearSky else if (CloudCover <= 1) then fewClouds else if (CloudCover <= 2) then skatteredClouds else if (CloudCover <=3) then brokenClouds else if (CloudCover <= 4) then overcast else 0;
    Qsolar = cloudImpact * extraterrHorizSolar * bldgSolarQperExtratHoriz;
    
    Qinternal = if ((TimeOfDay >= occDayStart) and (TimeOfDay <= occDayEnd)) then if (DayOfWeek > 5) then QintOccupiedWeekend else QintOccupied + QintBaseline else QintBaseline;
    
  end GainsConverter;
  
  model BuildingThermalLoad "A simple inverse model of a building" 
    
    annotation (
      uses(Modelica(version="2.2.1")),
      Diagram,
      Icon(
        Rectangle(extent=[-100,100; 100,-100],
                                           style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Ellipse(extent=[36,4; 44,-4], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=10,
            rgbfillColor={95,95,95})),
        Text(
          extent=[-52,-42; 100,-80],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=10,
            rgbfillColor={95,95,95},
            fillPattern=1),
          string="%name"),
        Ellipse(extent=[-36,42; -28,34], style(
            color=0,
            rgbcolor={0,0,0},
            fillColor=10,
            rgbfillColor={95,95,95})),
        Line(points=[-100,74; -86,68; -80,70; -80,60; -70,64; -70,54; -60,58;
              -60,48; -50,52; -50,42; -44,44; -36,40], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Line(points=[-28,36; -14,30; -8,32; -8,22; 2,26; 2,16; 12,20; 12,10; 22,
              14; 22,4; 28,6; 36,2], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Line(points=[-38,82; -24,76; -18,78; -18,68; -8,72; -8,62; 2,66; 2,56;
              12,60; 12,50; 18,52; 26,48], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Line(points=[-88,70; -68,96; -38,82], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Line(points=[26,48; 50,36; 32,4], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Line(points=[-100,8; -36,36], style(
            color=0,
            rgbcolor={0,0,0},
            pattern=3,
            thickness=2,
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Line(points=[-100,-62; 36,-2], style(
            color=0,
            rgbcolor={0,0,0},
            pattern=3,
            thickness=2,
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Line(points=[44,0; 100,10], style(
            color=0,
            rgbcolor={0,0,0},
            pattern=3,
            thickness=2,
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Line(points=[-32,34; -32,26], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Line(points=[-40,26; -24,26], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Line(points=[-36,24; -28,24], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1)),
        Line(points=[-34,22; -30,22], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillColor=0,
            rgbfillColor={0,0,0},
            fillPattern=1))));
    Modelica.Blocks.Interfaces.RealInput Tamb 
      annotation (extent=[-140,54; -100,94]);
    Modelica.Blocks.Interfaces.RealInput Qsolar 
      annotation (extent=[-140,-12; -100,28]);
    Modelica.Blocks.Interfaces.RealInput Qinternal 
      annotation (extent=[-140,-82; -100,-42]);
    Modelica.Blocks.Interfaces.RealOutput Qload 
      annotation (extent=[100,0; 120,20]);
    Modelica.Blocks.Interfaces.RealInput ZoneTempSP 
      annotation (extent=[-82,-110; -56,-84]);
    
    parameter Real UAeff_inst=9574.5;
    parameter Real Capacitance=496094.1;
    parameter Real UAc_outside=11487.5;
    parameter Real UAc_inside=8555;
    parameter Real timestepsPerHour=1;
    
    Real Tmass(start=21);
    
  equation 
    Qload = max(0, Qinternal + UAc_inside*(Tmass-ZoneTempSP) + UAeff_inst*(Tamb-ZoneTempSP));
    der(Tmass) = ( Qsolar + UAc_outside*(Tamb-Tmass) + UAc_inside*(ZoneTempSP-Tmass))   / (Capacitance*timestepsPerHour);
    
  end BuildingThermalLoad;
  
  model InverseModel1 
    "Converts time to Qsolar and Qinternal and uses the simple inverse building model to find Qload" 
    annotation (
      uses(Modelica(version="2.2.1")),
      Diagram,
      Icon(
        Rectangle(extent=[-100,100; 100,-100],
                                           style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Text(
          extent=[-74,-42; 104,-82],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="%name"),
        Text(
          extent=[-98,78; -54,98],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="Tamb"),
        Text(
          extent=[-98,-38; -56,-60],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="Time"),
        Text(
          extent=[104,50; 156,20],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="Qload"),
        Text(
          extent=[-100,-76; -62,-98],
          style(color=3, rgbcolor={0,0,255}),
          string="SP"),
        Line(points=[-62,-22; 90,-22], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=4,
            fillPattern=1)),
        Line(points=[-58,-32; -48,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-44,-32; -34,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-30,-32; -20,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-16,-32; -6,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-2,-32; 8,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[14,-32; 24,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[30,-32; 40,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[46,-32; 56,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[62,-32; 72,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[76,-32; 86,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-58,34; 18,86; 88,34], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=4,
            fillPattern=1)),
        Line(points=[-38,-22; -38,46], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillPattern=1)),
        Line(points=[70,-22; 70,46], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillPattern=1)),
        Text(
          extent=[24,16; 72,-24],
          style(color=0, rgbcolor={0,0,0}),
          string="I1"),
        Text(
          extent=[-96,68; -54,44],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="Cloud"),
        Text(
          extent=[-98,30; -62,8],
          style(color=3, rgbcolor={0,0,255}),
          string="DayY"),
        Text(
          extent=[-98,-4; -56,-26],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="DayW")));
    Modelica.Blocks.Interfaces.RealInput Tamb 
      annotation (extent=[-140,70; -100,110]);
    Modelica.Blocks.Interfaces.RealInput TimeOfDay 
      annotation (extent=[-140,-68; -100,-28]);
    Modelica.Blocks.Interfaces.RealOutput Qload 
      annotation (extent=[100,-2; 120,18]);
    InverseModel.BuildingThermalLoad Bldg1(UAeff_inst=7363.875) 
                            annotation (extent=[26,-6; 62,30]);
    InverseModel.GainsConverter Bldg1_daytimeConverter 
      annotation (extent=[-58,-32; -16,0]);
    Modelica.Blocks.Interfaces.RealInput SP annotation (extent=[-140,-110; -100,
          -68]);
    Modelica.Blocks.Interfaces.RealInput CloudCover 
      annotation (extent=[-140,36; -100,76]);
    Modelica.Blocks.Interfaces.RealInput DayOfYear 
      annotation (extent=[-140,0; -100,40]);
    Modelica.Blocks.Interfaces.RealInput DayOfWeek 
      annotation (extent=[-140,-34; -100,6]);
  equation 
    connect(Tamb, Bldg1.Tamb) annotation (points=[-120,90; -58,90; -58,25.32; 
          22.4,25.32],
                 style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=10,
        rgbfillColor={95,95,95},
        fillPattern=1));
    connect(Bldg1.Qload, Qload) annotation (points=[63.8,13.8; 92,13.8; 92,8;
          110,8],                                                 style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=10,
        rgbfillColor={95,95,95},
        fillPattern=1));
    connect(TimeOfDay, Bldg1_daytimeConverter.TimeOfDay) annotation (points=[-120,-48;
          -90,-48; -90,-27.52; -62.2,-27.52],style(
        color=74,
        rgbcolor={0,0,127},
        fillPattern=1));
    connect(Bldg1_daytimeConverter.Qsolar, Bldg1.Qsolar) annotation (points=[-13.48,
          -8; 0,-8; 0,13.44; 22.4,13.44],      style(
        color=74,
        rgbcolor={0,0,127},
        fillPattern=1));
    connect(Bldg1_daytimeConverter.Qinternal, Bldg1.Qinternal) annotation (points=[-13.48,
          -24; 8,-24; 8,-14; 22.4,-14; 22.4,0.84],     style(
        color=74,
        rgbcolor={0,0,127},
        fillPattern=1));
    connect(SP, Bldg1.ZoneTempSP) annotation (points=[-120,-89; -120,-66; 31.58,
          -66; 31.58,-5.46],
                       style(color=74, rgbcolor={0,0,127}));
    connect(CloudCover, Bldg1_daytimeConverter.CloudCover) annotation (points=[-120,56;
          -72,56; -72,-4.48; -62.2,-4.48],          style(color=74, rgbcolor={0,
            0,127}));
    connect(DayOfYear, Bldg1_daytimeConverter.DayOfYear) annotation (points=[-120,20;
          -80,20; -80,-12.16; -62.2,-12.16],        style(color=74, rgbcolor={0,
            0,127}));
    connect(DayOfWeek, Bldg1_daytimeConverter.DayOfWeek) annotation (points=[
          -120,-14; -92,-14; -92,-19.52; -62.2,-19.52], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
  end InverseModel1;
  
  model InverseModel_calibrator "Tests the inverse model with its wrapper" 
    InverseModel.InverseModel1 Bldg1 
      annotation (extent=[-22,40; 20,76]);
    annotation (uses(Modelica(version="2.2.1")), Diagram,
      experiment(StopTime=4392),
      experimentSetupOutput);
    Buildings.Utilities.Reports.Printer printer(fileName=
          "c:\\home\\inverseModel\\GenOptFiles\\modelOutput.txt",
      samplePeriod=1,
      configuration=3,
      nin=1) 
      annotation (extent=[52,-76; 72,-56]);
    Modelica.Blocks.Sources.CombiTimeTable realOuput(
      tableOnFile=true,
      tableName="realOutputData",
      fileName="C:\\home\\inverseModel\\realOutputData.txt",
      columns=2:2)                annotation (extent=[0,-8; 20,12]);
    Modelica.Blocks.Math.Add add(k1=-1) annotation (extent=[56,6; 68,18]);
    Modelica.Blocks.Math.Product product annotation (extent=[56,-16; 68,-4]);
    Modelica.Blocks.Continuous.Integrator integrator 
      annotation (extent=[56,-36; 68,-26]);
    Modelica.Blocks.Sources.CombiTimeTable realInput(
      tableOnFile=true,
      tableName="realInputData",
      fileName="C:\\home\\inverseModel\\realInputData.txt",
      columns=2:7) annotation (extent=[-84,50; -64,70]);
    Modelica.Blocks.Sources.SawTooth timeOfDay(amplitude=24, period=24) 
      annotation (extent=[-84,18; -64,38]);
  equation 
    connect(integrator.y, printer.x[1]) annotation (points=[68.6,-31; 72,-31;
          72,-48; 46,-48; 46,-66; 50,-66], style(color=74, rgbcolor={0,0,127}));
    connect(Bldg1.Qload, add.u1) annotation (points=[22.1,59.44; 50,59.44; 50,
          15.6; 54.8,15.6], style(color=74, rgbcolor={0,0,127}));
    connect(realOuput.y[1], add.u2) annotation (points=[21,2; 36,2; 36,8.4;
          54.8,8.4], style(color=74, rgbcolor={0,0,127}));
    connect(add.y, product.u1) annotation (points=[68.6,12; 72,12; 72,2; 50,2;
          50,-6.4; 54.8,-6.4], style(color=74, rgbcolor={0,0,127}));
    connect(add.y, product.u2) annotation (points=[68.6,12; 72,12; 72,2; 50,2;
          50,-13.6; 54.8,-13.6], style(color=74, rgbcolor={0,0,127}));
    connect(product.y, integrator.u) annotation (points=[68.6,-10; 72,-10; 72,
          -20; 50,-20; 50,-31; 54.8,-31], style(color=74, rgbcolor={0,0,127}));
    connect(realInput.y[4], Bldg1.Tamb) annotation (points=[-63,60; -46,60; -46,74.2;
          -26.2,74.2], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[5], Bldg1.CloudCover) annotation (points=[-63,60; -46,
          60; -46,68.08; -26.2,68.08], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[1], Bldg1.DayOfYear) annotation (points=[-63,60; -44,60;
          -44,61.6; -26.2,61.6], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[2], Bldg1.DayOfWeek) annotation (points=[-63,60; -44,60;
          -44,55.48; -26.2,55.48], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[6], Bldg1.SP) annotation (points=[-63,60; -46,60; -46,
          41.98; -26.2,41.98], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(timeOfDay.y, Bldg1.TimeOfDay) annotation (points=[-63,28; -46,28;
          -46,49.36; -26.2,49.36], style(color=74, rgbcolor={0,0,127}));
  end InverseModel_calibrator;
  annotation (uses(Modelica(version="2.2.1"), Modelica_Fluid(version=
            "1.0 Beta 2")));
  model RegressionModel1 
    "Uses a regression model to find Qload [W] given Tamb [C]" 
    
    annotation (
      uses(Modelica(version="2.2.1")),
      Diagram,
      Icon(
        Rectangle(extent=[-100,100; 100,-100],
                                           style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Text(
          extent=[-74,-42; 104,-82],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="%name"),
        Text(
          extent=[-96,60; -52,80],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="Tamb"),
        Text(
          extent=[104,50; 156,20],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="Qload"),
        Line(points=[-62,-22; 90,-22], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=4,
            fillPattern=1)),
        Line(points=[-58,-32; -48,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-44,-32; -34,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-30,-32; -20,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-16,-32; -6,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-2,-32; 8,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[14,-32; 24,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[30,-32; 40,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[46,-32; 56,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[62,-32; 72,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[76,-32; 86,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-58,34; 18,86; 88,34], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=4,
            fillPattern=1)),
        Line(points=[-38,-22; -38,46], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillPattern=1)),
        Line(points=[70,-22; 70,46], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillPattern=1)),
        Text(
          extent=[28,14; 70,-24],
          style(color=0, rgbcolor={0,0,0}),
          string="R1")));
    Modelica.Blocks.Interfaces.RealInput Tamb 
      annotation (extent=[-140,48; -100,88]);
    Modelica.Blocks.Interfaces.RealOutput Qload 
      annotation (extent=[100,-2; 120,18]);
    
    parameter Real Ycp=4.4248;
    parameter Real Xcp=13.303;
    parameter Real RS=10.1972;
    
  equation 
    Qload = Ycp + RS * (Tamb - Xcp);
    
  end RegressionModel1;
  
  model RegressionModel2 
    "Uses a regression model to find Qload [W] given Tamb [C] and TimeOfDay [hr]" 
    
    annotation (
      uses(Modelica(version="2.2.1")),
      Diagram,
      Icon(
        Rectangle(extent=[-100,100; 100,-100],
                                           style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})),
        Text(
          extent=[-74,-42; 104,-82],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="%name"),
        Text(
          extent=[-96,60; -52,80],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="Tamb"),
        Text(
          extent=[-98,8; -56,-14],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="Time"),
        Text(
          extent=[104,50; 156,20],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillPattern=1),
          string="Qload"),
        Line(points=[-62,-22; 90,-22], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=4,
            fillPattern=1)),
        Line(points=[-58,-32; -48,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-44,-32; -34,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-30,-32; -20,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-16,-32; -6,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-2,-32; 8,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[14,-32; 24,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[30,-32; 40,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[46,-32; 56,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[62,-32; 72,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[76,-32; 86,-22], style(
            color=0,
            rgbcolor={0,0,0},
            fillPattern=1)),
        Line(points=[-58,34; 18,86; 88,34], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=4,
            fillPattern=1)),
        Line(points=[-38,-22; -38,46], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillPattern=1)),
        Line(points=[70,-22; 70,46], style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2,
            fillPattern=1)),
        Text(
          extent=[28,14; 70,-24],
          style(color=0, rgbcolor={0,0,0}),
          string="R2")));
    Modelica.Blocks.Interfaces.RealInput Tamb 
      annotation (extent=[-140,48; -100,88]);
    Modelica.Blocks.Interfaces.RealOutput Qload 
      annotation (extent=[100,-2; 120,18]);
    
    parameter Real Ycp=4.4248;
    parameter Real Xcp=13.303;
    parameter Real RS=10.1972;
    parameter Real X2=10.01;
    
    Modelica.Blocks.Interfaces.RealInput TimeOfDay 
      annotation (extent=[-140,-24; -100,16]);
  equation 
    Qload = Ycp + RS * (Tamb - Xcp) + X2 * TimeOfDay;
    
  end RegressionModel2;
  
  model InverseModel_testerWithCoil "Tests the inverse model" 
    InverseModel.InverseModel1 Bldg1 
      annotation (extent=[-52,46; -10,82]);
    annotation (uses(Modelica(version="2.2.1")), Diagram,
      experiment(StopTime=7656),
      experimentSetupOutput);
    Buildings.Utilities.Reports.Printer printer(
      samplePeriod=1,
      configuration=1,
      fileName="c:\\home\\inverseModel\\modelOutput.txt",
      startTime=1,
      nin=2) 
      annotation (extent=[70,-90; 90,-70]);
    Modelica.Blocks.Sources.CombiTimeTable realInput(
      tableOnFile=true,
      tableName="realInputData",
      fileName="C:\\home\\inverseModel\\realInputData.txt",
      columns=2:7) annotation (extent=[-94,56; -74,76]);
    Modelica.Blocks.Sources.CombiTimeTable realOuput(
      tableOnFile=true,
      tableName="realOutputData",
      fileName="C:\\home\\inverseModel\\realOutputData.txt",
      columns=2:3)                annotation (extent=[-94,-90; -74,-70]);
    CoolingCoil coolingCoil(redeclare package Medium = 
          Modelica.Media.Water.ConstantPropertyLiquidWater) 
      annotation (extent=[6,28; 26,46]);
    Modelica_Fluid.Sources.PrescribedMassFlowRate_TX massFlowRate(redeclare 
        package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater) 
      annotation (extent=[-32,-14; -12,6]);
    Modelica_Fluid.Sources.PrescribedBoundary_pTX boundary_prescribed(T=293,
        redeclare package Medium = 
          Modelica.Media.Water.ConstantPropertyLiquidWater) 
      annotation (extent=[56,-14; 38,6]);
    Modelica.Blocks.Sources.Constant const2(k=101325) 
      annotation (extent=[86,-8; 68,12]);
    Modelica.Blocks.Sources.CombiTimeTable realWaterInput(
      tableOnFile=true,
      columns=2:3,
      tableName="realWaterInputData",
      fileName="C:\\home\\inverseModel\\realWaterInputData.txt") 
                                  annotation (extent=[-94,-14; -74,6]);
    Modelica.Blocks.Math.Add add annotation (extent=[-64,-34; -44,-14]);
    Modelica.Blocks.Sources.Constant const(k=273.15) 
      annotation (extent=[-94,-50; -74,-30]);
    Modelica.Blocks.Math.Max max annotation (extent=[-64,8; -44,28]);
    Modelica.Blocks.Sources.Constant const1(k=0.6) 
      annotation (extent=[-94,22; -74,42]);
  equation 
    connect(massFlowRate.port, coolingCoil.port_a) annotation (points=[-12,-4;
          -4,-4; -4,37; 6,37], style(
        color=69,
        rgbcolor={0,127,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(coolingCoil.port_b, boundary_prescribed.port) annotation (points=[
          26,37; 32,37; 32,-4; 38,-4], style(
        color=69,
        rgbcolor={0,127,255},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(const2.y, boundary_prescribed.p_in) annotation (points=[67.1,2;
          57.8,2], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(Bldg1.Qload, coolingCoil.load) annotation (points=[-7.9,65.44; 0,
          65.44; 0,43.84; 4,43.84], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(Bldg1.Qload, printer.x[1]) annotation (points=[-7.9,65.44; 94,65.44;
          94,-46; 60,-46; 60,-81; 68,-81], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realOuput.y[1], printer.x[2]) annotation (points=[-73,-80; -2.5,-80;
          -2.5,-79; 68,-79], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[4], Bldg1.Tamb) annotation (points=[-73,66; -66,66; -66,
          80.2; -56.2,80.2], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[5], Bldg1.CloudCover) annotation (points=[-73,66; -66,
          66; -66,74.08; -56.2,74.08], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[1], Bldg1.DayOfYear) annotation (points=[-73,66; -64,66;
          -64,67.6; -56.2,67.6], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[2], Bldg1.DayOfWeek) annotation (points=[-73,66; -64,66;
          -64,61.48; -56.2,61.48], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[3], Bldg1.TimeOfDay) annotation (points=[-73,66; -66,66;
          -66,55.36; -56.2,55.36], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[6], Bldg1.SP) annotation (points=[-73,66; -66,66; -66,
          47.98; -56.2,47.98], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realWaterInput.y[1], add.u1) annotation (points=[-73,-4; -70,-4;
          -70,-18; -66,-18], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(const.y, add.u2) annotation (points=[-73,-40; -70,-40; -70,-30; -66,
          -30], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(add.y, massFlowRate.T_in) annotation (points=[-43,-24; -40,-24; -40,
          -4; -34,-4], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(const1.y, max.u1) annotation (points=[-73,32; -70,32; -70,24; -66,
          24], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realWaterInput.y[2], max.u2) annotation (points=[-73,-4; -70,-4;
          -70,12; -66,12], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(max.y, massFlowRate.m_flow_in) annotation (points=[-43,18; -38,18;
          -38,2; -31.3,2], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
  end InverseModel_testerWithCoil;
  
  model CoolingCoil 
    "Simplified coil model for use with inverse building load model, equivalent to HeaterCoolerIdeal in building library, but different interface variable" 
    extends Buildings.Fluids.Interfaces.PartialStaticTwoPortHeatMassTransfer;
    extends Buildings.BaseClasses.BaseIcon;
    
    Modelica.Blocks.Interfaces.RealInput load 
      annotation (extent=[-140,56; -100,96]);
    annotation (Diagram, Icon(Rectangle(extent=[-100,100; 100,-100], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255})), Text(
          extent=[-56,-40; 58,-90],
          style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255},
            fillPattern=1),
          string="Coil")));
    
  equation 
    dp = 0;
    Q_flow = load;
    mXi_flow = zeros(Medium.nXi); // no mass added or removed (sensible heat only)  
  end CoolingCoil;
  
  model InverseModel_tester0 "Tests the inverse model" 
    InverseModel.InverseModel1 Bldg1 
      annotation (extent=[-52,46; -10,82]);
    annotation (uses(Modelica(version="2.2.1")), Diagram,
      experiment(StopTime=7656, Interval=1),
      experimentSetupOutput);
    Buildings.Utilities.Reports.Printer printer(
      configuration=1,
      fileName="c:\\home\\inverseModel\\modelOutput.txt",
      startTime=1,
      nin=2,
      samplePeriod=1) 
      annotation (extent=[70,-90; 90,-70]);
    Modelica.Blocks.Sources.CombiTimeTable realInput(
      tableOnFile=true,
      tableName="realInputData",
      fileName="C:\\home\\inverseModel\\realInputData.txt",
      columns=2:7) annotation (extent=[-94,62; -74,82]);
    Modelica.Blocks.Sources.CombiTimeTable realOuput(
      tableOnFile=true,
      tableName="realOutputData",
      fileName="C:\\home\\inverseModel\\realOutputData.txt",
      columns=2:3)                annotation (extent=[-94,-90; -74,-70]);
    Modelica.Blocks.Sources.SawTooth timeOfDay(amplitude=24, period=24) 
      annotation (extent=[-94,20; -74,40]);
  equation 
    connect(Bldg1.Qload, printer.x[1]) annotation (points=[-7.9,65.44; 94,65.44; 
          94,-46; 60,-46; 60,-81; 68,-81], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realOuput.y[1], printer.x[2]) annotation (points=[-73,-80; -2.5,-80;
          -2.5,-79; 68,-79], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[4], Bldg1.Tamb) annotation (points=[-73,72; -66,72; -66,
          80.2; -56.2,80.2], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[5], Bldg1.CloudCover) annotation (points=[-73,72; -66,
          72; -66,74.08; -56.2,74.08], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[1], Bldg1.DayOfYear) annotation (points=[-73,72; -64,72;
          -64,67.6; -56.2,67.6], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[2], Bldg1.DayOfWeek) annotation (points=[-73,72; -64,72;
          -64,61.48; -56.2,61.48], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[6], Bldg1.SP) annotation (points=[-73,72; -66,72; -66,
          47.98; -56.2,47.98], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(timeOfDay.y, Bldg1.TimeOfDay) annotation (points=[-73,30; -66,30;
          -66,55.36; -56.2,55.36], style(color=74, rgbcolor={0,0,127}));
  end InverseModel_tester0;
  
  model InverseModel_testerSecondsTimestep "Tests the inverse model" 
    InverseModel.InverseModel1 Bldg1 
      annotation (extent=[-52,46; -10,82]);
    annotation (uses(Modelica(version="2.2.1")), Diagram,
      experiment(StopTime=7656),
      experimentSetupOutput);
    Buildings.Utilities.Reports.Printer printer(
      configuration=1,
      fileName="c:\\home\\inverseModel\\modelOutput.txt",
      startTime=1,
      nin=2,
      samplePeriod=3600) 
      annotation (extent=[70,-90; 90,-70]);
    Modelica.Blocks.Sources.CombiTimeTable realInput(
      tableOnFile=true,
      tableName="realInputData",
      fileName="C:\\home\\inverseModel\\realInputData.txt",
      columns=2:7) annotation (extent=[-94,62; -74,82]);
    Modelica.Blocks.Sources.CombiTimeTable realOuput(
      tableOnFile=true,
      tableName="realOutputData",
      fileName="C:\\home\\inverseModel\\realOutputData.txt",
      columns=2:3)                annotation (extent=[-94,-90; -74,-70]);
    Modelica.Blocks.Sources.SawTooth timeOfDay(amplitude=24, period=86400) 
      annotation (extent=[-94,20; -74,40]);
  equation 
    connect(Bldg1.Qload, printer.x[1]) annotation (points=[-7.9,65.44; 94,65.44;
          94,-46; 60,-46; 60,-81; 68,-81], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realOuput.y[1], printer.x[2]) annotation (points=[-73,-80; -2.5,-80;
          -2.5,-79; 68,-79], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[4], Bldg1.Tamb) annotation (points=[-73,72; -66,72; -66,
          80.2; -56.2,80.2], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[5], Bldg1.CloudCover) annotation (points=[-73,72; -66,
          72; -66,74.08; -56.2,74.08], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[1], Bldg1.DayOfYear) annotation (points=[-73,72; -64,72;
          -64,67.6; -56.2,67.6], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[2], Bldg1.DayOfWeek) annotation (points=[-73,72; -64,72;
          -64,61.48; -56.2,61.48], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(realInput.y[6], Bldg1.SP) annotation (points=[-73,72; -66,72; -66,
          47.98; -56.2,47.98], style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255},
        fillPattern=1));
    connect(timeOfDay.y, Bldg1.TimeOfDay) annotation (points=[-73,30; -66,30;
          -66,55.36; -56.2,55.36], style(color=74, rgbcolor={0,0,127}));
  end InverseModel_testerSecondsTimestep;

  model Campus4_Link 
    
    annotation (uses(UTC(version="2"), Modelica_Fluid(version="0.900")),
        Diagram,
      Icon(          Text(
          extent=[-56,76; 42,28],
          style(color=3, rgbcolor={0,0,255}),
          string="%name"),
        Rectangle(extent=[-20,0; 60,-40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Polygon(points=[-20,-40; -60,-20; -60,20; -20,0; -20,-40], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Polygon(points=[-60,20; 20,20; 60,0; -20,0; -60,20], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=30,
            rgbfillColor={215,215,215},
            fillPattern=1)),
        Polygon(points=[-16,-4; -16,-28; 6,-28; 6,-4; -16,-4], style(
            color=3,
            rgbcolor={0,0,255},
            gradient=1,
            fillColor=68,
            rgbfillColor={170,213,255})),
        Polygon(points=[-33,3; -33,-21; -23,-26; -23,-2; -33,3], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=68,
            rgbfillColor={170,213,255},
            fillPattern=1)),
        Polygon(points=[10,-4; 10,-28; 32,-28; 32,-4; 10,-4], style(
            color=3,
            rgbcolor={0,0,255},
            gradient=1,
            fillColor=68,
            rgbfillColor={170,213,255})),
        Polygon(points=[35,-4; 35,-28; 57,-28; 57,-4; 35,-4], style(
            color=3,
            rgbcolor={0,0,255},
            gradient=1,
            fillColor=68,
            rgbfillColor={170,213,255})),
        Polygon(points=[-46,9; -46,-15; -36,-20; -36,4; -46,9], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=68,
            rgbfillColor={170,213,255},
            fillPattern=1)),
        Polygon(points=[-58,15; -58,-9; -48,-14; -48,10; -58,15], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=68,
            rgbfillColor={170,213,255},
            fillPattern=1))));
    Modelica_Fluid.Pipes.LumpedPipe pipe(
      redeclare package WallFriction = 
          Modelica_Fluid.PressureLosses.BaseClasses.WallFriction.NoFriction,
      diameter=24*0.0254,
      redeclare package Medium = Medium,
      T_start=(65 - 32)*5/9 + 273.15,
      initType=Modelica_Fluid.Types.Init.InitialValues,
      length=100)                        annotation (extent=[16,53; 32,39]);
    Modelica.Thermal.HeatTransfer.PrescribedHeatFlow prescribedHeatFlow 
      annotation (extent=[17,24; 31,34],  rotation=90);
    Modelica.Blocks.Math.Gain gain(k=1.75e3) 
      annotation (extent=[46,-26; 40,-18]);
    Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM(
      m_flow(start=150),
      dp(start=60*12*0.0254*995*9.81),
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
      redeclare package Medium = Medium,
      dp_nominal=(80*12*0.0254)*9.81*995/2,
      m_flow_nominal=(3125*3.78*0.001/60)*995) 
                          annotation (extent=[-7,41; 4,51]);
    inner Modelica_Fluid.Ambient ambient annotation (extent=[-84,72; -64,92]);
    Modelica_Fluid.PressureLosses.PressureDropPipe fixedResistanceDpM1(
      m_flow(start=150),
      dp(start=60*12*0.0254*995*9.81),
      frictionType=Modelica_Fluid.Types.FrictionTypes.ConstantLaminar,
      redeclare package Medium = Medium,
      dp_nominal=80*12*0.0254*9.81*995/2,
      m_flow_nominal=(3125*3.78*0.001/60)*995) 
                          annotation (extent=[39,41; 50,51]);
    
    Modelica.Blocks.Math.Add3 add3_1(k3=+1) 
                                     annotation (extent=[62,-26; 52,-16]);
    Modelica.Blocks.Math.Gain Cp(k=4.3e3) 
      annotation (extent=[-19,-3; -13,5],    rotation=0);
    Modelica.Blocks.Math.Division division 
      annotation (extent=[0,8; -9,18],       rotation=90);
    Modelica_Fluid.Interfaces.FluidPort_a CHWS(redeclare package Medium = 
          Medium) 
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (extent=[-90,36; -70,56]);
    Modelica_Fluid.Interfaces.FluidPort_b CHWR(redeclare package Medium = 
          Medium) 
      "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
      annotation (extent=[60,36; 80,56]);
    Modelica.Blocks.Interfaces.RealOutput m_flow 
      annotation (extent=[60,-8; 86,20]);
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
    Modelica.Blocks.Math.Add add(k1=-1, k2=+1) 
      annotation (extent=[-52,18; -42,28],   rotation=-90);
    Modelica.Blocks.Sources.Constant T_CHWR(k=(65 - 32)*5/9 + 273.15) 
      annotation (extent=[-76,31; -62,41]);
    Modelica_Fluid.Sensors.Temperature T_CHWS(redeclare package Medium = 
          Medium)    annotation (extent=[-50,39; -38,53]);
    Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=40, uMin=1) 
      annotation (extent=[-38,-3; -30,5],    rotation=0);
    Modelica.Blocks.Nonlinear.Limiter limiter2(uMax=1e7, uMin=0.01*1e7) 
      annotation (extent=[34,-25; 26,-18],   rotation=0);
    Modelica.Blocks.Math.Add3 add3_2(k3=+1) 
                                     annotation (extent=[82,-18; 70,-8]);
    InverseModel1 Sci(Bldg1_daytimeConverter(
        bldgSolarQperExtratHoriz=99922, 
        QintOccupied=116104, 
        QintOccupiedWeekend=411884, 
        QintBaseline=308350), Bldg1(
        UAeff_inst=10089, 
        Capacitance=623034, 
        UAc_outside=87893, 
        UAc_inside=99935, 
        timestepsPerHour=3600)) annotation (extent=[-42,-64; -22,-44]);
    InverseModel1 Lib(Bldg1_daytimeConverter(
        bldgSolarQperExtratHoriz=99637, 
        QintOccupied=63949, 
        QintOccupiedWeekend=121374, 
        QintBaseline=134888), Bldg1(
        UAeff_inst=10989, 
        Capacitance=560853, 
        UAc_outside=3053, 
        UAc_inside=647, 
        timestepsPerHour=3600)) annotation (extent=[-42,-94; -22,-74]);
    InverseModel1 COB(Bldg1_daytimeConverter(
        bldgSolarQperExtratHoriz=5076, 
        QintOccupied=127855, 
        QintBaseline=20769), Bldg1(
        UAeff_inst=8832, 
        Capacitance=641315, 
        UAc_outside=15088, 
        UAc_inside=10636, 
        timestepsPerHour=3600)) annotation (extent=[10,-64; 30,-44]);
    InverseModel1 Rec(Bldg1(
        UAeff_inst=10483, 
        Capacitance=694941, 
        UAc_outside=14381, 
        UAc_inside=10319, 
        timestepsPerHour=3600), Bldg1_daytimeConverter(
        bldgSolarQperExtratHoriz=5017, 
        QintOccupied=138886, 
        QintBaseline=15806)) annotation (extent=[10,-94; 30,-74]);
    InverseModel1 Sierra(Bldg1(
        UAeff_inst=2844, 
        Capacitance=495585, 
        UAc_outside=52973, 
        UAc_inside=5015, 
        timestepsPerHour=3600), Bldg1_daytimeConverter(
        bldgSolarQperExtratHoriz=77, 
        QintOccupied=14, 
        QintOccupiedWeekend=39104, 
        QintBaseline=47583)) annotation (extent=[60,-94; 80,-74]);
    Modelica.Blocks.Sources.Constant Cloud(k=0.2)
      annotation (extent=[-94,-28; -86,-20]);
    Modelica.Blocks.Sources.Constant dYear(k=187)
      annotation (extent=[-94,-44; -86,-36]);
    Modelica.Blocks.Sources.Constant dWeek(k=3)
      annotation (extent=[-94,-60; -86,-52]);
    Modelica.Blocks.Sources.Constant hour(k=15)
      annotation (extent=[-94,-76; -86,-68]);
    Modelica.Blocks.Sources.Constant Tset(k=21)
      annotation (extent=[-94,-92; -86,-84]);
    Modelica.Blocks.Sources.Constant Tamb(k=29)
      annotation (extent=[-94,-12; -86,-4]);
  equation 
    connect(pipe.thermalPort, prescribedHeatFlow.port) annotation (points=[24,42.22; 
          24,34],         style(color=42, rgbcolor={191,0,0}));
    connect(add3_1.y, gain.u) annotation (points=[51.5,-21; 50,-21; 50,-22; 
          46.6,-22],                                                   style(
          color=74, rgbcolor={0,0,127}));
    connect(fixedResistanceDpM.port_b, pipe.port_a) annotation (points=[4,46; 16,
          46],                                       style(color=69, rgbcolor=
           {0,127,255}));
    connect(pipe.port_b, fixedResistanceDpM1.port_a) annotation (points=[32,46; 
          39,46],                                       style(color=69,
          rgbcolor={0,127,255}));
    connect(T_CHWS.port_b, fixedResistanceDpM.port_a) annotation (points=[-38,46; 
          -7,46],                                     style(color=69, rgbcolor={0,
            127,255}));
    connect(T_CHWS.port_a, CHWS) annotation (points=[-50,46; -80,46],
                                        style(color=69, rgbcolor={0,127,255}));
    connect(fixedResistanceDpM1.port_b, CHWR) 
      annotation (points=[50,46; 70,46],style(color=69, rgbcolor={0,127,255}));
    connect(T_CHWR.y, add.u2) annotation (points=[-61.3,36; -50,36; -50,29],
        style(color=74, rgbcolor={0,0,127}));
    connect(T_CHWS.T, add.u1) annotation (points=[-44,38.3; -44,29],  style(color=
           74, rgbcolor={0,0,127}));
    connect(limiter1.y, Cp.u) annotation (points=[-29.6,1; -19.6,1],     style(
          color=74, rgbcolor={0,0,127}));
    connect(limiter1.u, add.y) annotation (points=[-38.8,1; -38.8,0.5; -47,0.5; 
          -47,17.5],         style(color=74, rgbcolor={0,0,127}));
    connect(Cp.y, division.u2) annotation (points=[-12.7,1; -12.7,1.5; -7.2,1.5; 
          -7.2,7],          style(color=74, rgbcolor={0,0,127}));
    connect(limiter2.u, gain.y) annotation (points=[34.8,-21.5; 38.4,-21.5; 
          38.4,-22; 39.7,-22],
                          style(color=74, rgbcolor={0,0,127}));
    connect(limiter2.y, prescribedHeatFlow.Q_flow) annotation (points=[25.6,
          -21.5; 25.6,1.25; 24,1.25; 24,24],
                                           style(color=74, rgbcolor={0,0,127}));
    connect(limiter2.y, division.u1) annotation (points=[25.6,-21.5; -2.2,-21.5; 
          -2.2,7; -1.8,7],   style(color=74, rgbcolor={0,0,127}));
    connect(CHWS, CHWS) 
      annotation (points=[-80,46; -80,46],
                                         style(color=69, rgbcolor={0,127,255}));
    connect(division.y, m_flow) annotation (points=[-4.5,18.5; -4,34; 34,34; 34,
          6; 73,6],style(color=74, rgbcolor={0,0,127}));
    connect(Sci.Qload, add3_1.u3) annotation (points=[-21,-53.2; -14,-53.2; -14,
          -36; 63,-36; 63,-25], style(color=74, rgbcolor={0,0,127}));
    connect(COB.Qload, add3_1.u2) annotation (points=[31,-53.2; 68,-53.2; 68,
          -21; 63,-21], style(color=74, rgbcolor={0,0,127}));
    connect(add3_2.y, add3_1.u1) annotation (points=[69.4,-13; 68,-13; 68,-17; 
          63,-17], style(color=74, rgbcolor={0,0,127}));
    connect(Rec.Qload, add3_2.u2) annotation (points=[31,-83.2; 36,-83.2; 36,
          -64; 90,-64; 90,-13; 83.2,-13], style(color=74, rgbcolor={0,0,127}));
    connect(Lib.Qload, add3_2.u3) annotation (points=[-21,-83.2; -12,-83.2; -12,
          -70; 88,-70; 88,-17; 83.2,-17], style(color=74, rgbcolor={0,0,127}));
    connect(Sierra.Qload, add3_2.u1) annotation (points=[81,-83.2; 94,-83.2; 94,
          -9; 83.2,-9], style(color=74, rgbcolor={0,0,127}));
    connect(Tamb.y, Sci.Tamb) annotation (points=[-85.6,-8; -58,-8; -58,-45; 
          -44,-45], style(color=74, rgbcolor={0,0,127}));
    connect(Tamb.y, Lib.Tamb) annotation (points=[-85.6,-8; -58,-8; -58,-75; 
          -44,-75], style(color=74, rgbcolor={0,0,127}));
    connect(Tamb.y, COB.Tamb) annotation (points=[-85.6,-8; -58,-8; -58,-68; -2,
          -68; -2,-45; 8,-45], style(color=74, rgbcolor={0,0,127}));
    connect(Tamb.y, Rec.Tamb) annotation (points=[-85.6,-8; -58,-8; -58,-68; -2,
          -68; -2,-75; 8,-75], style(color=74, rgbcolor={0,0,127}));
    connect(Tamb.y, Sierra.Tamb) annotation (points=[-85.6,-8; -58,-8; -58,-68; 
          50,-68; 50,-75; 58,-75], style(color=74, rgbcolor={0,0,127}));
    connect(Cloud.y, Sci.CloudCover) annotation (points=[-85.6,-24; -60,-24; 
          -60,-48.4; -44,-48.4], style(color=74, rgbcolor={0,0,127}));
    connect(Cloud.y, Lib.CloudCover) annotation (points=[-85.6,-24; -60,-24; 
          -60,-78.4; -44,-78.4], style(color=74, rgbcolor={0,0,127}));
    connect(Cloud.y, COB.CloudCover) annotation (points=[-85.6,-24; -60,-24; 
          -60,-68; 0,-68; 0,-48.4; 8,-48.4], style(color=74, rgbcolor={0,0,127}));
    connect(Cloud.y, Rec.CloudCover) annotation (points=[-85.6,-24; -60,-24; 
          -60,-68; 0,-68; 0,-78.4; 8,-78.4], style(color=74, rgbcolor={0,0,127}));
    connect(Cloud.y, Sierra.CloudCover) annotation (points=[-85.6,-24; -60,-24; 
          -60,-68; 48,-68; 48,-78.4; 58,-78.4], style(color=74, rgbcolor={0,0,
            127}));
    connect(dYear.y, Sci.DayOfYear) annotation (points=[-85.6,-40; -62,-40; -62,
          -52; -44,-52], style(color=74, rgbcolor={0,0,127}));
    connect(dYear.y, Lib.DayOfYear) annotation (points=[-85.6,-40; -62,-40; -62,
          -82; -44,-82], style(color=74, rgbcolor={0,0,127}));
    connect(dYear.y, COB.DayOfYear) annotation (points=[-85.6,-40; -62,-40; -62,
          -68; 2,-68; 2,-52; 8,-52], style(color=74, rgbcolor={0,0,127}));
    connect(dYear.y, Rec.DayOfYear) annotation (points=[-85.6,-40; -62,-40; -62,
          -68; 2,-68; 2,-82; 8,-82], style(color=74, rgbcolor={0,0,127}));
    connect(dYear.y, Sierra.DayOfYear) annotation (points=[-85.6,-40; -62,-40; 
          -62,-68; 46,-68; 46,-82; 58,-82], style(color=74, rgbcolor={0,0,127}));
    connect(dWeek.y, Sci.DayOfWeek) annotation (points=[-85.6,-56; -64.8,-56; 
          -64.8,-55.4; -44,-55.4], style(color=74, rgbcolor={0,0,127}));
    connect(dWeek.y, Lib.DayOfWeek) annotation (points=[-85.6,-56; -64,-56; -64,
          -85.4; -44,-85.4], style(color=74, rgbcolor={0,0,127}));
    connect(dWeek.y, COB.DayOfWeek) annotation (points=[-85.6,-56; -64,-56; -64,
          -68; -4,-68; -4,-55.4; 8,-55.4], style(color=74, rgbcolor={0,0,127}));
    connect(dWeek.y, Rec.DayOfWeek) annotation (points=[-85.6,-56; -64,-56; -64,
          -68; -4,-68; -4,-85.4; 8,-85.4], style(color=74, rgbcolor={0,0,127}));
    connect(dWeek.y, Sierra.DayOfWeek) annotation (points=[-85.6,-56; -64,-56; 
          -64,-68; 44,-68; 44,-85.4; 58,-85.4], style(color=74, rgbcolor={0,0,
            127}));
    connect(hour.y, Sci.TimeOfDay) annotation (points=[-85.6,-72; -66,-72; -66,
          -58.8; -44,-58.8], style(color=74, rgbcolor={0,0,127}));
    connect(hour.y, Lib.TimeOfDay) annotation (points=[-85.6,-72; -66,-72; -66,
          -88.8; -44,-88.8], style(color=74, rgbcolor={0,0,127}));
    connect(hour.y, COB.TimeOfDay) annotation (points=[-85.6,-72; -66,-72; -66,
          -68; -6,-68; -6,-58.8; 8,-58.8], style(color=74, rgbcolor={0,0,127}));
    connect(hour.y, Rec.TimeOfDay) annotation (points=[-85.6,-72; -66,-72; -66,
          -68; -6,-68; -6,-88.8; 8,-88.8], style(color=74, rgbcolor={0,0,127}));
    connect(hour.y, Sierra.TimeOfDay) annotation (points=[-85.6,-72; -66,-72; 
          -66,-68; 42,-68; 42,-88.8; 58,-88.8], style(color=74, rgbcolor={0,0,
            127}));
    connect(Tset.y, Sci.SP) annotation (points=[-85.6,-88; -70,-88; -70,-62.9; 
          -44,-62.9], style(color=74, rgbcolor={0,0,127}));
    connect(Tset.y, Lib.SP) annotation (points=[-85.6,-88; -70,-88; -70,-92.9; 
          -44,-92.9], style(color=74, rgbcolor={0,0,127}));
    connect(Tset.y, COB.SP) annotation (points=[-85.6,-88; -70,-88; -70,-68; -8,
          -68; -8,-62.9; 8,-62.9], style(color=74, rgbcolor={0,0,127}));
    connect(Tset.y, Rec.SP) annotation (points=[-85.6,-88; -70,-88; -70,-68; -8,
          -68; -8,-92.9; 8,-92.9], style(color=74, rgbcolor={0,0,127}));
    connect(Tset.y, Sierra.SP) annotation (points=[-85.6,-88; -70,-88; -70,-68; 
          40,-68; 40,-92.9; 58,-92.9], style(color=74, rgbcolor={0,0,127}));
  end Campus4_Link;
end InverseModel;
