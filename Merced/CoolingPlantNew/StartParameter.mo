within Merced.CoolingPlantNew;
partial model StartParameter
  "Partial model for thermal energy storage tank"
//  import Modelica.SIunits.Conversions.*;
  import SI = Modelica.SIunits;
//  import MFI = Modelica_Fluid.Interfaces;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching = true);
  parameter Modelica.Media.Interfaces.PartialMedium.Temperature T_startA=273.15 + 12
    "Initial value of temperature T"                             annotation (
      Dialog(tab="Initialization", group="Initialization of energy balance"));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFraction X_startA[:]=
      zeros(Medium.nX) "Initial values of independent mass fractions X"
    annotation (Dialog(tab="Initialization", group=
          "Initialization of mass fractions (only for multi-substance fluids)"));
  parameter Modelica.Media.Interfaces.PartialMedium.Temperature T_startB=273.15+4
    "Initial value of temperature T"                             annotation (
      Dialog(tab="Initialization", group="Initialization of energy balance"));
  parameter SI.Length h_startB=
      10 "Initial fluid level of B (cold)" annotation (Dialog(tab=
          "Initialization", group="Initialization of energy balance"));
  parameter SI.Length h_startA=
      5 "Initial fluid level of A (Hot)" annotation (Dialog(tab=
          "Initialization", group="Initialization of energy balance"));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFraction X_startB[:]=
      zeros(Medium.nX) "Initial values of independent mass fractions X"
    annotation (Dialog(tab="Initialization", group=
          "Initialization of mass fractions (only for multi-substance fluids)"));
end StartParameter;
