## The Automated build script for arma missions

The automated build script will build your mission according to `.mission.json` file and place the complete pbo into `$mission\out` directory.

## Requirements

* Powershell 5.1
    If your OS is not Windows 10, you will need to download WMF 5.1, as versions prior to 5.0 have a nasty bug when parsing JSON files.
    You can get it [here](https://msdn.microsoft.com/en-us/powershell/wmf/5.1/install-configure)
* Several Arma 3 Tools directories in your `$PATH` enviromental variable
    Those include: FileBank, CfgConvert (located in `Arma 3 Tools install directory\NameOfTheTool\`)
    If you're unsure how to add items to your $PATH variable consult [this link](https://www.howtogeek.com/118594/how-to-edit-your-system-path-for-easy-command-line-access/)
* Your mission must be a git repository and `git` must be in your `$PATH` enviroment variable

## Notes

The system will automaticaly edit `author` and `briefingName` in your `description.ext` to precisely reflect Author name, Gamemode, Name and Version of your mission. Do not touch those manually if using this script. Edit `.mission.json` instead.

The System will also binarize `mission.sqm` to speed up loading times and reduce filesize. However it will not leave binarized file in the working directory
________
## The mission manifest

```json
{
    "Prefix":  "GAMEMODE",
    "Author": "Your name",
    "Version": "1.0",
    "InternalName":  "Name_separated_by_underscores",
    "Name":  "Name of the Mission",
    "Map":  "Visual Name",
    "MapName":  "InternalName"
}
```
| Key | Description |
|-----|-------------|
| Prefix | The gamemode prefix, e.g. COOP |
| Author | Name of the author(s) |
| Version | Major Version of this mission (Note: you can rely on `git describe` to automatically create minor versions, only edit this if you're incrementing major version)|
| InternalName | Name of the mission that will be used for the filename. Should not contain spaces |
| Name | Pretty name for your mission on the briefing screen|
| Map | Pretty name of the map |
| MapName | Internal Name of the Map, e.g. `Altis` or `Sara_dbe1` (United Sahrani) |