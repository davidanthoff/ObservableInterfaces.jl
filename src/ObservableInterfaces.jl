module ObservableInterfaces

using QueryOperators, DataFrames

export Foo, TextFile, MapObservable, ConsoleSink, Subject

abstract type Observable end

function onnext end
function oncompleted end

function subscribe end

mutable struct Subject{T} <: Observable
    observers::Vector{Any}

    function Subject{T}()
        return new{T}(Vector{Any}())
    end
end

function subscribe(s::Subject, observer)
    push!(s.observers, observer)
end

function onnext(s::Subject, el)
    for o in s.observers
        onnext(o, el)
    end
end

function oncompleted(s::Subject)
    for o in s.observers
        oncompleted(o)
    end
end

mutable struct Foo <: Observable
    range::Int
    observers::Vector{Any}

    function Foo(range)
        return new(range, Vector{Any}(0))
    end
end

function subscribe(f::Foo, observer)
    push!(f.observers, observer)
end

function process(f::Foo)
    for i in 1:f.range
        for s in f.observers
            onnext(s,i)
        end
    end

    for s in f.observers
        oncompleted(s)
    end
end

mutable struct MapObservable <: Observable
    f
    observers::Vector{Any}
    function MapObservable(f, observable)
        new_instance = new(f, Vector{Any}(0))
        subscribe(observable, new_instance)
        return new_instance
    end
end

function subscribe(f::MapObservable, observer)
    push!(f.observers, observer)
end

function onnext(mo::MapObservable, el)
    for o in mo.observers
        onnext(o, mo.f(el))
    end
end

function oncompleted(mo::MapObservable)
    for o in mo.observers
        oncompleted(o)
    end
end

mutable struct TextFile
    handle

    function TextFile(filename::AbstractString, observable)
        h = open(filename, "w")
        new_instance = new(h)
        subscribe(observable, new_instance)
        return new_instance
    end
end

function onnext(tx::TextFile, el)
    println(tx.handle, el)
end

function oncompleted(tx::TextFile)
    close(tx.handle)
end

mutable struct ConsoleSink
    function ConsoleSink(observable)
        new_instance = new()
        subscribe(observable, new_instance)
        return new_instance
    end
end

function onnext(tx::ConsoleSink, el)
    println(el)
end

function oncompleted(tx::ConsoleSink)
end

include("query.jl")

end # module
