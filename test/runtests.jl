using PlutoLaTeXPDF
using Test
using Printf

@testset "PlutoLaTeXPDF.jl" begin
    #=
    PlutoLaTeXPDF.ADMONITIONTYPES["languages"] = ("awesomeblock", raw"[ForestGreen]{2pt}{\faCode}{ForestGreen}")
    PlutoLaTeXPDF.ADMONITIONTYPES["c"] = ("awesomeblock", raw"[ForestGreen]{2pt}{\textbf{\sffamily C}}{ForestGreen}")
    PlutoLaTeXPDF.ADMONITIONTYPES["python"] = ("awesomeblock", raw"[ForestGreen]{2pt}{\faPython}{ForestGreen}")
    PlutoLaTeXPDF.ADMONITIONTYPES["matlab"] = ("awesomeblock", raw"[ForestGreen]{2pt}{\textbf{\sffamily M}}{ForestGreen}")
    PlutoLaTeXPDF.ADMONITIONTYPES["continue"] = ("awesomeblock", raw"{2pt}{\faEllipsis}{black}")
    dir = joinpath(@__DIR__, "..", "example")
    file = joinpath(@__DIR__, "notebooks", "test_1.jl")
    file = joinpath(homedir(), "GitHub", "ES123", "Lectures", "Lecture00.jl")
    toPDF(dir, file; author="Ben Lauwens")
    files = String[]
    for i in 1:18
        file = @sprintf "Lecture%0.2u.jl" i
        push!(files, joinpath(homedir(), "GitHub", "ES123", "Lectures", file))
    end
    #=
    toPDF(joinpath(@__DIR__, "..", "example", "book.pdf"), files;
               title="ThinkJulia, How to Think as a Computer Scientist",
               author="Ben Lauwens",
               template=joinpath(@__DIR__, "..", "template", "oreilly.tex"))
    =#
    =#
    files = String[]
    for i in 1:3
        file = @sprintf "Lecture%0.2u" i
        push!(files, joinpath(homedir(), "Documents", "Github", "ES111", "Lectures", file * ".jl"))
    end
    toPDF(joinpath(homedir(), "Documents", "Github", "ES111", "Calculus.pdf"), files;
               title="Calculus",
               author="Ben Lauwens",
               template=joinpath(@__DIR__, "..", "template", "oreilly.tex"),
               language="english")
end
