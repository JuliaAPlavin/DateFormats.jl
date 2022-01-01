module DateFormats

using Dates

export
    Date, DateTime, Dates,
    JulianDay, JD, ModifiedJulianDay, MJD, YearDecimal, UnixTime,
    mjd, modified_julian_day, julian_day, unix_time, yeardecimal, period_decimal

const DTM = Union{Date, DateTime}
const DTPeriod = Union{TimePeriod, DatePeriod, Dates.CompoundPeriod}
const RealM = Union{Real, Missing}

""" Datetime representation as a Julian day."""
struct JulianDay{T <: RealM}
    value::T
end
const JD = JulianDay

""" Datetime representation as a modified Julian day."""
struct ModifiedJulianDay{T <: RealM}
    value::T
end
const MJD = ModifiedJulianDay

""" Datetime representation as a decimal year number."""
struct YearDecimal{T <: RealM}
    value::T
end

struct UnixTime{T <: RealM}
    value::T
end

const MYTYPES = Union{JD, MJD, YearDecimal, UnixTime}

Base.isapprox(a::T, b::T; kwargs...) where {T <: MYTYPES} = isapprox(a.value, b.value; kwargs...)
Base.isless(a::T, b::T) where {T <: MYTYPES} = isless(a.value, b.value)
Base.isequal(a::T, b::T) where {T <: MYTYPES} = isequal(a.value, b.value)

""" Convert from a Date or DateTime.

```jldoctest
julia> JulianDay(Date(2020, 2, 3))
JulianDay{Float64}(2.4588825e6)

julia> JD(Date(2020, 2, 3))
JulianDay{Float64}(2.4588825e6)
```
"""
JD(x::DTM) = JD(julian_day(x))

""" Convert from a Date or DateTime.

```jldoctest
julia> ModifiedJulianDay(Date(2020, 2, 3))
ModifiedJulianDay{Float64}(58882.0)

julia> MJD(Date(2020, 2, 3))
ModifiedJulianDay{Float64}(58882.0)
```
"""
MJD(x::DTM) = MJD(modified_julian_day(x))

""" Convert from a Date or DateTime.

```jldoctest
julia> YearDecimal(Date(2020, 2, 3))
YearDecimal{Float64}(2020.0901639344263)
```
"""
YearDecimal(x::DTM) = YearDecimal(yeardecimal(x))

UnixTime(x::DTM) = UnixTime(unix_time(x))

""" Convert to DateTime.

```jldoctest
julia> DateTime(YearDecimal(2020.123))
2020-02-15T00:25:55.200

julia> DateTime(MJD(58882))
2020-02-03T00:00:00
```
"""
DateTime(x::JD) = julian_day(x.value)
DateTime(x::MJD) = modified_julian_day(x.value)
DateTime(x::YearDecimal) = yeardecimal(x.value)
DateTime(x::UnixTime) = unix_time(x.value)
Date(x::MYTYPES) = Date(DateTime(x))

Base.convert(T::Type{<:MYTYPES}, x::DTM) = T(x)
Base.convert(T::Type{<:DTM}, x::MYTYPES) = T(x)

""" Convert from/to DateTime to/from modified julian days. """
modified_julian_day(::Missing) = missing
modified_julian_day(x::DTM) = julian_day(x) - 2400000.5
modified_julian_day(x::Real) = julian_day(2400000.5 + x)
modified_julian_day(x::String) = modified_julian_day(parse(Float64, x))
const mjd = modified_julian_day

""" Convert from/to DateTime to/from julian days. """
julian_day(::Missing) = missing
julian_day(x::Date) = julian_day(DateTime(x))
julian_day(x::DTM) = datetime2julian(x)
julian_day(x::Real) = julian2datetime(x)
julian_day(x::String) = julian_day(parse(Float64, x))

""" Convert from/to DateTime to/from julian days. """
unix_time(x) = unix_time(Second, x)
unix_time(::Type, ::Missing) = missing
unix_time(::Type{Second}, x::DateTime) = datetime2unix(x)
unix_time(::Type{Second}, x::Real) = unix2datetime(x)
unix_time(T::Type, x::DTM) = unix_time(Second, x) / period_decimal(Second, T)
unix_time(T::Type, x::Date) = unix_time(T, DateTime(x))
unix_time(T::Type, x::Real) = unix2datetime(x * period_decimal(Second, T))
unix_time(T::Type, x::String) = unix_time(T, parse(Float64, x))


yearfrac(dtm::T) where {T <: DTM} = (dtm - T(year(dtm))) / (T(year(dtm) + 1) - T(year(dtm)))

""" Convert from/to DateTime to/from a decimal year number. """
yeardecimal(dtm::DTM) = year(dtm) + yearfrac(dtm)
yeardecimal(::Missing) = missing
yeardecimal(t::DTPeriod) = period_decimal(Year, t)
yeardecimal(x::String) = yeardecimal(parse(Float64, x))

function yeardecimal(years::Real)
    years_whole = round(Int, years)
    year_ms = DateTime(years_whole + 1) - DateTime(years_whole) |> Dates.value
    period_ms = year_ms * (years - years_whole)
    return DateTime(years_whole) + Millisecond(round(Int64, period_ms))
end

""" Represent `t` as a decimal number of `P` periods.

`P` can be a type like `Day`, or a value like `Day(5)`. """
period_decimal(P::Type{<:DTPeriod}, t::DTPeriod) = period_decimal(P(1), t)
period_decimal(P::Type{<:DTPeriod}, T::Type{<:DTPeriod}) = period_decimal(P, T(1))
period_decimal(p::DTPeriod, t::DTPeriod) = Dates.tons(t) / Dates.tons(p)
period_decimal(_, ::Missing) = missing


end
