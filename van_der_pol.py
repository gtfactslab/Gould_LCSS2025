import pickle
from typing import Literal, Tuple
import time

import jax
import jax.numpy as jnp

import immrax as irx
from immrax.embedding import AuxVarEmbedding
from immrax.system import Trajectory
from immrax.utils import (
    angular_sweep,
    run_times,
)


backend = "cpu"


class VanDerPolOsc(irx.System):
    def __init__(self, mu: float = 1) -> None:
        self.evolution = "continuous"
        self.xlen = 2
        self.name = "Van der Pol Oscillator"
        self.mu = mu

    def f(self, t, x: jnp.ndarray) -> jnp.ndarray:
        x1, x2 = x.ravel()
        return jnp.array([self.mu * (x1 - 1 / 3 * x1**3 - x2), x1 / self.mu])


def angular_refined_trajectory(
    num_aux_vars: int, mode: Literal["sample", "linprog"], save: bool = False
) -> Tuple[Trajectory, jax.Array]:
    # Generate angular sweep aux vars
    # Odd num_aux_var is not a good choice, as it will generate angle theta=pi/2, which is redundant with the actual state vars
    aux_vars = angular_sweep(num_aux_vars)
    H = jnp.vstack([jnp.eye(2), aux_vars])
    lifted_x0_int = irx.interval(H) @ x0_int

    # Compute refined trajectory
    auxsys = AuxVarEmbedding(sys, H, mode=mode)
    print("Compiling...")
    start = time.time()
    get_traj = jax.jit(
        lambda t0, tf, x0: auxsys.compute_trajectory(t0, tf, x0, solver="euler"),
        backend=backend,
    )
    get_traj(0.0, 0.01, irx.i2ut(lifted_x0_int))
    print(f"Compilation took: {time.time() - start:.4g}s")
    print("Compiled.\nComputing trajectory...")
    traj, comp_time = run_times(
        10,
        get_traj,
        0.0,
        sim_len,
        irx.i2ut(lifted_x0_int),
    )
    print(
        f"Computing trajectory with {mode} refinement for {num_aux_vars} aux vars took: {comp_time.mean():.4g} ± {comp_time.std():.4g}s"
    )

    ys_int = [irx.ut2i(y) for y in traj.ys]
    final_bound = ys_int[-1][2:]
    final_bound_size = (final_bound[0].upper - final_bound[0].lower) * (
        final_bound[1].upper - final_bound[1].lower
    )
    print(f"Final bound: \n{final_bound}, size: {final_bound_size}")

    if save:
        pickle.dump(ys_int, open(f"{mode}_traj_{num_aux_vars}.pkl", "wb"))

    return traj, H


x0_int = irx.icentpert(jnp.array([1.0, 0.0]), jnp.array([0.1, 0.1]))
sim_len = 2 * jnp.pi

sys = VanDerPolOsc()  # Can use an arbitrary system here
for i in range(2, 7, 2):
    traj_s, H = angular_refined_trajectory(i, "sample")
    traj_lp, H = angular_refined_trajectory(i, "linprog")
