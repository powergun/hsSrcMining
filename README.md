# Program Source Mining

## Inspiration: Megaparsec

see: <https://markkarpov.com/tutorial/megaparsec.html>

## Inspiration: Bidirectional TOML Serialization

see: <https://kowainik.github.io/posts/2019-01-14-tomland>


## How to build

### Prerequisite

- Haskell stack

[Install haskell stack on Linux, Mac and Windows](https://docs.haskellstack.org/en/stable/install_and_upgrade/)

### Compile, Install and Run sca (Static Code Analysis) tools

```shell
cd sca
stack test
# install sca tools to /Users/${USER}/.local/bin
# to print installation path, run `stack path --local-bin`
stack install

# run sca-walk:
cd <your_repo>
sca-walk .

# or
sca-walk <path_to_your_repo>
```
