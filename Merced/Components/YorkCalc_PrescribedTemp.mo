within Merced.Components;
model YorkCalc_PrescribedTemp
  "Cooling tower with variable speed using the York calculation for the approach temperature"
  extends
    Buildings.HeatExchangers.CoolingTowers.BaseClasses.PartialStaticTwoPortCoolingTower;
  parameter Modelica.SIunits.Temperature TAirInWB0 = 273.15+25.55
    "Design inlet air wet bulb temperature"
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TApp0 = 3.89
    "Design apprach temperature"
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TRan0 = 5.56
    "Design range temperature (water in - water out)"
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mWat0_flow = 0.15
    "Design water flow rate"
      annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Power PFan0 = 275 "Fan power"
      annotation (Dialog(group="Nominal condition"));
  parameter Real fraFreCon(min=0, max=1) = 0.125
    "Fraction of tower capacity in free convection regime";
  parameter Real yMin(min=0.01, max=1) = 0.3
    "Minimum control signal until fan is switched off (used for smoothing)";
  Modelica.SIunits.Temperature TApp(min=0, nominal=1) "Approach temperature";
  Modelica.SIunits.Temperature TAppCor(min=0, nominal=1)
    "Approach temperature based on manufacturer correlation";
  Modelica.SIunits.Temperature TAppFreCon(min=0, nominal=1)
    "Approach temperature for free convection";
  Modelica.SIunits.Temperature TRan(nominal=1) "Range temperature";
  Modelica.SIunits.MassFraction FRWat
    "Ratio actual over design water mass flow ratio";
  Modelica.SIunits.MassFraction FRAir
    "Ratio actual over design air mass flow ratio";
  parameter Modelica.SIunits.Temperature T_CWS_const(min=273.15)=273.15+25
    "Leaving water temperature setpoint";
protected
  parameter Modelica.SIunits.MassFraction FRWat0(min=0, start=1, fixed=false)
    "Ratio actual over design water mass flow ratio at nominal condition";
  parameter Modelica.SIunits.Temperature TWatIn0(fixed=false)
    "Water inlet temperature at nominal condition";
  parameter Modelica.SIunits.Temperature TWatOut0(fixed=false)
    "Water outlet temperature at nominal condition";
  parameter Modelica.SIunits.MassFlowRate mWatRef_flow(min=0, start=mWat0_flow, fixed=false)
    "Reference water flow rate";
  Modelica.SIunits.Temperature dTMax(nominal=1)
    "Maximum possible temperature difference";
public
  Buildings.HeatExchangers.CoolingTowers.Correlations.BoundsYorkCalc bou
    "Bounds for correlation";
  Modelica.Blocks.Interfaces.RealInput T_CWS_in "Fan control signal"
                                         annotation (Placement(transformation(
          extent={{-140,60},{-100,100}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput P "power"
    annotation (Placement(transformation(extent={{92,30},{112,50}}, rotation=0)));
initial equation
  TWatOut0 = TAirInWB0 + TApp0;
  TRan0 = TWatIn0 - TWatOut0; // by definition of the range temp.
  TApp0 = Buildings.HeatExchangers.CoolingTowers.Correlations.yorkCalc(TRan=TRan0, TWB=TAirInWB0,
                                FRWat=FRWat0, FRAir=1); // this will be solved for FRWat0
  mWatRef_flow = mWat0_flow/FRWat0;
equation
  // use setpoint as leaving water tempeature boundary condition
  TWatOut_degC=T_CWS_in-273.15;
  if cardinality(T_CWS_in)==0 then
    T_CWS_in = T_CWS_const
      "leaving cooling tower temperature provided by parameter";
  end if;
  assert( (T_CWS_in-273.15)<=TAppFreCon+TAirIn_degC-0.1,
    "APPROACH TEMPERATURE SETPOINT GREATER THAN FREE COOLING APPROACH TEMPERATURE");
  // range temperature
  TRan = medium_a.T - medium_b.T;
  // fractional mass flow rates
  FRWat = m_flow/mWatRef_flow;
  TAppCor = Buildings.HeatExchangers.CoolingTowers.Correlations.yorkCalc(TRan=TRan, TWB=TAir,
                                  FRWat=FRWat, FRAir=max(FRWat/bou.liqGasRat_max, FRAir));
  dTMax = TWatIn_degC - TAirIn_degC;
  TAppFreCon = (1-fraFreCon) * ( TWatIn_degC-TAirIn_degC)  + fraFreCon *
               Buildings.HeatExchangers.CoolingTowers.Correlations.yorkCalc(TRan=TRan, TWB=TAir, FRWat=FRWat, FRAir=1);
  TApp = Buildings.Utilities.Math.spliceFunction(pos=TAppCor, neg=TAppFreCon,
         x=FRAir-yMin/2, deltax=yMin/2);
  TWatOut_degC = TApp + TAirIn_degC;
  P = FRAir^3 * PFan0;
  annotation (Icon(graphics={
        Text(
          extent={{-56,14},{56,-106}},
          lineColor={255,255,255},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          textString=
               "York"),
        Text(
          extent={{-102,104},{-44,78}},
          lineColor={0,0,127},
          textString=
               "T_CWS"),
        Rectangle(
          extent={{-100,82},{-70,78}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(extent={{58,48},{108,34}}, textString=
                                          "P")}),
                          Diagram(graphics),
    Documentation(info="<html>
<p>
Model for a steady state cooling tower with variable speed fan using the York calculation for the
aproach temperature.
</p>
<p>
This model uses a performance curve for a York cooling tower to compute the approach temperature.
If the fan control signal is zero, then the cooling tower operates in a free convection mode.
In the current implementation the fan power consumption is proportional to the control signal raised
to the third power. 
Not yet implemented are the basin heater power consumption, the water usage and the option to provide
a fan efficiency curve to compute the fan power consumption. Otherwise, the model is similar to the
one in EnergyPlus.
</p>
<h2>References</h2>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 2.0.0 Engineering Reference</a>, April 9, 2007.
</p>
</html>", revisions="<html>
<ul>
<li>
May 16, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end YorkCalc_PrescribedTemp;
