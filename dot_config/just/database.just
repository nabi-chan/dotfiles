now := `date +%Y%m%d_%H%M%S`
db_host := "127.0.0.1"
db_user := "root"
db_pass := "1744"

[private]
get-db-size database:
  mysql -h {{db_host}} -u {{db_user}} -p{{db_pass}} -sN -e "SELECT SUM(DATA_LENGTH) FROM information_schema.TABLES WHERE TABLE_SCHEMA = '{{database}}';"

backup-db database:
  #!/usr/bin/env zsh
  set -euo pipefail
  size=$(jg get-db-size {{database}})
  mysqldump -h {{db_host}} -u {{db_user}} -p{{db_pass}} --single-transaction --quick --compression-algorithms=zstd --skip-lock-tables --extended-insert --set-gtid-purged=OFF --disable-keys {{database}} \
    | pv --progress --size $size --rate --bytes --timer --eta > {{database}}_{{now}}.sql
  afplay /System/Library/Sounds/Blow.aiff

restore-db database filepath:
  pv {{filepath}} \
    | mysql -h {{db_host}} -u {{db_user}} -p{{db_pass}} --init-command="SET autocommit=0" --compression-algorithms=zstd {{database}}
  afplay /System/Library/Sounds/Blow.aiff
