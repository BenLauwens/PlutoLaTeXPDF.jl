module PlutoLaTeXPDF

using Markdown
using Pluto: ServerSession, SessionActions, can_show_logs
using Gumbo

export tolatex, latextoPDF, toPDF

function _inline_tolatex(io::IOBuffer, arr::Vector{Any})
    for element in arr
        _inline_tolatex(io, element)
    end
end

function _inline_tolatex(io::IOBuffer, txt::String)
    txt = replace(txt, '_' => raw"\_",
                       '^' => raw"\^{}",
                       '%' => raw"\%",
                       '#' => raw"\#",
                       '\\' => raw"\textbackslash ",
                       '$' => raw"\$"
                       )
    print(io, txt)
end

_inline_tolatex(io::IOBuffer, f::Float64) = print(io, f)

_inline_tolatex(io::IOBuffer, i::Int64) = print(io, i)

function _inline_tolatex(io::IOBuffer, math::Markdown.LaTeX)
    print(io, raw"$", math.formula, raw"$")
end

function _inline_tolatex(io::IOBuffer, code::Markdown.Code)
    print(io, raw"\texttt{")
    _inline_tolatex(io, code.code)
    print(io, "}")
end

function _inline_tolatex(io::IOBuffer, italic::Markdown.Italic)
    print(io, raw"\textit{")
    _inline_tolatex(io, italic.text)
    print(io, "}")
end

function _inline_tolatex(io::IOBuffer, bold::Markdown.Bold)
    print(io, raw"\textbf{")
    _inline_tolatex(io, bold.text)
    print(io, "}")
end

function _inline_tolatex(io::IOBuffer, link::Markdown.Link)
    print(io, raw"\href{")
    _inline_tolatex(io, link.url)
    print(io, "}{")
    _inline_tolatex(io, link.text)
    print(io, "}")
end

function _inline_tolatex(io::IOBuffer, footnote::Markdown.Footnote)
    print(io, raw"\footnotemark[", footnote.id, "]")
end

function _inline_tolatex(io::IOBuffer, unknown)
    dump(unknown)
end

function _tolatex(io::IOBuffer, unknown)
    dump(unknown)
end

function _tolatex(io::IOBuffer, md::Markdown.MD)
    _tolatex(io, md.content)
end

function _tolatex(io::IOBuffer, arr::Vector)
    for (nr, element) in enumerate(arr)
        if nr !=1 && element isa Markdown.Paragraph
            print(io, raw"\par ")
        end
        _tolatex(io, element)
    end
end

function _tolatex(io::IOBuffer, h1::Markdown.Header{1})
    print(io, raw"\chapter{")
    _inline_tolatex(io, h1.text)
    println(io, "}")
end

function _tolatex(io::IOBuffer, h2::Markdown.Header{2})
    print(io, raw"\section{")
    _inline_tolatex(io, h2.text)
    println(io, "}")
end

function _tolatex(io::IOBuffer, h3::Markdown.Header{3})
    print(io, raw"\subsection{")
    _inline_tolatex(io, h3.text)
    println(io, "}")
end

function _tolatex(io::IOBuffer, h4::Markdown.Header{4})
    print(io, raw"\subsubsection{")
    _inline_tolatex(io, h4.text)
    println(io, "}")
end

function _tolatex(io::IOBuffer, par::Markdown.Paragraph)
    _inline_tolatex(io, par.content)
    println(io)
end

function _tolatex(io::IOBuffer, eq::Markdown.LaTeX)
    println(io, raw"\begin{equation}")
    println(io, eq.formula)
    println(io, raw"\end{equation}")
end

function _tolatex(io::IOBuffer, src::Markdown.Code)
    language = if src.language == "" "text" else src.language end
    println(io, raw"\begin{minted}[frame=single]{", language, "}")
    println(io, replace(src.code, '\t' => "    ", "\\\"" => "\""))
    println(io, raw"\end{minted}")
end

function _tolatex(io::IOBuffer, blockquote::Markdown.BlockQuote)
    println(io, raw"\begin{awesomeblock}[Navy]{2pt}{\faQuoteLeft}{Navy}")
    _tolatex(io, blockquote.content)
    println(io, raw"\end{awesomeblock}")
end

function _tolatex(io::IOBuffer, footnote::Markdown.Footnote)
    print(io, raw"\footnotetext[", footnote.id, "]{")
    _tolatex(io, footnote.text)
    println(io, "}")
end

