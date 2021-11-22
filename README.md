# Godot-GIF-to-Spritesheet-to-Animated-Scene-converter
Have you ever needed to convert a lot of GIFs (100+) into Pre-Animated Godot Scenes?? These scripts can do that for you!!

## Info:
The 2 scripts require you run them from the directory your GIFs (and therefore spritesheets) are in.
- gif_to_spritesheet.sh: Converts the GIFs into Spritesheets
- spritesheets_into_tscn.sh: Converts the Spritesheets into Scenes (GIFs still required for now)

The following files are made (and can be deleted after running):
- `../listpngs`
- `../listgifs`

## Requirements:
- ImageMagick (conversions/processing)
- Gifsicle (gif information)
- File (resolution information)
- Bash (wc, rev, cut, cat, echo, head, tail, expr, bc, seq)

## Limitations:
- GIF format required (for now), plain spritesheets won't work
- GIFs with variation in time per frame aren't currently supported
- TSCN (Godot Scene) format may change in the future, requiring edits (Tested with Godot 3.4)

## Credits:
- [Godot](https://godotengine.org) for making such an amazing game engine
- lertsenem		}
- Shineru		}- For helping me implement ImageMagick to reduce dependencies
- bengtsts		}
