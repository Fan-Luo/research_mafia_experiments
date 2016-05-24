#!/usr/bin/perl -w 
use English;

my @singleapp = Readapps('singleapp.txt');
my @single_swl_list = Readapps('single_swl_list.txt');

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
        push @filelist, $list[$i] . "/single_results.txt"
    }
    return @filelist;
}

#@benchmarks =(@apps, @apps2, @apps3, @apps4 );

@file_list= Constructlist(@single_swl_list);

$result_file = "single_results_swls_summary.txt";

open(OUTPUT, ">$result_file") || die "Cannot open file $result_file for writing\n";


for($i = 0; $i <= $#singleapp; $i++){

    for ($j = 0; $j <= $#file_list; $j++)
    {
        my $app_result = `grep -w $singleapp[$i] $file_list[$j]| awk '\{print \$0\}'`;
        chomp($app_result);
        push @result, $app_result;
    }

    print OUTPUT "$singleapp[$i] \n";

    print OUTPUT "swl_list \t";  
    print OUTPUT "Benchmarks \t";
    print OUTPUT "IPC\t";
    print OUTPUT "Stall warps\t";
    print OUTPUT "Stall Dramfull\t";
    print OUTPUT "Stall icnt2sh\t";

    print OUTPUT "INS\t";
    print OUTPUT "RBL \t";
    print OUTPUT "AVGEMFLat \t";
    print OUTPUT "AVGEMRQLat \t";
    # print OUTPUT "DRAM-Util \t";
	
	   print OUTPUT "App1-BW \t";
    print OUTPUT "Waste-BW \t";
    print OUTPUT "Idle-BW \t";
    
    print OUTPUT "L2-Miss-Rate-1\t";
    print OUTPUT "L2-MPKI\t";

	print OUTPUT "\n";

 
    for ($k = 0;$k <= $#file_list; $k++)
    {
        print OUTPUT "$single_swl_list[$k] \t";

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






























