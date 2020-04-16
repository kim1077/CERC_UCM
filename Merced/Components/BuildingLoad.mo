within Merced.Components;
model BuildingLoad "Internal heat gains from a text file"
  extends Merced.Components.BaseClasses.TimeSeries(final icol[:]=
       cols);
   parameter Integer[:] cols={2} "Columns to be interpolated";
  Modelica.Blocks.Interfaces.RealOutput q[1] "Building Cooling Load in [W]"
    annotation (Placement(transformation(extent={{100,-8},{120,12}}, rotation=0)));
equation
  q[1]=max(0,tab.y[1]);
  // Error check
  if doErrorCheck then
    assert(q[1]> -10, "cooling load cannot be negative.");
  end if;
end BuildingLoad;
