# Cakefile for Sublime Text

fs = require 'fs'
{spawn, exec} = require 'child_process'

task 'sbuild', 'compile source', ->
	
  opts = ['-c', '-b', '-o']
  opts = opts.concat ['.', '.']
  app = spawn 'coffee', opts
  app.stdout.pipe(process.stdout)
  app.stderr.pipe(process.stderr)
  app.on 'exit', (status) -> console.log ';)' if status is 0
