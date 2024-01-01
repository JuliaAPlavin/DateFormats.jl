# Overview

Common date and datetime representation formats: Julian days, modified Julian days, unix time, decimal numbers of years and other periods. These formats can be converted to/from `Date`s and `DateTime`s.

# Examples


```julia
julia> using Dates, DateFormats
```

Create between datetimes and modified Julian days (MJD):
```julia
julia> mjd(60000)
2023-02-25

julia> mjd(60000.5)
2023-02-25T12:00:00

julia> mjd(Date(2000))
51544
```

Decimal number of years:
```julia
julia> yeardecimal(Date(2020, 7, 2))
2020.5

julia> yeardecimal(2000.5)
2000-07-02T00:00:00
```

Fractional date/time periods use `*ₜ` to multiply and `/ₜ` to divide.
```julia
julia> Minute(150) /ₜ Hour
2.5

julia> Hour(150) /ₜ Hour
150

julia> (Day(123) + Second(360)) /ₜ Hour
2952.1

julia> DateTime(2020) + 3.5 *ₜ Hour
2020-01-01T03:30:00
```
