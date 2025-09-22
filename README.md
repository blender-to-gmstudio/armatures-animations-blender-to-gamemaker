# Basic Skeletal Animation Exports from Blender to GameMaker

This GameMaker project shows a basic, straightforward way to export skeletal animations from Blender to GameMaker.

> **Created with**:
> 
> GameMaker: 2024.13\
> Blender : 4.1

## Limitations

The project shows a basic export of a Blender armature that has a single animation (an action). Since it is basic, it comes with a few limitations:

* Simple bone hierarchy.
* Uses bone parents, doesn't support skinning.
* Models need to be manually aligned to the bone axis in Blender.
* Likely has issues with gimbal lock and other mathematical oddities.
* Should work fine with Blender's bone constraints, such as inverse kinematics constraint.

## File Format

An animation is exported as two files in JSON format:

* A file that stores the rig, with a `.rig` extension
* A file that stores the frames of an animation, with a `.anim` extension

The model data is stored in binary and can be loaded with [buffer_load()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Buffers/buffer_load.htm). It uses GameMaker's [default vertex format](https://manual.gamemaker.io/monthly/en/Additional_Information/Guide_To_Primitives_And_Vertex_Building.htm#passthrough_vertex_format), with a normal attribute added.

The format of the rig file and animation file is identical. It consists of a hierarchy of structs that store only a few attributes:

```json
{
    "translation": [tx, ty, tz],
    "rotation": [rx, ry, rz],
    "model": "model.vbx",
    "children": [
        
    ]
}
```

The `"children"` array stores items of the same format. The `"model"` is only set on items in the rig file and is set to an empty string `""` for items in the animation file. It contains the filename of the model.
