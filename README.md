
<a id='Overview'></a>

<a id='Overview-1'></a>

# Overview


Common date and datetime representation formats: for now Julian days, modified Julian days, and decimal year numbers are supported. All of these formats can be converted to/from `Date`s and `DateTime`s.


<a id='Examples'></a>

<a id='Examples-1'></a>

# Examples


```julia-repl
julia> using Dates, DateFormats
```


Create a modified julian day date. The constructor name can be either fully-spelled or abbreviated as MJD:


```julia-repl
julia> dt_mjd = ModifiedJulianDay(58882)
ModifiedJulianDay{Int64}(58882)

julia> MJD(58882) == dt_mjd
true
```


Convert to Date or DateTime, via a convert() method or with a constructor:


```julia-repl
julia> dt = DateTime(dt_mjd)
2020-02-03T00:00:00

julia> convert(Date, dt_mjd)
2020-02-03
```


Convert the DateTime to a decimal number of years:


```julia-repl
julia> YearDecimal(dt)
YearDecimal{Float64}(2020.0901639344263)
```


The numerical value is kept in the `value` field:


```julia-repl
julia> convert(YearDecimal, dt).value
2020.0901639344263
```


<a id='Reference'></a>

<a id='Reference-1'></a>

# Reference

<a id='DateFormats.julian_day-Tuple{Missing}' href='#DateFormats.julian_day-Tuple{Missing}'>#</a>
**`DateFormats.julian_day`** &mdash; *Method*.



```julia
julian_day(_::Missing) -> Missing

```

Convert from/to DateTime to/from julian days. 


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L106' class='documenter-source'>source</a><br>

<a id='DateFormats.modified_julian_day-Tuple{Missing}' href='#DateFormats.modified_julian_day-Tuple{Missing}'>#</a>
**`DateFormats.modified_julian_day`** &mdash; *Method*.



```julia
modified_julian_day(_::Missing) -> Missing

```

Convert from/to DateTime to/from modified julian days. 


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L99' class='documenter-source'>source</a><br>

<a id='DateFormats.period_decimal-Tuple{Type{<:Union{Dates.CompoundPeriod, DatePeriod, TimePeriod}}, Real}' href='#DateFormats.period_decimal-Tuple{Type{<:Union{Dates.CompoundPeriod, DatePeriod, TimePeriod}}, Real}'>#</a>
**`DateFormats.period_decimal`** &mdash; *Method*.



```julia
period_decimal(P::Type{<:Union{Dates.CompoundPeriod, DatePeriod, TimePeriod}}, t::Real) -> Any

```

Create a time period `t * P` rounded to a nanosecond. 


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L139' class='documenter-source'>source</a><br>

<a id='DateFormats.period_decimal-Tuple{Type{<:Union{Dates.CompoundPeriod, DatePeriod, TimePeriod}}, Union{Dates.CompoundPeriod, DatePeriod, TimePeriod}}' href='#DateFormats.period_decimal-Tuple{Type{<:Union{Dates.CompoundPeriod, DatePeriod, TimePeriod}}, Union{Dates.CompoundPeriod, DatePeriod, TimePeriod}}'>#</a>
**`DateFormats.period_decimal`** &mdash; *Method*.



```julia
period_decimal(P::Type{<:Union{Dates.CompoundPeriod, DatePeriod, TimePeriod}}, t::Union{Dates.CompoundPeriod, DatePeriod, TimePeriod}) -> Any

```

Represent `t` as a decimal number of `P` periods.

`P` can be a type like `Day`, or a value like `Day(5)`. 


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L142' class='documenter-source'>source</a><br>

<a id='DateFormats.unix_time-Tuple{Any}' href='#DateFormats.unix_time-Tuple{Any}'>#</a>
**`DateFormats.unix_time`** &mdash; *Method*.



```julia
unix_time(x) -> Any

```

Convert from/to DateTime to/from julian days. 


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L113' class='documenter-source'>source</a><br>

<a id='DateFormats.yeardecimal-Tuple{Union{Date, DateTime}}' href='#DateFormats.yeardecimal-Tuple{Union{Date, DateTime}}'>#</a>
**`DateFormats.yeardecimal`** &mdash; *Method*.



```julia
yeardecimal(dtm::Union{Date, DateTime}) -> Float64

```

Convert from/to DateTime to/from a decimal year number. 


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L126' class='documenter-source'>source</a><br>

<a id='DateFormats.JD-Tuple{Union{Date, DateTime}}' href='#DateFormats.JD-Tuple{Union{Date, DateTime}}'>#</a>
**`DateFormats.JD`** &mdash; *Method*.



Convert from a Date or DateTime.

```julia-repl
julia> JulianDay(Date(2020, 2, 3))
JulianDay{Float64}(2.4588825e6)

julia> JD(Date(2020, 2, 3))
JulianDay{Float64}(2.4588825e6)
```


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L45' class='documenter-source'>source</a><br>

<a id='DateFormats.JulianDay' href='#DateFormats.JulianDay'>#</a>
**`DateFormats.JulianDay`** &mdash; *Type*.



Datetime representation as a Julian day.


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L18' class='documenter-source'>source</a><br>

<a id='DateFormats.MJD-Tuple{Union{Date, DateTime}}' href='#DateFormats.MJD-Tuple{Union{Date, DateTime}}'>#</a>
**`DateFormats.MJD`** &mdash; *Method*.



Convert from a Date or DateTime.

```julia-repl
julia> ModifiedJulianDay(Date(2020, 2, 3))
ModifiedJulianDay{Float64}(58882.0)

julia> MJD(Date(2020, 2, 3))
ModifiedJulianDay{Float64}(58882.0)
```


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L57' class='documenter-source'>source</a><br>

<a id='DateFormats.ModifiedJulianDay' href='#DateFormats.ModifiedJulianDay'>#</a>
**`DateFormats.ModifiedJulianDay`** &mdash; *Type*.



Datetime representation as a modified Julian day.


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L24' class='documenter-source'>source</a><br>

<a id='DateFormats.YearDecimal' href='#DateFormats.YearDecimal'>#</a>
**`DateFormats.YearDecimal`** &mdash; *Type*.



Datetime representation as a decimal year number.


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L30' class='documenter-source'>source</a><br>

<a id='DateFormats.YearDecimal-Tuple{Union{Date, DateTime}}' href='#DateFormats.YearDecimal-Tuple{Union{Date, DateTime}}'>#</a>
**`DateFormats.YearDecimal`** &mdash; *Method*.



Convert from a Date or DateTime.

```julia-repl
julia> YearDecimal(Date(2020, 2, 3))
YearDecimal{Float64}(2020.0901639344263)
```


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L69' class='documenter-source'>source</a><br>

<a id='Dates.DateTime-Tuple{JulianDay}' href='#Dates.DateTime-Tuple{JulianDay}'>#</a>
**`Dates.DateTime`** &mdash; *Method*.



```julia
DateTime(x::JulianDay) -> Union{Missing, DateTime}

```

Convert to DateTime.

```julia-repl
julia> DateTime(YearDecimal(2020.123))
2020-02-15T00:25:55.200

julia> DateTime(MJD(58882))
2020-02-03T00:00:00
```


<a target='_blank' href='https://github.com/aplavin/DateFormats.jl/blob/bb3f54c540c13253e92bf1e4ba6daf8c575e2820/src/DateFormats.jl#L80' class='documenter-source'>source</a><br>

