module TimeZonesExt
using TimeZones
import DateFormats: modified_julian_day, julian_day, unix_time, yeardecimal

for f in (:julian_day, :modified_julian_day, :yeardecimal, :unix_time)
    @eval $f(zdt::ZonedDateTime) = $f(DateTime(zdt, UTC))
end

end
