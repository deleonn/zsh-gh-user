# zsh-gh-user

A lightweight Oh My Zsh plugin that displays your current GitHub CLI account in the prompt.

## Pre-requisites

- ZSH with oh-my-zsh
- gh cli

## Installation

1. `git clone https://github.com/deleonn/zsh-gh-user ~/.oh-my-zsh/custom/plugins/zsh-gh-user`
2. In `.zshrc`:

```
plugins=(zsh-gh-user)
```


## Theme integration

In your `.zshrc` prompt:

```zsh
PROMPT='%~\n$(gh_user_prompt)%# '
```

