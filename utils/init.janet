(defn make-log-bits
  []
  (def log @[])

  (defn logf
    [fmt & args]
    (array/push log (string/format fmt ;args)))

  (defn dump-log
    []
    (each line log (print line)))

  (defn exit-with-logf
    [msg & args]
    (dump-log)
    (eprintf msg ;args)
    (os/exit 1))

  {:log log
   :logf logf
   :dump-log dump-log
   :exit-with-logf exit-with-logf})

########################################################################

(defn is-dir?
  [path]
  (= :directory (os/stat path :mode)))

(defn is-file?
  [path]
  (= :file (os/stat path :mode)))

# XXX: only work with :file, :link, :directory, nothing else
(defn del-tree
  [path]
  (def stat-mode (os/lstat path :mode))
  (cond
    (or (= :file stat-mode)
        (= :link stat-mode))
    (os/rm path)
    #
    (= :directory stat-mode)
    (do
      (each child-path (os/dir path)
        (del-tree (string path "/" child-path)))
      (os/rmdir path))
    #
    (errorf "unexpected object of type: %s" stat-mode)))
