/// @description Basic Animated Model Object

rig_name = "armature";

frame = 0;
frame_int = 0;
frame_lerp = 0;
frame_cur = 0;
frame_next = 0;
frame_inc = .3;

#region Model Map

model_dir = "models";

model_map = ds_map_create();

var _fname = file_find_first(model_dir + "/" + "*.vbx", fa_none);

while(_fname != "") {
    var _model = model_load(model_dir + "/" + _fname);
    var _name = filename_change_ext(_fname, "");
    model_map[? _name] = _model;
    _fname = file_find_next();
}

file_find_close();

#endregion

#region Rig (exported from Blender)

rig = json_parse(json_load(model_dir + "/" + rig_name + ".rig"));
set_vb_from_model_map(rig, model_map);

arr_samples = json_parse(json_load("models/" + rig_name + ".anim"));

num_frames = array_length(arr_samples);

frame_int = floor(frame);
frame_lerp = 0;

frame_cur = frame_int mod num_frames;
frame_next = (frame_int + 1) mod num_frames;

#endregion

#region Global scale matrix

mat_scale = matrix_build(0, 0, 0, 0, 0, 0, 10, 10, 10);

#endregion