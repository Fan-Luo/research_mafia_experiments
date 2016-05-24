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

$result_file = "find_results.txt";
 

open(OUTPUT, ">$result_file") || die "Cannot open file $result_file for writing\n";

for ($j = 0; $j <= $#file_list1; $j++)
{
    
    print OUTPUT "$benchmarks[$j] \t";

    my @app_names = split(/_/, $benchmarks[$j]);
    my $app1_name = $app_names[0];
    my $app2_name = $app_names[1];
    
    chomp($app1_name);
    chomp($app2_name);

    # push @app2, $app2_name;
    # push @app1, $app1_name;
  
    my $find_1 = `grep "statistics" $file_list1[$j] | head -n 1 | awk '\{print \$6\}'`;
    chomp($find_1);
    $find_1 = trim($find_1); 

   my $find_2 = `grep "statistics" $file_list2[$j] | head -n 1 | awk '\{print \$6\}'`;
    chomp($find_2);
    $find_2 = trim($find_2);
     
    $string1 = "instructions";
    
    if(($find_1 eq $string1) || ($find_2 eq $string1) ){
	   
        print OUTPUT "Fan: \t";
        print OUTPUT "$app1_name\t";
        print OUTPUT "$app2_name\t";
        print OUTPUT "$find_1\t";
        print OUTPUT "$find_2\n";
        
    }

    else{
          print OUTPUT "Fan: \t";
          print OUTPUT "Fan: \t";
          print OUTPUT "Fan: \t";
          print OUTPUT "Fan: \t";
          print OUTPUT "Fan: \n";
    }

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