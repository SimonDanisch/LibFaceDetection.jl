using GLMakie, LibFaceDetection, FileIO
path = download("https://thumbs.dreamstime.com/z/many-faces-2754451.jpg", "faces.jpg")
img = load(path)
faces = detect_faces(img)
scene = image(rotr90(img), scale_plot=false)
for face in faces
    linesegments!(face.boundingbox)
    scatter!(face.points)
end
display(scene)
