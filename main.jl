raw_str = readchomp("./test1.jl")
str_arr = split(raw_str, "#")


abstract type Tp end

struct PrimType <: Tp
    name::String
end

UnionType = AbstractArray{Tp, 1}

function Un(arr::Array{Any, 1}) 
    ret::UnionType = []
    for ut in arr 
        if ut::UnionType
            for t in ut
                check(x) = (x == t)
                if(length(filter(check, ret)) == 0)
                    ret = [ret..., t]
                end
            end
        else
            check(x) = (x == ut)
            if(length(filter(check, ret)) == 0)
                ret = [ret..., ut]
            end
        end
    end
    return ret
end

function inferExpr(expr, env)
    if typeof(expr) === Int64
        return [PrimType("Int64")]
    elseif typeof(expr) === Int64
        return [PrimType("String")]
    end
end

function inferSeq(ast_tree, env)
    if length(ast_tree) == 0
        return [], env
    end
    ast = ast_tree[1]
    if (typeof(ast) == LineNumberNode)
    elseif (ast.head == Symbol("="))
        tp = inferExpr(ast.args[2], env)
        env = bind(ast.args[1], tp, env)
        return inferSeq(ast_tree[2:length(ast_tree)], env)
    elseif (ast.head == :block)
        return inferSeq(ast.args, env)
    elseif (ast.head == :if)
        t1, env1 = inferSeq([ast.args[2]], env)
        t2 = []
        env2 = nothing
        if (length(ast.args) == 3)
            t2, env2 = inferSeq([ast.args[3]], env)
        end
        # No matter you enter either branch, you will sure to return and not effect rest code.
        if (length(t1) > 0 && length(t2) > 0)
            return Un([t1, t2]), env
        elseif (length(t1) > 0)
            t3, env3 = inferSeq(ast_tree[2:length(ast_tree)], env2)
            return Un([t1,t2,t3]), env3
        elseif (length(t2) > 0)
            t3, env3 = inferSeq(ast_tree[2:length(ast_tree)], env1)
            return Un([t1,t2,t3]), env3
        else
            #t3, env3 = inferSeq(ast_tree[2:length(ast_tree)], mergeEnv(env1, env2))
            #return Un([t1,t2,t3]), env3
        end
    end
    return inferSeq(ast_tree[2:length(ast_tree)], env)
end

function bind(l, r, env)
    return Pair(Pair(l,r), env)
end

function main(env, str_arr)
    ast_tree::Vector{Any} = []
    for i = 1:length(str_arr)
        ast = Meta.parse(str_arr[i]);
        append!(ast_tree, [ast])
    end
    tp, env = inferSeq(ast_tree, env)
end

env = nothing
main(env, str_arr)
