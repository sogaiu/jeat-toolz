#!/usr/bin/env janet

(import ./conf)
(import ./utils :as u)

########################################################################

(defn main
  [& argv]
  (def force
    (when (> (length argv) 1)
      (when-let [argv-1 (get argv 1)]
        (or (= "-f" argv-1)
            (= "--force" argv-1)))))

  (def {:logf logf
        :dump-log dump-log
        :exit-with-logf exit-with-logf}
    (u/make-log-bits))
  #
  (when (not (u/is-dir? ".git"))
    (exit-with-logf "needs to be run in a git repository root dir"))
  (logf "Verified git repository root at: %s." (os/cwd))
  #
  (def {:jeat-dir-name jeat-dir-name
        :jeat-runner-dest-path jeat-runner-dest-path}
    (conf/init))
  #
  (when (not (os/stat jeat-dir-name))
    (exit-with-logf "did not find %s, aborting" jeat-dir-name))
  (when (not (u/is-dir? jeat-dir-name))
    (exit-with-logf "%s is not a directory, aborting" jeat-dir-name))
  (logf "Verified %s dir exists." jeat-dir-name)
  #
  (when (not (os/stat jeat-runner-dest-path))
    (exit-with-logf "did not find %s, aborting" jeat-runner-dest-path))
  (when (not (u/is-file? jeat-runner-dest-path))
    (exit-with-logf "%s is not a file, aborting" jeat-runner-dest-path))
  (logf "Verified %s exists." jeat-runner-dest-path)
  #
  (when (not force)
    (print "WARNING: this will attempt to remove a file and a directory.")
    (print "Specifically:")
    (printf "* %s" jeat-runner-dest-path)
    (printf "* %s" jeat-dir-name)
    (print "Please check for uncommitted / untracked work before continuing.")
    (def response (getline "Proceed? [y/N] "))
    (when (not (string/has-prefix? "y" (string/ascii-lower response)))
      (print "Ok, bye!")
      (os/exit 1)))
  #
  (os/rm jeat-runner-dest-path)
  (when (os/stat jeat-runner-dest-path)
    (exit-with-logf "failed to delete runner script: %s"
                    jeat-runner-dest-path))
  (logf "Deleted %s." jeat-runner-dest-path)
  #
  (u/del-tree jeat-dir-name)
  (when (os/stat jeat-dir-name)
    (exit-with-logf "failed to delete jeat dir: %s"
                    jeat-dir-name))
  (logf "Deleted %s." jeat-dir-name)
  #
  (when (not (nil? (os/getenv "VERBOSE")))
    (dump-log))
  #
  (print)
  (print "Congratulations, jeat was successfully uninstalled.")
  (print "If there was a configuration, it should not have been removed.")
  (print "If this was meant to be permanent, consider committing :)"))

