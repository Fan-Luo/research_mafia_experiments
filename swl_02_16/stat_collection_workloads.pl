#!/usr/bin/perl -w 

use English;

#use Data::Dump qw(dump);


my @apps = Readapps('apps.txt');
my @apps2 = Readapps('apps2.txt');
my @apps3 = Readapps('apps3.txt');
my @apps4 = Readapps('apps4.txt');

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

sub Combination{
    my @list = @_;
    local @result;
    foreach my $a (0..$#list) {
        push @result, join("_", $list[$a], $list[$a]);
        foreach my $b ($a+1..$#list) {
            push @result, join("_", $list[$a], $list[$b]);
        }
    }
    return @result;
}

sub Product{
    my ($ref_list1, $ref_list2) = @_;
    local @result;
    print("The first array is  @{$ref_list1}.\n");
    print("The second array is  @{$ref_list2}.\n");
    foreach my $a (@{$ref_list1}){
        foreach my $b (@{$ref_list2}) {
            push @result, join("_", $a, $b);
        }
    }
    return @result;
}

sub Constructlist1{
    my @list = @_;
    local @filelist;
    for my $i (0..$#list) {
        push @filelist, "workloads/" . $list[$i] . "/stream1.txt"
    }
    return @filelist;
}


sub Constructlist2{
    my @list = @_;
    local @filelist;
    for my $i (0..$#list) {
        push @filelist, "workloads/" . $list[$i] . "/stream2.txt"
    }
    return @filelist;
}

sub file_exists {
   my ($qfn) = @_;
   my $rv = -e $qfn;
   die "Unable to determine if file exists: $!"
      if !defined($rv) && !$!{ENOENT};
   return $rv;
}

@benchmarks_complete =( Combination(@apps), Combination(@apps2), Combination(@apps3), Combination(@apps4),Product(\@apps, \@apps2),Product(\@apps, \@apps3),Product(\@apps, \@apps4),Product(\@apps2, \@apps3),Product(\@apps2, \@apps4),Product(\@apps3, \@apps4));

@complete_filelist1= Constructlist1(@benchmarks_complete);
@complete_filelist2= Constructlist2(@benchmarks_complete);
#dump @file_list;
#,Readapps('tuples_unnecessary.txt')
#,Constructlist(Readapps('tuples_unnecessary.txt')) 

#############
my @bench_names = (Readapps('tuples_error.txt'));
my @tuples1 = (Constructlist1(Readapps('tuples_error.txt')));
my @tuples2 = (Constructlist2(Readapps('tuples_error.txt')));
#my @bench_names_want = (Readapps('tuples_done.txt'));
#my @tuples_want = (Constructlist(Readapps('tuples_done.txt')));
################

#my %tuples = map {$_=>1} @tuples;
#my @file_list = grep { !$tuples{$_} } @complete_filelist;
#print join(", ", @bench_names);
#chomp(@tuples);
#print join(", ", @tuples);

##############
my %tuples1;
@tuples1{@tuples1} = ();
@file_list1 = grep !exists $tuples1{$_}, @complete_filelist1;

my %tuples2;
@tuples2{@tuples2} = ();
@file_list2 = grep !exists $tuples2{$_}, @complete_filelist2;

my %bench_names;
@bench_names{@bench_names} = ();
@benchmarks = grep !exists $bench_names{$_}, @benchmarks_complete;
############

$result_file = "all_results.txt";
$sing_apps = "single_results.txt";

open(OUTPUT, ">$result_file") || die "Cannot open file $result_file for writing\n";

