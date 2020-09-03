#!/usr/bin/perl
use v5.10;
use strict;
use warnings;
use Gearman::Worker;

my $timeoutInMs = 2;
my $worker = Gearman::Worker->new(debug => 1);
$worker->job_servers({ host => "localhost", port => 4730 },);
$worker->register_function(
    'x', $timeoutInMs,
    sub {
        say "doing stuff";
        sleep 1; #in seconds
    }
);
$worker->work(
    on_complete => sub {
        my ($jobhandle, $result) = @_;
        say "on complete $jobhandle";
    },
    on_fail => sub {
        my ($jobhandle, $err) = @_;
        say "on fail $jobhandle";
    },
) while 1;
