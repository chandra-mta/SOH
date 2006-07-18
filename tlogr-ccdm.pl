#!/proj/axaf/bin/perl
##!/opt/local/bin/perl

# produce a Chandra status snapshot

# define the working directory for the snapshots

$work_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH/CCDM";
$tl_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH/CCDM";
$sohf = "$work_dir/soh-ccdm.html";


## read the ACORN tracelog files - SOH

@tlfiles = <$tl_dir/ccdm*.tl>;
foreach $f (@tlfiles) {
    open (TLF, $f) or next;
    @msids = split ' ', <TLF>;
    shift @msids;                 # exclude time
    <TLF>;                        # skip second line
    my $v;                 # initialize values
    my $color = "#FF4466"; # initialize color, orangish.  If not changed
                           #  before output, something is wrong
    my $time = 99999;      # initialize time
    my $data = 0;          # no data yet
    while (<TLF>) {
      $v = $_ ;
      $data = 1;
    }
    if ($data == 1) {
      $color = "#66FFFF";
      @vals = split ' ',$v;
      $time = shift @vals;
    }
    foreach (@msids) { $h{$_} = [$time,shift @vals, $color] };
    push @times,$time;
}

# delete obsolete tracelog files

for $i (1 .. $#tlfiles) {
    $pf = $tlfiles[$i-1];
    $f = $tlfiles[$i];
    $proot = substr $pf, 0, rindex($pf,'_');
    $root = substr $f, 0, rindex($f,'_');
    push @of,$pf if (($root eq $proot) and (-s $f) and (-M $pf > 0.02));
}
unlink @of;

# do not produce a snapshot with stale data

sub numerically { $a <=> $b };
@stimes = sort numerically @times;
$ltime = pop @stimes;
$time0 = shift @stimes;
while ($time0 == 99999) { $time0 = shift @stimes; }
die "Exit because of stale data! Data timespan: $time0 to $ltime\n" if ($ltime - $time0) > 100000;

# do some computations

$t1998 = 883612800.0;
($sec,$min,$hr,$dummy,$dummy,$y,$dummy,$yday,$dummy) = gmtime($ltime+$t1998);
$obt = sprintf "%4d:%3.3d:%2.2d:%2.2d:%2.2d",$y+1900,$yday+1,$hr,$min,$sec;

#%h = check_state(%h);

$utc = `date -u +"%Y:%j:%T (%b%e)"`;
($dummy,$dummy,$dummy,$dummy,$dummy,$y,$dummy,$yday,$dummy) = gmtime();
chomp $utc;

# determine LOS or AOS
@contact = chk_contact($utc);

# write out state of health snapshot
open(SF, ">$sohf") or die "Cannot open $sohf\n";
print SF "<HTML><HEAD><TITLE>Chandra State of Health - CCDM</TITLE></HEAD>\n";
print SF "<BODY BGCOLOR=\"#000000\" TEXT=\"#EEEEEE\" LINK=\"#DDDDDD\" ALINK=\"#DDDDDD\" VLINK=\"#DDDDDD\">\n";
printf SF "<H1>CHANDRA STATE OF HEALTH - CCDM</H1>\n";

