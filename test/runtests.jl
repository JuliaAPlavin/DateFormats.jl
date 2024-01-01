using TestItems
using TestItemRunner
@run_package_tests


@testitem "jd" begin
    @test modified_julian_day(59014) === Date(2020, 6, 14)  # Date
    @test modified_julian_day(59014.) === DateTime(2020, 6, 14)  # DateTime
    @test modified_julian_day(59014.30417) === DateTime(2020, 6, 14, 7, 18, 0, 288)
    @test modified_julian_day(Date(2020, 6, 14)) === 59014  # int
    @test modified_julian_day(DateTime(2020, 6, 14)) === 59014.0  # float
    @test modified_julian_day(DateTime(2020, 6, 14, 7, 18, 0, 288)) ≈ 59014.30417

    @test julian_day(2459014.5) === DateTime(2020, 6, 14)
    @test julian_day(2459014.30417) === DateTime(2020, 6, 13, 19, 18, 0, 288)
    @test julian_day(DateTime(2020, 6, 14)) === 2.4590145e6
    @test julian_day(DateTime(2020, 6, 14, 7, 18, 0, 288)) ≈ 2.45901480417e6
end

@testitem "unix" begin
    using Dates

    @test unix_time(1.5920928e9) === DateTime(2020, 6, 14)
    @test unix_time(1.592119080288e9) === DateTime(2020, 6, 14, 7, 18, 0, 288)
    @test unix_time(Millisecond, 1.592119080288e12) === DateTime(2020, 6, 14, 7, 18, 0, 288)
    @test unix_time(DateTime(2020, 6, 14)) === 1.5920928e9
    @test unix_time(DateTime(2020, 6, 14, 7, 18, 0, 288)) ≈ 1.592119080288e9
    @test unix_time(Millisecond, DateTime(2020, 6, 14, 7, 18, 0, 288)) ≈ 1.592119080288e12
end

@testitem "yeardecimal datetime" begin
    import DateFormats as DF

    @test DF.yearfrac(Date(2019, 1, 1)) ≈ 0
    @test DF.yearfrac(Date(2019, 12, 31)) ≈ 1 - 1/365
    @test DF.yearfrac(Date(2020, 1, 1)) ≈ 0
    @test DF.yearfrac(Date(2020, 12, 31)) ≈ 1 - 1/366
    @test DF.yearfrac(Date(2019, 6, 2)) ≈ 0.416438356
    @test DF.yearfrac(Date(2020, 6, 2)) ≈ 0.418032787

    @test DF.yearfrac(DateTime(2019, 1, 1)) ≈ 0
    @test DF.yearfrac(DateTime(2019, 12, 31)) ≈ 1 - 1/365
    @test DF.yearfrac(DateTime(2019, 1, 1, 12, 30)) ≈ (12.5/24)/365

    @test yeardecimal(Date(2019, 1, 1)) ≈ 2019
    @test yeardecimal(Date(2019, 12, 31)) ≈ 2020 - 1/365
    @test yeardecimal(Date(2020, 1, 1)) ≈ 2020
    @test yeardecimal(Date(2020, 12, 31)) ≈ 2021 - 1/366
    @test yeardecimal(Date(2019, 6, 2)) ≈ 2019 + 0.416438356
    @test yeardecimal(Date(2020, 6, 2)) ≈ 2020 + 0.418032787

    @test yeardecimal(DateTime(2019, 1, 1)) ≈ 2019
    @test yeardecimal(DateTime(2019, 12, 31)) ≈ 2020 - 1/365
    @test yeardecimal(DateTime(2019, 1, 1, 12, 30)) ≈ 2019 + (12.5/24)/365

    @test yeardecimal(2019) === DateTime(2019, 1, 1)
    @test yeardecimal(2019 + 0.5/365) === DateTime(2019, 1, 1, 12)
    @test yeardecimal(2019 + 1/365) === DateTime(2019, 1, 2)

    @test yeardecimal(Date(yeardecimal(2019))) == 2019
    @test yeardecimal(Date(yeardecimal(2020 - 1/365 + 1e-5))) ≈ 2020 - 1/365

    @testset for v in [2019, 2019.123, 2019.0001, 2019.9999]
        @test yeardecimal(yeardecimal(v)) ≈ v
    end
    @testset for v in [DateTime(2019, 1, 1, 0, 0, 0, 0), DateTime(2019, 1, 1, 0, 0, 0, 1), DateTime(2019, 12, 31, 23, 59, 59, 999)]
        @test yeardecimal(yeardecimal(v)) == v
    end
end

@testitem "TimeZones" begin
    using TimeZones

    dt = ZonedDateTime(2020, 6, 14, tz"Europe/Moscow")
    @test julian_day(dt) == 2.4590145e6 - 3/24
    @test mjd(dt) == 59014 - 3/24
    @test unix_time(dt) == 1.5920928e9 - 3*3600
    @test yeardecimal(dt) == 2020.4504781420765
end

@testitem "missing" begin
    using Dates

    @testset for f in [
            julian_day, modified_julian_day, yeardecimal, unix_time,
            Base.Fix1(period_decimal, Second),
            Base.Fix1(*ₜ, 123), Base.Fix2(*ₜ, Second), Base.Fix2(*ₜ, missing),
            Base.Fix1(/ₜ, Second(123)), Base.Fix2(/ₜ, Second), Base.Fix2(/ₜ, missing),
        ]
        @test f(missing) === missing
    end
end

