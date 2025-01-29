#!/usr/bin/env janet

(import ./conf)
(import ./utils :as u)

########################################################################

(defn main
  [& argv]
  (def force
    (or (os/getenv "JTZ_FORCE")
        (when (> (length argv) 1)
          (when-let [argv-1 (get argv 1)]
            (or (= "-f" argv-1)
                (= "--force" argv-1))))))

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
        :jeat-test-dir-name jeat-test-dir-name}
    (conf/init))
  #
  (when (not (os/stat jeat-dir-name))
    (exit-with-logf "did not find %s, aborting" jeat-dir-name))
  (when (not (u/is-dir? jeat-dir-name))
    (exit-with-logf "%s is not a directory, aborting" jeat-dir-name))
  (logf "Verified %s dir exists." jeat-dir-name)
  (when (not (u/is-dir? jeat-test-dir-name))
    (exit-with-logf "%s dir not found, aborting" jeat-test-dir-name))
  (logf "Verified %s dir exists." jeat-test-dir-name)
  #
  (def gsv-result
    (os/execute ["git" "subrepo" "--version"]
                :p
                {:out (file/temp)}))
  (when (not (zero? gsv-result))
    (exit-with-logf "failed to run git subrepo, is it installed?"))
  (logf "Verified git subrepo command is available.")
  #
  (when (not force)
    (print "WARNING: this will attempt to update a directory.")
    (print "Specifically:")
    (printf "* %s" jeat-dir-name)
    (print "Please check for uncommitted / untracked work before continuing.")
    (def response (getline "Proceed? [y/N] "))
    (when (not (string/has-prefix? "y" (string/ascii-lower response)))
      (print "Ok, bye!")
      (os/exit 1)))
  #
  (with [of (file/temp)]
    (with [ef (file/temp)]
      (def gsp-result
        (os/execute ["git" "subrepo" "pull" jeat-dir-name]
                    :p
                    {:err ef :out of}))
      (when (not (zero? gsp-result))
        (file/seek ef :set 0)
        (def err-content (file/read ef :all))
        (exit-with-logf "subrepo pull of jeat failed with exit code: %d\n%s"
                        gsp-result err-content)))
    (logf "Subrepo pull of jeat succeeded."))
  #
  (when (not (nil? (os/getenv "VERBOSE")))
    (dump-log))
  #
  (print)
  (print "Congratulations, jeat was successfully updated.")
  (print `Please verify correct operation via "jpm test".`)
  (print "If there is a problem, consider rolling back to the previous commit."))

