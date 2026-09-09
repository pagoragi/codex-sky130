cd design/magic
load cmos_inverter_layout
select top cell
expand
drc euclidean on
drc style drc(full)
drc check
drc catchup
set count [drc list count total]
puts "DRC_TOTAL=$count"
set report [open ../../build/inverter-layout/drc-count.txt w]
puts $report $count
close $report
if {$count != 0} {
    set errors [drc listall why]
    puts "DRC_ERRORS=$errors"
    set details [open ../../build/inverter-layout/drc-errors.txt w]
    puts $details $errors
    close $details
    exit 1
}
quit -noprompt
