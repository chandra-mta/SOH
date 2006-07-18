#!/opt/local/bin/perl
##!/proj/axaf/bin/perl
use strict;

#use lib '/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH/LIB';
use lib '/data/mta4/www/SOH/LIB';
# produce a Chandra status snapshot

# define the working directory for the snapshots

my $work_dir = "/data/mta4/www/SOH/Smode";
my $tl_dir = "/data/mta4/www/SOH";
my $web_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH/Smode";
my @ftype = qw(configMISC epsMISC mechSIM propMUPS sohCCDM sohEPS sohPCAD sohSAFE sohTEL sohTHERM safeRESP1 safeRESP2 safeRESP3 safeSCS1 safeSCS2 safeSCS3 safeSCS4 safeRESP2a);

# safeRESP2a is having troubles, that's why it's separate and special.

use soh;
#use tmp; # debug
#my %xh1 = tmp_data(); #debug
my %xh1 = get_data($tl_dir, @ftype);
my %xh2 = get_data("/data/mta4/www/SOH", qw(FORM));
my %xh = (%xh1, %xh2);

%xh = get_times(%xh);

#use comp_smode
#%xh = do_comps(%xh);

%xh = set_status(%xh);

#use check_state;
#%xh = check_state("$work_dir/smode.par", %xh);

use format_smode_pop;
soh_format("$work_dir/soh-smode.html", %xh);
#`cp $work_dir/soh-smode.html $web_dir`;
# end
