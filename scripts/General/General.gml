/// General Functions
/// 
/// 

/// @func json_load
/// @desc Loads the contents of a JSON file and returns them as a string

/// @param {string} _path The path to the JSON file
/// 
/// @returns {string}
/// 
function json_load(_path) {
    var _buff = buffer_load(_path);
    var _json = buffer_read(_buff, buffer_text);
    buffer_delete(_buff);
    return _json;
}