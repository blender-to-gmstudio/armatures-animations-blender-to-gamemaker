/// @description Advance animation
frame += frame_inc;

frame_int = floor(frame);
frame_lerp = frac(frame);

frame_cur = frame_int mod num_frames;
frame_next = (frame_int + 1) mod num_frames;