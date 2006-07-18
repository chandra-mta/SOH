#!/opt/local/bin/perl
##!/proj/axaf/bin/perl

# only let one copy run at once
my $lock = "/home/mta/.rt1_ccdm_on";
if (-e $lock) {
  exit;
  #die("waiting for last one to finish\n");
}
`date > $lock`;

# check for AOS and run realtime scripts
# if tracelogs have been updated in the past $time minutes
my $time = 5.0;

# directory to look for updated tracelogs
my $work_dir = "/data/mta4/www/Snapshot";
# directory to run snapshot
my $snap_dir = "/data/mta4/www/Snapshot";
# directory to run SOH
my $soh_dir = "/data/mta4/www/SOH";
# directory to run rt data browser
#$browser_dir = "/data/mta/www/mta_telem/mta_rt";

#my $HOME = $ENV{HOME};
my $HOME = "/home/mta";

# lock file, if this file exists, we're AOS
# let main rt_checker handle this
#my $lfile = "$HOME/.aos_lock";

my $aos = 0;
my $date = `date`;
#print "$date"; #debug
chomp $date;

@tlfiles = <$work_dir/chandra*.tl>;
foreach $f (@tlfiles) {
  if (-M $f < $time/1440) {
    #$aos = 1;
    #if (! -e $lfile) {
      #`echo $date > $lfile`;
      #print "rt_checker on at $date AOS\n"; # debug
    #}
    #`$snap_dir/tlogr.pl >> $HOME/Logs/RT/tlogr_bu.cron 2>&1`;
    #`$soh_dir/tlogr-soh.pl >> $HOME/Logs/RT/tlogr-soh_bu.cron 2>&1`;
    #`$soh_dir/Config/tlogr-config.pl >> $HOME/Logs/RT/tlogr-config_bu.cron 2>&1`;
    #`$soh_dir/PCAD/tlogr-pcad.pl >> $HOME/Logs/RT/tlogr-pcad_bu.cron 2>&1`;
    #`$soh_dir/Mech/tlogr-mech.pl >> $HOME/Logs/RT/tlogr-mech_bu.cron 2>&1`;
    #`$soh_dir/Prop/tlogr-prop.pl >> $HOME/Logs/RT/tlogr-prop_bu.cron 2>&1`;
    `$soh_dir/Therm/tlogr-therm.pl >> $HOME/Logs/RT/tlogr-therm_bu.cron 2>&1`;
    `$soh_dir/CCDM/tlogr-ccdm.pl >> $HOME/Logs/RT/tlogr-ccdm_bu.cron 2>&1`;
    #`$soh_dir/EPS/tlogr-eps.pl >> $HOME/Logs/RT/tlogr-eps_bu.cron 2>&1`;
    #`$browser_dir/cp_cxcds_prod.pl & >> $HOME/Logs/RT/cp_cxcds_prod.cron 2>&1`;
    last;
  }
}

#if ($aos == 0 && -e $lfile) { 
  #unlink $lfile;
  #print "rt_checker off at $date LOS\n"; # debug
#}

unlink $lock;
