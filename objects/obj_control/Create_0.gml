/// @description Controller

#region Basic Camera Setup

cam = view_camera[0];  // "Pick up" the existing camera

distance = 60;
direction = -45;

mat_proj = matrix_build_projection_perspective_fov(-45, view_wport[0]/view_hport[0], 1, 10000);
mat_view = matrix_build_lookat(lengthdir_x(distance, direction), lengthdir_y(distance, direction), -distance, 0, 0, 0, 0, 0, -1);

camera_set_proj_mat(cam, mat_proj);
camera_set_view_mat(cam, mat_view);

#endregion

#region GPU Setup

gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_cullmode(cull_counterclockwise);

layer_force_draw_depth(true, 0);

#endregion

#region Basic Lighting

draw_light_define_ambient(c_dkgray);

draw_light_define_direction(0, -distance, -distance, distance, c_white);
draw_light_enable(0, true);

draw_set_lighting(true);

#endregion

#region Mouse

dragging = false;

#endregion
