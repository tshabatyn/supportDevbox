settings {
  logfile    = "/var/log/lsyncd/lsyncd.log",
  statusFile = "/var/log/lsyncd/lsyncd.status",
  nodaemon   = true --<== лучше оставить для дебага. потом выключите.
}
--[[
sync {
  default.rsync, --<== используем rsync для синхронизации. по-идее, можно использовать и что-то другое.
  source="/raid", --<== локальная директория, которую синхронизируем
  target="node01:/raid", --<== dns-имя и директория на ноде-получателе через двоеточие
  rsyncOps={"-ausS", "--temp-dir=/mnt-is"}, --<== temp-dir нужна если синхронизация двухсторонняя.
  delay=10 --<== время, которое будет собираться список событий для синхронизации
}
]]
sync {
  default.rsync,
  source="/opt/data",
  target="/var/www",
--  rsyncOps={"-ausS", "--temp-dir=/tmp/lsyncd"},
  rsync = {
    archive = false,
    compress = false,
    whole_file = true,
    perms = true,
    acls = true,
    owner = true,
    keep_dirlinks = true,
    temp_dir = "/tmp/lsyncd",
    copy_links = true,
--    verbose = false,
    update = true
  },
  delay=3
}
--[[
sync {
  default.rsync,
  source="/opt/data",
  target="/var/www",
  rsyncOps={"-ausS", "--temp-dir=/tmp/lsyncd"},
  delay=10
}]]
