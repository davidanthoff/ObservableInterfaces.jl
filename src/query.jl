function QueryOperators.query(source::Observable)
    return source
end

function QueryOperators.map(source::Observable, f::Function, f_expr::Expr)
    return MapObservable(f, source)
end

function DataFrames.DataFrame(source::Observable)
    df = DataFrame()
    subscribe(source, df)
    return df
end

function Base.Array(source::Observable)
    ar = Array{Any}(0)
    subscribe(source, ar)
    return ar
end

function onnext(obs::Array, value)
    push!(obs, value)
end

function oncompleted(obs::Array)
end
