#!/usr/bin/env janet

(import ./conf)
(import ./utils :as u)

########################################################################

(defn main
  [& argv]
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
  (try
    (os/execute ["jpm" "test"] :px)
    ([e]
      (eprint e)))
  #
  (when (not (nil? (os/getenv "VERBOSE")))
    (dump-log))
  #
  (print)
  (print "Congratulations, jpm test was conducted."))

