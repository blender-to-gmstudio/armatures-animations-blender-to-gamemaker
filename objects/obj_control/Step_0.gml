/// @description Update viewpoint if dragging
if (dragging) {
    direction -= window_mouse_get_delta_x();
    distance += window_mouse_get_delta_y();
    distance = clamp(distance, 40, 100);
}

mat_view = matrix_build_lookat(lengthdir_x(distance, direction), lengthdir_y(distance, direction), -distance, 0, 0, 0, 0, 0, -1);
camera_set_view_mat(cam, mat_view);