model Example
  // Declare Model Elements
  Deltares.ChannelFlow.Hydraulic.Storage.Linear storage(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 0.5)) annotation(
    Placement(visible = true, transformation(origin = {-62.978, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Discharge discharge annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Level level annotation(
    Placement(visible = true, transformation(origin = {122.3, 20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump pump annotation(
    Placement(visible = true, transformation(origin = {-15, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump ablass annotation(
    Placement(visible = true, transformation(origin = {-55, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Storage.Linear outflow(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 0.5)) annotation(
    Placement(visible = true, transformation(origin = {35, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump outpump annotation(
    Placement(visible = true, transformation(origin = {85, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Define Input/Output Variables and set them equal to model variables
  input Modelica.SIunits.VolumeFlowRate Q_pump(fixed = false, min = 0.0, max = 20.0) = pump.Q;
  input Modelica.SIunits.VolumeFlowRate Q_ablass(fixed = false, min = 0.0, max = 20.0) = ablass.Q;
  input Modelica.SIunits.VolumeFlowRate Q_in(fixed = true) = discharge.Q;
  //input Modelica.SIunits.Position H_end(fixed = true) = level.H;
  input Modelica.SIunits.VolumeFlowRate Q_outpump(fixed = false, min = 0.0, max = 20.0) = outpump.Q;
  //input Modelica.SIunits.VolumeFlowRate Q_outpump(fixed = true) = outpump.Q;
  output Modelica.SIunits.Position storage_level = storage.HQ.H;
  output Modelica.SIunits.Position outflow_level = outflow.HQ.H;
  //output Modelica.SIunits.VolumeFlowRate Q_out = outpump.Q;
  //output Modelica.SIunits.Position sea_level = level.H;
  
  // falta definir variables para los siguientes dos elementos e incorporarlas en python
  
  Deltares.ChannelFlow.Hydraulic.Storage.Linear ablasskanal annotation(
    Placement(visible = true, transformation(origin = {-15, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump ablasskanalout annotation(
    Placement(visible = true, transformation(origin = {20, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
/////////////////////////////////////

equation
  connect(ablasskanal.HQ, ablasskanalout.HQUp) annotation(
    Line(points = {{-15, -17}, {0, -17}, {0, -15}, {10, -15}}, color = {0, 0, 255}));
  connect(ablass.HQDown, ablasskanal.HQ) annotation(
    Line(points = {{-45, -15}, {-27.5, -15}, {-27.5, -17}, {-15, -17}}, color = {0, 0, 255}));
  connect(ablasskanalout.HQDown, outflow.HQ) annotation(
    Line(points = {{30, -15}, {35, -15}, {35, 20}, {35, 20}}, color = {0, 0, 255}));
  connect(storage.HQ, ablass.HQUp) annotation(
    Line(points = {{-65, 20}, {-65, 20}, {-65, -15}, {-65, -15}}, color = {0, 0, 255}));
  connect(outflow.HQ, outpump.HQUp) annotation(
    Line(points = {{35, 22}, {77, 22}, {77, 20}}, color = {0, 0, 255}));
  connect(pump.HQDown, outflow.HQ) annotation(
    Line(points = {{-5, 20}, {35, 20}, {35, 22}}, color = {0, 0, 255}));
  connect(outpump.HQDown, level.HQ) annotation(
    Line(points = {{93, 20}, {115, 20}}, color = {0, 0, 255}));
  connect(discharge.HQ, storage.HQ) annotation(
    Line(points = {{-112, 20}, {-68.5, 20}, {-68.5, 22}, {-63, 22}}, color = {0, 0, 255}));
  connect(storage.HQ, pump.HQUp) annotation(
    Line(points = {{-63, 22}, {-33.5, 22}, {-33.5, 20}, {-23, 20}}, color = {0, 0, 255}));
// Connect Model Elements
  annotation(
    Diagram(coordinateSystem(extent = {{-148.5, -105}, {148.5, 105}}, initialScale = 0.1, grid = {5, 5})));
end Example;