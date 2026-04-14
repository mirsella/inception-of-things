# inception-of-things

Infrastructure learning repo built around Vagrant, K3s, K3d, and Argo CD.

## Layout

- `p1`: two VMs, one K3s server and one worker.
- `p2`: one K3s VM serving multiple apps through ingress.
- `p3`: K3d + Argo CD setup.
- `bonus`: extended local setup with GitLab.

## What Each Part Covers

- `p1` is the basic cluster exercise: bootstrap K3s on one VM and join a worker.
- `p2` moves to app deployment and hostname-based ingress.
- `p3` introduces GitOps with Argo CD on top of a local K3d cluster.
- `bonus` expands the setup with a local GitLab instance and extra automation scripts.

## Run a part

```bash
cd p1
vagrant up
```

Use the same pattern for `p2` and `p3`.

## Bonus

```bash
cd bonus
sudo bash everything.sh run
```

## Notes

- These setups are meant for local learning labs, not production deployment.
- IPs, forwarded ports, and some repo references are hardcoded for convenience.
- Some helper scripts in `bonus/` are destructive and remove local tooling or clusters.