function _tolatex(io::IOBuffer, table::Markdown.Table)
    rows = table.rows
    len_row = length(rows)
    println(io, raw"\begin{center}")
    println(io, raw"\begin{tabular}{", reduce(*, map(string, table.align)),"}")
    println(io, raw"\hline")
    for (nr_row, columns) in enumerate(rows)
        len_col = length(columns)
        if nr_row == 2 println(io, raw"\hline") end
        for (nr_col, cell) in enumerate(columns)
            _inline_tolatex(io, cell)
            if nr_col != len_col
                print(io, " & ")
            else
                print(io, " \\\\")
            end
        end
        println(io)
    end
    println(io, raw"\hline")
    println(io, raw"\end{tabular}")
    println(io, raw"\end{center}")
end

const ADMONITIONTYPES = Dict{String, Tuple{String, String}}(
    "danger" => ("cautionblock", ""),
    "warning" => ("warningblock", ""),
    "info" => ("noteblock", ""),
    "note" => ("noteblock", ""),
    "tip" => ("tipblock", ""),
    "important" => ("importantblock", "")
)

function _tolatex(io::IOBuffer, admonition::Markdown.Admonition)
    if admonition.category ∈ keys(ADMONITIONTYPES)
        admonitiontype = get(ADMONITIONTYPES, admonition.category, ("awesomeblock", raw"[black]{2pt}{\faLaptop}{black}"))
        println(io, raw"\begin{", admonitiontype[1], "}", admonitiontype[2])
        _tolatex(io, admonition.content)
        println(io, raw"\end{", admonitiontype[1], "}")
    else
        print(io, raw"\begin{", admonition.category, "}")
        if admonition.title != uppercasefirst(admonition.category)
            print(io, "[", split(admonition.title, uppercasefirst(admonition.category) * " of ")[end], "]")
            if uppercasefirst(admonition.category) == "Template"
                print(io, raw"\mbox{}")
                println(io, raw"\par")
            else
                println(io)
            end
        end
        _tolatex(io, admonition.content)
        println(io, raw"\end{", admonition.category, "}")
    end
end

const LISTTYPES = Dict{Int64, String}(
    -1 => "itemize",
)

function _tolatex(io::IOBuffer, list::Markdown.List)
    listtype = get(LISTTYPES, list.ordered, "enumerate")
    println(io, raw"\begin{", listtype, "}")
    for item in list.items
        print(io, raw"\item ")
        _tolatex(io, item)
    end
    println(io, raw"\end{", listtype, "}")
end

function _outputtolatex(io::IOBuffer, arr::Vector)
    for (nr, element) in enumerate(arr)
        if nr > 10
            print(io, ", ...")
            break
        end
        if nr != 1 && element isa Tuple
            print(io, ", ")
        end
        if element isa Dict{Symbol, Any}
            print(io, nr, ". ")
        end
        _outputtolatex(io, element)
    end
end

function _outputtolatex(io::IOBuffer, element::Tuple{Int64, Tuple})
    mime = element[2][2]
    content = element[2][1]
    if mime == MIME("application/vnd.pluto.tree+object")
        _outputtolatex(io, content)
    elseif mime == MIME("text/plain")
        print(io, content)
    else
        dump(element)
    end
end

function _outputtolatex(io::IOBuffer, element::Tuple{Symbol, Tuple{String, MIME{Symbol("text/plain")}}})
    field = element[1]
    value = element[2][1]
    print(io, field, " = ", value)
end

function _outputtolatex(io::IOBuffer, element::Tuple{Tuple{String, MIME{Symbol("text/plain")}}, Tuple{String, MIME{Symbol("text/plain")}}})
    key = element[1][1]
    value = element[2][1]
    print(io, key, " => ", value)
end

function _outputtolatex(io::IOBuffer, element::Tuple{Symbol, Tuple{Dict{Symbol, Any}, MIME{Symbol("application/vnd.pluto.tree+object")}}})
    field = element[1]
    print(io, field, " = ")
    _outputtolatex(io, element[2][1])
end

function _outputtolatex(io::IOBuffer, element::Tuple{Tuple{String, MIME{Symbol("text/plain")}}, Tuple{Dict{Symbol, Any}, MIME{Symbol("application/vnd.pluto.tree+object")}}})
    key = element[1][1]
    print(io, key, " => ")
    _outputtolatex(io, element[2][1])
end

function _outputtolatex(io::IOBuffer, parent::Dict{Symbol, Any})
    type = get(parent, :type, :nothing)
    if type == :Tuple
        print(io, "(")
        _outputtolatex(io, parent[:elements])
        print(io, ")")
    elseif type == :Array
        print(io, parent[:prefix], "[")
        _outputtolatex(io, parent[:elements])
        print(io, "]")
    elseif type == :Set
        print(io, parent[:prefix], "()")
        _outputtolatex(io, parent[:elements])
        print(io, ")")
    elseif type == :Dict
        print(io, parent[:prefix], "(")
        _outputtolatex(io, parent[:elements])
        print(io, ")")
    elseif type == :struct
        print(io, parent[:prefix], "(")
        _outputtolatex(io, parent[:elements])
        print(io, ")")
    elseif haskey(parent, :stacktrace)
        println(io, parent[:msg])
        _outputtolatex(io, parent[:stacktrace])
    elseif haskey(parent, :call)
        file = parent[:file]
        if file != "none"
            print(io, parent[:call], " @ ")
            print(io, occursin('#', file) ? "Local" : file, ":", parent[:line])
            println(io, parent[:inlined] ? " [inlined]" : "")
        end
    else
        @show keys(parent)
        @show values(parent)
        dump(parent)
    end
