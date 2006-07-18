#!/proj/axaf/bin/perl
##!/opt/local/bin/perl

# produce a Chandra status snapshot

# define the working directory for the snapshots

$work_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH/EPS";
$tl_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH";
$sohf = "$work_dir/soh-eps.html";


## read the ACORN tracelog files - SOH

@tlfiles = <$tl_dir/eps*.tl>;
push @tlfiles, <$tl_dir/sohEPS*.tl>;
foreach $f (@tlfiles) {
    open (TLF, $f) or next;
    @msids = split ' ', <TLF>;
    shift @msids;                 # exclude time
    <TLF>;                        # skip second line
    my $v;                 # initialize values
    my $color = "#FF9999"; # initialize color, orangish.  If not changed
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

$h{'POWER'} = [$ltime, ${$h{ELBI_LOW}}[1]*${$h{ELBV}}[1], "#66FFFF"];

#%h = check_state(%h);

$utc = `date -u +"%Y:%j:%T (%b%e)"`;
($dummy,$dummy,$dummy,$dummy,$dummy,$y,$dummy,$yday,$dummy) = gmtime();
chomp $utc;

# determine LOS or AOS
@contact = chk_contact($utc);

# write out state of health snapshot
open(SF, ">$sohf") or die "Cannot open $sohf\n";
print SF "<HTML><HEAD><TITLE>Chandra State of Health - EPS</TITLE></HEAD>\n";
print SF "<BODY BGCOLOR=\"#000000\" TEXT=\"#EEEEEE\" LINK=\"#DDDDDD\" ALINK=\"#DDDDDD\" VLINK=\"#DDDDDD\">\n";
printf SF "<H1>CHANDRA STATE OF HEALTH - EPS</H1>\n";

printf SF "Last Updated: &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp UTC %s <BR>\n", $utc;
printf SF "<BR>\n";
printf SF "Last Data Received: &nbsp &nbsp OBT %s \n", $obt;
printf SF "&nbsp &nbsp &nbsp &nbsp Contact: &nbsp <%s>%s <\/%s><BR>\n", $contact[1], $contact[0], $contact[1];
#printf SF "OBT %17.2f <BR>\n", $ltime;
printf SF "<BR>\n";
printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>Load Bus</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>Solar Array</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>EPS SW</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ELBV</FONT></TD>\n", ${$h{ELBV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{ELBV}}[2], ${$h{ELBV}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ESAMYI</FONT></TD>\n", ${$h{ESAMYI}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{ESAMYI}}[2], ${$h{ESAMYI}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EGCTTEL1</FONT></TD>\n", ${$h{EGCTTEL1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EGCTTEL1}}[2], ${$h{EGCTTEL1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ELBI_LOW</FONT></TD>\n", ${$h{ELBI_LOW}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{ELBI_LOW}}[2], ${$h{ELBI_LOW}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TSAMYT</FONT></TD>\n", ${$h{TSAMYT}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TSAMYT}}[2], ${$h{TSAMYT}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EGCTTEL3</FONT></TD>\n", ${$h{EGCTTEL3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EGCTTEL3}}[2], ${$h{EGCTTEL3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ELDBCRNG</FONT></TD>\n", ${$h{ELDBCRNG}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{ELDBCRNG}}[2], ${$h{ELDBCRNG}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ESAPYI</FONT></TD>\n", ${$h{ESAPYI}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{ESAPYI}}[2], ${$h{ESAPYI}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EPSTATE</FONT></TD>\n", ${$h{EPSTATE}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EPSTATE}}[2], ${$h{EPSTATE}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>POWER</FONT></TD>\n", ${$h{POWER}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{POWER}}[2], ${$h{POWER}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TSAPYT</FONT></TD>\n", ${$h{TSAPYT}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TSAPYT}}[2], ${$h{TSAPYT}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EECLIPSE</FONT></TD>\n", ${$h{EECLIPSE}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EECLIPSE}}[2], ${$h{EECLIPSE}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EESAILLM</FONT></TD>\n", ${$h{EESAILLM}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EESAILLM}}[2], ${$h{EESAILLM}}[1];

printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";

printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>Battery 1</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>Battery 2</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>Battery 3</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1V</FONT></TD>\n", ${$h{EB1V}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{EB1V}}[2], ${$h{EB1V}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2V</FONT></TD>\n", ${$h{EB2V}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{EB2V}}[2], ${$h{EB2V}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3V</FONT></TD>\n", ${$h{EB3V}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{EB3V}}[2], ${$h{EB3V}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1CI</FONT></TD>\n", ${$h{EB1CI}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{EB1CI}}[2], ${$h{EB1CI}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2CI</FONT></TD>\n", ${$h{EB2CI}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{EB2CI}}[2], ${$h{EB2CI}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3CI</FONT></TD>\n", ${$h{EB3CI}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{EB3CI}}[2], ${$h{EB3CI}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1DI</FONT></TD>\n", ${$h{EB1DI}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{EB1DI}}[2], ${$h{EB1DI}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2DI</FONT></TD>\n", ${$h{EB2DI}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{EB2DI}}[2], ${$h{EB2DI}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3DI</FONT></TD>\n", ${$h{EB3DI}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{EB3DI}}[2], ${$h{EB3DI}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TB1T1</FONT></TD>\n", ${$h{TB1T1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TB1T1}}[2], ${$h{TB1T1}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TB2T1</FONT></TD>\n", ${$h{TB2T1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TB2T1}}[2], ${$h{TB2T1}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TB3T1</FONT></TD>\n", ${$h{TB3T1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TB3T1}}[2], ${$h{TB3T1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TB1T2</FONT></TD>\n", ${$h{TB1T2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TB1T2}}[2], ${$h{TB1T2}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TB2T2</FONT></TD>\n", ${$h{TB2T2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TB2T2}}[2], ${$h{TB2T2}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TB3T2</FONT></TD>\n", ${$h{TB3T2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TB3T2}}[2], ${$h{TB3T2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TB1T3</FONT></TD>\n", ${$h{TB1T3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TB1T3}}[2], ${$h{TB1T3}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TB2T3</FONT></TD>\n", ${$h{TB2T3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TB2T3}}[2], ${$h{TB2T3}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TB3T3</FONT></TD>\n", ${$h{TB3T3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{TB3T3}}[2], ${$h{TB3T3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1K1</FONT></TD>\n", ${$h{EB1K1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB1K1}}[2], ${$h{EB1K1}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2K1</FONT></TD>\n", ${$h{EB2K1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB2K1}}[2], ${$h{EB2K1}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3K1</FONT></TD>\n", ${$h{EB3K1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB3K1}}[2], ${$h{EB3K1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1K2</FONT></TD>\n", ${$h{EB1K2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB1K2}}[2], ${$h{EB1K2}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2K2</FONT></TD>\n", ${$h{EB2K2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB2K2}}[2], ${$h{EB2K2}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3K2</FONT></TD>\n", ${$h{EB3K2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB3K2}}[2], ${$h{EB3K2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1K3</FONT></TD>\n", ${$h{EB1K3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB1K3}}[2], ${$h{EB1K3}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2K3</FONT></TD>\n", ${$h{EB2K3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB2K3}}[2], ${$h{EB2K3}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3K3</FONT></TD>\n", ${$h{EB3K3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB3K3}}[2], ${$h{EB3K3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1K4</FONT></TD>\n", ${$h{EB1K4}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB1K4}}[2], ${$h{EB1K4}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2K4</FONT></TD>\n", ${$h{EB2K4}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB2K4}}[2], ${$h{EB2K4}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3K4</FONT></TD>\n", ${$h{EB3K4}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB3K4}}[2], ${$h{EB3K4}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1K5</FONT></TD>\n", ${$h{EB1K5}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB1K5}}[2], ${$h{EB1K5}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2K5</FONT></TD>\n", ${$h{EB2K5}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB2K5}}[2], ${$h{EB2K5}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3K5</FONT></TD>\n", ${$h{EB3K5}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB3K5}}[2], ${$h{EB3K5}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1UV</FONT></TD>\n", ${$h{EB1UV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB1UV}}[2], ${$h{EB1UV}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2UV</FONT></TD>\n", ${$h{EB2UV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB2UV}}[2], ${$h{EB2UV}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3UV</FONT></TD>\n", ${$h{EB3UV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{EB3UV}}[2], ${$h{EB3UV}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EOCHRGB1</FONT></TD>\n", ${$h{EOCHRGB1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{EOCHRGB1}}[2], ${$h{EOCHRGB1}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EOCHRGB2</FONT></TD>\n", ${$h{EOCHRGB2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{EOCHRGB2}}[2], ${$h{EOCHRGB2}}[1];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EOCHRGB3</FONT></TD>\n", ${$h{EOCHRGB3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{EOCHRGB3}}[2], ${$h{EOCHRGB3}}[1];

printf SF "</TABLE>\n";

printf SF "<BR>\n";
printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/soh.html\">[Top Level]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/Config/soh-config.html\">[S/C Config]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/PCAD/soh-pcad.html\">[PCAD]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/CCDM/soh-ccdm.html\">[CCDM]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/Mech/soh-mech.html\">[Mechanisms]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/Therm/soh-therm.html\">[Thermal]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/Prop/soh-prop.html\">[Propulsion]</A>\n";
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
