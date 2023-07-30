zmodload zsh/datetime

_source_start=$EPOCHREALTIME
source $1
_source_end=$EPOCHREALTIME

((_source_duration = (_source_end-_source_start) * 1000))
printf "%5.1fms for ${(D)1}\n" $_source_duration
((_source_total = _source_total + _source_duration))
