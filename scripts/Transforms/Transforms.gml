/// Transform Hierarchy Functionality
/// 
/// 

/// @func set_vb_from_model_map
/// @desc Quick way to assign vertex buffer from the model map
/// 
function set_vb_from_model_map(_node, _model_map) {
    var _vb = -1;
    if (ds_map_exists(_model_map, _node.model)) {
        _vb = _model_map[? _node.model];
    }
    _node.vb = _vb;
    
    for(var i = 0;i < array_length(_node.children);i++) {
        set_vb_from_model_map(_node.children[i], _model_map);
    }
}

/// @func draw_hierarchy
/// @desc Draw a skeletal hierarchy starting at the given root
/// 
function draw_hierarchy(_root, _sample_root, _sample_root_next, _lerp, _mat_global=matrix_build_identity()) {
    matrix_stack_clear();
    
    static rot = 0;
    
    matrix_stack_push(_mat_global);
    
    // Perform the final rotation to turn the armature upright
    var _mat_rot_180 = matrix_build(0, 0, 0, 180, 0, 0, 1, 1, 1);
    matrix_stack_push(_mat_rot_180);
    
    var _mat_world = matrix_get(matrix_world);
    
    draw_node(_root, _sample_root, _sample_root_next, _lerp);
    
    matrix_set(matrix_world, _mat_world);
    
    matrix_stack_clear();
}

/// @func draw_node
/// @desc Draw a single node recursively, lerping its transform from the current sample to the next
/// 
function draw_node(_node, _sample_node, _sample_node_next, _lerp) {
    var _t_node = _node.translation;
    var _r_node = _node.rotation;
    var _mat_node = matrix_build(_t_node[0], _t_node[1], _t_node[2], _r_node[0], _r_node[1], _r_node[2], 1, 1, 1);  // ignore scale
    
    matrix_stack_push(_mat_node);
    
    var _t_sample = _sample_node.translation;
    var _r_sample = _sample_node.rotation;
    
    var _t_sample_next = _sample_node_next.translation;
    var _r_sample_next = _sample_node_next.rotation;
    
    var _t = [lerp(_t_sample[0], _t_sample_next[0], _lerp), lerp(_t_sample[1], _t_sample_next[1], _lerp), lerp(_t_sample[2], _t_sample_next[2], _lerp)];
    var _r = [lerp(_r_sample[0], _r_sample_next[0], _lerp), lerp(_r_sample[1], _r_sample_next[1], _lerp), lerp(_r_sample[2], _r_sample_next[2], _lerp)];
    
    var _mat_sample = matrix_build(_t[0], _t[1], _t[2], _r[0], _r[1], _r[2], 1, 1, 1);  // ignore scale
    
    matrix_stack_push(_mat_sample);
    
    // Draw me
    matrix_set(matrix_world, matrix_stack_top());
    if (_node.vb != -1) {
        vertex_submit(_node.vb, pr_trianglelist, -1);
    }
    
    // Draw children
    var _arr_children = _node.children;
    var _arr_sample_children = _sample_node.children;
    var _arr_sample_children_next = _sample_node_next.children;
    for(var i = 0;i < array_length(_arr_children);i++) {
        draw_node(_arr_children[i], _arr_sample_children[i], _arr_sample_children_next[i], _lerp);
    }
    
    matrix_stack_pop();  // Pop sample transform
    
    matrix_stack_pop();  // Pop rig transform
}