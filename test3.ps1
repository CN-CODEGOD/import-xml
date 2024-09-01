using namespace system.xml.linq
$CurrentDate = Get-Date
$YearEnd = Get-Date -Year $CurrentDate.Year -Month 12 -Day 31 -Format yyyyMMdd
$MonthEnd = Get-Date -Year $CurrentDate.Year -Month $CurrentDate.Month -Day ([datetime]::DaysInMonth($CurrentDate.Year,$CurrentDate.Month)) -Format yyyyMMdd

$x = [xelement]::new("Trigger",
    [xelement]::new("Value1",$YearEnd),
    [xelement]::new("Value2",$MonthEnd),
    [xelement]::new("Value3",$MonthEnd),
    [xelement]::new("Value4","FINANCE"),
    [xelement]::new("Value5",""),
    [xelement]::new("Value6",""))

$x.tostring()