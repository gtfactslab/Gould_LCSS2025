# Gould_LCSS2025

This repository contains the code for the LCSS / ACC joint submission "Automatic and Scalable Safety Verification using Interval Reachability with Subspace Sampling".

## Installation

This repository depends on [`immrax`](https://github.com/gtfactslab/immrax), an interval reachability toolbox in JAX.
Currently, `immrax` is not available on PyPI and must be installed manually.
We recommend creating a conda environment to install `immrax`:

```bash
conda create -n immrax python=3.11
conda activate immrax
pip install --upgrade pip
cd immrax
pip install .
```

This project's other dependencies can be installed with

```bash
pip install -r requirements.txt
```

## Examples


