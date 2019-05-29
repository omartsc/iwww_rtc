model Example
  // Declare Model Elements
  Deltares.ChannelFlow.Hydraulic.Storage.Linear UWB(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 0.1)) annotation(
    Placement(visible = true, transformation(origin = {45, 65}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Storage.Linear TSP(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.0, max = 0.6)) annotation(
    Placement(visible = true, transformation(origin = {-87.978, -5}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Discharge ZFL annotation(
    Placement(visible = true, transformation(origin = {-135, -5}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Discharge EZG annotation(
    Placement(visible = true, transformation(origin = {-135, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Deltares.ChannelFlow.Hydraulic.Storage.Linear2 TSP2(A = 1.0e6, H_b = 0.0, HQ.H(min = 0.6, max = 1.0)) annotation(
    Placement(visible = true, transformation(origin = {-95, 65}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump KBW annotation(
    Placement(visible = true, transformation(origin = {-95, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump KBW_2 annotation(
    Placement(visible = true, transformation(origin = {-15, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.Structures.Pump KBW_3 annotation(
    Placement(visible = true, transformation(origin = {85, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Deltares.ChannelFlow.Hydraulic.BoundaryConditions.Level WSP annotation(
    Placement(visible = true, transformation(origin = {130, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  
  // Define Input/Output Variables and set them equal to model variables
  input Boolean is_TSP_full;
  input Boolean is_TSP2_full;
  input Modelica.SIunits.Position H_TSP_full(fixed = true);
  input Modelica.SIunits.Position H_TSP2_full(fixed = true);
  input Modelica.SIunits.VolumeFlowRate Q_ZFL(fixed = true) = ZFL.Q;
  input Modelica.SIunits.VolumeFlowRate Q_EZG(fixed = true) = EZG.Q;
  input Modelica.SIunits.VolumeFlowRate Q_KBW_3(fixed = false, min = 0.0, max = 18.0) = KBW_3.Q;
  input Modelica.SIunits.VolumeFlowRate Q_KBW_2(fixed = false, min = 0.0, max = 18.0) = KBW_2.Q;
  input Modelica.SIunits.VolumeFlowRate Q_KBW(fixed = false, min = 0.0, max = 18.0) = KBW.Q;
  output Modelica.SIunits.Position WSP_TSP = TSP.HQ.H;
  output Modelica.SIunits.Position WSP_TSP2 = TSP2.HQ.H;
  output Modelica.SIunits.Position WSP_UWB = UWB.HQ.H;
  
equation
  connect(EZG.HQ, TSP.HQ) annotation(
    Line(points = {{-127, -25}, {-98, -25}, {-98, -5}}, color = {0, 0, 255}));
  connect(KBW_3.HQDown, WSP.HQ) annotation(
    Line(points = {{93, 55}, {105.5, 55}, {105.5, 55}, {123, 55}, {123, 55}, {120.5, 55}, {120.5, 55}, {118, 55}}, color = {0, 0, 255}));
  connect(UWB.HQ, KBW_3.HQUp) annotation(
    Line(points = {{45, 57}, {52.5, 57}, {52.5, 57}, {60, 57}, {60, 55}, {75, 55}}, color = {0, 0, 255}));
  connect(KBW_2.HQDown, UWB.HQ) annotation(
    Line(points = {{-7, 55}, {43, 55}, {43, 56}, {43, 56}, {43, 57}}, color = {0, 0, 255}));
  connect(TSP2.HQ, KBW_2.HQUp) annotation(
    Line(points = {{-95, 57}, {-60, 57}, {-60, 52}, {-25, 52}, {-25, 52}, {-25, 52}, {-25, 57}, {-25, 57}}, color = {0, 0, 255}));
  connect(KBW.HQDown, TSP2.HQ) annotation(
    Line(points = {{-95, 38}, {-97.5, 38}, {-97.5, 38}, {-95, 38}, {-95, 53}, {-95, 53}, {-95, 53}, {-95, 53}}, color = {0, 0, 255}));
  connect(TSP.HQ, KBW.HQUp) annotation(
    Line(points = {{-95.978, -5}, {-94.978, -5}, {-94.978, 22}}, color = {0, 0, 255}));
  connect(ZFL.HQ, TSP.HQ) annotation(
    Line(points = {{-127, -5}, {-96, -5}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-148.5, -105}, {148.5, 105}}, initialScale = 0.1, grid = {5, 5})));
end Example;