#!/opt/local/bin/perl

use lib '/data/mta4/www/SOH/LIB';
# produce a Chandra status snapshot

# define the working directory for the snapshots

my $work_dir = "/data/mta4/www/SOH";
my $tl_dir = "/data/mta4/www/SOH";
my $web_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH";
my @ftype = qw(FORM CCDM PCAD CONFIG PROP LOAD);

use soh;
my %h = get_times(get_data($tl_dir, @ftype));

use comp_soh;
%h = do_comps(%h);

%h = set_status(%h);

use check_state;
%h = check_state("$work_dir/soh.par", %h);

use format_load_pop;
load_format("$work_dir/soh-load-rev.html", %h);
#`cp $work_dir/load_rev.html $web_dir`;
# end
