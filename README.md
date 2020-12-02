# LibFaceDetection

[![Build Status](https://github.com/SimonDanisch/LibFaceDetection.jl/workflows/CI/badge.svg)](https://github.com/SimonDanisch/LibFaceDetection.jl/actions)
[![Coverage](https://codecov.io/gh/SimonDanisch/LibFaceDetection.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/SimonDanisch/LibFaceDetection.jl)

Wrapper for https://github.com/ShiqiYu/libfacedetection

Usage:

```julia
using GLMakie, LibFaceDetection, FileIO
path = download("https://thumbs.dreamstime.com/z/many-faces-2754451.jpg", "faces.jpg")
img = load(path)
faces = detect_faces(img)
scene = image(rotr90(img), scale_plot=false, show_axis=false)
for face in faces
    linesegments!(face.boundingbox)
    scatter!(face.points, markersize=20, color=tuple.([:blue, :blue, :green, :red, :red], 0.4))
end
display(scene)
```

![image](https://user-images.githubusercontent.com/1010467/100922072-b4c29580-34dd-11eb-9c03-1c0310260f24.png)

