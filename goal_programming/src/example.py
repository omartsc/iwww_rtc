import numpy as np

from rtctools.optimization.collocated_integrated_optimization_problem \
    import CollocatedIntegratedOptimizationProblem
from rtctools.optimization.csv_mixin import CSVMixin
from rtctools.optimization.goal_programming_mixin \
    import Goal, GoalProgrammingMixin, StateGoal
from rtctools.optimization.modelica_mixin import ModelicaMixin
from rtctools.util import run_optimization_problem


# class WaterLevelRangeGoal(StateGoal):
#     # Applying a state goal to every time step is easily done by defining a goal
#     # that inherits StateGoal. StateGoal is a helper class that uses the state
#     # to determine the function, function range, and function nominal
#     # automatically.
#     state = 'storage.HQ.H'
#     # One goal can introduce a single or two constraints (min and/or max). Our
#     # target water level range is 0.43 - 0.44. We might not always be able to
#     # realize this, but we want to try.
#     target_min = 0.43
#     target_max = 0.44
#
#     # Because we want to satisfy our water level target first, this has a
#     # higher priority (=lower number).
#     priority = 1

# class WasserspiegelZiel(StateGoal):
#     # Applying a state goal to every time step is easily done by defining a goal
#     # that inherits StateGoal. StateGoal is a helper class that uses the state
#     # to determine the function, function range, and function nominal
#     # automatically.
#     state = 'storage.HQ.H'
#     # One goal can introduce a single or two constraints (min and/or max). Our
#     # target water level range is 0.43 - 0.44. We might not always be able to
#     # realize this, but we want to try.
#     target_min = 0.3
#     target_max = 0.3
#
#     # Because we want to satisfy our water level target first, this has a
#     # higher priority (=lower number).
#     priority = 1

class OptimaleGrenzen(StateGoal):

    state = 'pump.Q'

    target_min = 6.0
    target_max = 17.0

    priority = 1

class WirtschaftlichesZiel(StateGoal):

    state = 'pump.Q'

    target_min = 10.0
    target_max = 15.0

    priority = 2


class GesamtAbfluss(Goal):

    def function(self, optimization_problem, ensemble_member):
        return optimization_problem.integral('Q_outpump')

    # The nominal is used to scale the value returned by
    # the function method so that the value is on the order of 1.
    function_nominal = 100.0
    priority = 3
    # The penalty variable is taken to the order'th power.
    order = 1


class MinimizeChangeInQpumpGoal(Goal):
    # To reduce pump power cycles, we add a third goal to minimize changes in
    # Q_pump. This will be passed into the optimization problem as a path goal
    # because it is an an individual goal that should be applied at every time
    # step.
    def function(self, optimization_problem, ensemble_member):
        return optimization_problem.der('Q_outpump')
    function_nominal = 5.0
    priority = 4
    # Default order is 2, but we want to be explicit
    order = 2


class Example(GoalProgrammingMixin, CSVMixin, ModelicaMixin,
              CollocatedIntegratedOptimizationProblem):
    """
    An introductory example to goal programming in RCT-Tools
    """

    def path_constraints(self, ensemble_member):

        constraints = super().path_constraints(ensemble_member)

        # constraints.append((self.state('outflow_level'), 0.2, 0.35))
        # constraints.append((self.state('Q_ablass'), 1.0, 3.0))

        return constraints

    def goals(self):
        return [GesamtAbfluss()]

    def path_goals(self):
        return [OptimaleGrenzen(self), MinimizeChangeInQpumpGoal(), WirtschaftlichesZiel(self)]

    def pre(self):
        # Call super() class to not overwrite default behaviour
        super().pre()
        # We keep track of our intermediate results, so that we can print some
        # information about the progress of goals at the end of our run.
        self.intermediate_results = []

    def priority_completed(self, priority):
        # We want to show that the results of our highest priority goal (water
        # level) are remembered. The other information we want to see is how our
        # lower priority goal (Q_pump) progresses. We can write some code that
        # sumerizes the results and stores it.

        # A little bit of tolerance when checking for acceptance, because
        # strictly speaking 0.4299... is smaller than 0.43.
        _min = 0.43 - 1e-4
        _max = 0.44 + 1e-4

        results = self.extract_results()
        n_level_satisfied = sum(
            1 for x in results['storage.HQ.H'] if _min <= x <= _max)
        q_pump_integral = sum(results['Q_pump'])
        q_pump_sum_changes = np.sum(np.diff(results['Q_pump'])**2)
        self.intermediate_results.append(
            (priority, n_level_satisfied, q_pump_integral, q_pump_sum_changes))

    def post(self):
        # Call super() class to not overwrite default behaviour
        super().post()
        for priority, n_level_satisfied, q_pump_integral, q_pump_sum_changes \
                in self.intermediate_results:
            print('\nAfter finishing goals of priority {}:'.format(priority))
            print('Level goal satisfied at {} of {} time steps'.format(
                n_level_satisfied, len(self.times())))
            print('Integral of Q_pump = {:.2f}'.format(q_pump_integral))
            print('Sum of squares of changes in Q_pump: {:.2f}'.format(q_pump_sum_changes))

    # Any solver options can be set here
    def solver_options(self):
        options = super().solver_options()
        solver = options['solver']
        options[solver]['print_level'] = 1
        return options


# Run
run_optimization_problem(Example)
