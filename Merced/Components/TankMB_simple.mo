within Merced.Components;
model TankMB_simple
/*  Moving boundary stratified thermal fluid tank model. A hot and cold stratified lumps are
    separated by a thermocline.
 
    Assumptions:
    Cold water enters/exits PortA and warm water enters/exits PortB. 
    Assume inlet/outlet flow mixing b/w nodes is exponentially dissipated by height of node.
    Assume tank temperature is same as adjacent fluid temperature.
 
    Deficiencies:
    Does not accomodate instances where node volume goes to zero.
    Does not directly account for mixing due to thermal buoyancy.
    Does not model temperature of wall thermal mass
    Does not take account into radiant warming/cooling.
*/
  import SI = Modelica.SIunits;
  import Cv = Modelica.SIunits.Conversions;
  extends BaseClasses.StartParameter;
  Modelica.Fluid.Interfaces.FluidPort PortA(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,68},{10,88}}, rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort PortB(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}}, rotation=
            0)));
  parameter SI.Length Radius=20 "radius of tank" annotation (Dialog(group="Tank Dimensions"));
  parameter SI.Area TankCA=3.14*Radius^2 "cross sectional area" annotation (Dialog(group="Tank Dimensions"));
  parameter Real Cpw=4000; // J/kg-C
  parameter SI.Density rho=1000;// kg
// state variables
  SI.Energy UA;
  SI.Energy UB;
  Real mA(unit="kg") "Mass of volume";
  Real mB(unit="kg") "Mass of volume";
  SI.Temperature TwA;
  SI.Temperature TwB;
  SI.Length heightA;
  SI.Length heightB;
// mixing factor between nodes
  // heat/enthalpy flow rates
  Modelica.Blocks.Interfaces.RealOutput z[2]={heightA,heightB}
    annotation (Placement(transformation(extent={{60,30},{80,50}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput T[2]={TwA,TwB}
    annotation (Placement(transformation(extent={{60,-42},{80,-22}}, rotation=0)));
initial equation
  heightA = h_startA;
  heightB = h_startB;
  TwA = T_startA;
  TwB = T_startB;
equation
  // mass as a function of fluid level
  mA=heightA*TankCA*rho;
  mB=heightB*TankCA*rho;
  // fluid mass balances
  der(mA)=(1-0)*PortA.m_flow+0*PortB.m_flow;
  der(mB)=(1-0)*PortB.m_flow+0*PortA.m_flow;
  PortB.m_flow+PortA.m_flow=0;
  // fluid and tank energy balances
  UA=mA*Cpw*TwA;
  UB=mB*Cpw*TwB;
  der(UA)=PortA.m_flow*PortA.h_outflow;
  der(UB)=PortB.m_flow*PortB.h_outflow;

  // axillary equation
  PortA.p = PortB.p;
  PortA.Xi_outflow = PortB.Xi_outflow;
  PortB.C_outflow = PortA.C_outflow;

  annotation (         Icon(graphics={
        Ellipse(
          extent={{-60,-40},{60,-80}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={170,213,255}),
        Ellipse(
          extent={{-60,80},{60,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={170,213,255}),
        Ellipse(
          extent={{-60,32},{60,-8}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Rectangle(
          extent={{-60,60},{58,14}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0}),
        Text(
          extent={{-32,-22},{34,-58}},
          lineColor={0,0,255},
          textString=
               "Node B"),
        Text(
          extent={{-32,54},{34,18}},
          lineColor={0,0,255},
          textString=
               "Node A"),
        Text(
          extent={{52,70},{86,46}},
          lineColor={0,0,255},
          textString=
               "z"),
        Text(
          extent={{54,-2},{88,-26}},
          lineColor={0,0,255},
          textString=
               "T")}));
end TankMB_simple;