end

function _outputtolatex(io::IOBuffer, unknown)
    dump(unknown)
end

function htmltolatex(io::IOBuffer, text::HTMLText)
    _inline_tolatex(io, text.text)
end

function htmltolatex(io::IOBuffer, node::HTMLElement{:p})
    print(io, raw"\par ")
    for elem in node.children
        htmltolatex(io, elem)
    end
    println(io)
end

function htmltolatex(io::IOBuffer, node::HTMLElement{:span})
    print(io, raw"\par\textbf{")
    for elem in node.children
        htmltolatex(io, elem)
    end
    println(io, raw"}")
end

function htmltolatex(io::IOBuffer, node::HTMLElement{:ul})
    println(io, raw"\begin{itemize}")
    for elem in node.children
        htmltolatex(io, elem)
    end
    println(io, raw"\end{itemize}")
end

function htmltolatex(io::IOBuffer, node::HTMLElement{:li})
    print(io, raw"\item ")
    for elem in node.children
        htmltolatex(io, elem)
    end
    println(io)
end

function htmltolatex(io::IOBuffer, node::HTMLElement{:b})
    print(io, raw"\textbf{")
    for elem in node.children
        htmltolatex(io, elem)
    end
    print(io, raw"}")
end

function htmltolatex(io::IOBuffer, node::HTMLElement{:code})
    print(io, raw"\texttt{")
    for elem in node.children
        htmltolatex(io, elem)
    end
    print(io, raw"}")
end

function htmltolatex(io::IOBuffer, node::HTMLElement{:em})
    print(io, raw"\textit{")
    for elem in node.children
        htmltolatex(io, elem)
    end
    print(io, raw"}")
end

function htmltolatex(io::IOBuffer, node::HTMLNode)
    for elem in node.children
        htmltolatex(io, elem)
    end
end

const LOGTYPES = Dict{String, Tuple{String, String}}(
    "Info" => ("noteblock", ""),
    "Warn" => ("warningblock", ""),
    "Error" => ("cautionblock", ""),
    "Debug" => ("awesomeblock", raw"[violet]{2pt}{\faBug}{violet}")
)

_is_pluto_file(file::String) = first(eachline(file)) == "### A Pluto.jl notebook ###"

