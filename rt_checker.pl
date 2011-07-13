#!/opt/local/bin/perl
##!/proj/axaf/bin/perl

# only let one copy run at once
my $lock = "/home/mta/.rt1_on";
if (-e $lock) {
  exit;
  #die("waiting for last one to finish\n");
}
`date > $lock`;

# check for AOS and run realtime scripts
# if tracelogs have been updated in the past $time minutes
my $time = 5.0;
#my $time = 1.0;  # test 09/05/03

# directory to look for updated tracelogs
my $work_dir = "/data/mta4/www/Snapshot";
# directory to run snapshot
my $snap_dir = "/data/mta4/www/Snapshot";
# directory to run SOH
my $soh_dir = "/data/mta4/www/SOH";

#my $HOME = $ENV{HOME};
my $HOME = "/home/mta";

# lock file, if this file exists, we're AOS
my $lfile = "$HOME/.aos1_lock";

my $aos = 0;
my $date = `date`;
#print "$date"; #debug
chomp $date;

@tlfiles = <$work_dir/chandra*.tl>;
foreach $f (@tlfiles) {
  if (-M $f < $time/1440) {
    $aos = 1;
    if (! -e $lfile) {
      `echo $date > $lfile`;
      print "rt_checker on at $date AOS\n"; # debug
    }
    #`$snap_dir/tlogr.pl >> $HOME/Logs/RT/tlogr_bu.cron 2>&1`;
    `$soh_dir/tlogr-soh.pl >> $HOME/Logs/RT/tlogr-soh_bu.cron 2>&1`;
    `$soh_dir/Config/tlogr-config.pl >> $HOME/Logs/RT/tlogr-config_bu.cron 2>&1`;
    #`$soh_dir/PCAD/tlogr-pcad.pl >> $HOME/Logs/RT/tlogr-pcad_bu.cron 2>&1`;
    #`$soh_dir/Mech/tlogr-mech.pl >> $HOME/Logs/RT/tlogr-mech_bu.cron 2>&1`;
    `$soh_dir/Prop/tlogr-prop.pl >> $HOME/Logs/RT/tlogr-prop_bu.cron 2>&1`;
    `$soh_dir/Load/tlogr-load.pl >> $HOME/Logs/RT/tlogr-load_bu.cron 2>&1`;
    #`$soh_dir/Therm/tlogr-therm.pl >> $HOME/Logs/RT/tlogr-therm_bu.cron 2>&1`;
    #`$soh_dir/CCDM/tlogr-ccdm.pl >> $HOME/Logs/RT/tlogr-ccdm_bu.cron 2>&1`;
    #`$soh_dir/EPS/tlogr-eps.pl >> $HOME/Logs/RT/tlogr-eps_bu.cron 2>&1`;
    #`$browser_dir/cp_cxcds_prod.pl & >> $HOME/Logs/RT/cp_cxcds_prod.cron 2>&1`;
    sleep 6;
    last;
  }
}

if ($aos == 0 && -e $lfile) { 
  unlink $lfile;
  print "rt_checker off at $date LOS\n"; # debug
  #`echo "LOS" | mailx -s "LOS" brad`; #test 09/05/03
}

unlink $lock;
