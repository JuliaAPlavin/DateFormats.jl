using Test
using Dates
using DateFormats
const DF = DateFormats


import Aqua
import CompatHelperLocal
@testset begin
    CompatHelperLocal.@check()
    Aqua.test_ambiguities(DateFormats, recursive=false)
    Aqua.test_unbound_args(DateFormats)
    Aqua.test_undefined_exports(DateFormats)
    Aqua.test_stale_deps(DateFormats)
end


@testset "mjd" begin
    @test DF.mjd2datetime(59014) === DateTime(2020, 6, 14)  # ensure it's not a Date
    @test DF.mjd2datetime(59014.30417) === DateTime(2020, 6, 14, 7, 18, 0, 288)
    @test DF.datetime2mjd(DateTime(2020, 6, 14)) === 59014.0  # float
    @test DF.datetime2mjd(DateTime(2020, 6, 14, 7, 18, 0, 288)) ≈ 59014.30417

    @test DF.mjd2datetime(missing) === missing
    @test DF.datetime2mjd(missing) === missing
end

@testset "yeardecimal" begin
    @test DF.yearfrac(Date(2019, 1, 1)) ≈ 0
    @test DF.yearfrac(Date(2019, 12, 31)) ≈ 1 - 1/365
    @test DF.yearfrac(Date(2020, 1, 1)) ≈ 0
    @test DF.yearfrac(Date(2020, 12, 31)) ≈ 1 - 1/366
    @test DF.yearfrac(Date(2019, 6, 2)) ≈ 0.416438356
    @test DF.yearfrac(Date(2020, 6, 2)) ≈ 0.418032787

    @test DF.yearfrac(DateTime(2019, 1, 1)) ≈ 0
    @test DF.yearfrac(DateTime(2019, 12, 31)) ≈ 1 - 1/365
    @test DF.yearfrac(DateTime(2019, 1, 1, 12, 30)) ≈ (12.5/24)/365

    @test DF.yeardecimal(Date(2019, 1, 1)) ≈ 2019
    @test DF.yeardecimal(Date(2019, 12, 31)) ≈ 2020 - 1/365
    @test DF.yeardecimal(Date(2020, 1, 1)) ≈ 2020
    @test DF.yeardecimal(Date(2020, 12, 31)) ≈ 2021 - 1/366
    @test DF.yeardecimal(Date(2019, 6, 2)) ≈ 2019 + 0.416438356
    @test DF.yeardecimal(Date(2020, 6, 2)) ≈ 2020 + 0.418032787

    @test DF.yeardecimal(DateTime(2019, 1, 1)) ≈ 2019
    @test DF.yeardecimal(DateTime(2019, 12, 31)) ≈ 2020 - 1/365
    @test DF.yeardecimal(DateTime(2019, 1, 1, 12, 30)) ≈ 2019 + (12.5/24)/365

    @test DF.yeardecimal(2019) === DateTime(2019, 1, 1)
    @test DF.yeardecimal(2019 + 0.5/365) === DateTime(2019, 1, 1, 12)
    @test DF.yeardecimal(2019 + 1/365) === DateTime(2019, 1, 2)

    @test DF.yeardecimal(Date(DF.yeardecimal(2019))) == 2019
    @test DF.yeardecimal(Date(DF.yeardecimal(2020 - 1/365 + 1e-5))) ≈ 2020 - 1/365

    @testset for v in [2019, 2019.123, 2019.0001, 2019.9999]
        @test DF.yeardecimal(DF.yeardecimal(v)) ≈ v
    end
    @testset for v in [DateTime(2019, 1, 1, 0, 0, 0, 0), DateTime(2019, 1, 1, 0, 0, 0, 1), DateTime(2019, 12, 31, 23, 59, 59, 999)]
        @test DF.yeardecimal(DF.yeardecimal(v)) == v
    end

    @test DF.yeardecimal(Year(1)) == 1
    @test DF.yeardecimal(Year(123)) == 123
    @test DF.yeardecimal(Month(1)) ≈ 1/12
    @test DF.yeardecimal(Day(3)) ≈ 3/365.2425
    @test DF.yeardecimal(Millisecond(123)) ≈ 123/1000/60/60/24/365.2425
end

@testset "convert" begin
    @test convert(DateTime, YearDecimal(2019 + 0.5/365)) === DateTime(2019, 1, 1, 12)
    @test convert(YearDecimal, DateTime(2019, 1, 1, 12)) ≈ YearDecimal(2019 + 0.5/365)
    @test convert(YearDecimal, Date(2019, 1, 1)) ≈ YearDecimal(2019 + 0/365)

    @test convert(DateTime, MJD(59014.30417)) === DateTime(2020, 6, 14, 7, 18, 0, 288)
    @test convert(MJD, DateTime(2020, 6, 14, 7, 18, 0, 288)) ≈ MJD(59014.30417)

    @test convert(DateTime, JD(2459014.80417)) === DateTime(2020, 6, 14, 7, 18, 0, 288)
    @test convert(JD, DateTime(2020, 6, 14, 7, 18, 0, 288)) ≈ JD(2459014.80417)
end