function _tolatex(file::String)
    session = ServerSession()
    session.options.evaluation.workspace_use_distributed = true
    session.options.evaluation.capture_stdout = true
    session.options.server.disable_writing_notebook_files = true
    if !isfile(file) error("File does not exist!") end
    name, ext = splitext(basename(file))
    if ext != ".jl" error("File has no .jl extension!") end
    if ! _is_pluto_file(file) error("File is no Pluto file!") end
    notebook = SessionActions.open(session, file; run_async=false)
    imagecounter = 0
    io = IOBuffer()
    for cell_uuid in notebook.cell_order
        cell = notebook.cells_dict[cell_uuid]
        code = cell.code
        output = cell.output
        if startswith(code, "md\"")
            markdown = code[4:end-1]
            while startswith(markdown, '"') markdown = markdown[2:end-1] end
            _tolatex(io, Markdown.parse(markdown))
        elseif output.mime == MIME("image/svg+xml")
            imagecounter += 1
            imagefile = name * "_image_" * string(imagecounter) * ".svg"
            println(io, raw"\begin{filecontents*}[force]{", imagefile, "}")
            println(io, String(output.body), raw"\end{filecontents*}")
            if isempty(cell.logs)
                println(io, raw"\begin{center}")
                println(io, raw"\includesvg{", imagefile, "}")
                println(io, raw"\end{center}")
            else
                println(io, raw"\begin{figure}[h]")
                println(io, raw"\centering")
                println(io, raw"\includesvg{", imagefile, "}")
                print(io, raw"\caption{")
                for log in cell.logs
                    _inline_tolatex(io, log["msg"][1])
                end
                println(io, "}")
                println(io, raw"\end{figure}")
            end
        elseif output.mime == MIME("text/plain")
            if output.body != ""
                println(io, raw"\needspace{2\baselineskip}")
                println(io, raw"\begin{minted}{text}")
                println(io, output.body)
                println(io, raw"\end{minted}")
            end
        elseif output.mime == MIME("application/vnd.pluto.tree+object")
            println(io, raw"\begin{minted}{text}")
            _outputtolatex(io, output.body)
            println(io, "\n", raw"\end{minted}")
        elseif output.mime == MIME("application/vnd.pluto.stacktrace+object")
            println(io, raw"\color{red}")
            println(io, raw"\begin{minted}{text}")
            _outputtolatex(io, output.body)
            println(io, raw"\end{minted}")
            println(io, raw"\color{black}")
        elseif output.mime == MIME("text/html")
            if startswith(output.body, "<div class=\"markdown\">")
                if occursin("Version", output.body) # ThinkJulia hack
                    io_banner = IOBuffer()
                    Base.banner(io_banner)
                    banner = String(take!(io_banner))
                    println(io, raw"\begin{minted}[frame=single]{jlcon}")
                    println(io, banner * "julia>")
                    println(io, raw"\end{minted}")
                else
                    html = parsehtml(output.body)
                    #println(io)
                    print(io, raw"\par ")
                    htmltolatex(io, html.root[2])
                end
            else
                html = parsehtml(output.body)
                #println(io)
                print(io, raw"\par \ttfamily ")
                htmltolatex(io, html.root[2])
                println(io, raw"\rmfamily")
            end
        else
            dump(output)
        end
        if !cell.code_folded
            println(io, raw"\begin{minted}[frame=single]{julia}")
            println(io, replace(code, '\t' => "    "))
            println(io, raw"\end{minted}")
        end
        if can_show_logs(cell) && output.mime != MIME("image/svg+xml")
            for log in cell.logs
                logtype = get(LOGTYPES, log["level"], ("awesomeblock", raw"[black]{2pt}{\faTerminal}{black}"))
                println(io, raw"\begin{", logtype[1], "}", logtype[2])
                print(io, raw"\ttfamily ")
                msg = String(rstrip(log["msg"][1], '\n'))
                print(io, replace(msg, '\n' => "\n\n",
                                       ' ' => raw"\ ",
                                       '_' => raw"\_",
                                       "\\\"" => "\"",
                                       '\\' => raw"\textbackslash "))
                for kwarg in log["kwargs"]
                    print(io, raw"\par ")
                    _inline_tolatex(io, kwarg[1])
                    print(io, ": ")
                    _inline_tolatex(io, kwarg[2][1])
                end
                println(io, raw"\end{", logtype[1], "}")
            end
        end
    end
    String(take!(io))
end

function latextoPDF(file::String)
    dir, name = splitdir(file)
    cd(dir)
    for i in 1:3
        @info "LaTeX run $i"
        success(`xelatex -interaction=nonstopmode -shell-escape $name`)
    end
end

function tolatex(dir::String, file::String)
    if isdir(dir) cd(dir) else error("Directory does not exist!") end
    cd(dir)
    name, _ = splitext(basename(file))
    write(joinpath(dir, name * ".tex"), _tolatex(file))
end

function toPDF(dir::String, file::String; author::String="")
    if isdir(dir) cd(dir) else error("Directory does not exist!") end
    cd(dir)
    name, _ = splitext(basename(file))
    name = name * ".tex"
    content = _tolatex(file)
    template = joinpath(@__DIR__, "..", "template", "article.tex")
    document = read(template, String)
    m = match(r"\\chapter{(.*)}\n", content)
    title = if m === nothing
        ""
    else
        content = replace(content, m.match => "")
        m.captures[1]
    end
    document = replace(document, "TITLE" => title,
                                 "AUTHOR" => author,
                                 "CONTENT" => content)
    write(joinpath(dir, name), document)
    for i in 1:3
        @info "LaTeX run $i"
        success(`xelatex -interaction=nonstopmode -shell-escape $name`)
    end
end

function toPDF(path::String, files::Vector{String};
               title::String="",
               author::String="",
               template::String=joinpath(@__DIR__, "..", "template", "book.tex"),
               language::String="english")
    dir = dirname(path)
    if isdir(dir) cd(dir) else error("Directory does not exist!") end
    cd(dir)
    io = IOBuffer()
    for file in files
        name, _ = splitext(basename(file))
        @info "Convert " * name
        println(io, raw"\include{" * name *"}")
        content = _tolatex(file)
        write(joinpath(dir, name * ".tex"), content)
    end
    document = replace(read(template, String), "LANGUAGE" => language,
                                               "TITLE" => title,
                                               "AUTHOR" => author,
                                               "CONTENT" => String(take!(io)))
    name, _ = splitext(basename(path))
    name = name * ".tex"
    write(joinpath(dir, name), document)
    for i in 1:3
        @info "LaTeX run $i"
        success(`xelatex -interaction=nonstopmode -shell-escape $name`)
    end
end

end
