partial model TimeSeries "Time series from a text file" 
  
  annotation (Diagram,
Documentation(info="<html>
<p>
This partial block interpolates data from a text file. Models that extend this
model should define outports for the data being interpolated by this model.
The interpolation has a continuous derivative.
<h3>Main Author</h3>
<P>
    Michael Wetter<br>
    <a href=\"http://www.utrc.utc.com\">United Technologies Research Center</a><br>
    411 Silver Lane<br>
    East Hartford, CT 06108<br>
    USA<br>
    email: <A HREF=\"mailto:WetterM@utrc.utc.com\">WetterM@utrc.utc.com</A>
<h3>Release Notes</h3>
<ul>
<li><i>July 12, 2005</i>
       by Michael Wetter:<br>
       Introduced time wrapping.
<li><i>December 3, 2004</i>
       by Michael Wetter:<br>
       Implemented first version.
</li>
</ul>
</HTML>
"),
Icon( Rectangle(extent=[-60,60; 60,-60],   style(fillColor=30, fillPattern=1)),
      Line(points=[60,0; 100,0]),
      Line(points=[-54,40; -54,-40; 54,-40; 54,40; 28,40; 28,-40; -28,-40; -28,
            40; -54,40; -54,20; 54,20; 54,0; -54,0; -54,-20; 54,-20; 54,-40;
            -54,-40; -54,40; 54,40; 54,-40],                       style(
            color=0)),
      Line(points=[0,40; 0,-40],   style(color=0)),
      Rectangle(extent=[-54,40; -28,20],   style(
          color=0,
          fillColor=6,
          fillPattern=1)),
      Rectangle(extent=[-54,20; -28,0],   style(
          color=0,
          fillColor=6,
          fillPattern=1)),
      Rectangle(extent=[-54,0; -28,-20],   style(
          color=0,
          fillColor=6,
          fillPattern=1)),
      Rectangle(extent=[-54,-20; -28,-40],   style(
          color=0,
          fillColor=6,
          fillPattern=1)),
      Text(extent=[-52,56; -34,44],   string="u"),
      Text(extent=[2,56; 26,44],   string="y"),
      Text(extent=[-2,-40; 30,-54],   string="icol"),
      Text(extent=[68,14; 92,2],   string="y")));
 parameter String tableName="" "Table name of matrix";
 parameter String directoryName="" 
    "Name of directory where table is stored (or empty string)";
 parameter Real icol[:] "Columns of table to be interpolated";
 parameter Boolean doErrorCheck = true 
    "Flag, set to true for input error check";
 parameter Modelica.SIunits.Time timeSeriesLength = -1 
    "Length of time series, set to negative number to use always simulation time (introduces state events!)";
protected 
   parameter Boolean wrapTime(fixed=false) 
    "true: time of day; false: absolute time (in a year)";
  constant Real[:,:] dummy=[0,0] 
    "To prevent table from being written to mos script";
protected 
  Modelica.Blocks.Tables.CombiTable1Ds tab(
    final fileName=(if (directoryName) <> "" then directoryName else ""),
    smoothness=1,
    table=dummy,
    columns=integer((icol)),
    tableName=tableName,
    tableOnFile=(tableName) <> "NoName") "Table with time series data" 
    annotation (extent=[-22,-10; -2,10]);
initial equation 
  wrapTime = (timeSeriesLength >= 0);
equation 
  tab.u = if wrapTime then mod(time,timeSeriesLength) else time;
end TimeSeries;
