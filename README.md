# jeat-toolz (jtz)

Tools for installing and managing
[jeat](https://github.com/sogaiu/janet-ex-as-tests) aka
`janet-ex-as-tests`.

## Installation of `jeat-toolz` (`jtz`)

Quick:

```
jpm install https://github.com/sogaiu/jeat-toolz
```

Manual:

```
git clone https://github.com/sogaiu/jeat-toolz
cd look-up-janet-def
jpm install
```

In either case, success should lead to the command `jtz` being
available on `PATH` and a `jtz` directory under `JANET_PATH`.

`jtz` currently depends on [git
subrepo](https://github.com/ingydotnet/git-subrepo), please ensure it
is installed before proceeding.

## Install `jeat` in target project using `jtz`

The TLDR basic flow is:

* get `jeat`'s bits into a target project
* tell `jeat` which files and directories to look in for tests
  by editing `.jeat.janet`
* ensure tests are working via `jpm test`
* commit the changes to the target project

### Get `jeat` into place

For a target project:

```
cd ~/src/target-project
jtz -i
```

This should produce output like:

```
Congratulations, jeat was successfully installed.
1. Specify test targets by editing: .jeat.janet
2. After editing, try `jpm test` to see it in action.
3. Once satisfied, consider committing :)
```

### Tell `jeat` where to look for tests

There should now be a new file named `.jeat.janet` with
content like:

```janet
(defn init
  []
  {# describes what to test - file and dir paths
   :jeat-target-spec
   []
   # describes what to skip - file paths only
   #:jeat-exclude-spec
   #[]
   })
```

At a minimum, specify the files and directories in which to look for
tests by editing the value associated with the `:jeat-target-spec`.

If there are tests under the `my-code` subdirectory of your project
and in a top-level file named `misc.janet`, `.jeat.janet` might end up
looking like this:

```janet
(defn init
  []
  {# describes what to test - file and dir paths
   :jeat-target-spec
   ["my-code"
    "misc.janet"]
   # describes what to skip - file paths only
   #:jeat-exclude-spec
   #[]
   })
```

### Verify `jeat` is working via `jpm test`

Try out `jeat` tests via `jpm test` -- though if there aren't any
`jeat` tests yet, the output might not be so interesting :)

See the [test writing tips
document](https://github.com/sogaiu/janet-ex-as-tests/blob/master/doc_test-writing-tips.md)
at the `jeat` repository for details on writing tests.

### Commit

Once things are working, commit the changes to your target project.
