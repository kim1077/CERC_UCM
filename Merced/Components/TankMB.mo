within Merced.Components;
model TankMB
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
  Modelica.Fluid.Interfaces.FluidPort_a PortA(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,68},{10,88}}, rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_a PortB(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}}, rotation=
            0)));
  Medium.BaseProperties mediumA(
    preferredMediumStates=true);
  Medium.BaseProperties mediumB(
    preferredMediumStates=true);
  Medium.BaseProperties medPortA(
    preferredMediumStates=true);
  Medium.BaseProperties medPortB(
    preferredMediumStates=true);
  parameter SI.Length Radius=20 "radius of tank" annotation (Dialog(group="Tank Dimensions"));
  parameter SI.Length tTank=0.01 "thickness of tank" annotation (Dialog(group="Tank Dimensions"));
  parameter SI.Area TankCA=3.14*Radius^2 "cross sectional area" annotation (Dialog(group="Tank Dimensions"));
  parameter SI.Area WallCA=2*3.14*Radius*tTank "wall cross sectional area" annotation (Dialog(group="Tank Dimensions"));
  parameter SI.SpecificHeatCapacity CpWall=500 "specific heat of tank wall" annotation(Dialog(group="Thermal Properties"));
  parameter SI.Density rhoWall=7850 "density of tank wall";
  parameter SI.ThermalConductivity Kwater=0.6034
    "thermal conductivity of fluid" annotation(Dialog(group="Thermal Properties"));
  parameter SI.ThermalConductivity Kwall = 30
    "thermal conductivity of tank wall" annotation(Dialog(group="Thermal Properties"));
  parameter SI.ThermalConductivity Keff = Kwater+Kwall*WallCA/TankCA
    "effective thermal conductivity" annotation(Dialog(group="Thermal Properties"));
  parameter SI.CoefficientOfHeatTransfer hwater=1000
    "heat transfer coefficient of water (500-1e4)" annotation(Dialog(group="Thermal Properties"));
  parameter SI.CoefficientOfHeatTransfer hair=50
    "heat transfer coefficient of air (10-100)" annotation(Dialog(group="Thermal Properties"));
  parameter Real tauJet=0.8 "rate of decay of jet mixing";
  parameter Real tauBuoy=9.81*0.25
                                  "rate of decay of buoyancy mixing";
  parameter SI.Length delta=0.3 "minimum thermocline thickness";
// state variables
  SI.Energy UA;
  SI.Energy UB;
  Real mA(quantity=Medium.mediumName, unit="kg") "Mass of volume";
  Real mB(quantity=Medium.mediumName, unit="kg") "Mass of volume";
  Real mXA[Medium.nX](quantity=Medium.substanceNames, each unit="kg");
  Real mXB[Medium.nX](quantity=Medium.substanceNames, each unit="kg");
// monitored version of state variables
  SI.Temperature TwA;
  SI.Temperature TwB;
  SI.Length heightA;
  SI.Length heightB;
// mixing factor between nodes
  // mixing factor due to inlet/outlet jetting
  Real fAjet=exp(-tauJet*(heightA-delta));
  Real fBjet=exp(-tauJet*(heightB-delta));
  // mixing factor due to buoyancy
  Real fAbuoy=semiLinear(sign(PortA.m_flow),1-exp(semiLinear(mediumA.d-medPortA.d,0,+tauBuoy)),0);
  Real fBbuoy=semiLinear(sign(PortB.m_flow),1-exp(semiLinear(mediumB.d-medPortB.d,-tauBuoy,0)),0);
  // effective mixing factors
  Real fAmix= fAjet*(1+fAbuoy-fAbuoy*fAjet); // fAjet+fAbuoy-2*fAjet*fAbuoy; // fAjet*fAbuoy; //
  Real fBmix= fBjet*(1+fBbuoy-fBbuoy*fBjet); // fBjet+fBbuoy-2*fBjet*fBbuoy; // fBjet*fBbuoy; //
// heat/enthalpy flow rates
  SI.EnthalpyFlowRate HFlowWallA;
  SI.EnthalpyFlowRate HFlowWallB;
  SI.EnthalpyFlowRate HFlowA2B=semiLinear(fAmix*PortA.m_flow,mediumA.h,mediumB.h);
  SI.EnthalpyFlowRate HFlowB2A=semiLinear(fBmix*PortB.m_flow,mediumB.h,mediumA.h);
  SI.HeatFlowRate Qamb2A=(Tamb-TwA)*(2*3.14*Radius*heightA)/(1/hwater+1/hair+tTank/Kwall);
  SI.HeatFlowRate Qamb2B=(Tamb-TwB)*(2*3.14*Radius*heightB)/(1/hwater+1/hair+tTank/Kwall);
