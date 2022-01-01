# Overview

Common date and datetime representation formats: for now Julian days, modified Julian days, and decimal year numbers are supported. All of these formats can be converted to/from `Date`s and `DateTime`s.

# Examples

```jldoctest label
julia> using Dates, DateFormats
```

Create a modified julian day date. The constructor name can be either fully-spelled or abbreviated as MJD:
```jldoctest label
julia> dt_mjd = ModifiedJulianDay(58882)
ModifiedJulianDay{Int64}(58882)

julia> MJD(58882) == dt_mjd
true
```
Convert to Date or DateTime, via a convert() method or with a constructor:
```jldoctest label
julia> dt = DateTime(dt_mjd)
2020-02-03T00:00:00

julia> convert(Date, dt_mjd)
2020-02-03
```

Convert the DateTime to a decimal number of years:
```jldoctest label
julia> YearDecimal(dt)
YearDecimal{Float64}(2020.0901639344263)
```

The numerical value is kept in the `value` field:
```jldoctest label
julia> convert(YearDecimal, dt).value
2020.0901639344263
```


# Reference

```@autodocs
Modules = [DateFormats]
Order   = [:function, :type]
```
