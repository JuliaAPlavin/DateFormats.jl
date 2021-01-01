module DateFormats

using Dates

export JulianDay, MJD, YearDecimal

const DTM = Union{Date, DateTime}
const DTPeriod = Union{TimePeriod, DatePeriod}

struct JulianDay
    value::Float64
end

struct MJD
    value::Float64
end

struct YearDecimal
    value::Float64
end

const MYTYPES = Union{JulianDay, MJD, YearDecimal}

Base.isapprox(a::T, b::T; kwargs...) where {T <: MYTYPES} = isapprox(a.value, b.value; kwargs...)

datetime_to(::Type{JulianDay}, dtm::DTM) = datetime2julian(dtm)
datetime_to(::Type{MJD}, dtm::DTM) = datetime2mjd(dtm)
datetime_to(::Type{Year}, dtm::DTM) = yeardecimal(dtm)
datetime_from(x::JulianDay) = julian2datetime(x.value)
datetime_from(x::MJD) = mjd2datetime(x.value)
datetime_from(T::Type, x::Real) = datetime_from(T(x))
datetime_from(::Type{Year}, x::Real) = yeardecimal(x)

Base.convert(::Type{MJD}, x::DTM) = MJD(datetime2mjd(x))
Base.convert(::Type{YearDecimal}, x::DTM) = YearDecimal(yeardecimal(x))
Base.convert(T::Type{<:DTM}, x::MJD) = mjd2datetime(x.value)
Base.convert(T::Type{<:DTM}, x::YearDecimal) = yeardecimal(x.value)


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
