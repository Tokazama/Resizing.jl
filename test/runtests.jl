using Resizing
using Test

@testset "grow_end!" begin
    v = Vector{Int}(undef, 10)
    @test !Resizing.grow_end!(1:2, 2)
    @test Resizing.grow_end!(v, 2)
    @test length(v) == 12
end

@testset "grow_beg!" begin
    v = Vector{Int}(undef, 10)
    @test !Resizing.grow_beg!(1:2, 2)
    @test Resizing.grow_beg!(v, 2)
    @test length(v) == 12
end

@testset "grow_at!" begin
    v = Vector{Int}(undef, 10)
    @test !Resizing.grow_at!(1:2, 2, 2)
    @test Resizing.grow_at!(v, 2, 2)
    @test length(v) == 12
end

@testset "shrink_end!" begin
    v = Vector{Int}(undef, 10)
    @test !Resizing.shrink_end!(1:2, 2)
    @test Resizing.shrink_end!(v, 2)
    @test length(v) == 8
end

@testset "shrink_beg!" begin
    v = Vector{Int}(undef, 10)
    @test !Resizing.shrink_beg!(1:2, 2)
    @test Resizing.shrink_beg!(v, 2)
    @test length(v) == 8
end

@testset "shrink_at!" begin
    v = Vector{Int}(undef, 10)
    @test !Resizing.shrink_at!(1:2, 2, 2)
    @test Resizing.shrink_at!(v, 2, 2)
    @test length(v) == 8
end


