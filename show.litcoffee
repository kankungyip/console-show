# Console colors show

Console color text display tool.

**Module dependencies:**

```coffee

	util = require 'util'
```

**Helpers:**

```coffee

	floor = Math.floor
```

**Global themes:**

```coffee

	themes = {}
```


## Prototype

### `show (aStyleFormat [, ...])`

Prints to `stdout` with newline. The `aStyleFormat` is a string that like 
`#[foreColor [backColor]] [style] [theme] [...]{ string }`. This function can 
take multiple arguments in a `printf()`-like way. Supported placeholders are:

- `%s`	String.
- `%d`	Number (both integer and float).
- `%j`	JSON.
- `%`	single percent sign ('%'). This does not consume an argument.
- `{{`	open brace sign ('{').
- `}}`	close brace sign ('}').

**Source:**

```coffee

	show = -> util.puts show.format.apply show, arguments
```

**Example:**

```coffee

show '#bold{bold text}'
show '#red blink{blink red text}'
```


### `codec (aStyle)`

*(Private)*

Return the ANSI escape code from `aStyle` is a name of the style.

Supported styles are:

- **Font styles**: **bold**, *italic*, underline, blink
- **Normal colors**: black, red, green, yellow, blue, magenta, cyan, white
- **Bright colors**: light-black, light-red, light-green, light-yello, 
	light-blue, light-megenta, light-cyan, light-white
- **RGB color**: *r*(0~5), *g*(0~5), *b*(0~5)
- **Grayscale**: 0~24
- **User theme**: [see `show.set (aThemeName, aStyleFormat)`](#theme)

**Source:**

```coffee

	codec = (style) ->
		style = style.trim().toLowerCase()
		switch style

			when 'bold'			then -1
			when 'italic'		then -3  # not widely supported
			when 'underline'	then -4
			when 'blink'		then -5

			when 'black'		then 0
			when 'red'			then 1
			when 'green'		then 2
			when 'yellow'		then 3
			when 'blue'			then 4
			when 'magenta'		then 5
			when 'cyan'			then 6
			when 'white'		then 7

			when 'lightblack', 'light-black'		then 8
			when 'lightred', 'light-red'			then 9
			when 'lightgreen', 'light-green'		then 10
			when 'lightyellow', 'light-yellow'		then 11
			when 'lightblue', 'light-blue'			then 12
			when 'lightmagenta', 'light-magenta'	then 13
			when 'lightcyan', 'light-cyan'			then 14
			when 'lightwhite', 'light-white'		then 15

			else
				arr = style.split ','
				if arr.length is 3
					if (r = floor arr[0] / 51) > 5 then r = 5
					if (g = floor arr[1] / 51) > 5 then g = 5
					if (b = floor arr[2] / 51) > 5 then b = 5
					16 + 36 * r + 6 * g + b

				else
					num = parseInt style
					if not isNaN num
						if 0 <= num < 24 then 232 + num else false

					else if def = themes[style]
						arr = []
						for col in "#{def}".split ' '
							val = codec col
							arr.push val if val isnt false
						if arr.length > 0 then arr else false

					else false
```


### `prop (aKey, options)`

*(Private)*

Define a property was named by the `aKey`, the `options` is the property's options.

**Source:**

```coffee

	prop = (key, opts) ->
		opts.configurable = false
		opts.enumerable = true
		Object.defineProperty show, key, opts
```


### `show.format (aStyleFormat [, ...])`

Return a formatted string using the `aStyleFormat`. This function can take 
multiple arguments in a `printf()`-like way.

**Source:**

```coffee

	format = ->
		text = util.format.apply @, arguments
		text = text.replace /#[\w\, ]+{(?:.*?(?:}})?)*?}/g, (str) ->
			color = false
			parts = /^#([\w\, ]+){((?:.*?(?:}})?)*?)}$/.exec str
			arr = []

			for col in parts[1].split ' '
				continue unless style = codec col
				if not util.isArray style then style = [style]
				for val in style
					if val < 0
						arr.push -val
					else
						if color is false then color = 30 else color = 40
						arr.push color + 8, 5, val
						color = false if color > 39

			util.format '\x1b[%sm%s\x1b[0m', arr.join(';'), parts[2].trim()
		text.replace /{{/g, '{'
			.replace /}}/g, '}'

	prop 'format', value: format
```

**Example:**

```coffee

str = show.format '#red{error message}'
console.error str
```


### <span name="theme" id="theme"></span>`show.set (aThemeName, aStyleString)`

Define a theme was named `aThemeName`, and the theme is `aStyleString`.

**Source:**

```coffee

	prop 'set', value: (name, theme) -> themes[name.toLowerCase()] = theme
```

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

**Source:**

```coffee

	prop 'error', value: -> util.error @format.apply @, arguments
```

**Example:**

```coffee

show.error '#red{error message}'
```

## Appendix

**Expose:**

	module.exports = show


**Reference:**

- [ANSI escape code](http://en.wikipedia.org/wiki/ANSI_escape_code)


**Licensed:**

MIT Licensed.

Copyright (c) 2014 [Kan Kung-Yip](mailto:kan@kungyip.com)
