# Shortcut-Update
This utility was born from a project at my workplace, which would otherwise
require manually migrating shortcut files from one network host to another.

While I'm not sure _who else_ would actually need this; it should at the
very least provide an example if something needs to be used in the future.

I've written this in a way such that the prefix pattern/replace strings will
be interpreted as AHK-Style regular expressions.  Please refer to the 
[Regular Expression QuickRef](https://www.autohotkey.com/docs/misc/RegEx-QuickRef.htm) 
for more information on how these are formatted

# GUI
Provides a textbox for the path, search and replace prefixes; as well as a checkbox
for the recursive search option.  I've also added a simple "Browse" button; to make
locating the root directory somewhat more user friendly.