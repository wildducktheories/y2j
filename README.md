#NAME
	y2j, j2y - a tool to convert python to yaml and yaml to python

#SYNOPSIS
	# convert from YAML to JSON
	y2j < yaml > json
	j2y -d < yaml > json

	# convert from JSON to YAML
	j2y < json > yaml
	y2j -d < json > yaml

	# create an installer for this script
	y2j.sh installer

#DESCRIPTION

This tool provides a utility for converting json to yaml and vice versa.

The script will use the local python installation if one exists and the necessary python modules are installed
or will use a docker container based on the wildducktheories/y2j image otherwise.

#INSTALLATION

```
docker run -e INSTALL_DIR=/usr/local/bin --rm wildducktheories/y2j y2j.sh installer | bash
```

If INSTALL_DIR is not specified, the installer will install the scripts into /usr/local/bin

#AUTHOR

Jon Seymour &lt;jon@wildducktheories.com&gt;

#ACKNOWLEDGMENTS

Conversions based on the commandlinefu scripts found here:
* http://www.commandlinefu.com/commands/view/12218/convert-yaml-to-json
* http://www.commandlinefu.com/commands/view/12219/convert-json-to-yaml