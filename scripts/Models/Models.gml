/// Basic 3D Model Functionality
/// 
/// 

#region Vertex Formats

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_color();
vertex_format_add_texcoord();
fmt_default_normal = vertex_format_end();

#endregion

#region Functions

/// @func model_load
/// @desc Loads a single model from a file and returns it as a frozen vertex buffer.
///
/// @param {string} _fname The filename to load
/// @param {ID.VertexFormat} _format The vertex format to use (and that the data is in)
/// 
/// @returns {ID.VertexBuffer}
/// 
function model_load(_fname, _format=global.fmt_default_normal) {
    var _buff = buffer_load(_fname);
    var _vb = vertex_create_buffer_from_buffer(_buff, _format);
    vertex_freeze(_vb);
    buffer_delete(_buff);
    return _vb;
}

#endregion