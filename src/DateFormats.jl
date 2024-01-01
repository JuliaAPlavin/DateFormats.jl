module DateFormats

using Dates

export
    Date, DateTime, Dates,
    JulianDay, JD, ModifiedJulianDay, MJD, YearDecimal, UnixTime,
    mjd, modified_julian_day, julian_day, unix_time, yeardecimal,
    period_decimal, *ₜ, /ₜ


const DTM = Union{Date, DateTime}
const DTPeriod = Union{TimePeriod, DatePeriod, Dates.CompoundPeriod}
const RealM = Union{Real, Missing}

for (T, f, desc) in (
        (:JD, :julian_day, "Julian day"),
        (:MJD, :modified_julian_day, "modified Julian day"),
        (:YearDecimal, :yeardecimal, "decimal year number"),
        (:UnixTime, :unix_time, "unix time"),
    )
    @eval begin
        """    $($T){T <: Real}
        
        Datetime representation as a $($desc). """
        struct $T{T <: RealM}
            value::T
        end

        $T(x::DTM) = $T($f(x))
        DateTime(x::$T) = $f(x.value)

        Base.isapprox(a::$T, b::$T; kwargs...) = isapprox(a.value, b.value; kwargs...)
        Base.isless(a::$T, b::$T) = isless(a.value, b.value)
        Base.isequal(a::$T, b::$T) = isequal(a.value, b.value)
    end
end

const JulianDay = JD
const ModifiedJulianDay = MJD

const MYTYPES = Union{JD, MJD, YearDecimal, UnixTime}
Date(x::MYTYPES) = Date(DateTime(x))
Base.convert(T::Type{<:MYTYPES}, x::DTM) = T(x)
Base.convert(T::Type{<:DTM}, x::MYTYPES) = T(x)


"""    modified_julian_day(x)

Convert between Date[Time] and modified julian days represented as a number (`60000`) or a string (`"60000"`). """
function modified_julian_day end
const mjd = modified_julian_day
modified_julian_day(::Missing) = missing
modified_julian_day(x::Date) = convert(Int, modified_julian_day(DateTime(x)))
modified_julian_day(x::DateTime) = julian_day(x) - 2400000.5
modified_julian_day(x::Integer) = convert(Date, julian_day(2400000.5 + x))
modified_julian_day(x::Real) = julian_day(2400000.5 + x)
modified_julian_day(x::AbstractString) = modified_julian_day(parse(Float64, x))

"""    julian_day(x)

Convert between Date[Time] and julian days represented as a number or a string. """
function julian_day end
julian_day(::Missing) = missing
julian_day(x::Date) = julian_day(DateTime(x))
julian_day(x::DTM) = datetime2julian(x)
julian_day(x::Real) = julian2datetime(x)
julian_day(x::AbstractString) = julian_day(parse(Float64, x))

"""    unix_time(x)

Convert between Date[Time] and unix time represented as a number or a string. """
function unix_time end
unix_time(x) = unix_time(Second, x)
unix_time(::Type, ::Missing) = missing
unix_time(::Type{Second}, x::DateTime) = datetime2unix(x)
unix_time(::Type{Second}, x::Real) = unix2datetime(x)
unix_time(T::Type, x::DTM) = unix_time(Second, x) / period_decimal(Second, T)
unix_time(T::Type, x::Date) = unix_time(T, DateTime(x))
unix_time(T::Type, x::Real) = unix2datetime(x * period_decimal(Second, T))
unix_time(T::Type, x::AbstractString) = unix_time(T, parse(Float64, x))


yearfrac(dtm::T) where {T <: DTM} = (dtm - T(year(dtm))) / (T(year(dtm) + 1) - T(year(dtm)))

"""    yeardecimal(x)

Convert between Date[Time] and decimal year represented as a number or a string. """
function yeardecimal end
yeardecimal(dtm::DTM) = year(dtm) + yearfrac(dtm)
yeardecimal(::Missing) = missing
yeardecimal(t::DTPeriod) = period_decimal(Year, t)
yeardecimal(x::AbstractString) = yeardecimal(parse(Float64, x))

function yeardecimal(years::Real)
    years_whole = round(Int, years)
    year_ms = DateTime(years_whole + 1) - DateTime(years_whole) |> Dates.value
    period_ms = year_ms * (years - years_whole)
    return DateTime(years_whole) + Millisecond(round(Int64, period_ms))
end


"""    t *ₜ p

Create a time period `t * p` rounded to a nanosecond. """
function *ₜ end
*ₜ(t::Real, P::Type{<:DTPeriod}) = t *ₜ P(1)
*ₜ(t::Real, p::DTPeriod) = Nanosecond(round(Int, t * Dates.tons(p)))
*ₜ(::Missing, _) = missing
*ₜ(_, ::Missing) = missing
*ₜ(::Missing, ::Missing) = missing

"""    t /ₜ p

Represent `t` as a decimal number of `p` periods. """
function /ₜ end
/ₜ(T::Type{<:DTPeriod}, P::Type{<:DTPeriod}) = T(1) /ₜ P(1)
/ₜ(t::DTPeriod, P::Type{<:DTPeriod}) = t /ₜ P(1)
/ₜ(t::DTPeriod, p::DTPeriod) = Dates.tons(t) / Dates.tons(p)
/ₜ(::Missing, _) = missing
/ₜ(_, ::Missing) = missing
/ₜ(::Missing, ::Missing) = missing


""" Use `t *ₜ P` or `t /ₜ P` instead. """
function period_decimal end

period_decimal(P::Type{<:DTPeriod}, t::Real) = t *ₜ P

period_decimal(P::Type{<:DTPeriod}, t::DTPeriod) = t /ₜ P
period_decimal(P::Type{<:DTPeriod}, T::Type{<:DTPeriod}) = T /ₜ P
period_decimal(p::DTPeriod, t::DTPeriod) = t /ₜ p
period_decimal(_, ::Missing) = missing

end
