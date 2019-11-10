raw_str = readchomp("./test1.jl")
str_arr = split(raw_str, "#")

struct PrimType
    name::String
end

struct BottomType
end

function inferExpr(expr)
    if typeof(expr) === Int64
        return PrimType("Int64")
    end
end

function inferSeq(ast, env)
    if (typeof(ast) == LineNumberNode)
        return BottomType(), env
    end

    if (ast.head == Symbol("="))
        tp = inferExpr(ast.args[2])
        env = bind(ast.args[1], tp, env)
        return BottomType(), env
    elseif (ast.head == :block)
        for arg in ast.args
            tp , env = inferSeq(arg, env)
            if (typeof(tp) != BottomType)
                return tp, env
            end
        end
        return BottomType(), env
    else
        return BottomType(), env
    end
end

function bind(l, r, env)
    return Pair(Pair(l,r), env)
end

function main(env, str_arr)
    for i = 1:length(str_arr)
        ast = Meta.parse(str_arr[i]);
        dump(ast)
        if (ast.head == Symbol("="))
            tp, env = inferSeq(ast, env)
        elseif (ast.head == Symbol("if"))
            t1, env1 = inferSeq(ast.args[2], env)
        end
    end
end

env = nothing
main(env, str_arr)
