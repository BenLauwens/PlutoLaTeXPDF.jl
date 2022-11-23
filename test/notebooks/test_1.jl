### A Pluto.jl notebook ###
# v0.19.15

using Markdown
using InteractiveUtils

# ╔═╡ db7cb529-b5c3-42ef-a245-e688a25c8bda
# ╠═╡ show_logs = false
begin
    import Pkg
    # activate a temporary environment
    # Pkg.activate(mktempdir())
    # Pkg.add(url="https://github.com/BenLauwens/NativeSVG.jl.git")
	Pkg.activate()
    using NativeSVG
end

# ╔═╡ 48e21c30-6985-11ed-1d70-95ccaf4a4e55
md"# Test 1"

# ╔═╡ cb672b94-e5f5-43f5-a480-3946a4fa527a
md"## Return Values"

# ╔═╡ 27739825-c5aa-4f1d-8753-0ea463426bd8
1 + 1 == 2

# ╔═╡ b630417d-576a-4aa3-bd58-c40c9c6aa98a
ones(2), rand(4)

# ╔═╡ d464e275-83d1-45fe-94e9-73cdac408db8
"ja", "nee"

# ╔═╡ 3fb1e683-0e17-43da-be80-0bc7dc993029
Dict("ja" => 1, "nee" => 0)

# ╔═╡ 8cbcd4ad-77e0-4c28-9a54-13e80044ec3a
md"## Printing and Logging"

# ╔═╡ aee58110-44e7-4eb5-8ea1-26662e078f72
let a = 150, b = 158
	@info "Hello, World!" a
	@debug "Debug" b
end

# ╔═╡ 389f4b8f-6853-4046-bb4f-05672250a5dd
println("Hello, World!")

# ╔═╡ c68e47f6-4876-4aa3-bb39-5f28930a12c6
md"## Markdown"

# ╔═╡ 06abcf47-dba3-492b-bf9e-37c7a6013f49
md"""This is a `nice` *formula* relating **energy** ``E`` and **`mass`** ``m``

```math
E = mc^2
```
and some *`Julia`* code
```julia
println("Hello, World!")
```
"""

# ╔═╡ 61800de0-4630-4632-a1c8-6f70c5dd850d
md"""!!! danger
    The first word after `!!!` declares the type of the admonition. There are standard admonition types that should produce special styling. Namely (in order of decreasing severity): `danger`, `warning`, `info/note`, and `tip`.

    You can also use your own admonition types, as long as the type name only contains lowercase Latin characters (`a-z`).
"""

# ╔═╡ 0272f099-c517-471c-885f-631199818470
md"## Scalable Vector Graphics"

# ╔═╡ 2fb3f97d-4a89-4395-91ad-b57e27fe8fc8
let
	@info "Julia Symbol"
	Drawing(width="100", height="75") do
		g(stroke_linecap="butt", stroke_miterlimit="4", stroke_width="3.0703125") do
			circle(cx="20", cy="20", r="16", stroke="#cb3c33", fill="#d5635c")
			circle(cx="40", cy="56", r="16", stroke="#389826", fill="#60ad51")
			circle(cx="60", cy="20", r="16", stroke="#9558b2", fill="#aa79c1")
		end
	end
end

# ╔═╡ 8039edb1-d37c-4761-900f-96b8a562713a
Drawing(width=720, height=220) do
    rect(x=210, y=10, width=400, height=60, fill="rgb(242, 242, 242)", stroke="black")
	text(x=180, y=45, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("Main") 
	end
	text(x=280, y=30, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("line1") 
	end
	text(x=290, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=320, y=30, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"Bing tiddle \"") 
	end
	text(x=280, y=60, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("line2") 
	end
	text(x=290, y=60, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=320, y=60, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"tiddle bang\"") 
	end
	rect(x=210, y=80, width=400, height=90, fill="rgb(242, 242, 242)", stroke="black")
	text(x=180, y=130, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("cattwice") 
	end
	text(x=280, y=100, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("part1") 
	end
	text(x=290, y=100, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=320, y=100, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"Bing tiddle \"") 
	end
	text(x=280, y=130, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("part2") 
	end
	text(x=290, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=320, y=130, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"tiddle bang\"") 
	end
	text(x=280, y=160, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("concat") 
	end
	text(x=290, y=160, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=320, y=160, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"Bing tiddle tiddle bang\"") 
	end
	rect(x=210, y=180, width=400, height=30, fill="rgb(242, 242, 242)", stroke="black")
	text(x=180, y=200, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("printtwice") 
	end
	text(x=280, y=200, font_family="JuliaMono, monospace", text_anchor="end", font_size="0.85rem", font_weight=600) do
		str("bruce") 
	end
	text(x=290, y=200, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("→") 
	end
	text(x=320, y=200, font_family="JuliaMono, monospace", font_size="0.85rem", font_weight=600) do 
		str("\"Bing tiddle tiddle bang\"") 
	end
	@info "Stack diagram."
end

# ╔═╡ 912cdd0f-ef6a-4800-a3df-6f1bf4ee3c73
md"""## Lists

* a = b
* b = c
* c = d

1. a = b
2. b = c
3. c = d 
"""

# ╔═╡ Cell order:
# ╟─db7cb529-b5c3-42ef-a245-e688a25c8bda
# ╟─48e21c30-6985-11ed-1d70-95ccaf4a4e55
# ╟─cb672b94-e5f5-43f5-a480-3946a4fa527a
# ╠═27739825-c5aa-4f1d-8753-0ea463426bd8
# ╠═b630417d-576a-4aa3-bd58-c40c9c6aa98a
# ╠═d464e275-83d1-45fe-94e9-73cdac408db8
# ╠═3fb1e683-0e17-43da-be80-0bc7dc993029
# ╟─8cbcd4ad-77e0-4c28-9a54-13e80044ec3a
# ╠═aee58110-44e7-4eb5-8ea1-26662e078f72
# ╠═389f4b8f-6853-4046-bb4f-05672250a5dd
# ╟─c68e47f6-4876-4aa3-bb39-5f28930a12c6
# ╟─06abcf47-dba3-492b-bf9e-37c7a6013f49
# ╟─61800de0-4630-4632-a1c8-6f70c5dd850d
# ╟─0272f099-c517-471c-885f-631199818470
# ╟─2fb3f97d-4a89-4395-91ad-b57e27fe8fc8
# ╟─8039edb1-d37c-4761-900f-96b8a562713a
# ╟─912cdd0f-ef6a-4800-a3df-6f1bf4ee3c73
