using LibFaceDetection
using Test
using FileIO
using GeometryBasics

@testset "LibFaceDetection.jl" begin
    img = load(joinpath(@__DIR__, "faces.jpg"))
    faces = detect_faces(img)
    @test length(faces) == 12
    @testset "faces: $(i)" for (i, face) in enumerate(faces)
        # mainly test against corruption!
        bb = face.boundingbox
        @test all(p-> p in bb, face.points)
        @test bb in Rect(Vec2f0(0, 0), Vec2f0(reverse(size(img))))
    end
end
