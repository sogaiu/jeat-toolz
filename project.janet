(declare-project
  :name "jeat-toolz"
  :url "https://github.com/sogaiu/jeat-toolz"
  :repo "git+https://github.com/sogaiu/jeat-toolz.git")

(declare-source
  :source @["jtz"])

(declare-binscript
  :main "bin/jtz"
  :is-janet true)

