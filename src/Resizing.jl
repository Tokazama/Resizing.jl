module Resizing

import Compat: @assume_effects

const UNSAFE_GROW_DOC = """
This method assumes that `collection` will grow without any errors and may result in
undefined behavior if the user isn't certain `collection` can safely grow. For example, an
instance of `Vector` cannot be shared with another instance of `Array` to change sizes.
"""

const UNSAFE_SHRINK_DOC = """
This method assumes that `collection` will shrink without any errors and may result in
undefined behavior if the user isn't certain `collection` can safely shrink. For example, an
instance of `Vector` cannot be shared with another instance of `Array` to change sizes. It
also assumes that the provided number of elements the will be removed does not exceed the
size of `collection`.
"""

# https://github.com/JuliaLang/julia/issues/34478

# TODO query if shared (`reshape`) so we can use `:nothrow` on `unsafe_*` methods
# https://github.com/JuliaLang/julia/pull/47540
const FLAG_OFFSET = 1 + sizeof(Csize_t)>>1 + sizeof(Ptr{Cvoid}) >>1
function isshared(x::Array)
    ptr = pointer_from_objref(x)
    GC.@preserve x begin
        out = (unsafe_load(convert(Ptr{UInt16}, ptr), FLAG_OFFSET) & 0x4000) !== 0x0000
    end
    return out
end


"""
    shrink_end!(collection, n::Integer) -> Bool

Deletes `n` elements from begining at the last index of `collection`. If successful will
return `true`.
"""
shrink_end!(x, n::Integer) = false
function shrink_end!(x::Vector, n::Integer)
    if isshared(x) || (length(x) - n) < 0
        return false
    else
        unsafe_shrink_end!(x, n)
        return true
    end
end

"""
    unsafe_shrink_end!(collection, n::Integer) -> Nothing

Deletes `n` elements from the last index of `collection`.

$(UNSAFE_SHRINK_DOC)
"""
@assume_effects :terminates_locally :nothrow function unsafe_shrink_end!(x::Vector, n::Integer)
    ccall(:jl_array_del_end, Cvoid, (Any, UInt), x, n)
end

"""
    shrink_at!(collection, i::Int, n::Integer) -> Bool

Shrink `collection` by `n` elements at index `i`. If successful this will return `true`.
"""
shrink_at!(x, i::Int, n::Integer) = false
function shrink_at!(x::Vector, i::Int, n::Integer)
    if isshared(x) || i < 1 || (i + n) > length(x)
        return false
    else
        unsafe_shrink_at!(x, i, n)
        return true
    end
end

"""
    unsafe_shrink_at!(collection, i, n::Integer) -> Nothing

Deletes `n` elements from index `i` of `collection`.

$(UNSAFE_SHRINK_DOC)
"""
@assume_effects :terminates_locally :nothrow function unsafe_shrink_at!(x::Vector, i, n::Integer)
    ccall(:jl_array_del_at, Cvoid, (Any, Int, UInt), x, i-1, n)
end


"""
    shrink_beg!(collection, n::Integer) -> Bool

Deletes `n` elements from the first index of `collection`. If successful will
return `true`.
"""
shrink_beg!(x, n::Integer) = false
function shrink_beg!(x::Vector, n::Integer)
    if isshared(x) || (length(x) - n) < 0
        return false
    else
        unsafe_shrink_beg!(x, n)
        return true
    end
end

"""
    unsafe_shrink_beg!(collection, n::Integer) -> Nothing

Deletes `n` elements from the first index of `collection`.

$(UNSAFE_SHRINK_DOC)
"""
@assume_effects :terminates_locally :nothrow function unsafe_shrink_beg!(x::Vector, n::Integer)
    ccall(:jl_array_del_beg, Cvoid, (Any, UInt), x, n)
end

"""
    grow_at!(collection, i::Int, n::Integer) -> Bool

Grow `collection` by `n` elements at index `i`. This does not ensure that new
elements are defined. If successful this will return true return `true`.
"""
grow_at!(x, i, n::Integer) = false
function grow_at!(x::Vector, i, n::Integer)
    if isshared(x) || 1 > i || i > (length(x) + 1)
        return false
    else
        unsafe_grow_at!(x, i, n)
        return true
    end
end

"""
    unsafe_grow_at!(collection, i::Int, n::Integer) -> Nothing

Grows by `n` elements at index `i` of `collection`.

$(UNSAFE_GROW_DOC)
"""
@assume_effects :terminates_locally :nothrow function unsafe_grow_at!(x::Vector, i::Int, n::Integer)
    ccall(:jl_array_grow_at, Cvoid, (Any, Int, UInt), x, i-1, n)
end

"""
    grow_end!(collection, n::Integer) -> Bool

Grow `collection` by `n` elements from its last index. This does not ensure that new
elements are defined. If successful will return `true`.
"""
grow_end!(x, n::Integer) = false
grow_end!(x::Vector, n::Integer) = isshared(x) ? false : (unsafe_grow_end!(x, n); true)

"""
    unsafe_grow_end!(collection, n) -> Nothing

Grows by `n` elements at the last index of `collection`. 

$(UNSAFE_GROW_DOC)
"""
@assume_effects :terminates_locally :nothrow function unsafe_grow_end!(x::Vector, n)
    ccall(:jl_array_grow_end, Cvoid, (Any, UInt), x, n)
end

"""
    grow_beg!(collection, n::Integer) -> Bool

Grow `collection` by `n` elements from its first index. This does not ensure that new
elements are defined. If successful will return `true`.
"""
grow_beg!(x, n::Integer) = false
grow_beg!(x::Vector, n::Integer) = isshared(x) ? false : (unsafe_grow_beg!(x, n); true)

"""
    unsafe_grow_beg!(collection, n) -> Nothing

Grows by `n` elements at the first index of `collection`.

$(UNSAFE_GROW_DOC)
"""
@assume_effects :terminates_locally :nothrow function unsafe_grow_beg!(x::Vector, n)
    ccall(:jl_array_grow_end, Cvoid, (Any, UInt), x, n)
end

end
