module LibFaceDetection

using Colors
using FixedPointNumbers
using GeometryBasics
using libfacedetection_jll

# Write your package code here.
include("cwrapper.jl")

export detect_faces

end
