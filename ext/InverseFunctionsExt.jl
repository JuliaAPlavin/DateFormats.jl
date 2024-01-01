module InverseFunctionsExt
import InverseFunctions: inverse
using DateFormats

inverse(f::Base.Fix2{typeof(*ₜ)}) = Base.Fix2(/ₜ, f.x)
inverse(f::Base.Fix2{typeof(/ₜ)}) = Base.Fix2(*ₜ, f.x)

inverse(f::Union{typeof.((modified_julian_day, julian_day, unix_time, yeardecimal))...}) = f
inverse(f::Base.Fix1{typeof(period_decimal)}) = f

end
