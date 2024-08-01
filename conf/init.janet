# XXX: update return value if there are additions / removals
(defn init
  []
  (setdyn :jeat-dir-name
          (os/getenv "JEAT_DIR_NAME" "jeat"))

  (setdyn :jeat-repo
          (os/getenv "JEAT_REPO"
                     "https://github.com/sogaiu/janet-ex-as-tests"))

  (setdyn :jeat-conf-name
          (os/getenv "JEAT_CONF_NAME"
                     ".jeat.janet"))

  (setdyn :jeat-conf-src-path
          (os/getenv "JEAT_CONF_SRC_PATH"
                     (string (dyn :jeat-dir-name) "/"
                             "default" (dyn :jeat-conf-name))))

  (setdyn :jeat-test-dir-name
          (os/getenv "JEAT_TEST_DIR_NAME" "test"))

  (setdyn :jeat-runner-name
          (os/getenv "JEAT_RUNNER_NAME"
                     "jeat-from-jpm-test.janet"))

  (setdyn :jeat-runner-src-path
          (os/getenv "JEAT_RUNNER_SRC_PATH"
                     (string (dyn :jeat-dir-name) "/"
                             (dyn :jeat-runner-name))))

  (setdyn :jeat-runner-dest-path
          (os/getenv "JEAT_RUNNER_DEST_PATH"
                     (string (dyn :jeat-test-dir-name) "/"
                             (dyn :jeat-runner-name))))

  {:jeat-dir-name (dyn :jeat-dir-name)
   :jeat-repo (dyn :jeat-repo)
   :jeat-conf-name (dyn :jeat-conf-name)
   :jeat-conf-src-path (dyn :jeat-conf-src-path)
   :jeat-test-dir-name (dyn :jeat-test-dir-name)
   :jeat-runner-name (dyn :jeat-runner-name)
   :jeat-runner-src-path (dyn :jeat-runner-src-path)
   :jeat-runner-dest-path (dyn :jeat-runner-dest-path)})
