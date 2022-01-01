module DateFormats

using Dates

export JulianDay, JD, ModifiedJulianDay, MJD, YearDecimal

const DTM = Union{Date, DateTime}
const DTPeriod = Union{TimePeriod, DatePeriod}
const RealM = Union{Real, Missing}

struct JulianDay{T <: RealM}
    value::T
end
const JD = JulianDay

struct ModifiedJulianDay{T <: RealM}
    value::T
end
const MJD = ModifiedJulianDay

struct YearDecimal{T <: RealM}
    value::T
end

const MYTYPES = Union{JD, MJD, YearDecimal}

Base.isapprox(a::T, b::T; kwargs...) where {T <: MYTYPES} = isapprox(a.value, b.value; kwargs...)
Base.isless(a::T, b::T) where {T <: MYTYPES} = isless(a.value, b.value)
Base.isequal(a::T, b::T) where {T <: MYTYPES} = isequal(a.value, b.value)

JD(x::Date) = JD(DateTime(x))
JD(x::DateTime) = JD(datetime2julian(x))
MJD(x::Date) = MJD(DateTime(x))
MJD(x::DateTime) = MJD(datetime2mjd(x))
YearDecimal(x::DTM) = YearDecimal(yeardecimal(x))
DateTime(x::JD) = julian2datetime(x.value)
DateTime(x::MJD) = mjd2datetime(x.value)
DateTime(x::YearDecimal) = yeardecimal(x.value)
Date(x::MYTYPES) = Date(DateTime(x))

Base.convert(T::Type{<:MYTYPES}, x::DTM) = T(x)
Base.convert(T::Type{<:DTM}, x::MYTYPES) = T(x)


mjd2datetime(mjd) = julian2datetime(2400000.5 + mjd)
datetime2mjd(dt)  = datetime2julian(dt) - 2400000.5

Dates.julian2datetime(::Missing) = missing
Dates.datetime2julian(::Missing) = missing


yearfrac(dtm::T) where {T <: DTM} = (dtm - T(year(dtm))) / (T(year(dtm) + 1) - T(year(dtm)))
yeardecimal(dtm::DTM) = year(dtm) + yearfrac(dtm)

function yeardecimal(years::Real)
    years_whole = round(Int, years)
    year_ms = DateTime(years_whole + 1) - DateTime(years_whole) |> Dates.value
    period_ms = year_ms * (years - years_whole)
    return DateTime(years_whole) + Millisecond(round(Int64, period_ms))
end

period_decimal(T::Type{<:DTPeriod}, t::DTPeriod) = Dates.tons(t) / Dates.tons(T(1))
period_decimal(p::DTPeriod, t::DTPeriod) = Dates.tons(t) / Dates.tons(p)
yeardecimal(t::DTPeriod) = period_decimal(Year, t)


end
