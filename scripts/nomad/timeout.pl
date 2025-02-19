#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use Time::Piece;

# Initialize variables
my $dry_run = 0;

# Parse arguments
GetOptions(
    'n' => \$dry_run,
) or die("Usage: $0 <search_regex> [-n]\n");

my $search_regex = shift @ARGV or die("Usage: $0 <search_regex> [-n]\n");

# Get the current timestamp in seconds
my $current_time = time();

# Open the Nomad job status command for reading
open my $fh, '-|', 'nomad job status -verbose -namespace chomp'
    or die "Failed to run 'nomad job status': $!\n";

while (my $line = <$fh>) {
    chomp $line;

    # Filter lines using the search regex
    next unless $line =~ /$search_regex/;

    # Split the line into fields
    my @fields = split /\s+/, $line;
    my $job_id = $fields[0];              # Assume job ID is the first field
    my $timestamp = $fields[-1];          # Assume timestamp is the last field

    # Convert the timestamp to seconds since epoch
    my $timestamp_seconds;
    eval {
        my $t = Time::Piece->strptime($timestamp, '%Y-%m-%dT%H:%M:%S');
        $timestamp_seconds = $t->epoch;
    };
    if ($@) {
        warn "Failed to parse timestamp '$timestamp': $@\n";
        next;
    }

    # Check if the timestamp is older than 48 hours
    if ($timestamp_seconds && ($current_time - $timestamp_seconds) > (48 * 3600)) {
        if ($dry_run) {
            print "Dry Run: Job '$job_id' would be deleted (timestamp: $timestamp).\n";
        } else {
            print "Deleting Job: '$job_id' (timestamp: $timestamp).\n";
            my $result = system("nomad job stop -namespace chomp -detach $job_id");
            if ($result != 0) {
                warn "Failed to delete job '$job_id': $!\n";
            }
        }
    }
}

close $fh;

