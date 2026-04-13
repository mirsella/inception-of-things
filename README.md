# inception-of-things

Infrastructure learning repo built around Vagrant, K3s, K3d, and Argo CD.

## Layout

- `p1`: two VMs, one K3s server and one worker.
- `p2`: one K3s VM serving multiple apps through ingress.
- `p3`: K3d + Argo CD setup.
- `bonus`: extended local setup with GitLab.

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
