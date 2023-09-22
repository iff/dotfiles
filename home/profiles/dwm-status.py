#!/usr/bin/env ltstatus

from ltstatus import formats, monitors as m, outputs, run

# switch this off if you dont have nerdfont or something compatible
# (see https://www.nerdfonts.com/)
icons = True

monitors = [
    m.Redshift(),
    m.Bluetooth(),
    m.Cpu(),
    m.Datetime(),
]

if icons:
    monitors = [m.with_icons() for m in monitors]

run(
    monitors=monitors,
    polling_interval=3,
    format=formats.dwm(),
    output=outputs.dwm(),
)
