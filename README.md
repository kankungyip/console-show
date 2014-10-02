# Console colors show

Console color text display tool.

```bash
$ npm install console-show
```


## Getting Started

```coffee
show = require 'console-show'

show '#red{ %s }', 'Red text'               # red color
show '#red bold{ Bold and red text }'       # bold and red
show '#239,67,165{ Color text }'            # rgb color
```


## APIs

### `show (aStyleFormat [, ...])`

Prints to `stdout` with newline. The `aStyleFormat` is a string that like 
`#[foreColor [backColor]] [style] [theme] [...]{ string }`. This function can 
take multiple arguments in a `printf()`-like way. Supported placeholders are:

- `%s`  String.
- `%d`  Number (both integer and float).
- `%j`  JSON.
- `%`   single percent sign ('%'). This does not consume an argument.
- `{{`  open brace sign ('{').
- `}}`  close brace sign ('}').

Supported styles are:

- **Font styles**: **bold**, *italic*, underline, blink
- **Normal colors**: black, red, green, yellow, blue, magenta, cyan, white
- **Bright colors**: light-black, light-red, light-green, light-yello, 
    light-blue, light-megenta, light-cyan, light-white
- **RGB color**: *r*(0~5), *g*(0~5), *b*(0~5)
- **Grayscale**: 0~24
- **User theme**: [see `show.set (aThemeName, aStyleFormat)`](#showset-athemename-astylestring)

**Example:**

```coffee
show '#bold{bold text}'
show '#red blink{blink red text}'
```


### `show.format (aStyleFormat [, ...])`

Return a formatted string using the `aStyleFormat`. This function can take 
multiple arguments in a `printf()`-like way.

**Example:**

```coffee
str = show.format '#red{error message}'
console.error str
```


### `show.set (aThemeName, aStyleString)`

Define a theme was named `aThemeName`, and the theme is `aStyleString`.

**Example:**

```coffee
show.set 'error', 'red bold'
show '#error{error message}'

show.set 'warning', 'white yellow blink'
show '#warning{warning message}'
```


### `show.error (aStyleFormat [, ...])`

Prints to `stderr` with newline. This function can take multiple arguments 
in a `printf()`-like way.

**Example:**

```coffee
show.error '#red{error message}'
```


## Test

```bash
$ npm test
```


## Licensed

The ***MIT*** Licensed.

Copyright (c) 2014 [Kan Kung-Yip](mailto:kan@kungyip.com)
