model Example
  // Declare Model Elements
  Deltares.ChannelFlow.Hydraulic.Storage.Linear storage(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 0.5)) annotation(
    Placement(visible = true, transformation(origin = {32.022, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -270)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Discharge discharge annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump pump annotation(
    Placement(visible = true, transformation(origin = {0, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump orifice annotation(
    Placement(visible = true, transformation(origin = {0, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Storage.Linear drainage_channel(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 0.5)) annotation(
    Placement(visible = true, transformation(origin = {-45, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump weir_drainage annotation(
    Placement(visible = true, transformation(origin = {-85, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump weir_main_channel annotation(
    Placement(visible = true, transformation(origin = {-85, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Storage.Linear main_channel(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 0.5)) annotation(
    Placement(visible = true, transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Level level_main annotation(
    Placement(visible = true, transformation(origin = {-125, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Level level_drain annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  // Define Input/Output Variables and set them equal to model variables
  input Modelica.SIunits.VolumeFlowRate Q_pump(fixed = true) = pump.Q;
  input Modelica.SIunits.VolumeFlowRate Q_drainage(fixed = true) = weir_drainage.Q;
  input Modelica.SIunits.VolumeFlowRate Q_main(fixed = true) = weir_main_channel.Q;
  //input Boolean is_downhill;
  input Modelica.SIunits.VolumeFlowRate Q_in(fixed = true) = discharge.Q;
  // input Modelica.SIunits.Position H_sea(fixed = false, min = 0.0, max = 10.0) = level.H;
  // input Modelica.SIunits.Position H_channel(fixed = false, min = 0.0, max = 5.0) = level_orifice.H;
  input Modelica.SIunits.VolumeFlowRate Q_orifice(fixed = false, min = 0.0, max = 7.0) = orifice.Q;
  output Modelica.SIunits.Position storage_level = storage.HQ.H;
  output Modelica.SIunits.Position drainage_level = drainage_channel.HQ.H;
  output Modelica.SIunits.Position main_channel_level = main_channel.HQ.H;
  // output Modelica.SIunits.Position sea_level(fixed = false, min = 0.0, max = 15.0) = level.H;
  // output Modelica.SIunits.Position channel_level(fixed = false, min = 0.0, max = 5.0) = level_orifice.H;
  Deltares.ChannelFlow.SimpleRouting.Branches.Integrator integrator1 annotation(
    Placement(visible = true, transformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(weir_drainage.HQDown, level_drain.HQ) annotation(
    Line(points = {{-95, 20}, {-110, 20}, {-110, 20}, {-110, 20}}, color = {0, 0, 255}));
  connect(drainage_channel.HQ, weir_drainage.HQUp) annotation(
    Line(points = {{-45, 20}, {-75, 20}, {-75, 20}, {-75, 20}}, color = {0, 0, 255}));
  connect(weir_main_channel.HQDown, level_main.HQ) annotation(
    Line(points = {{-95, -20}, {-120, -20}, {-120, -20}, {-115, -20}}, color = {0, 0, 255}));
  connect(main_channel.HQ, weir_main_channel.HQUp) annotation(
    Line(points = {{-40, -20}, {-75, -20}, {-75, -20}, {-75, -20}}, color = {0, 0, 255}));
  connect(pump.HQDown, main_channel.HQ) annotation(
    Line(points = {{-10, -20}, {-40, -20}, {-40, -22}}, color = {0, 0, 255}));
  connect(orifice.HQDown, drainage_channel.HQ) annotation(
    Line(points = {{-8, 20}, {-30, 20}, {-30, 22}, {-45, 22}}, color = {0, 0, 255}));
  connect(storage.HQ, orifice.HQUp) annotation(
    Line(points = {{40.022, 0}, {40.022, 20}, {8, 20}}, color = {0, 0, 255}));
  connect(storage.HQ, pump.HQUp) annotation(
    Line(points = {{40.022, 0}, {40, -20}, {8, -20}}, color = {0, 0, 255}));
  connect(discharge.HQ, storage.HQ) annotation(
    Line(points = {{52, 0}, {40.022, 0}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-148.5, -105}, {148.5, 105}}, initialScale = 0.1, grid = {5, 5})));
end Example;