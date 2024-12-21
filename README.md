# ehlphabet
Fork of the original [abjphabet mod](https://forum.minetest.net/viewtopic.php?f=11&t=11744) by ABJ

![screenshot](screenshot.png)

**Letter Machine Reciepe**|**Letter Machine UI**
----|----
![Letter Machine Reciepe](reciepe.png)|![Letter Machine UI](lmui.png)

Letter blocks can be created with the Letter Machine or given with /giveme ehlphabet:(ascii decimal)

Example: `/giveme ehlphabet:65` will give you a block with the letter [**A**] on it.
https://www.asciitable.com/

For UTF-8 characters add one more identifier /giveme ehlphabet:(first byte decimal)_(second byle decimal)

Example: `/giveme ehlphabet:195_132` will give you a block with the letter [**Ä**] on it.
http://www.utf8-chartable.de/

## Textures

Textures were generated using [**phantomjs**](http://phantomjs.org/download.html) script "gen.js" included in this repository.

To (re)generate textures run:

    $ phantomjs gen.js

To customize the look and size of letters, you need to know basic HTML and CSS and change it inside "gen.js".

## License

Textures are licensed under CC-BY-SA 3.0
See LICENSE file

## Changelist
2024-12-15 cleaned up by SwissalpS. Added stickers, shift-clicking inventories,
recycling recipes and dropped [intllib] in favour of core translation. Also added
Spanish and Catalan locales. (probably some more changes)

2018-01-24 patched by Och_Noe to use it as replacement for abjphabet (create aliases)

2018-03-29 support for UTF-8 and Cyrillic letters added

2018-03-31 German letters added

2018-04-01 intllib support added with Russian and German languages

