using Test
using Dates
using DateFormats
const DF = DateFormats


@testset "jd" begin
    @test modified_julian_day(59014) === DateTime(2020, 6, 14)  # ensure it's not a Date
    @test modified_julian_day(59014.30417) === DateTime(2020, 6, 14, 7, 18, 0, 288)
    @test modified_julian_day(DateTime(2020, 6, 14)) === 59014.0  # float
    @test modified_julian_day(DateTime(2020, 6, 14, 7, 18, 0, 288)) ≈ 59014.30417

    @test julian_day(2459014.5) === DateTime(2020, 6, 14)
    @test julian_day(2459014.30417) === DateTime(2020, 6, 13, 19, 18, 0, 288)
    @test julian_day(DateTime(2020, 6, 14)) === 2.4590145e6
    @test julian_day(DateTime(2020, 6, 14, 7, 18, 0, 288)) ≈ 2.45901480417e6
end

@testset "unix" begin
    @test unix_time(1.5920928e9) === DateTime(2020, 6, 14)
    @test unix_time(1.592119080288e9) === DateTime(2020, 6, 14, 7, 18, 0, 288)
    @test unix_time(DateTime(2020, 6, 14)) === 1.5920928e9
    @test unix_time(DateTime(2020, 6, 14, 7, 18, 0, 288)) ≈ 1.592119080288e9
end

@testset "yeardecimal datetime" begin
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

@testset "missing" begin
    @testset for f in [julian_day, modified_julian_day, yeardecimal, unix_time, x->period_decimal(Second, x)]
        @test f(missing) === missing
    end
end

@testset "inverse" begin
    @testset for f in [julian_day, modified_julian_day, yeardecimal, unix_time]
        x = DateTime(2020, 2, 3)
        @test f(f(x)) === x
        x = DateTime(2020, 2, 3, 4, 5, 6)
        @test f(f(x)) === x
        x = Date(2020, 2, 3)
        @test f(f(x)) === DateTime(x)
    end
end

@testset "decimal period" begin
    @test yeardecimal(Year(1)) == 1
    @test yeardecimal(Year(123)) == 123
    @test yeardecimal(Month(1)) ≈ 1/12
    @test yeardecimal(Day(3)) ≈ 3/365.2425
    @test yeardecimal(Millisecond(123)) ≈ 123/1000/60/60/24/365.2425

    @test period_decimal(Millisecond, Millisecond(123)) ≈ 123
    @test period_decimal(Day, Second(456)) ≈ 0.00527777777
    @test period_decimal(Second, Day(78)) ≈ 6.7392e6
    
    @test period_decimal(Second, Millisecond(12) + Hour(34)) ≈ 122400.012
    @test period_decimal(Second, Millisecond(12) + Hour(34) + Year(1)) ≈ 3.1679352012e7
    @test period_decimal(Second(1), Millisecond(12) + Hour(34) + Year(1)) ≈ 3.1679352012e7
    @test period_decimal(Second(5), Millisecond(12) + Hour(34) + Year(1)) ≈ 3.1679352012e7 / 5
end

@testset "convert" begin
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

@testset "constructor" begin
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

@testset "from string" begin
    @test yeardecimal("2019.123") === yeardecimal(2019.123)
    @test mjd("53318.30955") === mjd(53318.30955)
    @test julian_day("53318.30955") === julian_day(53318.30955)
end

@testset "ordering" begin
    vals = rand(10)
    @testset for T in [JD, MJD, YearDecimal]
        xs = T.(vals)
        @test map(x -> x.value, sort(xs)) == sort(vals)
    end
end


using Documenter, DocumenterMarkdown
DocMeta.setdocmeta!(DateFormats, :DocTestSetup, :(using DateFormats; using Dates); recursive=true)
makedocs(format=Markdown(), modules=[DateFormats], root="../docs")
mv("../docs/build/README.md", "../README.md", force=true)
rm("../docs/build", recursive=true)


import Aqua
import CompatHelperLocal
@testset begin
    CompatHelperLocal.@check()
    # see broken test in "from string"
    # Aqua.test_ambiguities(DateFormats, recursive=false)
    Aqua.test_unbound_args(DateFormats)
    Aqua.test_undefined_exports(DateFormats)
    Aqua.test_stale_deps(DateFormats)
end
