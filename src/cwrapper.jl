const SRect = Rect{2, Cshort}
const SPoint = Point{2, Cshort}

struct FaceLocationRaw
    confidence::Cshort
    boundingbox::SRect
    points::NTuple{5, SPoint}
    padding::NTuple{127, Cshort}
end

"""
    confidence: value between 0..1
    boundingbox: axis aligned boundingbox of the face
    points: 5 points, 2xeye, nose, 2xmouth
"""
struct FaceLocation
    confidence::Float64
    boundingbox::Rect{2, Float32}
    points::Vector{Point2f0}
end

convert_point(rows, p) = Point2f0(p[1], rows - p[2])
getpoints(rows, face) = convert_point.(rows, collect(face.points))

function convert_rect(rows, face)
    r = face.boundingbox
    o = origin(r)
    wh = widths(r)
    return Rect(Vec(convert_point(rows, o)) - Vec2f0(0, wh[2]), Vec2f0(wh))
end

function convert_location(rows::Int, location::FaceLocationRaw)
    return FaceLocation(location.confidence/100.0,
                        convert_rect(rows, location),
                        getpoints(rows, location))
end

const FUNC_NAME = if Sys.isapple() || (Sys.iswindows() && Sys.ARCH == :i686)
    :__Z14facedetect_cnnPhS_iii
else
    :_Z14facedetect_cnnPhS_iii
end

function detect_faces(img)
    buffer = fill(Cuchar(0), 0x20000)
    img_conv = BGR{N0f8}.(permutedims(img))
    # buffer needs to be preserved outside ccall since i think
    # it's used for the return value
    GC.@preserve buffer begin
        result = ccall((FUNC_NAME, libfacedetection), Ptr{Cint}, (Ptr{Cuchar}, Ptr{Cuchar}, Cint, Cint, Cint),
                        buffer, img_conv, size(img, 2), size(img, 1), size(img, 2)*3)
        result == C_NULL && return nothing
        n_faces = unsafe_load(result)
        faces = unsafe_wrap(Array, Ptr{FaceLocationRaw}(Ptr{Cshort}(result) + 4), n_faces)
        return convert_location.(size(img, 1), faces)
    end
end
