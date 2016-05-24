#!/usr/bin/perl -w 
use English;

my @workloads = Readapps('workloads.txt');
my @swl_list = Readapps('swl_list.txt');

sub Readapps{
    
    $var = $_[0];
    open(my $fh, "<",$var) || die "Failed to open file: $!\n";
    local @array;
    while(<$fh>) {
        chomp;
        push @array, (split / /, $_);
    }
    close $fh;
    
    return @array;
}


sub Constructlist{
    my @list = @_;
    local @filelist;
    for my $i (0..$#list) {
        push @filelist, $list[$i] . "/all_results.txt"
    }
    return @filelist;
}

#@benchmarks =(@apps, @apps2, @apps3, @apps4 );

@file_list= Constructlist(@swl_list);

$result_file = "all_results_summary.txt";

open(OUTPUT, ">$result_file") || die "Cannot open file $result_file for writing\n";


for($i = 0; $i <= $#workloads; $i++){

    for ($j = 0; $j <= $#file_list; $j++)
    {
        my $app_result = `grep -w $workloads[$i] $file_list[$j]| awk '\{print \$0\}'`;
        chomp($app_result);
        push @result, $app_result;
    }

    print OUTPUT "$workloads[$i] \n";

    print OUTPUT "swl_list \t";
    
    print OUTPUT "Benchmarks \t";
    
    print OUTPUT "App1 \t";
    print OUTPUT "App2 \t";

    print OUTPUT "AloneIPC1\t";
    print OUTPUT "AloneIPC2\t";

    print OUTPUT "IPC1\t";
    print OUTPUT "IPC2\t";

    print OUTPUT "SD1\t";
    print OUTPUT "SD2\t";
    print OUTPUT "WS\t";
    print OUTPUT "IT\t";
    print OUTPUT "FI\t";

    print OUTPUT "Stall warps-1\t";
    print OUTPUT "Stall warps-2\t";
    print OUTPUT "Stall Dramfull\t";
    print OUTPUT "Stall icnt2sh\t";
    print OUTPUT "App1-BW \t";
    print OUTPUT "App2-BW\t";
    print OUTPUT "Waste-BW \t";
    print OUTPUT "Idle-BW \t";


    # print OUTPUT "Avg-Slack-1\t";
    # print OUTPUT "Avg-Occupancy-1\t";

    # print OUTPUT "Avg-Slack-2\t";
    # print OUTPUT "Avg-Occupancy-2\t";

    print OUTPUT "RBL-1 \t";
    print OUTPUT "RBL-2 \t";
    print OUTPUT "AVGEMFLat-1 \t";
    print OUTPUT "AVGEMFLat-2 \t";
    print OUTPUT "AVGEMRQLat-1 \t";
    print OUTPUT "AVGEMRQLat-2 \t";

    # print OUTPUT "R0-1 \t";
    # print OUTPUT "R1-1 \t";
    # print OUTPUT "R2-1 \t";
    # print OUTPUT "R3-1 \t";
    # print OUTPUT "R4-1 \t";
    # print OUTPUT "R5-1 \t";
    # print OUTPUT "R6-1 \t";
    # print OUTPUT "R7-1 \t";
    # print OUTPUT "R8-1 \t";

    # print OUTPUT "R0-2 \t";
    # print OUTPUT "R1-2 \t";
    # print OUTPUT "R2-2 \t";
    # print OUTPUT "R3-2 \t";
    # print OUTPUT "R4-2 \t";
    # print OUTPUT "R5-2 \t";
    # print OUTPUT "R6-2 \t";
    # print OUTPUT "R7-2 \t";
    # print OUTPUT "R8-2 \t";
    print OUTPUT "MPKI-1 \t";
    print OUTPUT "MPKI-2 \t";
    print OUTPUT "L2MR-1\t";
    print OUTPUT "L2MR-2\t";
    print OUTPUT "L2MR\t";

    print OUTPUT "\n";
 
    for ($k = 0;$k <= $#file_list; $k++)
    {
        print OUTPUT "$swl_list[$k] \t";

        print OUTPUT "$result[$k] \t";
        
        print OUTPUT "\n";
    }

      @result=(); 
      print OUTPUT "\n";
      print OUTPUT "\n";
      print OUTPUT "\n";

}


sub avg {
    @_ == 1 or die ('Sub usage: $avg = avg(\@array);');
    my ($array_ref) = @_;
    my $sum;
    my $count = scalar @$array_ref;
        if ($count == 0) {
                return 0;
        }
    foreach (@$array_ref) { $sum += $_; }
    return $sum / $count;
}

sub max {
    @_ == 1 or die ('Sub usage: $max = max(\@array);');
    my ($array_ref) = @_;
    my $maxval = -999999999999999999;
    foreach (@$array_ref)
    {
        if ( $maxval < $_ )
        {
            $maxval = $_;
        }
    }
    return $maxval;
}

sub sum {
    @_ == 1 or die ('Sub usage: $sum = sum(\@array);');
    my ($array_ref) = @_;
    my $sum;
    foreach (@$array_ref) { $sum += $_; }
    return $sum;
}






























