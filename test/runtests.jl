using PlutoLaTeXPDF
using Test

@testset "PlutoLaTeXPDF.jl" begin
    PlutoLaTeXPDF.ADMONITIONTYPES["languages"] = ("awesomeblock", raw"[ForestGreen]{2pt}{\faCode}{ForestGreen}")
    dir = joinpath(@__DIR__, "..", "example")
    file = joinpath(@__DIR__, "notebooks", "test_1.jl")
    file = joinpath(homedir(), "GitHub", "ES123", "Lectures", "Lecture07.jl")
    #toPDF(dir, file; author="Ben Lauwens")
    files = String[]
    for i in 1:7
        push!(files, joinpath(homedir(), "GitHub", "ES123", "Lectures", "Lecture0$i.jl"))
    end
    ##=
    toPDF(joinpath(@__DIR__, "..", "example", "book.pdf"), files;
               title="ThinkJulia, How to Think as a Computer Scientist",
               author="Ben Lauwens",
               template=joinpath(@__DIR__, "..", "template", "oreilly.tex"))
    ##=#
end
