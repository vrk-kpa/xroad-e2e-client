#!/usr/bin/perl

# Simple monitoring client script for Palveluväylä

use warnings FATAL=>'all';
use strict;

use LWP::UserAgent;
use HTTP::Request::Common;
use XML::Parser;
use Scalar::Util;
use MIME::Lite;
use Config::Simple;

=begin comment
The MIT License (MIT)

Copyright (c) 2016 CSC - IT Center for Science, Population Register Centre (VRK)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
=cut

require './randomXML.pl';
require './helloXML.pl';

my %cfg = new Config::Simple('monitor.ini')->vars();
my $here = $cfg{'monitor.here'} || './';

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();

sub alertmsg {
	# This will send an alert message if either of the calls fail.
	# Remove the lock file by e.g. Cron, the lock file is a spam controller.
	if (! -e $cfg{'monitor.lock_file'}) {
		my $body = shift;
		my $emsg = MIME::Lite->new(
			From    => $cfg{'email.email_from'},
			To      => $cfg{'email.email_to'},
			Subject => $cfg{'email.email_subject'},
			Type    => 'multipart/mixed',
		);

		$emsg->attach(
				Type    => 'TEXT',
				Data    => $body
		);
		$emsg->send();
		open(my $lockfile, ">>", $cfg{'monitor.lock_file'});
		close($lockfile);
		}
}


# Remove tomorrow's file in advance (cron job or similar would be a better solution)
my $tomorrow = ($wday + 1) % 7;
if (-e $here . "results_" . $tomorrow . ".txt") {
	unlink $here . "results_" . $tomorrow . ".txt";
}

my $filename = $here . "results_" . $wday . ".txt";
open(my $fh, ">>", $filename) or die("Can not open results file for writing, $!");

my %ssl_opts = (
	verify_hostname => 0,
	SSL_version => 'TLS12'
);

if ($cfg{'ssl.ssl_enabled'} == 1) {
	$ssl_opts{'SSL_key_file'} = $cfg{'ssl.key_file_path'};
	$ssl_opts{'SSL_cert_file'} = $cfg{'ssl.cert_file_path'};
}


my $userAgent = LWP::UserAgent->new(agent => 'perl post', ssl_opts => \%ssl_opts);
my $soapRandom = soapRandom();
my $soapHello = soapHello();

# Control port and protocol, mainly to make it work when testing
my $port = $cfg{'monitor.host_port'} ? ":" . $cfg{'monitor.host_port'}:'';
my $protocol = $cfg{'monitor.host_port'} && int($cfg{'monitor.host_port'}) != 80 ? "https":"http";
my $_eval;
my $_evalh;
my $response = $userAgent->request(POST "$protocol://$cfg{'monitor.target_host'}$port",
				Content_Type => 'text/xml',
				Content => $soapRandom);
				
if ($response->{"_rc"} != 200) {
	print $fh $hour . ";" . $min . ";" . $sec . ";" . "0;";
	alertmsg("Can not connect to host.");
}
else {
				
	my $xmlp = XML::Parser::Lite::Tree::instance()->parse($response->content);
	$_eval = eval {defined($xmlp->{'children'}[1]->{'children'}[1]->{'children'}[0]->{'children'}[1]->
		{'children'}[0]->{'children'}[0]->{'content'}) && isint($xmlp->{'children'}[1]->{'children'}[1]->
		{'children'}[0]->{'children'}[1]->{'children'}[0]->{'children'}[0]->{'content'});};
	
	# Simple prints of results as csv to the file	
	print $fh $hour . ";" . $min . ";" . $sec . ";";
	if (defined($_eval) && $_eval == 1) { print $fh '1;'; } else { print $fh '0;'; }
}

my $helloResponse = $userAgent->request(POST "$protocol://$cfg{'monitor.target_host'}$port",
				Content_Type => 'text/xml',
				Content => $soapHello);
				
if ($helloResponse->{"_rc"} != 200) {
	print $fh "0";
	alertmsg("Can not connect to host.");
}
else {

	my $helloXmlp = XML::Parser::Lite::Tree::instance()->parse($helloResponse->content);
	$_evalh = eval {defined($helloXmlp->{'children'}[1]->{'children'}[1]->{'children'}[0]->{'children'}[1]->
		{'children'}[0]->{'children'}[0]->{'content'}) && $helloXmlp->{'children'}[1]->{'children'}[1]->
		{'children'}[0]->{'children'}[1]->{'children'}[0]->{'children'}[0]->{'content'} =~ /Test/;};
	
	if (defined($_evalh) && $_evalh == 1) { print $fh "1"; } else { print $fh "0"; }
}
print $fh "\n";

close($fh);

if (!defined($_eval) || !defined($_evalh)) {
	alertmsg("Client calls failed. One or both response content validators died.\n\n");
}
elsif ($_eval != 1 || $_evalh != 1) {
	alertmsg("Client calls failed. Statuses for individual calls: helloService - \'$_evalh\', getRandom - \'$_eval\' \n\n");
}


