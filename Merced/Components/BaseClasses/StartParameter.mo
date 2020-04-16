within Merced.Components.BaseClasses;
partial model StartParameter "Partial model for thermal energy storage tank"
//  import Modelica.SIunits.Conversions.*;
  import SI = Modelica.SIunits;
//  import MFI = Modelica_Fluid.Interfaces;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching = true);
  parameter Modelica.Media.Interfaces.PartialMedium.Temperature T_startA=291
    "Initial value of temperature T"                             annotation (
      Dialog(tab="Initialization", group="Initialization of energy balance"));
  parameter SI.Length h_startA=
      3 "Initial fluid level of A" annotation (Dialog(tab=
          "Initialization", group="Initialization of energy balance"));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFraction X_startA[:]=
      zeros(Medium.nX) "Initial values of independent mass fractions X"
    annotation (Dialog(tab="Initialization", group=
          "Initialization of mass fractions (only for multi-substance fluids)"));
  parameter Modelica.Media.Interfaces.PartialMedium.Temperature T_startB=277.15
    "Initial value of temperature T"                             annotation (
      Dialog(tab="Initialization", group="Initialization of energy balance"));
  parameter SI.Length h_startB=
      12 "Initial fluid level of B" annotation (Dialog(tab=
          "Initialization", group="Initialization of energy balance"));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFraction X_startB[:]=
      zeros(Medium.nX) "Initial values of independent mass fractions X"
    annotation (Dialog(tab="Initialization", group=
          "Initialization of mass fractions (only for multi-substance fluids)"));
end StartParameter;
