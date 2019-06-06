
import numpy as np

from rtctools.optimization.collocated_integrated_optimization_problem \
    import CollocatedIntegratedOptimizationProblem
from rtctools.optimization.csv_mixin import CSVMixin
from rtctools.optimization.modelica_mixin import ModelicaMixin
from rtctools.util import run_optimization_problem


class Example(CSVMixin, ModelicaMixin, CollocatedIntegratedOptimizationProblem):
    """
    This class is the optimization problem for the Example. Within this class,
    the objective, constraints and other options are defined.
    """

    # This is a method that returns an expression for the objective function.
    # RTC-Tools always minimizes the objective.
    def objective(self, ensemble_member):

        # Minimize water pumped. The total water pumped is the integral of the
        # water pumped from the starting time until the stoping time. In
        # practice, self.integral() is a summation of all the discrete states.

        return self.integral('Q_KBW_3', ensemble_member)

    # A path constraint is a constraint where the values in the constraint are a
    # Timeseries rather than a single number.
    def path_constraints(self, ensemble_member):
        # Call super to get default constraints
        constraints = super().path_constraints(ensemble_member)

        # es werden 2 boolsche Variablen mitoptimiert zur Steuerung
        # von 2 Pumpen-Elemente (Q_KBW und Q_KBW_2)

        # die maximale Wasserspiegel für die Steuerung wird für jeden
        # Zeitschritt im timeseries_import.csv gesetzt. Diese Werte
        # müssen nicht die gleichen wie in den hard constraints sein

        constraints.append(
            (self.state('Q_KBW') + (1 - self.state('is_TSP_full')) * 18,
                0.0, 18.0))

        constraints.append(
            (self.state('Q_KBW_2') + (1 - self.state('is_TSP2_full')) * 18,
                0.0, 18.0))

        M = 2
        constraints.append(
            (self.state('H_TSP_full') - self.state('TSP.HQ.H')
                - (1 - self.state('is_TSP_full')) * M,
                -np.inf, 0.0))

        constraints.append((self.state('H_TSP_full') - self.state('TSP.HQ.H')
                            + self.state('is_TSP_full') * M, 0.0, np.inf))

        constraints.append(
            (self.state('H_TSP2_full') - self.state('TSP2.HQ.H')
                - (1 - self.state('is_TSP2_full')) * M,
                -np.inf, 0.0))

        constraints.append((self.state('H_TSP2_full') - self.state('TSP2.HQ.H')
                            + self.state('is_TSP2_full') * M, 0.0, np.inf))

        # TSP und TSP2 werden im Modelica durch 2 unterschiedliche Klassen
        # definiert(Linear und Linear2), so dass sie 2 verschiedene
        # Volumen-Funktionen verwenden.

        constraints.append((self.state('TSP.HQ.H'), 0.1, 0.6))

        constraints.append((self.state('TSP2.HQ.H'), 0.6, 0.85))

        constraints.append((self.state('UWB.HQ.H'), 0.1, 1.0))

        return constraints

    # Any solver options can be set here
    def solver_options(self):
        options = super().solver_options()
        # Restrict solver output
        solver = options['solver']
        options[solver]['print_level'] = 1
        return options


# Run
run_optimization_problem(Example)
