module Resizing

import Compat: @assume_effects

# https://github.com/JuliaLang/julia/issues/34478

# TODO query if shared (`reshape`) so we can use `:nothrow` on `unsafe_*` methods
# https://github.com/JuliaLang/julia/pull/47540

"""
    can_grow_beg(collection) -> Bool

Return `true` if `collection` is an instance that can grow from its first index.
"""
can_grow_beg(x::Vector) = true
can_grow_beg(x) = false

"""
    can_grow_end(collection) -> Bool

Return `true` if `collection` is an instance that can grow from its last index.
"""
can_grow_end(x::Vector) = true
can_grow_end(x) = false

"""
    can_grow_at(collection, i) -> Bool

Return `true` if `collection` is an instance that can grow at index `i`.
"""
can_grow_at(x::Vector, i) = 1 <= i && i <= length(x)
can_grow_at(x, i) = false

"""
    can_delete_beg(collection, n) -> Bool

Return `true` if `collection` can delete `n` elements from its first index.
"""
can_delete_beg(x::Vector, delta) = length(x) - delta > 0
can_delete_beg(x, delta) = false

"""
    can_delete_end(collection, n) -> Bool

Return `true` if `collection` can delete `n` elements from its last index.
"""
can_delete_end(x::Vector, delta) = length(x) - delta > 0
can_delete_end(x, delta) = false

"""
    can_delete_at(collection, i, n) -> Bool

Return `true` if `collection` can delete `n` elements from index, `i`.
"""
can_delete_at(x::Vector, i, delta) = 1 <= i && (i + delta) <= length(x)
can_delete_at(x, i, delta) = false

"""
    unsafe_delete_end!(collection, n)

Deletes `n` elements from the last index of `collection`. This method assumes that
`can_delete_end(collection, n) == true`.
"""
@assume_effects :terminates_locally function unsafe_delete_end!(x::Vector, delta)
    ccall(:jl_array_del_end, Cvoid, (Any, UInt), x, delta)
end

"""
    unsafe_delete_beg!(collection, n)

Deletes `n` elements from the first index of `collection`. This method assumes that
`can_delete_beg(collection, n) == true`.
"""
@assume_effects :terminates_locally function unsafe_delete_beg!(x::Vector, delta)
    ccall(:jl_array_del_beg, Cvoid, (Any, UInt), x, delta)
end

"""
    unsafe_delete_at!(collection, i, n)

Deletes `n` elements from index `i` of `collection`. This method assumes that
`can_delete_at(collection, i, n) == true`.
"""
@assume_effects :terminates_locally function unsafe_delete_at!(x::Vector, i, delta)
    ccall(:jl_array_del_at, Cvoid, (Any, Int, UInt), x, i-1, delta)
end

"""
    unsafe_grow_beg!(collection, n)

Grows by `n` elements at the first index of `collection`. This method assumes that
`can_grow_beg(collection, n) == true`.
"""
@assume_effects :terminates_locally function unsafe_grow_beg!(x::Vector, delta)
    ccall(:jl_array_grow_end, Cvoid, (Any, UInt), x, delta)
end

"""
    unsafe_grow_end!(collection, n)

Grows by `n` elements at the last index of `collection`. This method assumes that
`can_grow_end(collection, n) == true`.
"""
@assume_effects :terminates_locally function unsafe_grow_end!(x::Vector, delta)
    ccall(:jl_array_grow_end, Cvoid, (Any, UInt), x, delta)
end

"""
    unsafe_grow_at!(collection, i, n)

Grows by `n` elements at index `i` of `collection`. This method assumes that
`can_grow_at(collection, i, n) == true`.
"""
@assume_effects :terminates_locally function unsafe_grow_at!(x::Vector, i::Int, delta)
    ccall(:jl_array_grow_at, Cvoid, (Any, Int, UInt), x, i-1, delta)
end

"""
    delete_end!(collection, n::Integer=1) -> Bool

Deletes `n` elements from begining at the last index of `collection`.
If successful this will return `true`.
"""
function delete_end!(x, delta=1)
    if can_delete_end(x, delta)
        unsafe_delete_end!(x, delta)
        return true
    else
        return false
    end
end

"""
    grow_beg!(collection, n::Integer=1) -> Bool

Grow `collection` by `n` elements from its first index. This does not ensure that new
elements are defined. If successful this will return `true`.
"""
function delete_beg!(x, delta=1)
    if can_delete_beg(x, delta)
        unsafe_delete_beg!(x, delta)
        return true
    else
        return false
    end
end

"""
    delete_at!(collection, i::Int, n::Integer) -> Bool

Shrink `collection` by `n` elements at index `i`.  This does not ensure that new
elements are defined. If successful this will return `true`.
"""
function delete_at!(x, i, delta=1)
    if can_delete_at(x, i, delta)
        unsafe_delete_at!(x, i, delta)
        return true
    else
        return false
    end
end

"""
    grow_at!(collection, i::Int, n::Integer=1) -> Bool

Grow `collection` by `n` elements at index `i`. This does not ensure that new
elements are defined. If successful this will return true return `true`.
"""
function grow_at!(x, i, delta=1)
    if can_grow_at(x, i)
        unsafe_grow_at!(x, i, delta)
        return true
    else
        return false
    end
end

"""
    grow_end!(collection, n::Integer=1) -> Bool

Grow `collection` by `n` elements from its last index. This does not ensure that new
elements are defined. If successful this will return `true`.
"""
function grow_end!(x, delta=1)
    if can_grow_end(x)
        unsafe_grow_end!(x, delta)
        return true
    else
        return false
    end
end

"""
    grow_beg!(collection, n::Integer=1) -> Bool

Grow `collection` by `n` elements from its first index. This does not ensure that new
elements are defined. If successful thiw will return `true`.
"""
function grow_beg!(x, delta=1)
    if can_grow_beg(x)
        unsafe_grow_beg!(x, delta)
        return true
    else
        return false
    end
end

end
