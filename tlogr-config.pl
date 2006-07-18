#!/proj/axaf/bin/perl
##!/opt/local/bin/perl

# produce a Chandra status snapshot

# define the working directory for the snapshots

$work_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH/Config";
$tl_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH";
$sohf = "$work_dir/soh-config.html";


## read the ACORN tracelog files - SOH

@tlfiles = <$tl_dir/config*.tl>;
push @tlfiles, <$tl_dir/sohTEL*.tl>;
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
print SF "<HTML><HEAD><TITLE>Chandra State of Health S/C Configuration</TITLE></HEAD>\n";
print SF "<BODY BGCOLOR=\"#000000\" TEXT=\"#EEEEEE\" LINK=\"#DDDDDD\" ALINK=\"#DDDDDD\" VLINK=\"#DDDDDD\">\n";
printf SF "<H1>CHANDRA STATE OF HEALTH - S/C CONFIGURATION</H1>\n";

printf SF "Last Updated: &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp UTC %s <BR>\n", $utc;
printf SF "<BR>\n";
printf SF "Last Data Received: &nbsp &nbsp OBT %s \n", $obt;
printf SF "&nbsp &nbsp &nbsp &nbsp Contact: &nbsp <%s>%s <\/%s><BR>\n", $contact[1], $contact[0], $contact[1];
#printf SF "OBT %17.2f <BR>\n", $ltime;
printf SF "<BR>\n";
printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>Flight Software</FONT></TR>";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSCS128S</FONT></TD>\n", ${$h{COSCS128S}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSCS128S}}[2], ${$h{COSCS128S}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSCS129S</FONT></TD>\n", ${$h{COSCS129S}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSCS129S}}[2], ${$h{COSCS129S}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSCS130S</FONT></TD>\n", ${$h{COSCS130S}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSCS130S}}[2], ${$h{COSCS130S}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COSCS107S</FONT></TD>\n", ${$h{COSCS107S}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{COSCS107S}}[2], ${$h{COSCS107S}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CORADMEN</FONT></TD>\n", ${$h{CORADMEN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{CORADMEN}}[2], ${$h{CORADMEN}}[1];
printf SF "<TR><TD><FONT SIZE=2>&nbsp</TR>\n";
printf SF "</TABLE>\n";

printf SF "<TD><TABLE BORDER=0><TR><TD><FONT SIZE=2>\&nbsp</TR></TABLE>\n";

printf SF "<TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>Attitude</FONT></TR>\n";

printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOATTQT1</FONT></TD>\n", ${$h{AOATTQT1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%10.7f</FONT></TD>\n", ${$h{AOATTQT1}}[2], ${$h{AOATTQT1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOATTQT2</FONT></TD>\n", ${$h{AOATTQT2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%10.7f</FONT></TD>\n", ${$h{AOATTQT2}}[2], ${$h{AOATTQT2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOATTQT3</FONT></TD>\n", ${$h{AOATTQT3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%10.7f</FONT></TD>\n", ${$h{AOATTQT3}}[2], ${$h{AOATTQT3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOATTQT4</FONT></TD>\n", ${$h{AOATTQT4}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%10.7f</FONT></TD>\n", ${$h{AOATTQT4}}[2], ${$h{AOATTQT4}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOALPANG</FONT></TD>\n", ${$h{AOALPANG}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOALPANG}}[2], ${$h{AOALPANG}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOBETANG</FONT></TD>\n", ${$h{AOBETANG}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOBETANG}}[2], ${$h{AOBETANG}}[1];
printf SF "</TABLE>\n";

printf SF "<TD><TABLE BORDER=0><TR><TD><FONT SIZE=2>\&nbsp</TR></TABLE>\n";

printf SF "<TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>SIM \& OTGs</FONT></TR>\n";

printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3TSCPOS</FONT></TD>\n", ${$h{"3TSCPOS"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%d</FONT></TD>\n", ${$h{"3TSCPOS"}}[2], ${$h{"3TSCPOS"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3FAPOS</FONT></TD>\n", ${$h{"3FAPOS"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%d</FONT></TD>\n", ${$h{"3FAPOS"}}[2], ${$h{"3FAPOS"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4HPOSARO</FONT></TD>\n", ${$h{"4HPOSARO"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{"4HPOSARO"}}[2], ${$h{"4HPOSARO"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4LPOSBRO</FONT></TD>\n", ${$h{"4LPOSBRO"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{"4LPOSBRO"}}[2], ${$h{"4LPOSBRO"}}[1];
printf SF "<TR><TD><FONT SIZE=2>&nbsp</TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</TR>\n";
printf SF "</TABLE>\n";

printf SF "<TD><TABLE BORDER=0><TR><TD><FONT SIZE=2>\&nbsp</TR></TABLE>\n";

printf SF "<TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>Misc</FONT></TR>\n";

printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOFTHRST</FONT></TD>\n", ${$h{AOFTHRST}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOFTHRST}}[2], ${$h{AOFTHRST}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOFATTMD</FONT></TD>\n", ${$h{AOFATTMD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOFATTMD}}[2], ${$h{AOFATTMD}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOPSSUPM</FONT></TD>\n", ${$h{AOPSSUPM}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOPSSUPM}}[2], ${$h{AOPSSUPM}}[1];
printf SF "<TR><TD><FONT SIZE=2>&nbsp</TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</TR>\n";
printf SF "</TABLE>\n";
printf SF "</TABLE>\n";

printf SF "<BR>\n";

printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=11><FONT SIZE=4>Stars \& Fids</FONT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=1><FONT SIZE=3>Image</FONT>\n";
printf SF "<TD><FONT SIZE=2>&nbsp\n";
printf SF "<TD ALIGN=CENTER COLSPAN=1><FONT SIZE=3>Status Flags</FONT>\n";
printf SF "<TD><FONT SIZE=2>&nbsp\n";
printf SF "<TD ALIGN=CENTER COLSPAN=1><FONT SIZE=3>Image Function</FONT>\n";
printf SF "<TD><FONT SIZE=2>&nbsp\n";
printf SF "<TD ALIGN=CENTER COLSPAN=1><FONT SIZE=3>Centroid Y Angle</FONT>\n";
printf SF "<TD><FONT SIZE=2>&nbsp\n";
printf SF "<TD ALIGN=CENTER COLSPAN=1><FONT SIZE=3>Centroid Z Angle</FONT>\n";
printf SF "<TD><FONT SIZE=2>&nbsp\n";
printf SF "<TD ALIGN=CENTER COLSPAN=1><FONT SIZE=3>Magnitude</FONT></TR>\n";

#printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMNUM0</FONT></TD>\n", ${$h{AOIMNUM0}}[2];
printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMNUM0}}[2], ${$h{AOIMNUM0}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMAGE0</FONT></TD>\n", ${$h{AOIMAGE0}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMAGE0}}[2], ${$h{AOIMAGE0}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACFCT0</FONT></TD>\n", ${$h{AOACFCT0}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOACFCT0}}[2], ${$h{AOACFCT0}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACYAN0</FONT></TD>\n", ${$h{AOACYAN0}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACYAN0}}[2], ${$h{AOACYAN0}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACZAN0</FONT></TD>\n", ${$h{AOACZAN0}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACZAN0}}[2], ${$h{AOACZAN0}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACMAG0</FONT></TD>\n", ${$h{AOACMAG0}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACMAG0}}[2], ${$h{AOACMAG0}}[1];
#printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMNUM1</FONT></TD>\n", ${$h{AOIMNUM1}}[2];
printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMNUM1}}[2], ${$h{AOIMNUM1}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMAGE1</FONT></TD>\n", ${$h{AOIMAGE1}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMAGE1}}[2], ${$h{AOIMAGE1}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACFCT1</FONT></TD>\n", ${$h{AOACFCT1}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOACFCT1}}[2], ${$h{AOACFCT1}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACYAN1</FONT></TD>\n", ${$h{AOACYAN1}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACYAN1}}[2], ${$h{AOACYAN1}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACZAN1</FONT></TD>\n", ${$h{AOACZAN1}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACZAN1}}[2], ${$h{AOACZAN1}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACMAG1</FONT></TD>\n", ${$h{AOACMAG1}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACMAG1}}[2], ${$h{AOACMAG1}}[1];
#printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMNUM2</FONT></TD>\n", ${$h{AOIMNUM2}}[2];
printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMNUM2}}[2], ${$h{AOIMNUM2}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMAGE2</FONT></TD>\n", ${$h{AOIMAGE2}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMAGE2}}[2], ${$h{AOIMAGE2}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACFCT2</FONT></TD>\n", ${$h{AOACFCT2}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOACFCT2}}[2], ${$h{AOACFCT2}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACYAN2</FONT></TD>\n", ${$h{AOACYAN2}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACYAN2}}[2], ${$h{AOACYAN2}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACZAN2</FONT></TD>\n", ${$h{AOACZAN2}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACZAN2}}[2], ${$h{AOACZAN2}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACMAG2</FONT></TD>\n", ${$h{AOACMAG2}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACMAG2}}[2], ${$h{AOACMAG2}}[1];
#printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMNUM3</FONT></TD>\n", ${$h{AOIMNUM3}}[2];
printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMNUM3}}[2], ${$h{AOIMNUM3}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMAGE3</FONT></TD>\n", ${$h{AOIMAGE3}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMAGE3}}[2], ${$h{AOIMAGE3}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACFCT3</FONT></TD>\n", ${$h{AOACFCT3}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOACFCT3}}[2], ${$h{AOACFCT3}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACYAN3</FONT></TD>\n", ${$h{AOACYAN3}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACYAN3}}[2], ${$h{AOACYAN3}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACZAN3</FONT></TD>\n", ${$h{AOACZAN3}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACZAN3}}[2], ${$h{AOACZAN3}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACMAG3</FONT></TD>\n", ${$h{AOACMAG3}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACMAG3}}[2], ${$h{AOACMAG3}}[1];
#printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMNUM4</FONT></TD>\n", ${$h{AOIMNUM4}}[2];
printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMNUM4}}[2], ${$h{AOIMNUM4}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMAGE4</FONT></TD>\n", ${$h{AOIMAGE4}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMAGE4}}[2], ${$h{AOIMAGE4}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACFCT4</FONT></TD>\n", ${$h{AOACFCT4}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOACFCT4}}[2], ${$h{AOACFCT4}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACYAN4</FONT></TD>\n", ${$h{AOACYAN4}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACYAN4}}[2], ${$h{AOACYAN4}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACZAN4</FONT></TD>\n", ${$h{AOACZAN4}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACZAN4}}[2], ${$h{AOACZAN4}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACMAG4</FONT></TD>\n", ${$h{AOACMAG4}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACMAG4}}[2], ${$h{AOACMAG4}}[1];
#printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMNUM5</FONT></TD>\n", ${$h{AOIMNUM5}}[2];
printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMNUM5}}[2], ${$h{AOIMNUM5}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMAGE5</FONT></TD>\n", ${$h{AOIMAGE5}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMAGE5}}[2], ${$h{AOIMAGE5}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACFCT5</FONT></TD>\n", ${$h{AOACFCT5}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOACFCT5}}[2], ${$h{AOACFCT5}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACYAN5</FONT></TD>\n", ${$h{AOACYAN5}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACYAN5}}[2], ${$h{AOACYAN5}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACZAN5</FONT></TD>\n", ${$h{AOACZAN5}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACZAN5}}[2], ${$h{AOACZAN5}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACMAG5</FONT></TD>\n", ${$h{AOACMAG5}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACMAG5}}[2], ${$h{AOACMAG5}}[1];
#printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMNUM6</FONT></TD>\n", ${$h{AOIMNUM6}}[2];
printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMNUM6}}[2], ${$h{AOIMNUM6}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMAGE6</FONT></TD>\n", ${$h{AOIMAGE6}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMAGE6}}[2], ${$h{AOIMAGE6}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACFCT6</FONT></TD>\n", ${$h{AOACFCT6}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOACFCT6}}[2], ${$h{AOACFCT6}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACYAN6</FONT></TD>\n", ${$h{AOACYAN6}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACYAN6}}[2], ${$h{AOACYAN6}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACZAN6</FONT></TD>\n", ${$h{AOACZAN6}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACZAN6}}[2], ${$h{AOACZAN6}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACMAG6</FONT></TD>\n", ${$h{AOACMAG6}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACMAG6}}[2], ${$h{AOACMAG6}}[1];
#printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMNUM7</FONT></TD>\n", ${$h{AOIMNUM7}}[2];
printf SF "<TR><TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMNUM7}}[2], ${$h{AOIMNUM7}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOIMAGE7</FONT></TD>\n", ${$h{AOIMAGE7}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOIMAGE7}}[2], ${$h{AOIMAGE7}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACFCT7</FONT></TD>\n", ${$h{AOACFCT7}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{AOACFCT7}}[2], ${$h{AOACFCT7}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACYAN7</FONT></TD>\n", ${$h{AOACYAN7}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACYAN7}}[2], ${$h{AOACYAN7}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACZAN7</FONT></TD>\n", ${$h{AOACZAN7}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACZAN7}}[2], ${$h{AOACZAN7}}[1];
printf SF "<TD><FONT SIZE=2>&nbsp\n";
#printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>AOACMAG7</FONT></TD>\n", ${$h{AOACMAG7}}[2];
printf SF "<TD ALIGN=CENTER><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{AOACMAG7}}[2], ${$h{AOACMAG7}}[1];
printf SF "</TABLE>\n";
printf SF "<BR>\n";
printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/soh.html\">[Top Level]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/PCAD/soh-pcad.html\">[PCAD]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/CCDM/soh-ccdm.html\">[CCDM]</A>\n";
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
