within Merced;
package CoolingPlantNew
  model KPI "CostCalculation"
    Modelica.Blocks.Interfaces.RealInput ER "ElectricityRate [$/kWh]" annotation (
       Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-80,56}), iconTransformation(extent={{-90,34},{-70,54}})));
    Modelica.Blocks.Interfaces.RealInput PHVAC "kW" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-80,20})));
    Modelica.Blocks.Interfaces.RealOutput y[4]  annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-10,34}), iconTransformation(extent={{-18,0},{2,20}})));
    Real X(start=0);
    Modelica.Blocks.Interfaces.RealInput PnonHVAC "kW" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-80,-4})));
    Modelica.Blocks.Interfaces.RealInput Psolarpv "kW" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-80,-28})));
    Modelica.Blocks.Interfaces.RealInput mr "kg/s" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-80,-52})));
    Modelica.Blocks.Interfaces.RealInput mCH "kg/s" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-80,-72})));
    Modelica.Blocks.Interfaces.RealInput TCHi "K" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-46,-52})));
    Modelica.Blocks.Interfaces.RealInput TCHe "K" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-46,-72})));
    Modelica.Blocks.Interfaces.RealInput Ts[2] "K" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-12,-52})));
    Modelica.Blocks.Interfaces.RealInput Tr "K" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-12,-72})));
    Real QCHL "kW";
    Real QDIS "kW";
  equation
    der(X)=ER*max(PHVAC+PnonHVAC-Psolarpv,0);
    QCHL=mCH*4.2*(TCHi-TCHe);
    QDIS=if mCH<mr then (mr-mCH)*4.2*(Tr-Ts[2])
         else (mr-mCH)*4.2*(Ts[1]-TCHe);
    y ={PHVAC,X,QCHL,QDIS};
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-82,62},{-14,-88}},
            lineColor={28,108,200},
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid)}),                      Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end KPI;
end CoolingPlantNew;
