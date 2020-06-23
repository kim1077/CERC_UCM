within Merced.Components;
model TankMB_H2 "Modified Notations: 1-->H, 2-->C"
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
  replaceable package MediumA =Modelica.Media.Interfaces.PartialMedium;
  replaceable package MediumB =Modelica.Media.Interfaces.PartialMedium;

  Modelica.Fluid.Interfaces.FluidPort_a PortA(redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{-10,68},{10,88}}, rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_a PortB(redeclare package Medium = MediumB)
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}}, rotation=
            0)));
  MediumA.BaseProperties mediumA(
    preferredMediumStates=true); // calling a model, i.e an object + equations
  MediumB.BaseProperties mediumB(
    preferredMediumStates=true); // calling a model, i.e an object + equations
  parameter SI.Length Radius=10;//20 "radius of tank" annotation (Dialog(group="Tank Dimensions"));
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
  Real mA(quantity=MediumA.mediumName, unit="kg") "Mass of volume";
  Real mB(quantity=MediumB.mediumName, unit="kg") "Mass of volume";
// monitored version of state variables
  SI.Temperature TwA;
  SI.Temperature TwB;
  SI.Length heightA(min=0,max=15);
  SI.Length heightB(min=0,max=15);
// mixing factor between nodes
  // mixing factor due to inlet/outlet jetting
  //Real fAjet=exp(-tauJet*(heightA-delta));
  //Real fBjet=exp(-tauJet*(heightB-delta));
  // mixing factor due to buoyancy
  //Real fAbuoy=semiLinear(sign(PortA.m_flow),1-exp(semiLinear(mediumA.d-medPortA.d,0,+tauBuoy)),0);
  //Real fBbuoy=semiLinear(sign(PortB.m_flow),1-exp(semiLinear(mediumB.d-medPortB.d,-tauBuoy,0)),0);
  // effective mixing factors
  //Real fAmix= fAjet*(1+fAbuoy-fAbuoy*fAjet); // fAjet+fAbuoy-2*fAjet*fAbuoy; // fAjet*fAbuoy; //
  //Real fBmix= fBjet*(1+fBbuoy-fBbuoy*fBjet); // fBjet+fBbuoy-2*fBjet*fBbuoy; // fBjet*fBbuoy; //
// heat/enthalpy flow rates
  //SI.EnthalpyFlowRate HFlowWallA;
  //SI.EnthalpyFlowRate HFlowWallB;
  //SI.EnthalpyFlowRate HFlowA2B= semiLinear(fAmix*PortA.m_flow,mediumA.h,mediumB.h);
  //SI.EnthalpyFlowRate HFlowB2A= semiLinear(fBmix*PortB.m_flow,mediumB.h,mediumA.h);
  //SI.HeatFlowRate Qamb2A=(Tamb-TwA)*(2*3.14*Radius*heightA)/(1/hwater+1/hair+tTank/Kwall);
  //SI.HeatFlowRate Qamb2B=(Tamb-TwB)*(2*3.14*Radius*heightB)/(1/hwater+1/hair+tTank/Kwall);
//  SI.EnthalpyFlowRate QAB=Keff*TankCA*(TwB-TwA)*2/(heightA+heightB);
  //SI.EnthalpyFlowRate QAB=Keff*TankCA*(TwB-TwA)*2/(1); // assuming a 2 meter thermocline boundary
  // Modelica.Blocks.Interfaces.RealInput Tamb "ambient temperature" annotation (Placement(transformation(extent={{-86,27},{-60,53}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput z[3]={heightA,heightB,heightB/(heightA+heightB)}
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
equation
  // mass as a function of fluid level
  mA=heightA*TankCA*mediumA.d;
  mB=heightB*TankCA*mediumB.d;
  // fluid mass balances
  der(mA)=PortA.m_flow;//(1-fAmix)*PortA.m_flow+fBmix*PortB.m_flow;
  der(mB)=PortB.m_flow;//(1-fBmix)*PortB.m_flow+fAmix*PortA.m_flow;
  der(mA)+der(mB)=0;
  // enthalpy flow rate from tank wall entering and leaving control volumes
  //HFlowWallA=0*semiLinear(der(heightA+heightB)*WallCA*rhoWall*CpWall,Tamb,TwA)-HFlowWallB;
  //HFlowWallB=0*semiLinear(der(heightB)*WallCA*rhoWall*CpWall,TwA,TwB);
  // fluid and tank energy balances
  UA=mA*mediumA.u;// + 0*TwA*CpWall*rhoWall*(heightA*WallCA+TankCA*tTank);//mA*mediumA.h + 0*TwA*CpWall*rhoWall*(heightA*WallCA+TankCA*tTank);
  UB=mB*mediumB.u;// + 0*TwB*CpWall*rhoWall*(heightB*WallCA+TankCA*tTank);//mB*mediumB.h + 0*TwB*CpWall*rhoWall*(heightB*WallCA+TankCA*tTank);
  der(UA)=PortA.m_flow*actualStream(PortA.h_outflow);//+HFlowWallA-HFlowA2B+HFlowB2A+QAB+Qamb2A);//(PortA.H_flow+HFlowWallA-HFlowA2B+HFlowB2A+QAB+Qamb2A);
  der(UB)=PortB.m_flow*actualStream(PortB.h_outflow);//+HFlowWallB+HFlowA2B-HFlowB2A-QAB+Qamb2B);//(PortB.H_flow+HFlowWallB+HFlowA2B-HFlowB2A-QAB+Qamb2B);
  // relationships between medium and flow variables
  PortA.p = mediumA.p;
  PortB.p = mediumB.p;
  PortA.h_outflow = mediumA.h;
  PortB.h_outflow = mediumB.h;

  mediumA.T = TwA;
  mediumB.T = TwB;
  //mediumA.p = (heightA+heightB)*9.81*mediumA.d;
  mediumB.p = (heightA+heightB)*9.81*mediumB.d;

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
end TankMB_H2;
