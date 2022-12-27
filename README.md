# Home Server

Configuration files and documentations for DIY home server

## Composing docker

```bash
docker-compose $(find docker* | sed -e 's/^/-f /') up -d
```

---
