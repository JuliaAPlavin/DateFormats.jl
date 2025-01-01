module StatisticsExt

using Statistics
using DateFormats: _MYTYPES

for T in _MYTYPES
    # needed for median():
    @eval Statistics.middle(x::$T) = $T(middle(x.value))
    @eval Statistics.middle(x::$T, y::$T) = $T(middle(x.value, y.value))
end

end
