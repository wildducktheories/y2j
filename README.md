#NAME
	y2j, j2y, yq - a tool to convert python to yaml and yaml to python

#SYNOPSIS
	# convert from YAML to JSON
	y2j < yaml > json
	j2y -d < yaml > json

	# convert from JSON to YAML
	j2y < json > yaml
	y2j -d < json > yaml

	# convert YAML to JSON, run jq, convert back to YAML
	yq {jq-filter} < yaml > yaml

	# create an installer for this script
	y2j.sh installer

#DESCRIPTION

This tool provides a utility for converting json to yaml and vice versa.

The script will use the local instances of jq, python and the required python modules if they exist locally
or will use a docker container based on the wildducktheories/y2j image otherwise.

#INSTALLATION

```
docker run --rm wildducktheories/y2j y2j.sh installer /usr/local/bin | bash
```

#LIMITATIONS
j2y only supports converstion of a single object or a single array on stdin, consequently jq-filters specified with yq
must only produce outputs which satisfy this constraint otherwise the pipeline will fail.

#AUTHOR

Jon Seymour &lt;jon@wildducktheories.com&gt;

#ACKNOWLEDGMENTS

Conversions based on the commandlinefu scripts found here:
* http://www.commandlinefu.com/commands/view/12218/convert-yaml-to-json
* http://www.commandlinefu.com/commands/view/12219/convert-json-to-yaml

#REVISIONS

##1.1
* Added support for yq.

##1.0
* Initial release.