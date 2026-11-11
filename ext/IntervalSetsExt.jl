module IntervalSetsExt
using IntervalSets
import DateFormats: modified_julian_day, julian_day, julian_epoch, unix_time, yeardecimal

for f in (:julian_day, :modified_julian_day, :julian_epoch, :yeardecimal, :unix_time)
    @eval $f(iv::Interval{L,R}) where {L,R} = Interval{L,R}($f(leftendpoint(iv)), $f(rightendpoint(iv)))
end

end