@testitem "inverse" begin
    using Dates
    using InverseFunctions

    @testset for f in [julian_day, modified_julian_day, yeardecimal, unix_time]
        x = DateTime(2020, 2, 3)
        @test f(f(x)) === x
        InverseFunctions.test_inverse(f, x; compare=isequal)

        x = DateTime(2020, 2, 3, 4, 5, 6)
        @test f(f(x)) === x
        InverseFunctions.test_inverse(f, x; compare=isequal)

        x = Date(2020, 2, 3)
        if f === modified_julian_day
            @test f(f(x)) === Date(x)
        else
            @test f(f(x)) === DateTime(x)
        end
        InverseFunctions.test_inverse(f, x; compare=isequal)
    end

    InverseFunctions.test_inverse(Base.Fix2(*ₜ, Day), 123.456; compare=isequal)
    InverseFunctions.test_inverse(Base.Fix2(*ₜ, Day(2)), 123.456; compare=isequal)
    InverseFunctions.test_inverse(Base.Fix2(/ₜ, Day), Second(456); compare=isequal)
    InverseFunctions.test_inverse(Base.Fix2(/ₜ, Day(2)), Second(456); compare=isequal)

    InverseFunctions.test_inverse(Base.Fix1(period_decimal, Day), Second(456); compare=isequal)
    InverseFunctions.test_inverse(Base.Fix1(period_decimal, Day), 123.456; compare=isequal)
end

@testitem "decimal period" begin
    using Dates

    @test yeardecimal(Year(1)) == 1
    @test yeardecimal(Year(123)) == 123
    @test yeardecimal(Month(1)) ≈ 1/12
    @test yeardecimal(Day(3)) ≈ 3/365.2425
    @test yeardecimal(Millisecond(123)) ≈ 123/1000/60/60/24/365.2425

    @test (123 *ₜ Second) === Second(123)
    @test (123 *ₜ Second(2)) === Second(2*123)
    @test (123.456 *ₜ Second) === Nanosecond(123456000000)
    @test (123.456 *ₜ Second(2)) === Nanosecond(2*123456000000)

    @test Millisecond(123) /ₜ Millisecond === 123
    @test Millisecond(123) /ₜ Millisecond(1) === 123.0
    @test Second(123) /ₜ Millisecond == 123000
    @test_broken Second(123) /ₜ Millisecond === 123000
    @test Second(456) /ₜ Day ≈ 0.00527777777
    @test Day(78) /ₜ Second ≈ 6.7392e6
    @test Year /ₜ Second ≈ 3.1556952e7
    @test (Millisecond(12) + Hour(34)) /ₜ Second ≈ 122400.012
    @test (Millisecond(12) + Hour(34) + Year(1)) /ₜ Second ≈ 3.1679352012e7
    @test (Millisecond(12) + Hour(34) + Year(1)) /ₜ Second(1) ≈ 3.1679352012e7
    @test (Millisecond(12) + Hour(34) + Year(1)) /ₜ Second(5) ≈ 3.1679352012e7 / 5

    @testset "deprecated" begin
        @test period_decimal(Day, Second(456)) ≈ 0.00527777777
        @test period_decimal(Second, 123.456)::Nanosecond == Millisecond(123456)
    end
end

@testitem "convert" begin
    @test convert(DateTime, YearDecimal(2019 + 0.5/365)) === DateTime(2019, 1, 1, 12)
    @test convert(YearDecimal, DateTime(2019, 1, 1, 12)) ≈ YearDecimal(2019 + 0.5/365)
    @test convert(YearDecimal, Date(2019, 1, 1)) ≈ YearDecimal(2019 + 0/365)

    @test convert(DateTime, MJD(59014.30417)) === DateTime(2020, 6, 14, 7, 18, 0, 288)
    @test convert(MJD, DateTime(2020, 6, 14, 7, 18, 0, 288)) ≈ MJD(59014.30417)
    @test convert(MJD, Date(2020, 6, 14)) ≈ MJD(59014.)

    @test convert(DateTime, JD(2459014.80417)) === DateTime(2020, 6, 14, 7, 18, 0, 288)
    @test convert(JD, DateTime(2020, 6, 14, 7, 18, 0, 288)) ≈ JD(2459014.80417)
    @test convert(JD, Date(2020, 6, 14)) ≈ JD(2459014.5)

    @test convert(DateTime, MJD(missing)) === missing
end

@testitem "constructor" begin
    x = rand() * 5e3
    @test DateTime(YearDecimal(x)) == convert(DateTime, YearDecimal(x))
    @test DateTime(JD(x)) == convert(DateTime, JD(x))
    @test DateTime(MJD(x)) == convert(DateTime, MJD(x))
    y = DateTime(YearDecimal(x))
    @test YearDecimal(y) == convert(YearDecimal, y)
    @test JD(y) == convert(JD, y)
    @test JulianDay(y) == convert(JD, y)
    @test MJD(y) == convert(MJD, y)
    y = Date(YearDecimal(x))
    @test YearDecimal(y) == convert(YearDecimal, y)
    @test JD(y) == convert(JD, y)
    @test JulianDay(y) == convert(JD, y)
    @test MJD(y) == convert(MJD, y)
end

@testitem "from string" begin
    @test yeardecimal("2019.123") === yeardecimal(2019.123)
    @test mjd("53318.30955") === mjd(53318.30955)
    @test julian_day("53318.30955") === julian_day(53318.30955)
    @views begin
        @test yeardecimal("2019.123"[begin:end]) === yeardecimal(2019.123)
        @test mjd("53318.30955"[begin:end]) === mjd(53318.30955)
        @test julian_day("53318.30955"[begin:end]) === julian_day(53318.30955)
    end
end

@testitem "ordering" begin
    vals = rand(10)
    @testset for T in [JD, MJD, YearDecimal]
        xs = T.(vals)
        @test map(x -> x.value, sort(xs)) == sort(vals)
    end
end


@testitem "_" begin
    import Aqua
    import CompatHelperLocal

    CompatHelperLocal.@check()
    Aqua.test_all(DateFormats)
end
