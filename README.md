# Resizing

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://Tokazama.github.io/Resizing.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://Tokazama.github.io/Resizing.jl/dev/)
[![Build Status](https://github.com/Tokazama/Resizing.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Tokazama/Resizing.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/Tokazama/Resizing.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/Tokazama/Resizing.jl)

Julia does not currently have a well developed interface for changing the size of collections. `Resizing` provides common methods for growing and shrinking collections. Although the relative position where a resizing method is executed may vary by method and collection type, a common pattern makes them straightforward to use and overload for new collections. For example, the following methods are responsible for growing a collection from the last index:

* `Resizing.unsafe_grow_end!(collection, n)`: assumes that all necessary conditions for growing `collection` by `n` elements from the last index are met without checking.
* `Resizing.grow_end!(collection, n)`: Calls `Resizing.unsafe_grow_end!(collection, n)` if it can determine that `collection` can safely grow by `n` elements from the last index, returning  `true` if successful.
* `Resizing.assert_grow_end!(collection, n)`: Calls `Resizing.grow_end!(collection, n)`. If `false` is returned it throws an error, otherwise returns `nothing`.

Note that `grow_end!` and `unsafe_grow_end!` must be defined for each new collection type, but `assert_grow_end!` can rely completely on the former two methods.

This same pattern exists for shrinking or growing at the beginning, end, or a specified index.