//  SI.EnthalpyFlowRate QAB=Keff*TankCA*(TwB-TwA)*2/(heightA+heightB);
  SI.EnthalpyFlowRate QAB=Keff*TankCA*(TwB-TwA)*2/(1); // assuming a 2 meter thermocline boundary
  Modelica.Blocks.Interfaces.RealInput Tamb "ambient temperature"
    annotation (Placement(transformation(extent={{-86,27},{-60,53}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput z[2]={heightA,heightB}
    annotation (Placement(transformation(extent={{60,30},{80,50}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput T[2]={TwA,TwB}
    annotation (Placement(transformation(extent={{60,-42},{80,-22}}, rotation=0)));
initial equation
/*  if not Medium.incompressible then
    mXA = mA*X_startA;
  end if;
  if not Medium.incompressible then
    mXB = mB*X_startB;
  end if; */
  heightA = h_startA;
  heightB = h_startB;
  mediumA.T = T_startA;
  mediumB.T = T_startB;
  mediumA.X = X_startA;
  mediumB.X = X_startB;
equation
  // mass as a function of fluid level
  mA=heightA*TankCA*mediumA.d;
  mB=heightB*TankCA*mediumB.d;
  // fluid mass balances
  der(mA)=(1-fAmix)*PortA.m_flow+fBmix*PortB.m_flow;
  der(mB)=(1-fBmix)*PortB.m_flow+fAmix*PortA.m_flow;
  der(mXA) = (1-fAmix)*PortA.mXi_flow+fBmix*PortB.mXi_flow;
  der(mXB) = (1-fBmix)*PortB.mXi_flow+fAmix*PortA.mXi_flow;
  // enthalpy flow rate from tank wall entering and leaving control volumes
  HFlowWallA=0*semiLinear(der(heightA+heightB)*WallCA*rhoWall*CpWall,Tamb,TwA)-HFlowWallB;
  HFlowWallB=0*semiLinear(der(heightB)*WallCA*rhoWall*CpWall,TwA,TwB);
  // fluid and tank energy balances
  UA=mA*mediumA.h + 0*TwA*CpWall*rhoWall*(heightA*WallCA+TankCA*tTank);
  UB=mB*mediumB.h + 0*TwB*CpWall*rhoWall*(heightB*WallCA+TankCA*tTank);
  der(UA)=(PortA.H_flow+HFlowWallA-HFlowA2B+HFlowB2A+QAB+Qamb2A);
  der(UB)=(PortB.H_flow+HFlowWallB+HFlowA2B-HFlowB2A-QAB+Qamb2B);
  // relationships between medium and flow variables
  PortA.H_flow = semiLinear(PortA.m_flow,PortA.h,mediumA.h);
  PortB.H_flow = semiLinear(PortB.m_flow,PortB.h,mediumB.h);
  PortA.mXi_flow = semiLinear(PortA.m_flow, PortA.Xi, mediumA.X);
  PortB.mXi_flow = semiLinear(PortB.m_flow, PortB.Xi, mediumB.X);
  //  PortA.m_flow driven by pressure
  //  PortB.m_flow driven by pressure
  // relationships between medium and non-flow variables
  //  PortA.h = mediumA.h; driven by enthalpy flow rate
  //  PortB.h = mediumB.h; driven by enthalpy flow rate
  //  PortA.Xi = mediumA.X; driven by mass fraction flow rate
  //  PortB.Xi = mediumB.X; driven by mass fraction flow rate
  PortA.p = mediumA.p;
  PortB.p = mediumB.p;
  // relationships between state variables and medium
  mediumA.T = TwA;
  mediumB.T = TwB;
  mediumA.X*mA = mXA;
  mediumB.X*mB = mXB;
  mediumA.p = (heightA+heightB)*9.81*mediumA.d;
  mediumB.p = (heightA+heightB)*9.81*mediumB.d;
  medPortA.p=PortA.p;
  medPortB.p=PortB.p;
  medPortA.h=PortA.h;
  medPortB.h=PortB.h;
  medPortA.Xi=PortA.Xi;
  medPortB.Xi=PortB.Xi;
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
          extent={{-96,74},{-62,50}},
          lineColor={0,0,255},
          textString=
               "T_amb"),
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
end TankMB;
