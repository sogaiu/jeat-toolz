#!/usr/bin/env janet

# uses git
# uses git subrepo

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
  (logf "Verified %s is a git repository root." (os/cwd))
  # XXX: possibly nicer to check whether something is uncommitted /
  #      untracked beore proceeding?
  #
  (def {:jeat-dir-name jeat-dir-name
        :jeat-repo jeat-repo
        :jeat-conf-name jeat-conf-name
        :jeat-conf-src-path jeat-conf-src-path
        :jeat-test-dir-name jeat-test-dir-name
        :jeat-runner-name jeat-runner-name
        :jeat-runner-src-path jeat-runner-src-path
        :jeat-runner-dest-path jeat-runner-dest-path}
    (conf/init))
  #
  (when (os/stat jeat-dir-name)
    (exit-with-logf "%s already exists" jeat-dir-name))
  (logf "Verified %s dir does not yet exist." jeat-dir-name)
  #
  (def gsv-result
    (os/execute ["git" "subrepo" "--version"]
                :p
                {:out (file/temp)}))
  (when (not (zero? gsv-result))
    (exit-with-logf "failed to run git subrepo, is it installed?"))
  (logf "Verified git subrepo command is available.")
  #
  (def gsc-result
    (os/execute ["git" "subrepo" "clone" jeat-repo jeat-dir-name]
                :p
                {:out (file/temp)}))
  (when (not (zero? gsc-result))
    (exit-with-logf "subrepo clone of jeat failed with exit code: %d"
                    gsc-result))
  (logf "Subrepo clone of jeat succeeded.")
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
  (spit jeat-runner-dest-path (slurp jeat-runner-src-path))
  (logf "Tried to create %s." jeat-runner-dest-path)
  (when (not (os/stat jeat-runner-dest-path))
    (exit-with-logf "failed to install runner in destination: %s"
                    jeat-runner-dest-path))
  (logf "Created %s." jeat-runner-dest-path)
  #
  (if (os/stat jeat-conf-name)
    (logf "Found existing %s, skipping." jeat-conf-name)
    (do
      (spit jeat-conf-name (slurp jeat-conf-src-path))
      (logf "Tried to create %s." jeat-conf-name)))
  (when (not (os/stat jeat-conf-name))
    (exit-with-logf "failed to create conf file: %s"
                    jeat-conf-name))
  (logf "Verified conf file exists at: %s" jeat-conf-name)
  #
  (when (not (nil? (os/getenv "VERBOSE")))
    (dump-log)
    (print))
  #
  (print "Congratulations, jeat was successfully installed.")
  (printf "1. Specify test targets by editing: %s" jeat-conf-name)
  (print `2. After editing, try "jpm test" to see it in action.`)
  (print `3. Once satisfied, consider committing :)`))

