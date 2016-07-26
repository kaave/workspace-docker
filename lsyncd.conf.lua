local homeDir = os.getenv("HOME")

settings {
  logfile = "/tmp/lsyncd.log",
  statusFile = "/tmp/lsyncd-status.log",
  maxProcesses = 2,
  delay = 3,
  -- not launch daemon mode
  nodaemon = true,
}

sync {
  default.rsync,
  -- your working directory
  source = homeDir.."/workspace/work",
  target = "localhost:/home/kaave/work",
  delete  = false,
  exclude = {
    ".DS_Store",
    ".git/**",
    ".gitkeep",
    -- for sass
    ".sass-cache/**",
    -- for npm
    "node_modules/**",
    "typings/**",
    -- for rails
    ".bundle/**",
    "log/**",
    "tmp/**",
    "db/*.sqlite3",
    "db/*.sqlite3-journal",
    "coverage/**",
    "spec/tmp/**",
    "vendor/bundle/**",
    -- for Phoenix framework
    "deps/**",
    "_build/**",
    "priv/static/**"
  },
  rsync = {
    verbose  = false,
    archive  = true,
    links    = true,
    update   = true,
    binary   = "/usr/local/bin/rsync",
    rsh = "/usr/bin/ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 -i "..homeDir.."/.ssh/id_rsa",
  }
}
