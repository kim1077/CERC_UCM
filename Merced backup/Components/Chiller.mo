model Chiller "Chiller Model Using Buildings Package" 
  extends Buildings.Fluids.Interfaces.PartialStaticFourPortHeatMassTransfer;
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(
      Rectangle(extent=[-100,61; -70,58], style(
          color=3,
          rgbcolor={0,0,255},
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Bitmap(extent=[-60,44; 56,-42], name="chiller.jpg"),
      Line(points=[-64,60; 56,60], style(
          color=1,
          rgbcolor={255,0,0},
          thickness=4,
          arrow=1)),
      Line(points=[-62,-60; 58,-60], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=4,
          arrow=2)),
      Text(extent=[68,-82; 118,-96],
                                   string="P"),
      Text(extent=[-102,-82; -56,-94], string="T_CHWS")),
Documentation(info="<html>
<p>
Chiller model based on Energy Plus electric EIR chiller model.
</p>
<p> This model uses three curves to predict capacity and power consumption:</p>
<p> 1. Biquadratic function predicting cooling capacity with respect to
fluid temperature entering the condenser (T_cws) and fluid temperature leaving the evaporator (T_chws). </p>
<p> 2. Biquadratic curve to predict power input to cooling capacity ratio with respect to
fluid temperature entering the condenser (T_cws) and fluid temperature leaving the evaporator (T_chws). </p>
<p> 3. Quadratic curve to predict power input to cooling capacity ratio with respect to the part load ratio</p>
 
</html>",
revisions="<html>
<ul>
<li>
October 13, 2008, by Brandon Hencey:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      Text(extent=[88,-68; 138,-82],
                                   string="P")));
  
  parameter Modelica.SIunits.HeatFlowRate Qref=4.2e6 "reference capacity";
  parameter Real COP_ref=4 "reference coefficient of performance";
  parameter Real PLR_max=1.0 "maximum part load ratio";
  parameter Real PLR_MinUnloadRatio=0.4 "minimum part unload ratio";
  parameter Real PLR_Min=0.1 "minimum part unload ratio";
  parameter Real eta_motor=1.0 
    "portion of compressor motor heat entering refrigerant";
  parameter Real a[:]={1, 0, 0, 0, 0, 0} "biquadratic coefficients for CAPFT";
  parameter Real b[:]={1, 0, 0, 0, 0, 0} "biquadratic coefficients for EIRFT";
  parameter Real c[:]={0, 1, 0} "quadratic coefficients for EIRFPLR";
  
  Real ChillerCapFTemp "cooling capacity factor function of temperature curve";
  Real ChillerEIRFTemp 
    "power input to cooling capacity ratio function of temperature curve";
  Real ChillerEIRFPLR 
    "power input to cooling capacity ratio function of part load ratio";
  Real PLR1 "Part Load Ratio";
  Real PLR2 "Part Load Ratio";
  Real CCR "Chiller Cycling Ratio";
  
  Modelica.SIunits.HeatFlowRate Qavail "Rated Capacity";
  Modelica.SIunits.HeatFlowRate Qevap 
    "cooling capacity required to cool T_chws to its setpoint";
  Modelica.SIunits.SpecificEnthalpy h_chws_ref "enthalpy setpoint for CHWS";
  Modelica.SIunits.Temperature Tcws=medium_a1.T_degC 
    "temperature of fluid entering condenser";
  Modelica.SIunits.Temperature Tchws=medium_b2.T_degC 
    "temperature of fluid leaving evaporator";
  
  Modelica.Blocks.Interfaces.RealInput T_chws_ref(
    redeclare type SignalType = Modelica.SIunits.Temperature (
     min = 274.15)) "set point for CHWS temperature" 
                                                  annotation (extent=[-118,-98;
        -100,-78]);
  
  Modelica.Blocks.Interfaces.RealOutput P "power" 
    annotation (extent=[100,-100; 120,-80],rotation=0);
equation 
  // chiller capacity fraction biquadratic curve
  ChillerCapFTemp = a[1]+a[2]*Tchws+a[3]*Tchws^2+a[4]*Tcws+a[5]*Tcws^2+a[6]*Tcws*Tchws;
  // chiller energy input ratio biquadratic curve
  ChillerEIRFTemp = b[1]+b[2]*Tchws+b[3]*Tchws^2+b[4]*Tcws+b[5]*Tcws^2+b[6]*Tcws*Tchws;
  // chiller energy input ratio quadratic curve
  ChillerEIRFPLR   = c[1]+c[2]*PLR2+c[3]*PLR2^2;
  
  Qavail = Qref*max(0.1,ChillerCapFTemp); //available cooling capacity
  //enthalpy of T_chws_ref
  h_chws_ref = Medium_2.specificEnthalpy_pTX(medium_b2.p,T_chws_ref, medium_b2.X);
  // cooling capacity required to chill water to setpoint
  Qevap = max(m_flow_2*(medium_a2.h-h_chws_ref),0);
  
  PLR1 = min( Qevap/Qavail, PLR_max); // power load ratio
  CCR = min( PLR1/PLR_Min,1.0); // chiller cycling ratio
  PLR2 = max(PLR_MinUnloadRatio, PLR1);
  P = Qavail/COP_ref*ChillerEIRFTemp*ChillerEIRFPLR*CCR; // compressor power
  
  // heat flow rates into evaporator and condenser
  Q_flow_2 = - min( Qevap, Qavail);
  Q_flow_1 = -Q_flow_2 + P*eta_motor;
  
  // no mass exchange
  mXi_flow_1 = zeros(Medium_1.nXi);
  mXi_flow_2 = zeros(Medium_2.nXi);
  
  // no pressure drop
  dp_1 = 0;
  dp_2 = 0;
end Chiller;
