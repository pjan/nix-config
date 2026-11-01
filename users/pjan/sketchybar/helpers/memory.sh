#!/bin/bash
# Outputs used memory as an integer percentage via vm_stat.
vm_stat 2>/dev/null | awk '
  /page size/                     { page = $8 }
  /Pages free/                    { free = $3+0 }
  /Pages active/                  { act  = $3+0 }
  /Pages wired/                   { wire = $4+0 }
  /Pages occupied by compressor/  { comp = $5+0 }
  /Pages inactive/                { inact = $3+0 }
  /Pages speculative/             { spec  = $3+0 }
  END {
    total = free + act + inact + spec + wire + comp
    used  = act + wire + comp
    if (total > 0) printf "%.0f", (used / total) * 100
    else print "0"
  }'
