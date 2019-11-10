a1 = 5
#
if (a1 < 6) a1 = "str"; return a1; elseif(a1 > 5) a1 = 10.0; else a1 = 3 end
#
function foo(x, y)
    if (x < 5 && y < 5)
        return "abc"
    else
        return 1
    end
end
