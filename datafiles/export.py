import bpy
import json
import struct
import math

from struct import pack
from math import degrees

def get_node_data(node, model_map):
    offset = (0, node.parent.length, 0) if node.parent else node.head_local
    matrix = node.matrix
    
    return {
        "translation": offset[:],
        "rotation": [-degrees(angle) for angle in matrix.to_euler('YXZ')],
        "model": model_map[node.name] if node.name in model_map else "",
        "children": [get_node_data(child_node, model_map) for child_node in node.children]
    }

def get_sample_data(node):
    offset = (0, 0, 0)
    matrix = node.matrix_basis
    
    return {
        "translation": offset[:],
        "rotation": [-degrees(angle) for angle in matrix.to_euler('YXZ')],
        "children": [get_sample_data(child_node) for child_node in node.children]
    }

# Where should this go, relative to the .blend file?
directory = bpy.path.abspath("//") + "/models/"

scene = bpy.context.scene
obj = bpy.context.object  # Rig object!

rig = obj.data
pose = obj.pose

# Write meshes and build model map (bone.name -> file path)
model_map = {}
mesh_objects = [o for o in obj.children if o.type == 'MESH']
for mesh_obj in mesh_objects:
    # Add to model map
    if mesh_obj.parent_type != 'BONE':
        # Not a mesh to consider!
        continue
    
    name = bpy.path.clean_name(mesh_obj.name).lower()
    model_map[mesh_obj.parent_bone] = name
    
    # Gather mesh data
    model_bytes = bytearray()
    
    mesh_data = mesh_obj.data
    
    for tri in mesh_data.loop_triangles:
        for li in reversed(tri.loops):
            vi = mesh_data.loops[li].vertex_index
            vertex = mesh_data.vertices[vi]
            
            co = vertex.co
            nml = vertex.normal
            
            # TODO Explanation for the minus signs used
            model_bytes.extend(pack('fff', *(-co.y, co.z, -co.x)))    # position
            model_bytes.extend(pack('fff', *(-nml.y, nml.z, -nml.x))) # normal
            model_bytes.extend(pack('BBBB', *(255, 255, 255, 255)))   # white, opaque
            model_bytes.extend(pack('ff', *(0, 0)))                   # don't use uv's
    
    # Write to file
    with open(directory + "/" + name + ".vbx", 'wb') as file:
        file.write(model_bytes)
    

# Get root bones/nodes
rig_roots = [b for b in rig.bones if not b.parent]
pose_roots = [b for b in pose.bones if not b.parent]

# Get the armature/rig data
rig_data = {
    "translation": (0, 0, 0),
    "rotation": (0, 0, 0),
    "model": "",
    "children": [get_node_data(rig_root, model_map) for rig_root in rig_roots]
}

# Get the sample data at every frame (NOT keyframe!)
sample_data = []
f_current = scene.frame_current
f_start = int(scene.frame_start)
f_end = int(scene.frame_end)
for frame in range(f_start, f_end):
    scene.frame_set(frame)
    sample_data.append({
        "translation": (0, 0, 0),
        "rotation": (0, 0, 0),
        "model": "",
        "children": [get_sample_data(pose_root) for pose_root in pose_roots]
    })
scene.frame_set(f_current)

# Write rig and animation data
name = bpy.path.clean_name(obj.name).lower()

with open(directory + "/" + name + ".rig", 'w') as file:
    json.dump(rig_data, file)

with open(directory + "/" + name + ".anim", 'w') as file:
    json.dump(sample_data, file)

