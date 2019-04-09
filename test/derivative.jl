#
# derivative()
#

@testset "derivative()" begin
    @testset "f(x::Real) = sin(x)" begin
        f1(x::Real) = sin(x)
        @test norm(derivative(f1, :scalar, :forward)(0.0) - cos(0.0)) < 10e-4
        @test norm(derivative(f1, :scalar, :central)(0.0) - cos(0.0)) < 10e-4
        @test norm(derivative(f1, :forward)(0.0) - cos(0.0)) < 10e-4
        @test norm(derivative(f1, :central)(0.0) - cos(0.0)) < 10e-4
        @test norm(derivative(f1)(0.0) - cos(0.0)) < 10e-4
    end

    @testset "f(x::Vector) = sin(x[1])" begin
        f2(x::Vector) = sin(x[1])
        @test norm(derivative(f2, :vector, :forward)([0.0]) .- cos(0.0)) < 10e-4
        @test norm(derivative(f2, :vector, :central)([0.0]) .- cos(0.0)) < 10e-4
    end
end

#
# adjoint overloading
#

@testset "adjoint overloading" begin
    @testset "f(x::Vector) = sin(x[1])" begin
        f3(x::Real) = sin(x)
        for x in Compat.range(0.0, stop=0.1, length=11) # seq()
            @test norm(f3'(x) - cos(x)) < 10e-4
        end
    end
end

#
# gradient()
#

@testset "gradient()" begin
    f4(x::Vector) = (100.0 - x[1])^2 + (50.0 - x[2])^2
    @test norm(Calculus.gradient(f4, :forward)([100.0, 50.0]) - [0.0, 0.0]) < 10e-4
    @test norm(Calculus.gradient(f4, :central)([100.0, 50.0]) - [0.0, 0.0]) < 10e-4
    @test norm(Calculus.gradient(f4)([100.0, 50.0]) - [0.0, 0.0]) < 10e-4
end

#
# jacobian()
#

@testset "jacobian()" begin
    @test norm(Calculus.jacobian(identity, rand(3), :forward) - Matrix(1.0I, 3, 3)) < 10e-4
    @test norm(Calculus.jacobian(identity, rand(3), :central) - Matrix(1.0I, 3, 3)) < 10e-4
end

#
# second_derivative()
#

@testset "second_derivative()" begin
    @test norm(second_derivative(x -> x^2)(0.0) - 2.0) < 10e-4
    @test norm(second_derivative(x -> x^2)(1.0) - 2.0) < 10e-4
    @test norm(second_derivative(x -> x^2)(10.0) - 2.0) < 10e-4
    @test norm(second_derivative(x -> x^2)(100.0) - 2.0) < 10e-4
end

#
# hessian()
#

@testset "hessian()" begin
    f5(x) = sin(x[1]) + cos(x[2])
    x₁, x₂ = 1.0, 1.0
    x = [x₁, x₂]
    @test norm(Calculus.gradient(f5)(x) - [cos(x₁), -sin(x₂)]) < 10e-4
    @test norm(hessian(f5)(x) - [-sin(x₁) 0.0; 0.0 -cos(x₂)]) < 10e-4
end
