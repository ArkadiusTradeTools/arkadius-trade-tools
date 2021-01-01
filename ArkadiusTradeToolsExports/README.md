# Arkadius' Trade Tools Exports for Elder Scrolls Online

## Running exports
After saving an export within ESO, you can generate a CSV file from your system by running the `run-export.bat` or `run-export.ps1` files in the root of the addon.

## Options
The export script supports the following options:

`-l, --latest`: Automatically picks the newest saved export for generation.

`-m, --members`: Includes only guild members when generating the export file.

`-d, --directory`: Sets the output directory for the generated CSV. The following values can be used to generate dynamic file names:

- guildName
- isMembers
- startTimeStamp
- endTimeStamp 

`-o, --out-file`: Sets the output file name for the generated CSV.

`-f, --date-format`: Sets the [Lua date format](https://www.lua.org/pil/22.1.html) to be used for any timestamps in the file name.