for ($j = 0; $j <= $#file_list1; $j++)
{
    my @app_names = split(/_/, $benchmarks[$j]);
    my $app1_name = $app_names[0];
    my $app2_name = $app_names[1];
    
    chomp($app1_name);
    chomp($app2_name);

    push @app2, $app2_name;
    push @app1, $app1_name;
   
    
    #print "$app1_name\n";
    #print "$app2_name\n";
	
	#print "$file_list[$j]";
	my $sing_ipc1 = `grep -w $app1_name $sing_apps | awk '\{print \$2\}'`;
	my $sing_ipc2 = `grep -w $app2_name $sing_apps | awk '\{print \$2\}'`;
	
	#print "$sing_ipc1 ";
	#print "$sing_ipc2\n";
	#my $sing_ipc1 = 1000;
	#my $sing_ipc2 = 1000;
	chomp($sing_ipc1);
	chomp($sing_ipc2);
	
	push @sing_ipc1s, $sing_ipc1;
	push @sing_ipc2s, $sing_ipc2;
	
	#if (-e "$file_list[$j]") {

    
    my $ipc1;
    my $ipc2;
    
    my $slowdown1 ;
    my $slowdown2 ;
    
    # my $wa;
    # my $tw;
    
    # my $wa2;
    # my $tw2;
    
    my $gpu_insn_1 ;
    my $gpu_insn_2;

    
    my $stall_warps_1;
    my $stall_warps_2;

    my $stall_dramfull;
   
    my $stall_icnt2sh; 

    my $misses_1;
    my $misses_2;
	
	my $row_locality_1;
	my $row_locality_2;

    my $averagemflatency1;
    my $averagemflatency2;

    my $averagemrqlatency1;
    my $averagemrqlatency2;
	
	my @bw_dist_1;
	my @bw_dist_2;
    my @bw_dist_3;
    my @bw_dist_4;

    my $Stream_1_L2missrate;
    my $Stream_2_L2missrate;
    my $L2missrate;


    $ipc1 = `grep gpu_ipc_1 $file_list1[$j] | tail -n 1 | awk '\{print \$3\}'`;
    $ipc2 = `grep gpu_ipc_2 $file_list2[$j] | tail -n 1 | awk '\{print \$3\}'`;
   
    $slowdown1 = `grep gpu_ipc_1 $file_list1[$j] | tail -n 1 | awk '\{print \$3\}'`;
    $slowdown2 = `grep gpu_ipc_2 $file_list2[$j] | tail -n 1 | awk '\{print \$3\}'`;

    $gpu_insn_1 = `grep "gpu_sim_insn_1" $file_list1[$j] | tail -n 1 | awk '\{print \$3\}'`;  
    $gpu_insn_2 = `grep "gpu_sim_insn_2" $file_list2[$j] | head -n 1 | awk '\{print \$3\}'`;
      
    my $stat_finish_1 = `grep "statistics" $file_list1[$j] | head -n 1 | awk '\{print \$2\}'`;
    chomp($stat_finish_1);
    $stat_finish_1 = trim($stat_finish_1); 

    my $stat_finish_2 = `grep "statistics" $file_list2[$j] | head -n 1 | awk '\{print \$2\}'`;
    chomp($stat_finish_2);
    $stat_finish_2 = trim($stat_finish_2);

   # $stat_finish = substr($stat_finish,0,4); 

    my $stat_maxinsn_1 = `grep "statistics" $file_list1[$j] | head -n 1 | awk '\{print \$4\}'`;
    chomp($stat_maxinsn_1);
    $stat_maxinsn_1 = trim($stat_maxinsn_1); 

    my $stat_maxinsn_2 = `grep "statistics" $file_list2[$j] | head -n 1 | awk '\{print \$4\}'`;
    chomp($stat_maxinsn_2);
    $stat_maxinsn_2 = trim($stat_maxinsn_2); 
    
    $string1 = "when";
    $string2 = "from";
    $string3 = "completed";

    if(($stat_finish_1 eq $string1) && ($stat_maxinsn_1 ne $string3) && (($stat_finish_2 eq $string2) || (($stat_finish_2 eq $string1) && ($stat_maxinsn_2 eq $string3)) )){
	   
        $stall_warps_1 = `grep "Stall:" $file_list1[$j] | tail -n 2 | head -n 1 | awk -F '[ :\t]' '\{print \$2\}'`;
        $stall_warps_2 = `grep "Stall:" $file_list1[$j] | tail -n 1 | awk -F '[ :\t]' '\{print \$2\}'`;
        
        $stall_dramfull = `grep "gpu_stall_dramfull" $file_list1[$j] | tail -n 1 | awk '\{print \$3\}'`;
        $stall_icnt2sh = `grep "gpu_stall_icnt2sh" $file_list1[$j] | tail -n 1 | awk '\{print \$3\}'`;
        

		@bw_dist_1 = `grep "bw_dist" $file_list1[$j] | tail -n 6 |  awk '\{print \$3\}'`;
		@bw_dist_2 = `grep "bw_dist" $file_list1[$j] | head -n 6 |  awk '\{print \$4\}'`;
        @bw_dist_3 = `grep "bw_dist" $file_list1[$j] | tail -n 6 |  awk '\{print \$6\}'`;
        @bw_dist_4 = `grep "bw_dist" $file_list1[$j] | tail -n 6 |  awk '\{print \$7\}'`;
	
		$row_locality_1 = `grep "average row locality_1" $file_list1[$j] |  tail -n 1 | awk '\{print \$7\}'`;
		$row_locality_2 = `grep "average row locality_2" $file_list1[$j] |  head -n 1 | awk '\{print \$7\}'`;
        
        $averagemflatency1 = `grep "averagemflatency_1" $file_list1[$j] | awk '\{print \$3\}'`;

        $averagemflatency2 = `grep "averagemflatency_2" $file_list1[$j] | awk '\{print \$2\}'`;

        $averagemrqlatency1 = `grep "averagemrqlatency_1" $file_list1[$j] | awk '\{print \$3\}'`;

        $averagemrqlatency2 = `grep "averagemrqlatency_2" $file_list1[$j] |  awk '\{print \$3\}'`;
       

    	# $gpu_insn_2 = `grep "gpu_sim_insn_2" $file_list[$j] | head -n 1 | awk '\{print \$3\}'`;
     #    $gpu_insn_1 = `grep "gpu_sim_insn_1" $file_list[$j] | tail -n 1 | awk '\{print \$3\}'`;

    	$misses_2 = `grep "Stream 2: Misses" $file_list1[$j] | head -n 1 | awk '\{print \$5\}'`;
        $misses_1 = `grep "Stream 1: Misses" $file_list1[$j] | tail -n 1 | awk '\{print \$5\}'`;

        $Stream_1_L2missrate = `grep  "Stream 1: L2 Cache Miss Rate" $file_list1[$j] | tail -n  1 | awk '\{print \$8\}'`;
        $Stream_2_L2missrate = `grep  "Stream 2: L2 Cache Miss Rate" $file_list1[$j] | tail -n  1 | awk '\{print \$8\}'`;
        $L2missrate = `grep  "L2 Cache Total Miss Rate" $file_list1[$j] | tail -n  1 | awk '\{print \$7\}'`;
        # $ipc2 = `grep gpu_ipc_2 $file_list[$j] | head -n 1 | awk '\{print \$3\}'`;
        # $ipc1 = `grep gpu_ipc_1 $file_list[$j] | tail -n 1 | awk '\{print \$3\}'`;
        
        # $slowdown2 = `grep gpu_ipc_2 $file_list[$j] | head -n 1 | awk '\{print \$3\}'`;
        # $slowdown1 = `grep gpu_ipc_1 $file_list[$j] | tail -n 1 | awk '\{print \$3\}'`;
        
        # $wa2 = `grep global_avg_wa_app_2 $file_list[$j] | head -n 1 | awk '\{print \$3\}'`;
        # $wa = `grep global_avg_wa_app_1 $file_list[$j] | tail -n 1 | awk '\{print \$3\}'`;
        
        # $tw2 = `grep global_avg_tw_app_2 $file_list[$j] | head -n 1 | awk '\{print \$3\}'`;
        # $tw = `grep global_avg_tw_app_1 $file_list[$j] | tail -n 1 | awk '\{print \$3\}'`;
        
    }
    elsif(($stat_finish_2 eq $string1) && ($stat_maxinsn_2 ne $string3) && (($stat_finish_1 eq $string2) || (($stat_finish_1 eq $string1) && ($stat_maxinsn_1 eq $string3)) )){
	
        $stall_warps_1 = `grep "Stall:" $file_list2[$j] | tail -n 2 | head -n 1 | awk -F '[ :\t]' '\{print \$2\}'`;
        $stall_warps_2 = `grep "Stall:" $file_list2[$j] | tail -n 1 | awk -F '[ :\t]' '\{print \$2\}'`;
      
        $stall_dramfull = `grep "gpu_stall_dramfull" $file_list2[$j] | tail -n 1 | awk '\{print \$3\}'`;

        $stall_icnt2sh = `grep "gpu_stall_icnt2sh" $file_list2[$j] | tail -n 1 | awk '\{print \$3\}'`;


		@bw_dist_1 = `grep "bw_dist" $file_list2[$j] | head -n 6 |  awk '\{print \$3\}'`;
		@bw_dist_2 = `grep "bw_dist" $file_list2[$j] | tail -n 6 |  awk '\{print \$4\}'`;
        @bw_dist_3 = `grep "bw_dist" $file_list2[$j] | tail -n 6 |  awk '\{print \$6\}'`;
        @bw_dist_4 = `grep "bw_dist" $file_list2[$j] | tail -n 6 |  awk '\{print \$7\}'`;
	
		$row_locality_2 = `grep "average row locality_2" $file_list2[$j] |  tail -n 1 | awk '\{print \$7\}'`;
		$row_locality_1 = `grep "average row locality_1" $file_list2[$j] |  head -n 1 | awk '\{print \$7\}'`;
    	
        $averagemflatency1 = `grep "averagemflatency_1" $file_list2[$j] | awk '\{print \$3\}'`;

        $averagemflatency2 = `grep "averagemflatency_2" $file_list2[$j] | awk '\{print \$2\}'`;
                   
        $averagemrqlatency1 = `grep "averagemrqlatency_1" $file_list2[$j] | awk '\{print \$3\}'`;

        $averagemrqlatency2 = `grep "averagemrqlatency_2" $file_list2[$j] | awk '\{print \$3\}'`;
        

    	# $gpu_insn_2 = `grep "gpu_sim_insn_2" $file_list[$j] | tail -n 1 | awk '\{print \$3\}'`;
     #    $gpu_insn_1 = `grep "gpu_sim_insn_1" $file_list[$j] | head -n 1 | awk '\{print \$3\}'`;

    	$misses_2 = `grep "Stream 2: Misses" $file_list2[$j] | tail -n 1 | awk '\{print \$5\}'`;
        $misses_1 = `grep "Stream 1: Misses" $file_list2[$j] | head -n 1 | awk '\{print \$5\}'`;

        $Stream_1_L2missrate = `grep  "Stream 1: L2 Cache Miss Rate" $file_list2[$j] | tail -n  1 | awk '\{print \$8\}'`;
        $Stream_2_L2missrate = `grep  "Stream 2: L2 Cache Miss Rate" $file_list2[$j] | tail -n  1 | awk '\{print \$8\}'`;
        $L2missrate = `grep  "L2 Cache Total Miss Rate" $file_list2[$j] | tail -n  1 | awk '\{print \$7\}'`;

        # $ipc2 = `grep gpu_ipc_2 $file_list[$j] | tail -n 1 | awk '\{print \$3\}'`;
        # $ipc1 = `grep gpu_ipc_1 $file_list[$j] | head -n 1 | awk '\{print \$3\}'`;
        
        # $slowdown2 = `grep gpu_ipc_2 $file_list[$j] | tail -n 1 | awk '\{print \$3\}'`;
        # $slowdown1 = `grep gpu_ipc_1 $file_list[$j] | head -n 1 | awk '\{print \$3\}'`;
        
        # $wa2 = `grep global_avg_wa_app_2 $file_list[$j] | tail -n 1 | awk '\{print \$3\}'`;
        # $wa = `grep global_avg_wa_app_1 $file_list[$j] | head -n 1 | awk '\{print \$3\}'`;
        
        # $tw2 = `grep global_avg_tw_app_2 $file_list[$j] | tail -n 1 | awk '\{print \$3\}'`;
        # $tw = `grep global_avg_tw_app_1 $file_list[$j] | head -n 1 | awk '\{print \$3\}'`;
    }
    
    else{
        print OUTPUT "Fan: \n";
        print OUTPUT "$app1_name\t";
        print OUTPUT "$app2_name\n";
        print OUTPUT "$stat_finish_1\n";
        print OUTPUT "$stat_maxinsn_1\n";
        print OUTPUT "$stat_finish_2\n";
        print OUTPUT "$stat_maxinsn_2\n";
        exit 0;
    }

    # chomp($wa);
    # chomp($tw);
    # chomp($wa2);
    # chomp($tw2 );
    
    # push @global_wa, $wa;
    # push @global_tw, $tw;
    # push @global_wa_2, $wa2;
    # push @global_tw_2 , $tw2 ;
    
    chomp($ipc1);
    chomp($ipc2);
    
    push @ipc_app1, $ipc1;
    push @ipc_app2, $ipc2;
    
    chomp($gpu_insn_1) ;
    chomp($gpu_insn_2);


    chomp($stall_warps_1);
    chomp($stall_warps_2);
    push @globalstallwarps_1, $stall_warps_1;   
    push @globalstallwarps_2, $stall_warps_2; 

    chomp($stall_dramfull);
    push @globalstalldramfull, $stall_dramfull; 

    chomp($stall_icnt2sh);
    push @globalstallicnt2sh, $stall_icnt2sh;   



    chomp($misses_1);
    chomp($misses_2);
    my $mpki_1 = 1000 * $misses_1 / $gpu_insn_1; 
    my $mpki_2 = 1000 * $misses_2 / $gpu_insn_2;
    
    push @mpki_1_ar,$mpki_1;
    push @mpki_2_ar,$mpki_2;

    if (length($ipc1)) {
        $slowdown1 = $ipc1 / $sing_ipc1;
    }
    
    if (length($ipc2)) {
        $slowdown2 = $ipc2 / $sing_ipc2;
    }
    
    my $speedup;
    
    if (length($slowdown1)) {
        if (length($slowdown2)) {
            $speedup = $slowdown1 + $slowdown2;
        }
    }
    
    my $throughput = 0;
    
    
    if (length($ipc1)) {
        if (length($ipc2)) {
            $throughput = $ipc1 + $ipc2;
        }
    }
    
    my @slowdown_ar;
    
    if (length($slowdown1)) {
        if (length($slowdown2)) {
            @slowdown_ar = ($slowdown1 / $slowdown2 , $slowdown2 / $slowdown1);
        }
    }
    
    my $fairness_index;
    $fairness_index = max(\@slowdown_ar );
    
    push @slowdown1_ar, $slowdown1;
    push @slowdown2_ar, $slowdown2;
    
    push @speedups, $speedup;
    push @throughputs, $throughput;
    push @fair_indexes, $fairness_index;
    
    
    chomp($row_locality_1);
    push @globalrow_locality_1, $row_locality_1;
    
    chomp($row_locality_2);
    push @globalrow_locality_2, $row_locality_2;


    chomp($averagemflatency1);
    chomp($averagemflatency2);
    push @globalaveragemflatency1, $averagemflatency1;
    push @globalaveragemflatency2, $averagemflatency2;

    chomp($averagemrqlatency1);
    chomp($averagemrqlatency2);
    push @globalaveragemrqlatency1, $averagemrqlatency1;
    push @globalaveragemrqlatency2, $averagemrqlatency2;
    
    # my $averagemflatency_1 = `grep "averagemflatency_1" $file_list[$j] |  tail -n 1 | awk '\{print \$3\}'`;
    # chomp($averagemflatency_1);
    # push @globalaveragemflatency_1, $averagemflatency_1;
    
    # my $averagemflatency_2 = `grep "averagemflatency_2" $file_list[$j] |  tail -n 1 | awk '\{print \$3\}'`;
    # chomp($averagemflatency_2);
    # push @globalaveragemflatency_2, $averagemflatency_2;
    
    
    chomp(@bw_dist_1);
    push @globalbw_dist_1, [avg(\@bw_dist_1)];
    
    chomp(@bw_dist_2);
    push @globalbw_dist_2, [avg(\@bw_dist_2)];
    

    chomp(@bw_dist_3);
    push @globalbw_dist_3, [avg(\@bw_dist_3)];
    

    chomp(@bw_dist_4);
    push @globalbw_dist_4, [avg(\@bw_dist_4)];
    
    chomp($Stream_1_L2missrate);
    push @globalStream_1_L2missrate, $Stream_1_L2missrate;
    
    chomp($Stream_2_L2missrate);
    push @globalStream_2_L2missrate, $Stream_2_L2missrate;
    
    chomp($L2missrate);
    push @globalL2missrate, $L2missrate;
    
	#}
}

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

for ($k = 0;$k <= $#file_list1;$k++)
{
    print OUTPUT "$benchmarks[$k] \t";

    print OUTPUT "$app1[$k] \t";
    print OUTPUT "$app2[$k] \t";

	print OUTPUT "$sing_ipc1s[$k]\t";
	print OUTPUT "$sing_ipc2s[$k]\t";
	
	#if (-e "$file_list[$k]") {
    print OUTPUT "$ipc_app1[$k] \t";
    print OUTPUT "$ipc_app2[$k] \t";
    
    print OUTPUT "$slowdown1_ar[$k] \t";
    print OUTPUT "$slowdown2_ar[$k] \t";
    print OUTPUT "$speedups[$k]\t";
    print OUTPUT "$throughputs[$k] \t";
    print OUTPUT "$fair_indexes[$k] \t";
    
    print OUTPUT "$globalstallwarps_1[$k] \t";
    print OUTPUT "$globalstallwarps_2[$k] \t";
    print OUTPUT "$globalstalldramfull[$k] \t";
    print OUTPUT "$globalstallicnt2sh[$k]\t";
    
    print OUTPUT "$globalbw_dist_1[$k][0] \t";
    print OUTPUT "$globalbw_dist_2[$k][0] \t";
    print OUTPUT "$globalbw_dist_3[$k][0] \t";
    print OUTPUT "$globalbw_dist_4[$k][0] \t";
    
    # print OUTPUT "$global_wa[$k] \t";
    # print OUTPUT "$global_tw[$k] \t";
    
    # print OUTPUT "$global_wa_2[$k] \t";
    # print OUTPUT "$global_tw_2[$k] \t";
    
    print OUTPUT "$globalrow_locality_1[$k] \t";
    print OUTPUT "$globalrow_locality_2[$k] \t";
    print OUTPUT "$globalaveragemflatency1[$k] \t";
    print OUTPUT "$globalaveragemflatency2[$k] \t";
    print OUTPUT "$globalaveragemrqlatency1[$k] \t";
    print OUTPUT "$globalaveragemrqlatency2[$k] \t";


    
    # print OUTPUT "$globalMY_app_1_rank_dist_0[$k] \t";
    # print OUTPUT "$globalMY_app_1_rank_dist_1[$k] \t";
    # print OUTPUT "$globalMY_app_1_rank_dist_2[$k] \t";
    # print OUTPUT "$globalMY_app_1_rank_dist_3[$k] \t";
    # print OUTPUT "$globalMY_app_1_rank_dist_4[$k] \t";
    # print OUTPUT "$globalMY_app_1_rank_dist_5[$k] \t";
    # print OUTPUT "$globalMY_app_1_rank_dist_6[$k] \t";
    # print OUTPUT "$globalMY_app_1_rank_dist_7[$k] \t";
    # print OUTPUT "$globalMY_app_1_rank_dist_8[$k] \t";
    
    # print OUTPUT "$globalMY_app_2_rank_dist_0[$k] \t";
    # print OUTPUT "$globalMY_app_2_rank_dist_1[$k] \t";
    # print OUTPUT "$globalMY_app_2_rank_dist_2[$k] \t";
    # print OUTPUT "$globalMY_app_2_rank_dist_3[$k] \t";
    # print OUTPUT "$globalMY_app_2_rank_dist_4[$k] \t";
    # print OUTPUT "$globalMY_app_2_rank_dist_5[$k] \t";
    # print OUTPUT "$globalMY_app_2_rank_dist_6[$k] \t";
    # print OUTPUT "$globalMY_app_2_rank_dist_7[$k] \t";
    # print OUTPUT "$globalMY_app_2_rank_dist_8[$k] \t";
    print OUTPUT "$mpki_1_ar[$k] \t";
    print OUTPUT "$mpki_2_ar[$k] \t";
    print OUTPUT "$globalStream_1_L2missrate[$k] \t";
    print OUTPUT "$globalStream_2_L2missrate[$k] \t";
    print OUTPUT "$globalL2missrate[$k] \t";
	#}
    
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

sub trim
{
   my $val = shift;
   $val =~ s/^\s*//;
  # $val =~ s/\s+$//;

   return $val;
} 