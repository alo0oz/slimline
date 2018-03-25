## slimline

Modular, fast and elegant ZSH prompt. Displays the right information at the right time.

<p align="center"><img src="screenshot.png" width="682" height="298"></p>

Features:
- sleek look
- modular layout using configurable sections in the left and right prompt
- the appearance of each section can be customized using format strings
- easily extensible using custom sections (which can be optionally asynchronous)
- fast non-blocking prompt using asynchronous information display

Sections:
- prompt symbol which indicates if asynchronous tasks are running
- current working directory which highlights if it is the root `/` directory
- exit code of last command if the exit code is not zero
- runtime of executed command if it exceeds a threshold
- username and hostname if connected to a ssh server or optionally always
- current time of day in 24h or 12h format
- current aws profile
- current python virtualenv
- nodejs version
- customizable git information display

With more information (connected to ssh server, runtime and exit status from last command, aws profile and nodejs version):

<p align="center"><img src="screenshot_full.png" width="857" height="298"></p>

<!-- TOC -->

- [slimline](#slimline)
- [Requirements](#requirements)
    - [Optional](#optional)
- [Installation](#installation)
    - [antigen](#antigen)
    - [zplugin](#zplugin)
    - [zgen](#zgen)
    - [Manually](#manually)
- [Sections and Formats](#sections-and-formats)
- [Legacy Options](#legacy-options)
- [Global Options](#global-options)
    - [Left Prompt](#left-prompt)
    - [Right Prompt](#right-prompt)
    - [Spelling Prompt](#spelling-prompt)
- [Built-in Sections](#built-in-sections)
    - [Prompt Symbol (`symbol`)](#prompt-symbol-symbol)
    - [Current Working Directory (`cwd`)](#current-working-directory-cwd)
    - [Exit Status (`exit_status`)](#exit-status-exit_status)
    - [Execution Time (`execution_time`)](#execution-time-execution_time)
    - [User and Host Info (`user_host_info`)](#user-and-host-info-user_host_info)
    - [Time (`time`)](#time-time)
    - [AWS Profile (`aws_profile`)](#aws-profile-aws_profile)
    - [Python Virtualenv (`virtualenv`)](#python-virtualenv-virtualenv)
    - [Node.js (`nodejs`) *async*](#nodejs-nodejs-async)
    - [Git (`git`) *async*](#git-git-async)
- [Custom Sections](#custom-sections)
    - [Functions](#functions)
        - [Render](#render)
        - [Init](#init)
        - [Preexec](#preexec)
        - [Precmd](#precmd)
        - [Async Task](#async-task)
        - [Async Task Complete](#async-task-complete)
    - [Utility Functions](#utility-functions)
        - [Section Format Expansion](#section-format-expansion)
        - [Logging](#logging)
        - [Callable Check](#callable-check)
    - [Complete Examples](#complete-examples)
        - [Minimal Section](#minimal-section)
        - [Section with init function](#section-with-init-function)
        - [Section with asynchronous task](#section-with-asynchronous-task)
- [Example](#example)
- [Thanks](#thanks)
- [License](#license)

<!-- /TOC -->

## Requirements

* zsh

### Optional

* python 2.6+ to enable git information display

## Installation

Choose one of the methods below.

### antigen

```
antigen bundle mgee/slimline
```

### zplugin

```
zplugin load mgee/slimline
```

### zgen

```
zgen load mgee/slimline
```

### Manually

Clone the repository:

```shell
git clone --recursive https://github.com/mgee/slimline.git
```

Source the prompt in your `.zshrc` (or other appropriate) file:

```shell
source <path-to-slimline>/slimline.zsh
```

## Sections and Formats

Slimline has two prompts. The left and right prompt. In each prompt sections can be placed and
ordered. The appearance of each section can be completely customized.

A section displays information like the current directory or the git status. Slimline provides
a number of sections by default but can also be extended with [custom sections](#custom-sections).
Each sections has a format string which can be customized to change the color or text
inside the section.

Inside the format of the section placeholders can be used which will be replaced with information
specific to this section. Placeholders are enclosed in pipes `|`, eg. the placeholder `|path|`
in the [`cwd` section](#current-working-directory-cwd).

## Legacy Options

Slimline uses a new option format but supports the previous options as fallback by setting
`SLIMLINE_PROMPT_VERSION` to `1`:
```shell
export SLIMLINE_PROMPT_VERSION=1 # Activate legacy option format
```

The legacy options are described [here](legacy_options.md).

## Global Options

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_PROMPT_VERSION</code></td>
      <td align="center"><code>2</code></td>
    </tr>
    <tr>
      <td>
        The version of the prompt options.
        To use the legacy options described <a href="legacy_options.md">here</a> set it to <code>1</code>.
      </td>
    </tr>
    <tr>
      <td rowspan=2><code>SLIMLINE_ENABLE_ASYNC_AUTOLOAD</code></td>
      <td align="center"><code>1</code></td>
    </tr>
    <tr>
      <td>
        Defines whether <a href="https://github.com/mafredri/zsh-async">zsh-async</a> should be
        automatically sourced if it was not already sourced.
        Disabling the automatic loading is useful if zsh-async is installed globally
        and therefore already loaded (e.g. via antigen or zplugin).
      </td>
    </tr>
  </tbody>
</table>

### Left Prompt

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_LEFT_PROMPT_SECTIONS</code></td>
      <td align="center"><code>user_host_info cwd symbol</code></td>
    </tr>
    <tr>
      <td>
        The sections to use in the left prompt.
      </td>
    </tr>
    <tr>
      <td rowspan=2><code>SLIMLINE_LEFT_PROMPT_SECTION_SEPARATOR</code></td>
      <td align="center"><code> </code></td>
    </tr>
    <tr>
      <td>
        The separator between each section.
      </td>
    </tr>
    <tr>
      <td rowspan=2><code>SLIMLINE_LEFT_PROMPT_FORMAT</code></td>
      <td align="center"><code>|sections| </code></td>
    </tr>
    <tr>
      <td>
        The format string for the left prompt (notice the space at the end).
        The placeholder <code>|sections|</code> will be replaced with the section output.
      </td>
    </tr>
  </tbody>
</table>

### Right Prompt

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_RIGHT_PROMPT_SECTIONS</code></td>
      <td align="center"><code>execution_time exit_status git aws_profile virtual_env nodejs</code></td>
    </tr>
    <tr>
      <td>
        The sections to use in the right prompt.
      </td>
    </tr>
    <tr>
      <td rowspan=2><code>SLIMLINE_RIGHT_PROMPT_SECTION_SEPARATOR</code></td>
      <td align="center"><code> </code></td>
    </tr>
    <tr>
      <td>
        The separator between each section.
      </td>
    </tr>
    <tr>
      <td rowspan=2><code>SLIMLINE_RIGHT_PROMPT_FORMAT</code></td>
      <td align="center"><code>|sections|</code></td>
    </tr>
    <tr>
      <td>
        The format string for the right prompt.
        The <code>|sections|</code> placeholder will be replaced with the section output.
      </td>
    </tr>
  </tbody>
</table>

### Spelling Prompt

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_SPELLING_PROMPT_FORMAT</code></td>
      <td align="center"><code>zsh: correct %F{red}|from|%f to %F{green}|to|%f [nyae]? </code></td>
    </tr>
    <tr>
      <td>
        The format string for spelling prompt which is shown for auto correction.
        The <code>|from|</code> placeholder will be replaced with the incorrect command
        and <code>|to|</code> with the correction.
      </td>
    </tr>
  </tbody>
</table>

## Built-in Sections

### Prompt Symbol (`symbol`)

The section displayes the prompt symbol. It supports two formats. The *working* format is used when asynchronous tasks are
pending and the *ready format for when all tasks are completed.

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_SYMBOL_WORKING_FORMAT</code></td>
      <td align="center"><code>%F{red}∙%f</code></td>
    </tr>
    <tr>
      <td>
        The format to use for the symbol when there are asynchronous tasks pending.
      </td>
    </tr>
    <tr>
      <td rowspan=2><code>SLIMLINE_SYMBOL_READY_FORMAT</code></td>
      <td align="center"><code>%F{white}∙%f</code></td>
    </tr>
    <tr>
      <td>
        The format to use for the symbol when all asynchronous tasks have completed.
      </td>
    </tr>
  </tbody>
</table>

### Current Working Directory (`cwd`)

This section displays the current working directory. It supports two formats.
The *root* format is used when the cwd is the root path and the other format when it is not.

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_CWD_FORMAT</code></td>
      <td align="center"><code>%F{cyan}|path|%f</code></td>
    </tr>
    <tr>
      <td>
        The format to use when the current working directory is in a
        normal directory (not the root path <code>/</code>).
        The placeholder for the path is <code>|path|</code>.
      </td>
    </tr>
    <tr>
      <td rowspan=2><code>SLIMLINE_CWD_ROOT_FORMAT</code></td>
      <td align="center"><code>%F{red}|path|%f</code></td>
    </tr>
    <tr>
      <td>
        The format to use when the current working directory is in the root path <code>/</code>.
        The placeholder for the path is <code>|path|</code>.
      </td>
    </tr>
  </tbody>
</table>

### Exit Status (`exit_status`)

The section displays the exit status of the last command if it is != 0.

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_EXIT_STATUS_FORMAT</code></td>
      <td align="center"><code>%F{red}|exit_status| ↵%f</code></td>
    </tr>
    <tr>
      <td>
        The format to use when the exit status of the last command is != 0.
        The placeholder for the exit status value is <code>|exit_status|</code>.
      </td>
    </tr>
  </tbody>
</table>

### Execution Time (`execution_time`)

The execution time of the last command if it exceeds the configurable threshold.

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_MAX_EXEC_TIME</code></td>
      <td align="center"><code>5</code></td>
    </tr>
    <tr>
      <td>
        The maximum execution time of a process in seconds until its run time is displayed on exit.
      </td>
    </tr>
    <tr>
      <td rowspan=2><code>SLIMLINE_EXECUTION_TIME_FORMAT</code></td>
      <td align="center"><code>%F{yellow}|time|%f</code></td>
    </tr>
    <tr>
      <td>
        The format of the execution time display.
        The placeholder for the execution time in seconds is <code>|time|</code>.
      </td>
    </tr>
  </tbody>
</table>

### User and Host Info (`user_host_info`)

This section displays user and host information and supports two formats.
The *root* format is used if the current user is root.
By default the user and host information is only displayed if the user is different than the
default user or if there is an active ssh session.

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_ALWAYS_SHOW_USER_HOST_INFO</code></td>
      <td align="center"><code>0</code></td>
    </tr>
    <tr>
      <td>
        Defines whether the user and host information should always be displayed.
      </td>
    </tr>
    <tr>
      <td rowspan=2><code>SLIMLINE_USER_HOST_INFO_DEFAULT_USER</code></td>
      <td align="center"><code>$USER</code></td>
    </tr>
    <tr>
      <td>
        The default user for this prompt. This is used to hide the user and host name
        if the current user is the same as the default user.
      </td>
    </tr>
    <tr>
      <td rowspan=2><code>SLIMLINE_USER_HOST_INFO_FORMAT</code></td>
      <td align="center"><code>%F{green}|user|%F{white}@%F{yellow}|host|%f</code></td>
    </tr>
    <tr>
      <td>
        The format of user and host info if the user is <i>not</i> root.
        The placeholder for the username is <code>|user|</code> and for the hostname is <code>|host|</code>.
      </td>
    </tr>
    <tr>
      <td rowspan=2><code>SLIMLINE_USER_HOST_INFO_ROOT_FORMAT</code></td>
      <td align="center"><code>%F{red}|user|%F{white}@%F{yellow}|host|%f</code></td>
    </tr>
    <tr>
      <td>
        The format of user and host info if the user <i>is</i> root.
        The placeholder for the username is <code>|user|</code> and for the hostname is <code>|host|</code>.
      </td>
    </tr>
  </tbody>
</table>

### Time (`time`)

This section displays the current time in 24h format and is disabled by default.
To use it add it to your left or right prompt manually. To use the 12h time format use the `|time12|` placeholder.

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_TIME_FORMAT</code></td>
      <td align="center"><code>%F{white}|time24|%f</code></td>
    </tr>
    <tr>
      <td>
        The format to use for displaying the time of day.
        The placeholder for the time in 24h format is <code>|time24|</code>.
        The placeholder for the time in 12h format is <code>|time12|</code>.
      </td>
    </tr>
  </tbody>
</table>

### AWS Profile (`aws_profile`)

This section displays the current aws profile detected via the `$AWS_PROFILE` environment variable.

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_AWS_PROFILE_FORMAT</code></td>
      <td align="center"><code>%F{white}[AWS:%F{blue}|profile|%F{white}]%f</code></td>
    </tr>
    <tr>
      <td>
        The format to use for displaying the aws profile.
        The placeholder for the profile is <code>|profile|</code>.
      </td>
    </tr>
  </tbody>
</table>

### Python Virtualenv (`virtualenv`)

This section displays the current python virtual env detected via the `$VIRTUAL_ENV` environment variable.

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_VIRTUALENV_FORMAT</code></td>
      <td align="center"><code>%F{white}[VENV:%F{cyan}|basename|%F{white}]%f</code></td>
    </tr>
    <tr>
      <td>
        The format to use for displaying the virtualenv information.
        The placeholder for the basename of the virtualenv is <code>|basename|</code>.
      </td>
    </tr>
  </tbody>
</table>

### Node.js (`nodejs`) *async*

This section displays the nodejs version if the current directory contains a `package.json` file or `node_modules` directory.

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_NODEJS_FORMAT</code></td>
      <td align="center"><code>%F{white}[%F{green}⬢ |version|%F{white}]%f</code></td>
    </tr>
    <tr>
      <td>
        The format to use for displaying the nodejs information.
        The placeholder for the configured version of nodejs is <code>|version|</code>.
      </td>
    </tr>
  </tbody>
</table>

### Git (`git`) *async*

This section displays various git status information.
It uses [gitline](https://github.com/mgee/gitline) to acquire and format the git information.
gitline can be extensively customized. Have a look at the [gitline options](https://github.com/mgee/gitline#options).

Additionally this section has the following options:

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default Value and Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan=2><code>SLIMLINE_GIT_FORMAT</code></td>
      <td align="center"><code>|output|</code></td>
    </tr>
    <tr>
      <td>
        The format to use for the git status information.
        The placeholder <code>|output|</code> is replaced with the output from gitline.
      </td>
    </tr>
  </tbody>
</table>

## Custom Sections

Custom sections can be easily written by following the slimline section naming scheme.
This way sections are automatically discovered and can execute asynchronous tasks easily.

Sections use the namespace `slimline::section::<name>` where name is replaced by the
section name. Each section needs at least a `render` function.
For a section with the name `foo` the render function is named `slimline::section::foo::render`.

A section can have the following functions:

| Function | Required | Description |
| :------- | :-----: | ------- |
| `slimline::section::<name>::render` | **yes** | This function is used to display information in the prompt. |
| `slimline::section::<name>::init` | no | This function can initialize data and check for requirements for the section. If the function returns `0` the section will be loaded. In case the section shall be deactivated return `1` instead. |
| `slimline::section::<name>::preexec` | no | If the function is defined it will be executed right before a new command in zsh is executed. |
| `slimline::section::<name>::precmd` | no | If the function is defined it will be executed before the prompt render functions. |
| `slimline::section::<name>::async_task` | no | This function will be executed asynchronously by zsh-async and its output will be available in the `async_task_complete` function.
| `slimline::section::<name>::async_task_complete` | no | This function is not required except when the `async_task` function is defined. This function will receive the output of the `async_task` function and other information. |

### Functions

#### Render

The render function `slimline::section::<name>::render` is responsible for emitting a string
which will be displayed in the prompt.

The function receives the following parameters:
| Parameter | Description |
| :-------: | ----------- |
| `$1`      | The event which triggered the render function. This can be one of the following: `setup`, `precmd`, `task_complete`, `all_tasks_complete`. |

Example:
```shell
slimline::section::foo::render() {
  echo "%F{blue}bar%f"
}
```

#### Init

The init function `slimline::section::<name>::init` is optional and initializes the section if necessary.
The function receives no parameters and returns 0 on success or 1 on failure.
If the function returns 1 the section will be disabled.

Example:
```shell
slimline::section::foo::init() {
  if slimline::utils::callable "ruby"; then
    return 0 # Ok, section can be loaded
  fi

  slimline::utils::warning "ruby not installed or not in PATH, disabling foo section"
  return 1 # Disable the section
}
```

#### Preexec

The prexec function `slimline::section::<name>::preexec` is called on the preexec hook of zsh
which is before a command is executed. This can be useful to capture the state if a command changes it.
For an example see the [`execution_time` section](sections/execution_time.zsh).

The function receives no parameters.

#### Precmd

The precmd function `slimline::section::<name>::precmd` is executed before each prompt.
It can be used to reset variables which are set in the async task function.
This way the render function does not display old data in case the async task is not completed yet.

The function receives no parameters.

Example:
```shell
slimline::section::foo::precmd() {
  unset slimline_section_foo_output
}
```

#### Async Task

The async task function `slimline::section::<name>::async_task` can be used to execute
a blocking command asynchronously. This greatly improves the speed of the prompt because
the prompt can be instantly rendered and only updated when the task is ready.

For an example see the [`git` section](sections/git.zsh) or [`nodejs` section](sections/nodejs.zsh).

The function receives the following parameters:
| Parameter | Description |
| :-------: | ----------- |
| `$1`      | The current directory of the prompt. This is important for executing commands because the task function is called from a different context and thus may have a different working directory. |

```shell
slimline::section::foo::async_task() {
  sleep 2
  echo "in directory $1"
}
```

#### Async Task Complete

The async task complete function `slimline::section::<name>::async_task_complete` is responsible
for handling the result of the async task.
If the async task function is defined the async task complete function needs to be defined too.
This function can be used to save the stdout output of a command in a global variable which
can be used in the render function.

For an example see the [`git` section](sections/git.zsh) or [`nodejs` section](sections/nodejs.zsh).

The function receives the following parameters:
| Parameter | Description |
| :-------: | ----------- |
| `$1`      | The return code of the task. |
| `$2`      | The stdout output of the task. |
| `$3`      | The stderr output of the task. |
| `$4`      | The execution time of the task as floating point value in seconds, e.g. 0.0258 seconds. |

Example:
```shell
slimline::section::foo::async_task_complete() {
  slimline_section_foo_output=$2
}
```

### Utility Functions

#### Section Format Expansion

#### Logging

#### Callable Check

### Complete Examples

#### Minimal Section

```shell
slimline::section::foo::render() {
  echo "%F{blue}bar%f"
}
```

#### Section with init function

```shell
slimline::section::foo::init() {
  if slimline::utils::callable "ruby"; then
    return 0 # Ok, section can be loaded
  fi

  slimline::utils::warning "ruby not installed or not in PATH, disabling foo section"
  return 1 # Disable the section
}

slimline::section::foo::render() {
  echo "%F{blue}bar%f"
}

# Add it to the right prompt
export SLIMLINE_RIGHT_PROMPT_SECTIONS="foo execution_time exit_status git aws_profile virtual_env nodejs"
```

#### Section with asynchronous task

```shell
slimline::section::foo::precmd() {
  unset slimline_section_foo_output
}

slimline::section::foo::async_task() {
  sleep 2
  echo "bar"
}

slimline::section::foo::async_task_complete() {
  slimline_section_foo_output=$2
}

slimline::section::foo::render() {
  echo "${slimline_section_foo_output}"
}

# Add it to the right prompt
export SLIMLINE_RIGHT_PROMPT_SECTIONS="foo execution_time exit_status git aws_profile virtual_env nodejs"
```

## Example

Here is an example for customizing the prompt symbol as well as the git repository indicator and
branch format:

```shell
export SLIMLINE_SYMBOL_READY_FORMAT="%F{white}\$%f"
export SLIMLINE_SYMBOL_WORKING_FORMAT="%F{red}\$%f"

# If you have a powerline compatible font you can also use the alternative repo indicator ''.
export GITLINE_REPO_INDICATOR='${reset}git'
export GITLINE_BRANCH='[${blue}${branch}${reset}]'

source "<path-to-slimline>/slimline.zsh"
```

<p align="center"><img src="screenshot_example.png" width="682" height="298"></p>

## Thanks

- [mafredri/zsh-async](https://github.com/mafredri/zsh-async)
- [sindresorhus/pure](https://github.com/sindresorhus/pure)
- [denysdovhan/spaceship-prompt](https://github.com/denysdovhan/spaceship-prompt)
- [sorin-ionescu/prezto](https://github.com/sorin-ionescu/prezto.git)

## License

Released under the [MIT License](LICENSE)
