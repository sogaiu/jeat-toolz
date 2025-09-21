(import ./argv :as av)
(import ./install :as inst)
(import ./update :as upd)
(import ./symlink :as sym)
(import ./uninstall :as uninst)

(def usage
  ``
  Usage: jtz [OPTION]

  Install and manage `jeat` [1] in a Janet project

    -h, --help                   show this output

    -i, --install                install jeat
    -p, --update                 update jeat
    -s, --symlink                symlink jeat
    -u, --uninstall              uninstall jeat

  `jtz` should be invoked from the root directory of
  a Janet project.

  Only one option should be specified per invocation.

  With the `-i` or `--install` option, install `jeat`
  into the project.

  With the `-p` or `--update` option, update `jeat`
  in the project.

  With the `-s` or `--symlink` option, use a symlinked
  version of `jeat` in the project.

  With the `-u` or `--uninstall` option, uninstall `jeat`
  from the project.

  ---

  [1] `jeat` is short for `janet-ex-as-tests`.  See:

    https://github.com/sogaiu/janet-ex-as-tests

  for more details.
  ``)

(defn main
  [& argv]
  (def [opts rest errs]
    (av/parse-argv argv))

  (when (not (empty? errs))
    (each err errs
      (eprint "jtz: " err))
    (eprint "Try 'jtz -h' for usage text.")
    (os/exit 1))

  # XXX: hacky, but way to avoid issues
  (when (> (length opts) 1)
    (eprint "Detected more than one option in invocation, aborting")
    (eprintf "Content of argv was: %n" argv)
    (os/exit 1))

  # usage
  (when (or (empty? opts)
            (opts :help))
    (print usage)
    (os/exit 0))

  (when (opts :install)
    (inst/main @[])
    (os/exit 0))

  (when (opts :update)
    (upd/main @[])
    (os/exit 0))

  (when (opts :symlink)
    (sym/main @[])
    (os/exit 0))

  (when (opts :uninstall)
    (uninst/main @[])
    (os/exit 0)))

