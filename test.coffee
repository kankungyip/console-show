assert = require 'assert'
show = require './'

describe 'Console colors show', ->

	describe 'show (aStyleFormat [, ...])', ->

		it 'color', ->
			assert.ifError show '#blue{blue man}'

		it 'color and bgcolor', ->
			assert.ifError show '#blue lightyellow{blue man and lightyellow face}'

		it 'color and style', ->
			assert.ifError show '#blue bold{big blue man}'

		it 'all styles', ->
			assert.ifError show '#blue lightyellow bold blink{wow!}'

	describe 'show.set (aThemeName, aStyleString)', ->

		it 'error theme', ->
			assert.ifError not show.set 'error', 'red bold'

		it 'print error', ->
			assert.ifError show '#error{i\'m error}'
