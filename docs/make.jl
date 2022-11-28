using Resizing
using Documenter

DocMeta.setdocmeta!(Resizing, :DocTestSetup, :(using Resizing); recursive=true)

makedocs(;
    modules=[Resizing],
    authors="Zachary P. Christensen <zchristensen7@gmail.com> and contributors",
    repo="https://github.com/Tokazama/Resizing.jl/blob/{commit}{path}#{line}",
    sitename="Resizing.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Tokazama.github.io/Resizing.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Tokazama/Resizing.jl",
    devbranch="main",
)
