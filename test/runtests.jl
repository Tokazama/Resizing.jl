using Resizing
using Test

@testset "grow_end!" begin
    v = Vector{Int}(undef, 10)
    @test !Resizing.grow_end!(1:2, 2)
    @test_throws ArgumentError Resizing.assert_grow_end!(1:2, 2)
    @test Resizing.grow_end!(v, 2)
    @test length(v) == 12
end

@testset "grow_beg!" begin
    v = Vector{Int}(undef, 10)
    @test !Resizing.grow_beg!(1:2, 2)
    @test_throws ArgumentError Resizing.assert_grow_beg!(1:2, 2)
    @test Resizing.grow_beg!(v, 2)
    @test length(v) == 12
end

@testset "grow_at!" begin
    v = Vector{Int}(undef, 10)
    @test !Resizing.grow_at!(1:2, 2, 2)
    @test_throws ArgumentError Resizing.assert_grow_at!(1:2, 2, 2)
    @test !Resizing.grow_at!(v, 12, 2)
    @test Resizing.grow_at!(v, 2, 2)
    @test length(v) == 12
end

@testset "shrink_end!" begin
    @test !Resizing.shrink_end!(1:2, 2)

    v = Vector{Int}(undef, 10)
    @test_throws ArgumentError Resizing.assert_shrink_end!(v, 11)
    @test Resizing.shrink_end!(v, 2)
    @test length(v) == 8
end

@testset "shrink_beg!" begin
    @test !Resizing.shrink_beg!(1:2, 2)

    v = Vector{Int}(undef, 10)
    @test_throws ArgumentError Resizing.assert_shrink_beg!(v, 11)
    @test Resizing.shrink_beg!(v, 2)
    @test length(v) == 8
end

@testset "shrink_at!" begin
    @test !Resizing.shrink_at!(1:2, 2, 2)

    v = Vector{Int}(undef, 10)
    @test_throws ArgumentError Resizing.assert_shrink_at!(v, 2, 9)
    @test Resizing.shrink_at!(v, 2, 2)
    @test length(v) == 8
end