printf SF "Last Updated: &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp UTC %s <BR>\n", $utc;
printf SF "<BR>\n";
printf SF "Last Data Received: &nbsp &nbsp OBT %s \n", $obt;
printf SF "&nbsp &nbsp &nbsp &nbsp Contact: &nbsp <%s>%s <\/%s><BR>\n", $contact[1], $contact[0], $contact[1];
#printf SF "OBT %17.2f <BR>\n", $ltime;
printf SF "<BR>\n";
printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=LEFT COLSPAN=11><FONT SIZE=4>CTU</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCTXA</FONT></TD>\n", ${$h{CCTXA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CCTXA}}[2], ${$h{CCTXA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CEM5VPPR</FONT></TD>\n", ${$h{CEM5VPPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CEM5VPPR}}[2], ${$h{CEM5VPPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSTSA</FONT></TD>\n", ${$h{CSTSA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSTSA}}[2], ${$h{CSTSA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CUSOBPWR</FONT></TD>\n", ${$h{CUSOBPWR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CUSOBPWR}}[2], ${$h{CUSOBPWR}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCTXB</FONT></TD>\n", ${$h{CCTXB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CCTXB}}[2], ${$h{CCTXB}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CEM5VPRD</FONT></TD>\n", ${$h{CEM5VPRD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CEM5VPRD}}[2], ${$h{CEM5VPRD}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSTSB</FONT></TD>\n", ${$h{CSTSB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSTSB}}[2], ${$h{CSTSB}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CVEEP</FONT></TD>\n", ${$h{CVEEP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CVEEP}}[2], ${$h{CVEEP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CE5VPCPR</FONT></TD>\n", ${$h{CE5VPCPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CE5VPCPR}}[2], ${$h{CE5VPCPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSBKWR1</FONT></TD>\n", ${$h{CSBKWR1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSBKWR1}}[2], ${$h{CSBKWR1}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUBITRS</FONT></TD>\n", ${$h{CTUBITRS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTUBITRS}}[2], ${$h{CTUBITRS}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CVEER</FONT></TD>\n", ${$h{CVEER}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CVEER}}[2], ${$h{CVEER}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CE5VPCRD</FONT></TD>\n", ${$h{CE5VPCRD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CE5VPCRD}}[2], ${$h{CE5VPCRD}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSBKWR2</FONT></TD>\n", ${$h{CSBKWR2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSBKWR2}}[2], ${$h{CSBKWR2}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CUSOAPWR</FONT></TD>\n", ${$h{CUSOAPWR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CUSOAPWR}}[2], ${$h{CUSOAPWR}}[1];
#printf SF "</TABLE>\n";

printf SF "<TR>\n";
#printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=LEFT COLSPAN=11><FONT SIZE=4>EIA</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AHKNATPR</FONT></TD>\n", ${$h{AHKNATPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AHKNATPR}}[2], ${$h{AHKNATPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPORD1X</FONT></TD>\n", ${$h{CPORD1X}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CPORD1X}}[2], ${$h{CPORD1X}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQATI1</FONT></TD>\n", ${$h{C2SQATI1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQATI1}}[2], ${$h{C2SQATI1}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQOBAR</FONT></TD>\n", ${$h{C2SQOBAR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQOBAR}}[2], ${$h{C2SQOBAR}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AHKNATRD</FONT></TD>\n", ${$h{AHKNATRD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AHKNATRD}}[2], ${$h{AHKNATRD}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPORD2X</FONT></TD>\n", ${$h{CPORD2X}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CPORD2X}}[2], ${$h{CPORD2X}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQATI2</FONT></TD>\n", ${$h{C2SQATI2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQATI2}}[2], ${$h{C2SQATI2}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQOBBP</FONT></TD>\n", ${$h{C2SQOBBP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQOBBP}}[2], ${$h{C2SQOBBP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAPCT</FONT></TD>\n", ${$h{C1SQAPCT}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQAPCT}}[2], ${$h{C1SQAPCT}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CRORD1X</FONT></TD>\n", ${$h{CRORD1X}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CRORD1X}}[2], ${$h{CRORD1X}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQATPP</FONT></TD>\n", ${$h{C2SQATPP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQATPP}}[2], ${$h{C2SQATPP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQOBBR</FONT></TD>\n", ${$h{C2SQOBBR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQOBBR}}[2], ${$h{C2SQOBBR}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAPIU</FONT></TD>\n", ${$h{C1SQAPIU}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQAPIU}}[2], ${$h{C1SQAPIU}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CRORD2X</FONT></TD>\n", ${$h{CRORD2X}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CRORD2X}}[2], ${$h{CRORD2X}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQATPS</FONT></TD>\n", ${$h{C2SQATPS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQATPS}}[2], ${$h{C2SQATPS}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQPTLX</FONT></TD>\n", ${$h{C2SQPTLX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQPTLX}}[2], ${$h{C2SQPTLX}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAPO</FONT></TD>\n", ${$h{C1SQAPO}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQAPO}}[2], ${$h{C1SQAPO}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQBTPP</FONT></TD>\n", ${$h{C1SQBTPP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQBTPP}}[2], ${$h{C1SQBTPP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAX</FONT></TD>\n", ${$h{C2SQAX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQAX}}[2], ${$h{C2SQAX}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQRTLX</FONT></TD>\n", ${$h{C2SQRTLX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQRTLX}}[2], ${$h{C2SQRTLX}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAPPP</FONT></TD>\n", ${$h{C1SQAPPP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQAPPP}}[2], ${$h{C1SQAPPP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQBTPS</FONT></TD>\n", ${$h{C1SQBTPS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQBTPS}}[2], ${$h{C1SQBTPS}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQBPCT</FONT></TD>\n", ${$h{C2SQBPCT}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQBPCT}}[2], ${$h{C2SQBPCT}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CM1CKBP1</FONT></TD>\n", ${$h{CM1CKBP1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CM1CKBP1}}[2], ${$h{CM1CKBP1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQATI1</FONT></TD>\n", ${$h{C1SQATI1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQATI1}}[2], ${$h{C1SQATI1}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQBX</FONT></TD>\n", ${$h{C1SQBX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQBX}}[2], ${$h{C1SQBX}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQBPIU</FONT></TD>\n", ${$h{C2SQBPIU}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQBPIU}}[2], ${$h{C2SQBPIU}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CM1CKBP2</FONT></TD>\n", ${$h{CM1CKBP2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CM1CKBP2}}[2], ${$h{CM1CKBP2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQATI2</FONT></TD>\n", ${$h{C1SQATI2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQATI2}}[2], ${$h{C1SQATI2}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQOBAP</FONT></TD>\n", ${$h{C1SQOBAP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQOBAP}}[2], ${$h{C1SQOBAP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQBPO</FONT></TD>\n", ${$h{C2SQBPO}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQBPO}}[2], ${$h{C2SQBPO}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CM1CKBR1</FONT></TD>\n", ${$h{CM1CKBR1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CM1CKBR1}}[2], ${$h{CM1CKBR1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQATPP</FONT></TD>\n", ${$h{C1SQATPP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQATPP}}[2], ${$h{C1SQATPP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQOBAR</FONT></TD>\n", ${$h{C1SQOBAR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQOBAR}}[2], ${$h{C1SQOBAR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQBPPP</FONT></TD>\n", ${$h{C2SQBPPP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQBPPP}}[2], ${$h{C2SQBPPP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CM1CKBR2</FONT></TD>\n", ${$h{CM1CKBR2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CM1CKBR2}}[2], ${$h{CM1CKBR2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQATPS</FONT></TD>\n", ${$h{C1SQATPS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQATPS}}[2], ${$h{C1SQATPS}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQOBBP</FONT></TD>\n", ${$h{C1SQOBBP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQOBBP}}[2], ${$h{C1SQOBBP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQBTI1</FONT></TD>\n", ${$h{C2SQBTI1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQBTI1}}[2], ${$h{C2SQBTI1}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CM2CKBP1</FONT></TD>\n", ${$h{CM2CKBP1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CM2CKBP1}}[2], ${$h{CM2CKBP1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAX</FONT></TD>\n", ${$h{C1SQAX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQAX}}[2], ${$h{C1SQAX}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQOBBR</FONT></TD>\n", ${$h{C1SQOBBR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQOBBR}}[2], ${$h{C1SQOBBR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQBTI2</FONT></TD>\n", ${$h{C2SQBTI2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQBTI2}}[2], ${$h{C2SQBTI2}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CM2CKBP2</FONT></TD>\n", ${$h{CM2CKBP2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CM2CKBP2}}[2], ${$h{CM2CKBP2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQBPCT</FONT></TD>\n", ${$h{C1SQBPCT}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQBPCT}}[2], ${$h{C1SQBPCT}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQPTLX</FONT></TD>\n", ${$h{C1SQPTLX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQPTLX}}[2], ${$h{C1SQPTLX}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQBTPP</FONT></TD>\n", ${$h{C2SQBTPP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQBTPP}}[2], ${$h{C2SQBTPP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CM2CKBR1</FONT></TD>\n", ${$h{CM2CKBR1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CM2CKBR1}}[2], ${$h{CM2CKBR1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQBPIU</FONT></TD>\n", ${$h{C1SQBPIU}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQBPIU}}[2], ${$h{C1SQBPIU}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQRTLX</FONT></TD>\n", ${$h{C1SQRTLX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQRTLX}}[2], ${$h{C1SQRTLX}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQBTPS</FONT></TD>\n", ${$h{C2SQBTPS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQBTPS}}[2], ${$h{C2SQBTPS}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CM2CKBR2</FONT></TD>\n", ${$h{CM2CKBR2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CM2CKBR2}}[2], ${$h{CM2CKBR2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQBPO</FONT></TD>\n", ${$h{C1SQBPO}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQBPO}}[2], ${$h{C1SQBPO}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAPCT</FONT></TD>\n", ${$h{C2SQAPCT}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQAPCT}}[2], ${$h{C2SQAPCT}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQBX</FONT></TD>\n", ${$h{C2SQBX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQBX}}[2], ${$h{C2SQBX}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CM3CKBP1</FONT></TD>\n", ${$h{CM3CKBP1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CM3CKBP1}}[2], ${$h{CM3CKBP1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQBPPP</FONT></TD>\n", ${$h{C1SQBPPP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQBPPP}}[2], ${$h{C1SQBPPP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAPIU</FONT></TD>\n", ${$h{C2SQAPIU}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQAPIU}}[2], ${$h{C2SQAPIU}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQOBAP</FONT></TD>\n", ${$h{C2SQOBAP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQOBAP}}[2], ${$h{C2SQOBAP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CM3CKBP2</FONT></TD>\n", ${$h{CM3CKBP2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CM3CKBP2}}[2], ${$h{CM3CKBP2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQBTI1</FONT></TD>\n", ${$h{C1SQBTI1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQBTI1}}[2], ${$h{C1SQBTI1}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAPO</FONT></TD>\n", ${$h{C2SQAPO}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQAPO}}[2], ${$h{C2SQAPO}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CEIAPR</FONT></TD>\n", ${$h{CEIAPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CEIAPR}}[2], ${$h{CEIAPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CM3CKBR1</FONT></TD>\n", ${$h{CM3CKBR1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CM3CKBR1}}[2], ${$h{CM3CKBR1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQBTI2</FONT></TD>\n", ${$h{C1SQBTI2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C1SQBTI2}}[2], ${$h{C1SQBTI2}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAPPP</FONT></TD>\n", ${$h{C2SQAPPP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{C2SQAPPP}}[2], ${$h{C2SQAPPP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CEIARD</FONT></TD>\n", ${$h{CEIARD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CEIARD}}[2], ${$h{CEIARD}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CM3CKBR2</FONT></TD>\n", ${$h{CM3CKBR2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CM3CKBR2}}[2], ${$h{CM3CKBR2}}[1];
#printf SF "</TABLE>\n";

printf SF "<TR>\n";
#printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=LEFT COLSPAN=11><FONT SIZE=4>IU</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCOACBFA</FONT></TD>\n", ${$h{CCOACBFA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CCOACBFA}}[2], ${$h{CCOACBFA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACBDL</FONT></TD>\n", ${$h{CIUACBDL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACBDL}}[2], ${$h{CIUACBDL}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCAEX</FONT></TD>\n", ${$h{CIUBCAEX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBCAEX}}[2], ${$h{CIUBCAEX}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCBSL</FONT></TD>\n", ${$h{CIUBCBSL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBCBSL}}[2], ${$h{CIUBCBSL}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCOACBFB</FONT></TD>\n", ${$h{CCOACBFB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CCOACBFB}}[2], ${$h{CCOACBFB}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACBEX</FONT></TD>\n", ${$h{CIUACBEX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACBEX}}[2], ${$h{CIUACBEX}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCAFL</FONT></TD>\n", ${$h{CIUBCAFL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBCAFL}}[2], ${$h{CIUBCAFL}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBEPDL</FONT></TD>\n", ${$h{CIUBEPDL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBEPDL}}[2], ${$h{CIUBEPDL}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCOBCBFB</FONT></TD>\n", ${$h{CCOBCBFB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CCOBCBFB}}[2], ${$h{CCOBCBFB}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACBFL</FONT></TD>\n", ${$h{CIUACBFL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACBFL}}[2], ${$h{CIUACBFL}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCAPA</FONT></TD>\n", ${$h{CIUBCAPA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBCAPA}}[2], ${$h{CIUBCAPA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBPL1L</FONT></TD>\n", ${$h{CIUBPL1L}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBPL1L}}[2], ${$h{CIUBPL1L}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCOBCBFB</FONT></TD>\n", ${$h{CCOBCBFB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CCOBCBFB}}[2], ${$h{CCOBCBFB}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACBPA</FONT></TD>\n", ${$h{CIUACBPA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACBPA}}[2], ${$h{CIUACBPA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUSB</FONT></TD>\n", ${$h{CIUSB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUSB}}[2], ${$h{CIUSB}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBPL2L</FONT></TD>\n", ${$h{CIUBPL2L}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBPL2L}}[2], ${$h{CIUBPL2L}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACADL</FONT></TD>\n", ${$h{CIUACADL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACADL}}[2], ${$h{CIUACADL}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACBRH</FONT></TD>\n", ${$h{CIUACBRH}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACBRH}}[2], ${$h{CIUACBRH}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCARH</FONT></TD>\n", ${$h{CIUBCARH}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBCARH}}[2], ${$h{CIUBCARH}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUCALIN</FONT></TD>\n", ${$h{CIUCALIN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUCALIN}}[2], ${$h{CIUCALIN}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACAEX</FONT></TD>\n", ${$h{CIUACAEX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACAEX}}[2], ${$h{CIUACAEX}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUSA</FONT></TD>\n", ${$h{CIUSA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUSA}}[2], ${$h{CIUSA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCASL</FONT></TD>\n", ${$h{CIUBCASL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBCASL}}[2], ${$h{CIUBCASL}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUCBLIN</FONT></TD>\n", ${$h{CIUCBLIN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUCBLIN}}[2], ${$h{CIUCBLIN}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACAFL</FONT></TD>\n", ${$h{CIUACAFL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACAFL}}[2], ${$h{CIUACAFL}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACBSL</FONT></TD>\n", ${$h{CIUACBSL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACBSL}}[2], ${$h{CIUACBSL}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCBDL</FONT></TD>\n", ${$h{CIUBCBDL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBCBDL}}[2], ${$h{CIUBCBDL}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUMACAC</FONT></TD>\n", ${$h{CIUMACAC}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUMACAC}}[2], ${$h{CIUMACAC}}[1];
#printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CNVLCD</FONT></TD>\n", ${$h{CNVLCD}}[2];
#printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CNVLCD}}[2], ${$h{CNVLCD}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACAPA</FONT></TD>\n", ${$h{CIUACAPA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACAPA}}[2], ${$h{CIUACAPA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUAEPDL</FONT></TD>\n", ${$h{CIUAEPDL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUAEPDL}}[2], ${$h{CIUAEPDL}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCBEX</FONT></TD>\n", ${$h{CIUBCBEX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBCBEX}}[2], ${$h{CIUBCBEX}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUMACAS</FONT></TD>\n", ${$h{CIUMACAS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUMACAS}}[2], ${$h{CIUMACAS}}[1];
#printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACAPA</FONT></TD>\n", ${$h{CIUACAPA}}[2];
#printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACAPA}}[2], ${$h{CIUACAPA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACARH</FONT></TD>\n", ${$h{CIUACARH}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACARH}}[2], ${$h{CIUACARH}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUAPL1L</FONT></TD>\n", ${$h{CIUAPL1L}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUAPL1L}}[2], ${$h{CIUAPL1L}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCBFL</FONT></TD>\n", ${$h{CIUBCBFL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBCBFL}}[2], ${$h{CIUBCBFL}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCSDSVCD</FONT></TD>\n", ${$h{CCSDSVCD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%d</FONT></TD>\n", ${$h{CCSDSVCD}}[2], ${$h{CCSDSVCD}}[1];
#printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACARH</FONT></TD>\n", ${$h{CIUACARH}}[2];
#printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACARH}}[2], ${$h{CIUACARH}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACASL</FONT></TD>\n", ${$h{CIUACASL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACASL}}[2], ${$h{CIUACASL}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUAPL2L</FONT></TD>\n", ${$h{CIUAPL2L}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUAPL2L}}[2], ${$h{CIUAPL2L}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCBPA</FONT></TD>\n", ${$h{CIUBCBPA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBCBPA}}[2], ${$h{CIUBCBPA}}[1];
#printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACASL</FONT></TD>\n", ${$h{CIUACASL}}[2];
#printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUACASL}}[2], ${$h{CIUACASL}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCADL</FONT></TD>\n", ${$h{CIUBCADL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBCADL}}[2], ${$h{CIUBCADL}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCBRH</FONT></TD>\n", ${$h{CIUBCBRH}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CIUBCBRH}}[2], ${$h{CIUBCBRH}}[1];
#printf SF "</TABLE>\n";

printf SF "<TR>\n";
#printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=LEFT COLSPAN=11><FONT SIZE=4>OBC</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCACKSUM</FONT></TD>\n", ${$h{CCACKSUM}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CCACKSUM}}[2], ${$h{CCACKSUM}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCBCKSUM</FONT></TD>\n", ${$h{CCBCKSUM}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CCBCKSUM}}[2], ${$h{CCBCKSUM}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCAONLIN</FONT></TD>\n", ${$h{CCAONLIN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CCAONLIN}}[2], ${$h{CCAONLIN}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCBONLIN</FONT></TD>\n", ${$h{CCBONLIN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CCBONLIN}}[2], ${$h{CCBONLIN}}[1];
#printf SF "</TABLE>\n";

printf SF "<TR>\n";
#printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=LEFT COLSPAN=11><FONT SIZE=4>PSU</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EHRCPPWR</FONT></TD>\n", ${$h{EHRCPPWR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EHRCPPWR}}[2], ${$h{EHRCPPWR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ERA1PPWR</FONT></TD>\n", ${$h{ERA1PPWR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{ERA1PPWR}}[2], ${$h{ERA1PPWR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ERAIRTNS</FONT></TD>\n", ${$h{ERAIRTNS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{ERAIRTNS}}[2], ${$h{ERAIRTNS}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ETX2IRCS</FONT></TD>\n", ${$h{ETX2IRCS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{ETX2IRCS}}[2], ${$h{ETX2IRCS}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EHRCRPWR</FONT></TD>\n", ${$h{EHRCRPWR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EHRCRPWR}}[2], ${$h{EHRCRPWR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ERA2IRCS</FONT></TD>\n", ${$h{ERA2IRCS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{ERA2IRCS}}[2], ${$h{ERA2IRCS}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ETX1IRCS</FONT></TD>\n", ${$h{ETX1IRCS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{ETX1IRCS}}[2], ${$h{ETX1IRCS}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ETX2PPWR</FONT></TD>\n", ${$h{ETX2PPWR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{ETX2PPWR}}[2], ${$h{ETX2PPWR}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ERA1IRCS</FONT></TD>\n", ${$h{ERA1IRCS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{ERA1IRCS}}[2], ${$h{ERA1IRCS}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ERA2PPWR</FONT></TD>\n", ${$h{ERA2PPWR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{ERA2PPWR}}[2], ${$h{ERA2PPWR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ETX1PPWR</FONT></TD>\n", ${$h{ETX1PPWR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{ETX1PPWR}}[2], ${$h{ETX1PPWR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ETXIRTNS</FONT></TD>\n", ${$h{ETXIRTNS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{ETXIRTNS}}[2], ${$h{ETXIRTNS}}[1];
#printf SF "</TABLE>\n";

printf SF "<TR>\n";
#printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=LEFT COLSPAN=11><FONT SIZE=4>EP RCTU</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CEPTLMA</FONT></TD>\n", ${$h{CEPTLMA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CEPTLMA}}[2], ${$h{CEPTLMA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CEPTLMB</FONT></TD>\n", ${$h{CEPTLMB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CEPTLMB}}[2], ${$h{CEPTLMB}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUEPA</FONT></TD>\n", ${$h{CTUEPA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTUEPA}}[2], ${$h{CTUEPA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUEPB</FONT></TD>\n", ${$h{CTUEPB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTUEPB}}[2], ${$h{CTUEPB}}[1];
#printf SF "</TABLE>\n";

printf SF "<TR>\n";
#printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=LEFT COLSPAN=11><FONT SIZE=4>PC RCTU</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCCMCTP</FONT></TD>\n", ${$h{CPCCMCTP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CPCCMCTP}}[2], ${$h{CPCCMCTP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCOCLRD</FONT></TD>\n", ${$h{CPCOCLRD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CPCOCLRD}}[2], ${$h{CPCOCLRD}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCPERD</FONT></TD>\n", ${$h{CPCPERD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CPCPERD}}[2], ${$h{CPCPERD}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUPCA</FONT></TD>\n", ${$h{CTUPCA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTUPCA}}[2], ${$h{CTUPCA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCCMCTR</FONT></TD>\n", ${$h{CPCCMCTR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CPCCMCTR}}[2], ${$h{CPCCMCTR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCOCMPR</FONT></TD>\n", ${$h{CPCOCMPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CPCOCMPR}}[2], ${$h{CPCOCMPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCTLMA</FONT></TD>\n", ${$h{CPCTLMA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CPCTLMA}}[2], ${$h{CPCTLMA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUPCB</FONT></TD>\n", ${$h{CTUPCB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTUPCB}}[2], ${$h{CTUPCB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCOCLPR</FONT></TD>\n", ${$h{CPCOCLPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CPCOCLPR}}[2], ${$h{CPCOCLPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCPEPR</FONT></TD>\n", ${$h{CPCPEPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CPCPEPR}}[2], ${$h{CPCPEPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCTLMB</FONT></TD>\n", ${$h{CPCTLMB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CPCTLMB}}[2], ${$h{CPCTLMB}}[1];
#printf SF "</TABLE>\n";

printf SF "<TR>\n";
#printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=LEFT COLSPAN=11><FONT SIZE=4>SI RCTU</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSICMCTP</FONT></TD>\n", ${$h{CSICMCTP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CSICMCTP}}[2], ${$h{CSICMCTP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSIOCLRD</FONT></TD>\n", ${$h{CSIOCLRD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSIOCLRD}}[2], ${$h{CSIOCLRD}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSIPEPR</FONT></TD>\n", ${$h{CSIPEPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSIPEPR}}[2], ${$h{CSIPEPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSITLMB</FONT></TD>\n", ${$h{CSITLMB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSITLMB}}[2], ${$h{CSITLMB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSICMCTR</FONT></TD>\n", ${$h{CSICMCTR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CSICMCTR}}[2], ${$h{CSICMCTR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSIOCMPR</FONT></TD>\n", ${$h{CSIOCMPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSIOCMPR}}[2], ${$h{CSIOCMPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSIPERD</FONT></TD>\n", ${$h{CSIPERD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSIPERD}}[2], ${$h{CSIPERD}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUSIA</FONT></TD>\n", ${$h{CTUSIA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTUSIA}}[2], ${$h{CTUSIA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSIOCLPR</FONT></TD>\n", ${$h{CSIOCLPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSIOCLPR}}[2], ${$h{CSIOCLPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSIOCMRD</FONT></TD>\n", ${$h{CSIOCMRD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSIOCMRD}}[2], ${$h{CSIOCMRD}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSITLMA</FONT></TD>\n", ${$h{CSITLMA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSITLMA}}[2], ${$h{CSITLMA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUSIB</FONT></TD>\n", ${$h{CTUSIB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTUSIB}}[2], ${$h{CTUSIB}}[1];
#printf SF "</TABLE>\n";

printf SF "<TR>\n";
#printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=LEFT COLSPAN=11><FONT SIZE=4>TS RCTU</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSCMCTP</FONT></TD>\n", ${$h{CTSCMCTP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CTSCMCTP}}[2], ${$h{CTSCMCTP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSOCLRD</FONT></TD>\n", ${$h{CTSOCLRD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTSOCLRD}}[2], ${$h{CTSOCLRD}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSPEPR</FONT></TD>\n", ${$h{CTSPEPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTSPEPR}}[2], ${$h{CTSPEPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSTLMB</FONT></TD>\n", ${$h{CTSTLMB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTSTLMB}}[2], ${$h{CTSTLMB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSCMCTR</FONT></TD>\n", ${$h{CTSCMCTR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CTSCMCTR}}[2], ${$h{CTSCMCTR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSOCMPR</FONT></TD>\n", ${$h{CTSOCMPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTSOCMPR}}[2], ${$h{CTSOCMPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSPERD</FONT></TD>\n", ${$h{CTSPERD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTSPERD}}[2], ${$h{CTSPERD}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUTSA</FONT></TD>\n", ${$h{CTUTSA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTUTSA}}[2], ${$h{CTUTSA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSOCLPR</FONT></TD>\n", ${$h{CTSOCLPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTSOCLPR}}[2], ${$h{CTSOCLPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSOCMRD</FONT></TD>\n", ${$h{CTSOCMRD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTSOCMRD}}[2], ${$h{CTSOCMRD}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSTLMA</FONT></TD>\n", ${$h{CTSTLMA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTSTLMA}}[2], ${$h{CTSTLMA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUTSB</FONT></TD>\n", ${$h{CTUTSB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CTUTSB}}[2], ${$h{CTUTSB}}[1];
#printf SF "</TABLE>\n";

printf SF "<TR>\n";
#printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=LEFT COLSPAN=11><FONT SIZE=4>RF</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPA1V</FONT></TD>\n", ${$h{CPA1V}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CPA1V}}[2], ${$h{CPA1V}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTXAPWR</FONT></TD>\n", ${$h{CTXAPWR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CTXAPWR}}[2], ${$h{CTXAPWR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CAUXCMDA</FONT></TD>\n", ${$h{CAUXCMDA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CAUXCMDA}}[2], ${$h{CAUXCMDA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CRFMODE1</FONT></TD>\n", ${$h{CRFMODE1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CRFMODE1}}[2], ${$h{CRFMODE1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPA2V</FONT></TD>\n", ${$h{CPA2V}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CPA2V}}[2], ${$h{CPA2V}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTXBPWR</FONT></TD>\n", ${$h{CTXBPWR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CTXBPWR}}[2], ${$h{CTXBPWR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CAUXCMDB</FONT></TD>\n", ${$h{CAUXCMDB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CAUXCMDB}}[2], ${$h{CAUXCMDB}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CRFMODE2</FONT></TD>\n", ${$h{CRFMODE2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CRFMODE2}}[2], ${$h{CRFMODE2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPA1PWR</FONT></TD>\n", ${$h{CPA1PWR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CPA1PWR}}[2], ${$h{CPA1PWR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTXAV</FONT></TD>\n", ${$h{CTXAV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CTXAV}}[2], ${$h{CTXAV}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCOHODRA</FONT></TD>\n", ${$h{CCOHODRA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CCOHODRA}}[2], ${$h{CCOHODRA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CXPNAMOD</FONT></TD>\n", ${$h{CXPNAMOD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CXPNAMOD}}[2], ${$h{CXPNAMOD}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPA2PWR</FONT></TD>\n", ${$h{CPA2PWR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CPA2PWR}}[2], ${$h{CPA2PWR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTXBV</FONT></TD>\n", ${$h{CTXBV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CTXBV}}[2], ${$h{CTXBV}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CCOHODRB</FONT></TD>\n", ${$h{CCOHODRB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CCOHODRB}}[2], ${$h{CCOHODRB}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CXPNARNG</FONT></TD>\n", ${$h{CXPNARNG}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CXPNARNG}}[2], ${$h{CXPNARNG}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CRXAV</FONT></TD>\n", ${$h{CRXAV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CRXAV}}[2], ${$h{CRXAV}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CRXASIG</FONT></TD>\n", ${$h{CRXASIG}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CRXASIG}}[2], ${$h{CRXASIG}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CRDRVA</FONT></TD>\n", ${$h{CRDRVA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CRDRVA}}[2], ${$h{CRDRVA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CXPNBMOD</FONT></TD>\n", ${$h{CXPNBMOD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CXPNBMOD}}[2], ${$h{CXPNBMOD}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CRXAV</FONT></TD>\n", ${$h{CRXAV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CRXAV}}[2], ${$h{CRXAV}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CRXBSIG</FONT></TD>\n", ${$h{CRXBSIG}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CRXBSIG}}[2], ${$h{CRXBSIG}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CRDRVB</FONT></TD>\n", ${$h{CRDRVB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CRDRVB}}[2], ${$h{CRDRVB}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CXPNBRNG</FONT></TD>\n", ${$h{CXPNBRNG}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CXPNBRNG}}[2], ${$h{CXPNBRNG}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CRXBV</FONT></TD>\n", ${$h{CRXBV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CRXBV}}[2], ${$h{CRXBV}}[1];
#printf SF "</TABLE>\n";

printf SF "<TR>\n";
#printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=LEFT COLSPAN=11><FONT SIZE=4>SSR</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSSR1CVA</FONT></TD>\n", ${$h{CSSR1CVA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSSR1CVA}}[2], ${$h{CSSR1CVA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSAOPIP</FONT></TD>\n", ${$h{COSAOPIP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSAOPIP}}[2], ${$h{COSAOPIP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBPBEN</FONT></TD>\n", ${$h{COSBPBEN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBPBEN}}[2], ${$h{COSBPBEN}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>OSSRACP1</FONT></TD>\n", ${$h{OSSRACP1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{OSSRACP1}}[2], ${$h{OSSRACP1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSSR1CVB</FONT></TD>\n", ${$h{CSSR1CVB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSSR1CVB}}[2], ${$h{CSSR1CVB}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSAPORO</FONT></TD>\n", ${$h{COSAPORO}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSAPORO}}[2], ${$h{COSAPORO}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBPBPR</FONT></TD>\n", ${$h{COSBPBPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBPBPR}}[2], ${$h{COSBPBPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>OSSRACP2</FONT></TD>\n", ${$h{OSSRACP2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{OSSRACP2}}[2], ${$h{OSSRACP2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSSR2CVA</FONT></TD>\n", ${$h{CSSR2CVA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSSR2CVA}}[2], ${$h{CSSR2CVA}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSAPROV</FONT></TD>\n", ${$h{COSAPROV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSAPROV}}[2], ${$h{COSAPROV}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBPORO</FONT></TD>\n", ${$h{COSBPORO}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBPORO}}[2], ${$h{COSBPORO}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>OSSRADIF</FONT></TD>\n", ${$h{OSSRADIF}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{OSSRADIF}}[2], ${$h{OSSRADIF}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSSR2CVB</FONT></TD>\n", ${$h{CSSR2CVB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CSSR2CVB}}[2], ${$h{CSSR2CVB}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSARCIN</FONT></TD>\n", ${$h{COSARCIN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSARCIN}}[2], ${$h{COSARCIN}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBPROV</FONT></TD>\n", ${$h{COSBPROV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBPROV}}[2], ${$h{COSBPROV}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>OSSRADP1</FONT></TD>\n", ${$h{OSSRADP1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{OSSRADP1}}[2], ${$h{OSSRADP1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSSR1CAV</FONT></TD>\n", ${$h{CSSR1CAV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CSSR1CAV}}[2], ${$h{CSSR1CAV}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSARCRY</FONT></TD>\n", ${$h{COSARCRY}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSARCRY}}[2], ${$h{COSARCRY}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBRCEN</FONT></TD>\n", ${$h{COSBRCEN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBRCEN}}[2], ${$h{COSBRCEN}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>OSSRADP2</FONT></TD>\n", ${$h{OSSRADP2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{OSSRADP2}}[2], ${$h{OSSRADP2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSSR2CBV</FONT></TD>\n", ${$h{CSSR2CBV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{CSSR2CBV}}[2], ${$h{CSSR2CBV}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSASTTO</FONT></TD>\n", ${$h{COSASTTO}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSASTTO}}[2], ${$h{COSASTTO}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBRCIN</FONT></TD>\n", ${$h{COSBRCIN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBRCIN}}[2], ${$h{COSBRCIN}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>OSSRAIFS</FONT></TD>\n", ${$h{OSSRAIFS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{OSSRAIFS}}[2], ${$h{OSSRAIFS}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TCM_SSR1</FONT></TD>\n", ${$h{TCM_SSR1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TCM_SSR1}}[2], ${$h{TCM_SSR1}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBCMRS</FONT></TD>\n", ${$h{COSBCMRS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBCMRS}}[2], ${$h{COSBCMRS}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBRCPR</FONT></TD>\n", ${$h{COSBRCPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBRCPR}}[2], ${$h{COSBRCPR}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>OSSRBEDC</FONT></TD>\n", ${$h{OSSRBEDC}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{OSSRBEDC}}[2], ${$h{OSSRBEDC}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TCM_SSR2</FONT></TD>\n", ${$h{TCM_SSR2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TCM_SSR2}}[2], ${$h{TCM_SSR2}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBCMTO</FONT></TD>\n", ${$h{COSBCMTO}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBCMTO}}[2], ${$h{COSBCMTO}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBRCRY</FONT></TD>\n", ${$h{COSBRCRY}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBRCRY}}[2], ${$h{COSBRCRY}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>OSSRBRPG</FONT></TD>\n", ${$h{OSSRBRPG}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{OSSRBRPG}}[2], ${$h{OSSRBRPG}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSACMRS</FONT></TD>\n", ${$h{COSACMRS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSACMRS}}[2], ${$h{COSACMRS}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBLCMV</FONT></TD>\n", ${$h{COSBLCMV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBLCMV}}[2], ${$h{COSBLCMV}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBSTTO</FONT></TD>\n", ${$h{COSBSTTO}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBSTTO}}[2], ${$h{COSBSTTO}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSACMTO</FONT></TD>\n", ${$h{COSACMTO}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSACMTO}}[2], ${$h{COSACMTO}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSBOPIP</FONT></TD>\n", ${$h{COSBOPIP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSBOPIP}}[2], ${$h{COSBOPIP}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSSR</FONT></TD>\n", ${$h{COSSR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{COSSR}}[2], ${$h{COSSR}}[1];
printf SF "</TABLE>\n";
printf SF "<BR>\n";
printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/soh.html\">[Top Level]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/Config/soh-config.html\">[S/C Config]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/PCAD/soh-pcad.html\">[PCAD]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/Mech/soh-mech.html\">[Mechanisms]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/Therm/soh-therm.html\">[Thermal]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/Prop/soh-prop.html\">[Propulsion]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/EPS/soh-eps.html\">[EPS]</A>\n";
printf SF "</TABLE>\n";
print SF "</BODY></HTML>\n";
close SF;
# end
########################################################################
sub check_state {
########################################################################

    my %hash = @_;

    $BLU = "#66FFFF";
    $GRN = "#33CC00";
    $YLW = "#FFFF00";
    $RED = "#FF0000";
    
    # Define variables to check
    my @checks;
    $parfile = "$work_dir/soh.par";
    open KEY, $parfile;
    while (<KEY>) {
      if ($_ =~ /^#/) {}
      else { push @checks, $_; }
    }
    close KEY;

    # Now do the checking, and adjust color of text accordingly
    foreach $check (@checks) {
      @chk = split(/\t+/, $check);
      #print "$chk[0]"; #debug
      $val = ${$hash{"$chk[0]"}}[1];
      #print " $val\n"; #debug

      # use chex
      #if ($chk[1] == 1) {
	#$color = $BLU; # Default to blue (not checked or undef)
        #if ($val) {
	  #$match = $chex->match(var => $chk[3], # State variable name
			        #val => $val, # Observed state value
			        #tol => $chk[4]);
#
	  #$color = $RED if ($match == 0); # Bad match => red
	  #$color = $GRN if ($match == 1); # Good match => green
        #}
      #}

      # use static limits
      if ($chk[1] == 2) {
        $color = $GRN;
        if ($val <= $chk[2] && $chk[2] ne '-') {$color = $YLW;}
        if ($val >= $chk[3] && $chk[3] ne '-') {$color = $YLW;}
        if ($val <= $chk[4] && $chk[4] ne '-') {$color = $RED;}
        if ($val >= $chk[5] && $chk[5] ne '-') {$color = $RED;}
      }

      # use a constant
      if ($chk[1] == 3) {
        my $cmp = $chk[2];
        $cmp =~ s/^\s+//;
        $cmp =~ s/\s+$//;
        $color = $RED;
        if ($val eq $cmp) { $color = $GRN;}
      }

      # use a function
      #if ($chk[1] == 4) {
        #$funcall = $chk[2];
        #$funcall =~ s/^\s+//;
        #$funcall =~ s/\s+$//;
        #$color = &$funcall($snap, $val);
      #}

      $hash{$chk[0]} = [${$hash{"$chk[0]"}}[0], $val, $color];
    }

    return %hash;
}

########################################################################
#   User defined functions for mode 4
########################################################################

sub chk_contact {
  my @time = split(/:/, $_[0]);
  my $times = (31536000*($time[0]-1998))+(86400*($time[1]-1))+(3600*$time[2])+(60*$time[3])+$time[4]; 
  my $leap = 2000;
  while ($time[0] > $leap) { # add leap years
    $times += 86400;
    $leap += 4;
  }
  my @contact;
  if (abs($times - $ltime) < 80) {
    @contact = ("AOS", "BLINK");
  } else {
    @contact = ("LOS", "B");
  }
  return @contact;
}
