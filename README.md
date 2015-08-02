#NAME
	y2j, j2y, yq - filters to convert JSON to YAML, YAML to JSON and YAML to YAML.

#SYNOPSIS
	# convert from YAML to JSON
	y2j < yaml > json
	j2y -d < yaml > json

	# convert from YAML to JSON with optional trailing jq transformation
	y2j {jq-filter} < yaml

	# convert from JSON to YAML
	j2y < json > yaml
	y2j -d < json > yaml

	# convert from JSON to YAM with optional leading jq transformation
	j2y {jq-filter} < json > yaml

	# convert YAML to JSON, run jq, convert back to YAML
	yq {jq-filter} < yaml > yaml

	# create an installer that will install y2j.sh into /usr/local/bin, then run that script with bash
	y2j.sh installer /usr/local/bin | sudo bash

#DESCRIPTION

This package provides filters for transforming JSON to YAML, YAML to JSON and YAML to YAML.

YAML to YAML transformations are performed by applying a jq filter to a JSON transformation
of the YAML input stream with y2j and transforming the resulting JSON stream back to YAML with j2y.

The script will use the local instances of jq, python and the required python modules if they exist locally
or will use a docker container based on the wildducktheories/y2j image otherwise.

#INSTALLATION

```
docker run --rm wildducktheories/y2j y2j.sh installer /usr/local/bin | sudo bash
```

Replace /usr/local/bin with a different directory to specify a different installation location or omit to
default to /usr/local/bin.

#EXAMPLES
##j2y
<pre>
echo '{ "foo": [ { "id": 1 } , {"id": 2 }] }' | j2y
</pre>

yields:

<pre>
foo:
- id: 1
- id: 2
</pre>

<pre>
echo '{"foo": "bar"}{"foo": "baz"}' | j2y -s .
</pre>

yields:

<pre>
- foo: bar
- foo: baz
</pre>

##y2j
<pre>
(
	y2j &lt;&lt;EOF
foo:
- id: 1
- id: 2
EOF
) | jq -c .
</pre>

yields:

<pre>
{"foo":[{"id":1},{"id":2}]}
</pre>

##yq

<pre>
yq '.foo=(.foo[]|select(.id == 1)|[.])' &lt;&lt;EOF
foo:
- id: 1
- id: 2
EOF
</pre>

yields:

<pre>
foo:
- id: 1
</pre>

#LIMITATIONS
* y2j only supports the subset of YAML streams that can be losslessly represented in JSON.
* j2y only supports reading of a single JSON object or a single JSON array from stdin. If the JSON input contains
multiple objects, consider using '-s .' with j2y to slurp the input into a single JSON array.
* yq only supports jq-filters that are guaranteed to produce a single JSON object or array.

Behaviour with inputs or filters that do not satisfy these constraints is not defined.

#AUTHOR

Jon Seymour &lt;jon@wildducktheories.com&gt;

#ACKNOWLEDGMENTS

Conversions used by y2j.sh are based on the commandlinefu scripts found here:
* http://www.commandlinefu.com/commands/view/12218/convert-yaml-to-json
* http://www.commandlinefu.com/commands/view/12219/convert-json-to-yaml

Filtering is implemented with jq. See http://stedolan.github.io/jq/.

#REVISIONS

##1.1
* Added support for yq.

##1.0
* Initial release.