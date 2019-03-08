model Example
  // Declare Model Elements
  Deltares.ChannelFlow.Hydraulic.Storage.Linear storage(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 0.5)) annotation(
    Placement(visible = true, transformation(origin = {102.022, 5}, extent = {{-10, -10}, {10, 10}}, rotation = -270)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Discharge discharge annotation(
    Placement(visible = true, transformation(origin = {130, 5}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump pump annotation(
    Placement(visible = true, transformation(origin = {70, -15}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump orifice annotation(
    Placement(visible = true, transformation(origin = {70, 25}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Storage.Linear drainage_channel(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 0.3)) annotation(
    Placement(visible = true, transformation(origin = {25, 35}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump weir_drainage annotation(
    Placement(visible = true, transformation(origin = {-15, 25}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump weir_main_channel annotation(
    Placement(visible = true, transformation(origin = {-15, -15}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Storage.Linear main_channel(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 0.5)) annotation(
    Placement(visible = true, transformation(origin = {30, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Deltares.ChannelFlow.Hydraulic.Storage.Linear channel_connect(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 0.8)) annotation(
    Placement(visible = true, transformation(origin = {-60, 5}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump terminal_flow annotation(
    Placement(visible = true, transformation(origin = {-95, 5}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Level terminal_level annotation(
    Placement(visible = true, transformation(origin = {-130, 5}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  
  // Define Input/Output Variables and set them equal to model variables
  input Modelica.SIunits.VolumeFlowRate Q_pump(fixed = true) = pump.Q;
  input Modelica.SIunits.VolumeFlowRate Q_terminal(fixed = true) = terminal_flow.Q;
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
  output Modelica.SIunits.Position channel_connect_level = channel_connect.HQ.H;
  // output Modelica.SIunits.Position sea_level(fixed = false, min = 0.0, max = 15.0) = level.H;
  // output Modelica.SIunits.Position channel_level(fixed = false, min = 0.0, max = 5.0) = level_orifice.H;
  
equation
  connect(terminal_flow.HQDown, terminal_level.HQ) annotation(
    Line(points = {{-103, 5}, {-118, 5}, {-118, 5}, {-118, 5}}, color = {0, 0, 255}));
  connect(channel_connect.HQ, terminal_flow.HQUp) annotation(
    Line(points = {{-68, 5}, {-85, 5}}, color = {0, 0, 255}));
  connect(weir_drainage.HQDown, channel_connect.HQ) annotation(
    Line(points = {{-23, 25}, {-66, 25}, {-66, 15}, {-66, 15}, {-66, 5}}, color = {0, 0, 255}));
  connect(weir_main_channel.HQDown, channel_connect.HQ) annotation(
    Line(points = {{-23, -15}, {-44.5, -15}, {-44.5, -15}, {-66, -15}, {-66, -2.5}, {-66, -2.5}, {-66, 5}}, color = {0, 0, 255}));
  connect(main_channel.HQ, weir_main_channel.HQUp) annotation(
    Line(points = {{30, -17}, {21.25, -17}, {21.25, -17}, {12.5, -17}, {12.5, -17}, {-5, -17}, {-5, -17}, {-5, -17}, {-5, -17}, {-2.5, -17}, {-2.5, -17}, {-5, -17}}, color = {0, 0, 255}));
  connect(pump.HQDown, main_channel.HQ) annotation(
    Line(points = {{62, -15}, {27, -15}, {27, -16}, {32, -16}, {32, -17}}, color = {0, 0, 255}));
  connect(drainage_channel.HQ, weir_drainage.HQUp) annotation(
    Line(points = {{25, 27}, {10, 27}, {10, 22}, {-5, 22}, {-5, 22}, {-5, 22}, {-5, 27}, {-5, 27}}, color = {0, 0, 255}));
  connect(orifice.HQDown, drainage_channel.HQ) annotation(
    Line(points = {{62, 25}, {57.75, 25}, {57.75, 25}, {53.5, 25}, {53.5, 25}, {40, 25}, {40, 27}, {32.5, 27}, {32.5, 27}, {28.75, 27}, {28.75, 27}, {25, 27}}, color = {0, 0, 255}));
  connect(storage.HQ, orifice.HQUp) annotation(
    Line(points = {{110.022, 5}, {110.022, 10}, {110.022, 10}, {110.022, 15}, {110.022, 15}, {110.022, 25}, {96.511, 25}, {96.511, 25}, {87.2555, 25}, {87.2555, 25}, {78, 25}}, color = {0, 0, 255}));
  connect(storage.HQ, pump.HQUp) annotation(
    Line(points = {{110.022, 5}, {110.011, -5}, {110.011, -5}, {110, -15}, {96.5, -15}, {96.5, -15}, {78, -15}}, color = {0, 0, 255}));
  connect(discharge.HQ, storage.HQ) annotation(
    Line(points = {{122, 5}, {110.022, 5}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-148.5, -105}, {148.5, 105}}, initialScale = 0.1, grid = {5, 5})));
end Example;