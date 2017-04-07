#!/usr/bin/env ruby

require_relative '../lib/mud_server'

mud = MudServer.new(5309)
mud.audit = true

mud.start
mud.join