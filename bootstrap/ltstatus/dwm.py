#!bin/ltstatus

from ltstatus import (
    RateLimitedMonitors,
    RegularGroupMonitor,
    StdoutStatus,
    XsetrootStatus,
    monitors,
)

monitor = RateLimitedMonitors(
    rate=30,
    monitors=[
        monitors.nvidia.Monitor(),
        monitors.datetime.Monitor(),
        monitors.redshift.Monitor(
            # format=monitors.redshift.format_brightness,
            format=monitors.redshift.format_temperature,
            # format=monitors.redshift.format_period,
        ),
        # monitors.bluetooth.Monitor(),
        # monitors.sound.Monitor(
        #     aliases={
        #         "Starship/Matisse HD Audio Controller Analog Stereo": "speakers",
        #     },
        # ),
        # monitors.spotify.Monitor(),
    ],
)

status = XsetrootStatus(
    monitor=monitor,
    order=[
        "nvidia",
        "redshift",
        "datetime",
    ],
    separator=" ",
    prefix="[",
    postfix="]",
    waiting="...",
)

status.run()
