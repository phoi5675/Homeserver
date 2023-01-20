# Home Server

## 서버 구조

- `structure.drawio` 참고

## 백업 정책

- Proxmox

  - Truenas 제외, `HDD/Backup/`에 저장
  - 매달 1일에 Incremental backup 실행
  - Proxmox Backup Server 이용

- Truenas

  - truenas 자체적으로 백업
  - `HDD/Backup/truenas_backup/`에 저장
  - rsync 이용, 매월 1일 새벽 4시에 백업

  ```bash
   rsync -aAXv / --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} /mnt/HDD/Backup/truenas_backup
  ```
