raw_str = readchomp("./test1.jl")
str_arr = split(raw_str, "\n")

struct PrimType
    name::String
end

function inferExpr(expr)
    if typeof(expr) === Int64
        return PrimType("Int64")
    end
end

function bind(l, r, env)
    return Pair(Pair(l,r), env)
end

env1 = nothing

for i = 1:length(str_arr)
    ast = Meta.parse(str_arr[i]);
    dump(ast)
    if (ast.head == Symbol("="))
        tp = inferExpr(ast.args[2])
        env = bind(ast.args[1], tp, env1)
    elseif (ast.head == Symbol("if"))
        println("if")
    end
end

