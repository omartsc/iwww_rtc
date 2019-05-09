model Example

  // Declare Model Elements
  
  Deltares.ChannelFlow.Hydraulic.Storage.Linear2 TSP(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 0.8)) annotation(
    Placement(visible = true, transformation(origin = {-57.978, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Discharge ZFL annotation(
    Placement(visible = true, transformation(origin = {-115, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Discharge EZG annotation(
    Placement(visible = true, transformation(origin = {-115, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Deltares.ChannelFlow.Hydraulic.Storage.Linear2 UWB(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 2.0)) annotation(
    Placement(visible = true, transformation(origin = {15, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump KBW annotation(
    Placement(visible = true, transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump KBW_2 annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Level WSP annotation(
    Placement(visible = true, transformation(origin = {95, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));


  // Define Input/Output Variables and set them equal to model variables
  input Boolean is_full;
  input Modelica.SIunits.Position H_full(fixed=true);
  input Modelica.SIunits.VolumeFlowRate Q_ZFL(fixed = true) = ZFL.Q;
  input Modelica.SIunits.VolumeFlowRate Q_EZG(fixed = true) = EZG.Q;
  input Modelica.SIunits.VolumeFlowRate Q_KBW_2(fixed = false, min = 0.0, max = 18.0) = KBW_2.Q;
  input Modelica.SIunits.VolumeFlowRate Q_KBW(fixed = false, min = 0.0, max = 18.0) = KBW.Q;
  output Modelica.SIunits.Position WSP_TSP = TSP.HQ.H;
  output Modelica.SIunits.Position WSP_UWB = UWB.HQ.H;
equation
  connect(ZFL.HQ, TSP.HQ) annotation(
    Line(points = {{-105, 20}, {-65, 20}, {-65, 0}, {-65, 0}}, color = {0, 0, 255}));
  connect(TSP.HQ, KBW.HQUp) annotation(
    Line(points = {{-65, 0}, {-75, 0}, {-75, 40}, {-38, 40}}, color = {0, 0, 255}));
  connect(KBW_2.HQDown, WSP.HQ) annotation(
    Line(points = {{60, 20}, {85, 20}, {85, 20}, {85, 20}}, color = {0, 0, 255}));
  connect(UWB.HQ, KBW_2.HQUp) annotation(
    Line(points = {{15, 40}, {15, 40}, {15, 20}, {40, 20}, {40, 20}}, color = {0, 0, 255}));
  connect(KBW.HQDown, UWB.HQ) annotation(
    Line(points = {{-22, 40}, {16.5, 40}, {16.5, 42}, {15, 42}}, color = {0, 0, 255}));
  connect(EZG.HQ, TSP.HQ) annotation(
    Line(points = {{-105, -25}, {-65, -25}, {-65, 0}, {-65, 0}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-148.5, -105}, {148.5, 105}}, initialScale = 0.1, grid = {5, 5})));
end Example;