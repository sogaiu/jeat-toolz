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
        :jeat-test-dir-name jeat-test-dir-name
        :jeat-runner-name jeat-runner-name
        :jeat-runner-src-path jeat-runner-src-path
        :jeat-runner-dest-path jeat-runner-dest-path
        :jeat-dev-path jeat-dev-path}
    (conf/init))
  #
  (when (os/stat jeat-dir-name)
    (exit-with-logf "found %s, aborting" jeat-dir-name))
  (logf "Verified %s dir does not exist." jeat-dir-name)
  #
  (os/link jeat-dev-path jeat-dir-name true)
  (when (not (os/stat jeat-dir-name))
    (exit-with-logf "failed to create symlink from %s to %s"
                    jeat-dir-name jeat-dev-path))
  (logf "Symlink creation succeeded.")
  #
  (when (not (os/stat jeat-test-dir-name))
    (os/mkdir jeat-test-dir-name)
    (logf "Tried to create %s dir." jeat-test-dir-name))
  #
  (when (not (u/is-dir? jeat-test-dir-name))
    (exit-with-logf "%s subdir not found and failed to create one"
                    jeat-test-dir-name))
  (logf "Verified %s dir exists." jeat-test-dir-name)
  #
  (when (os/stat jeat-runner-dest-path)
    (exit-with-logf "%s already exists, aborting"
                    jeat-runner-dest-path))
  (logf "Verified %s does not yet exist in %s dir."
        jeat-runner-name jeat-test-dir-name)
  #
  (os/link (string "../" jeat-runner-src-path)
           jeat-runner-dest-path true)
  (logf "Tried to create symlink %s." jeat-runner-dest-path)
  (when (not (os/stat jeat-runner-dest-path))
    (exit-with-logf "failed to symlink runner to: %s"
                    jeat-runner-dest-path))
  (logf "Created symlink: %s." jeat-runner-dest-path)
  #
  (when (not (nil? (os/getenv "VERBOSE")))
    (dump-log))
  #
  (print)
  (print "Congratulations, dev version of jeat was successfully linked.")
  (print `Please verify correct operation via "jpm test".`))

