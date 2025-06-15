# Gould_LCSS2025

This repository contains the code for the LCSS / ACC joint submission "Automatic and Scalable Safety Verification using Interval Reachability with Subspace Sampling".

## Installation

This repository depends on [`immrax`](https://github.com/gtfactslab/immrax), an interval reachability toolbox in JAX.  Currently, `immrax` is not available on PyPI and must be installed manually.  We recommend creating a conda environment to install `immrax`:

```bash
conda create -n immrax python=3.11
conda activate immrax
pip install --upgrade pip
```

For convenience, we have bundled `immrax` as a submodule in this repository. You may install it from the subdirectory: 

```bash
pip install -e ./immrax[examples]
```

If you have a cuda-enabled device you would like to utilize, please make sure to install the optional dependency group: 

```bash
pip install -e ./immrax[cuda,examples]
```

## Examples

For each of the four examples in the paper, there is corresponding code to produce the results presented: 

1. Example 1: `null_basis_consistency.m`
2. Example 2: `van_der_pol.py`
3. Example 3: `chem.ipynb`
4. Example 4: `platoon.ipynb` and `cora_comparison/platoon_reach.m`
