#!/usr/bin/perl
package HashDump;

use strict;
use YAML;
use YAML::Syck;
use XML::Simple;
use JSON 'decode_json';
use feature qw( say );
use Devel::ArgNames;

	my $arg = shift @ARGV;
	if ($arg){
		load($arg);
	}

sub new {
	my $proto = shift;
	my $class = ref $proto || $proto;
	my $self = {};
	bless $self, $class;
	return $self;
}



sub load {
	my ($self, $arg) = @_;
	my $dataname = arg_names(@_);	
	my $filename = $arg;
  if ($self ne 'HashDump'){
		$filename = $self;
		$dataname = '$arg';
	}
my $data;
	if (-e $filename){
		$data = eval { XMLin($filename) } || LoadFile($filename) || decode_json(get_content($filename));
	}else{
		$data = $arg;
	}

	dumpdata($data, $dataname);

	sub dumpdata {
		my $data = shift;
		my $dataname = shift;
		if (defined  $data){
			if (ref($data) eq 'ARRAY') {
				my $num = 0;
				foreach my $var (@$data) {
					my $dataname1 =  $dataname . '->[' . $num .']';
					if ((ref($var ) ne 'ARRAY') && (ref($var) ne 'HASH')) {
						say "$dataname1 = " .$var;
					}	
					if (defined $var){
						dumpdata($var,$dataname1);
					}
					++$num;
				}
			}elsif (ref($data) eq 'HASH') {
				while (my ($key, $value) = each %$data){
					my $dataname2 =  $dataname . '->{' . $key .'}';
					if ((ref($value ) ne 'ARRAY') && (ref($value) ne 'HASH')) {
						say "$dataname2 = " .$value;
					}	
					if (defined $value){
						dumpdata($value, $dataname2);
					}
				}
			}
		}else{
			say "$dataname = $data";
		}
	}
}
1;

