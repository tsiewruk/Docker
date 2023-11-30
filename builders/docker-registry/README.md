## How push image do remote docker-registry.

---

If you want to send an image to an external docker-registry you need to edit the file  `/etc/docker/daemon.json`.

```
{
    "insecure-registries": ["<REMOTE_HOST>:5000"]
}
```