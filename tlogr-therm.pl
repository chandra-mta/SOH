#!/opt/local/bin/perl
##!/proj/axaf/bin/perl
use strict;

#use lib '/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH/LIB';
use lib '/data/mta4/www/SOH/LIB';
# produce a Chandra status snapshot

# define the working directory for the snapshots

my $work_dir = "/data/mta4/www/SOH/Therm";
my $tl_dir = "/data/mta4/www/SOH/PCAD";
my $web_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH/Therm";
my @ftype = qw(ccdmSSR thermalACIS thermalCCDM_COMP thermalEPS_COMP thermalHRC thermalIP_SIDE_A thermalIP_SIDE_B thermalISIM thermalPCAD_COMP thermalSEA1 thermalSEA2 thermalEPHIN);

use soh;
my %xh1 = get_data($tl_dir, @ftype);
my %xh2 = get_data("/data/mta4/www/SOH", qw(FORM));
my %xh = (%xh1, %xh2);

%xh = get_times(%xh);

#use comp_therm;
#%xh = do_comps(%xh);

%xh = set_status(%xh);

use format_therm_pop;
soh_format("$work_dir/soh-therm.html", %xh);
#`cp $work_dir/soh-therm.html $web_dir`;
# end
