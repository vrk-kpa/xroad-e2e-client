#!/usr/bin/perl

use strict;
use GD::Graph::bars;
use GD::Graph::Data;
use MIME::Lite;
use Config::Simple;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();

my %cfg = new Config::Simple('report.ini')->vars();

my $resultsLoc = $cfg{'main.results_dir'} || './';
my $graphLoc = $cfg{'main.graph_dir'} || './';

my $to = $cfg{'email.to'};
my $from = $cfg{'email.from'};
my $subject = $cfg{'email.subject'};
my $message_ = 'Dear sir/madam, 

see the attached graphs for monitoring results from yesterday.

For detailed results, see the attached csv file. The file contents:

hour;minute;second;getRandom result;helloService result

Note: if no line is printed, the program has for example timed out for some reason and therefore been killed or experienced some other unhandled flaw.';

my $yesterday = ($wday + 6) % 7;
my $file = $resultsLoc . "results_" . $yesterday . ".txt";
open(my $fh, "<", $file) or die "Could not open $file: $!";

my @getRandom;
my @helloService;
my @getRandomFail;
my @helloServiceFail;
my @hours;

# Generate hour, success and fail data
for (my $i = 0; $i < 24; $i++) {
        $hours[$i] = $i;
        $getRandom[$i] = 0;
        $getRandomFail[$i] = 60;
        $helloService[$i] = 0;
        $helloServiceFail[$i] = 60;
}

while (my $line  = <$fh>) {
        my @csv = split(";", $line);
        $getRandom[$csv[0]] += $csv[3];
        $getRandomFail[$csv[0]] -= $csv[3];
        $helloService[$csv[0]] += $csv[4];
        $helloServiceFail[$csv[0]] -= $csv[4];
}

my $drand = GD::Graph::Data->new([\@hours, \@getRandomFail, \@getRandom]) or die GD::Graph::Data->error;
my $dhell = GD::Graph::Data->new([\@hours, \@helloServiceFail, \@helloService]) or die GD::Graph::Data->error;

my $hgraph = GD::Graph::bars->new(500, 500);
my $rgraph = GD::Graph::bars->new(500, 500);

# Generate graphs, basically the same code twice with different variable names
# This should be converted to a sub, but for now there are no exact requirements for this feature
# so this is left open

$rgraph->set(
        x_label => 'Hours',
        y_label => 'Success rate, max 60',
        title   => "$mday-$mon",
        y_max_value     => 60,
        y_min_value     => 0,
        show_values     => 1
) or die $rgraph->error;

$rgraph->plot($drand) or die $rgraph->error;

my $frand = $graphLoc . "rand.png";
my $orand;
open($orand, '>', $frand) or die "Cannot open $orand for write: $!";
binmode $orand;
print $orand $rgraph->gd->png;
close $orand;

$hgraph->set(
        x_label => 'Hours',
        y_label => 'Success',
        title   => "$mday-$mon",
        y_max_value     => 60,
        y_min_value     => 0,
        show_values     => 1
) or die $rgraph->error;

$hgraph->plot($dhell) or die $hgraph->error;

my $fhell = $graphLoc . "hell.png";
my $ohell;
open($ohell, '>', $fhell) or die "Cannot open $ohell for write: $!";
binmode $ohell;
print $ohell $hgraph->gd->png;
close $ohell;

my $msg = MIME::Lite->new(
        From    => $from,
        To      => $to,
        Subject => $subject,
        Type    => 'multipart/mixed',
        );

$msg->attach(
        Type    => 'text/plain',
        Data    => $message_
);

$msg->attach(
        Type            => 'image/png',
        Path            => $graphLoc . 'rand.png',
        Filename        => 'rand.png',
        Disposition     => 'attachment'
        );
$msg->attach(
        Type            => 'image/png',
        Path            => $graphLoc . 'hell.png',
        Filename        => 'hell.png',
        Disposition     => 'attachment'
        );
$msg->attach(
        Type            => 'text/csv',
        Path            => $file,
        Filename        => "daily_results.csv",
        Disposition     => 'attachment'
        );

$msg->send();
        