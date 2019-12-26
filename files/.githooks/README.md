# Custom git hook deployment

Allows usage of global hooks and/or repo-specific hooks.
Note: `~/.githooks` is used in examples as the global hook directory.

## Configuration
The "default" configuration is to use the global hooks directory.
This has been configured by doing
```
git config --global core.hookspath ~/.githooks/hooks
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
  git config --local core.hookmergestrategy <val>
  ```
  where `<val>` can be 0 or 1:
  * 0: if a corresponding local hook exists, skip the global hook. Otherwise, run the global hook.
  * 1: run global hooks, then local hooks, if they exist.
* If `core.hookmergestrategy` is not set, then it will default to option 0.


### Constructing a global hook
1. Make sure a symlink exists for the hook in `~/.githooks/hooks` and is linked to `~/.githooks/helpers/_hook_init`. This can be done by updating `~/.githooks/generate-symlinks.sh`, if necessary.
2. Create the actual hook by adding a bash script in `~/.githooks/hooks.d` with a `_run ()` function that contains the actual hook script.


## TODO
Actual
Some strategy for managing individual hooks to use global, local, or both.
Maybe a JSON config file...
