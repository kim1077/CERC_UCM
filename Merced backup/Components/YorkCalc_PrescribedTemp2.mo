model YorkCalc_PrescribedTemp2 
  "Cooling tower with variable speed using the York calculation for the approach temperature" 
  extends 
    Buildings.HeatExchangers.CoolingTowers.BaseClasses.PartialStaticTwoPortCoolingTower;
  annotation (Icon(
      Text(
        extent=[-56,14; 56,-106],
        style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=58,
          rgbfillColor={0,127,0},
          fillPattern=1),
        string="York"),
      Text(
        extent=[-102,104; -44,78],
        style(color=74, rgbcolor={0,0,127}),
        string="T_CWS"),
      Rectangle(extent=[-100,82; -70,78], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Text(extent=[58,48; 108,34], string="P")),
                          Diagram,
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
  parameter Modelica.SIunits.Temperature dTMin(min=0.01, max=20) = 10 
    "deltaT for smoothing switching between TAppMin and TAppMax";
  
  Modelica.SIunits.Temperature TApp(min=0, nominal=5) "Approach temperature";
  Modelica.SIunits.Temperature TAppMax(min=0, nominal=10) 
    "Free convection TApp";
  Modelica.SIunits.Temperature TAppMin(min=0, nominal=5,start=5) 
    "max fan speed TApp";
  Modelica.SIunits.Temperature TApp1(min=0, nominal=1) "intermediate Tapp";
  
  Modelica.SIunits.Temperature TRan(min=0,nominal=4) "Range temperature";
  Modelica.SIunits.MassFraction FRWat 
    "Ratio actual over design water mass flow ratio";
  Modelica.SIunits.MassFraction FRAir(min=0,max=2,nominal=0.5) 
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
  
public 
  Buildings.HeatExchangers.CoolingTowers.Correlations.BoundsYorkCalc bou 
    "Bounds for correlation";
  Modelica.Blocks.Interfaces.RealInput T_CWS_in(redeclare type SignalType = 
        Modelica.SIunits.Temperature,min=275,max=305,nominal=285) 
    "T_CWS Reference"                    annotation (extent=[-140,60; -100,100]);
  
  Modelica.Blocks.Interfaces.RealOutput P "power" 
    annotation (extent=[92,30; 112,50],    rotation=0);
initial equation 
  TWatOut0 = TAirInWB0 + TApp0;
  TRan0 = TWatIn0 - TWatOut0; // by definition of the range temp.
  TApp0 = Buildings.HeatExchangers.CoolingTowers.Correlations.yorkCalc(TRan=TRan0, TWB=TAirInWB0,
                                FRWat=FRWat0, FRAir=1); // this will be solved for FRWat0
  mWatRef_flow = mWat0_flow/FRWat0;
equation 
  
  // use setpoint as leaving water tempeature boundary condition
  if cardinality(T_CWS_in)==0 then
    T_CWS_in = T_CWS_const 
      "leaving cooling tower temperature provided by parameter";
  end if;
  
  // range temperature
  TRan = medium_a.T - medium_b.T;
  // fractional mass flow rates
  FRWat = m_flow/mWatRef_flow;
  
  // calculate minimum approach temperature
  TAppMin = Buildings.HeatExchangers.CoolingTowers.Correlations.yorkCalc(TRan=TWatIn_degC-(TAppMin+TAirIn_degC), TWB=TAir, FRWat=max(FRWat,0.2), FRAir=1);
  // calculate maximum approach temperature
  TAppMax = (TWatIn_degC-TAirIn_degC)-fraFreCon*(TWatIn_degC-(TAppMin+TAirIn_degC));
  // calculate FRAir using correlation and reference TApp
  TApp = Buildings.HeatExchangers.CoolingTowers.Correlations.yorkCalc(TRan=TWatIn_degC-(TApp+TAirIn_degC), TWB=TAir,
                                  FRWat=FRWat, FRAir=max(FRWat/bou.liqGasRat_max, FRAir));
  
  // bound reference approach temperature by max-min
  TApp1 = max(0,Buildings.Utilities.Math.spliceFunction(pos=T_CWS_in-TAir, neg=TAppMin,
         x=(T_CWS_in-TAir)-TAppMin, deltax=dTMin));
  // TApp1 = T_CWS_in-TAir;
  TApp = Buildings.Utilities.Math.spliceFunction(pos=TAppMax, neg=  TApp1,
         x=TApp1-TAppMax, deltax=dTMin);
  
  TWatOut_degC = TApp + TAirIn_degC;
  P = FRAir^3 * PFan0;
end YorkCalc_PrescribedTemp2;
