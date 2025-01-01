module AccessorsExt

using DateFormats
using DateFormats: Dates, MYTYPES
using Accessors

for func in [:year, :quarter, :month, :week, :day, :hour, :minute, :second, :millisecond, :dayofmonth, :yearmonth, :monthday, :yearmonthday]
    @eval Accessors.set(x::MYTYPES, ::typeof(Dates.$func), v) = @set x |> convert(DateTime, _) |> Dates.$func = v
end

end
