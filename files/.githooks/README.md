# Custom git hook deployment

Allows usage of global hooks and/or repo-specific hooks.
Note: `~/.githooks` is used in examples as the global hook directory.

## Configuration
The "default" configuration is to use the global hooks directory.
This has been configured by doing
```
git config --global core.hookspath ~/.githooks
```

### Individual repository configuration

#### Using only local hooks
Set `core.hookspath` to some repo-specific path:
```
git config --local core.hookspath .githooks
```


#### Using only global hooks
Do nothing - the global configuration takes care of this.


#### Using both global and local hooks
* Leave `core.hookspath` as the global setting.
* Set `core.localhookspath` to your local hooks directory. Example:
  ```
  git config --local core.localhookspath .githooks
  ```
* Set the merge strategy for combining global and local hooks:
  ```
  git config --local core.hooksmergestrategy <val>
  ```
  where `<val>` can be 0 or 1:
  * 0: if a corresponding local hook exists, skip the global hook. Otherwise, run the global hook.
  * 1: run global hooks, then local hooks, if they exist.
* If `core.hooksmergestrategy` is not set, then it will default to option 0.


### constructing a global hook
* All possible hooks must be instantiated in the global hooks directory.
* They must at least contain the following content:
  ```
  . $(dirname 0)/_check_local_hooks
  ```


## TODO
Some strategy for managing individual hooks to use global, local, or both.
Maybe a JSON config file...
