#!/proj/axaf/bin/perl
##!/opt/local/bin/perl

# produce a Chandra status snapshot

# define the working directory for the snapshots

$work_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH";
$tl_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH";


## read the ACORN tracelog files - SOH

@tlfiles = <$tl_dir/soh*.tl>;
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

$h{'AOATTER1'} = [${$h{AOATTER1}}[0], ${$h{AOATTER1}}[1] * 57.29578, ${$h{AOATTER1}}[2]];
$h{'AOATTER2'} = [${$h{AOATTER2}}[0], ${$h{AOATTER2}}[1] * 57.29578, ${$h{AOATTER2}}[2]];
$h{'AOATTER3'} = [${$h{AOATTER3}}[0], ${$h{AOATTER3}}[1] * 57.29578, ${$h{AOATTER3}}[2]];
$h{'AORATE1'} = [${$h{AORATE1}}[0], ${$h{AORATE1}}[1] * 57.29578, ${$h{AORATE1}}[2]];
$h{'AORATE2'} = [${$h{AORATE2}}[0], ${$h{AORATE2}}[1] * 57.29578, ${$h{AORATE2}}[2]];
$h{'AORATE3'} = [${$h{AORATE3}}[0], ${$h{AORATE3}}[1] * 57.29578, ${$h{AORATE3}}[2]];
$h{'AORWSPD1'} = [${$h{AORWSPD1}}[0], ${$h{AORWSPD1}}[1] * 9.549297, "white"];
$h{'AORWSPD2'} = [${$h{AORWSPD2}}[0], ${$h{AORWSPD2}}[1] * 9.549297, "white"];
$h{'AORWSPD3'} = [${$h{AORWSPD3}}[0], ${$h{AORWSPD3}}[1] * 9.549297, "white"];
$h{'AORWSPD4'} = [${$h{AORWSPD4}}[0], ${$h{AORWSPD4}}[1] * 9.549297, ${$h{AORWSPD4}}[2]];
$h{'AORWSPD5'} = [${$h{AORWSPD5}}[0], ${$h{AORWSPD5}}[1] * 9.549297, ${$h{AORWSPD5}}[2]];
$h{'AORWSPD6'} = [${$h{AORWSPD6}}[0], ${$h{AORWSPD6}}[1] * 9.549297, ${$h{AORWSPD6}}[2]];
$h{'MOMENTUM'} = [${$h{AOSYMOM1}}[0], sqrt(${$h{AOSYMOM1}}[1]**2 + ${$h{AOSYMOM2}}[1]**2 + ${$h{AOSYMOM3}}[1]**2), "white"];
$h{'POWER'} = [$ltime, ${$h{ELBI_LOW}}[1]*${$h{ELBV}}[1], "white"];
if (${$h{COFLCXSM}}[1] == -1330) {
  $h{'COFLCXSM'} = [${$h{COFLCXSM}}[0], 'FACE', ${$h{COFLCXSM}}[2]];
}

%h = check_state(%h);

$utc = `date -u +"%Y:%j:%T (%b%e)"`;
($dummy,$dummy,$dummy,$dummy,$dummy,$y,$dummy,$yday,$dummy) = gmtime();
chomp $utc;

# determine LOS or AOS
@contact = chk_contact($utc);

# write out state of health snapshot
$sohf = "$work_dir/soh.html";
open(SF, ">$sohf") or die "Cannot open $sohf\n";
print SF "<HTML><HEAD><TITLE>Chandra State of Health</TITLE></HEAD>\n";
print SF "<BODY BGCOLOR=\"#000000\" TEXT=\"#EEEEEE\" LINK=\"#DDDDDD\" ALINK=\"#DDDDDD\" VLINK=\"#DDDDDD\">\n"; 
printf SF "<H1>TOP LEVEL STATE OF HEALTH</H1>\n";

printf SF "Last Updated: &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp UTC %s <BR>\n", $utc;
printf SF "<BR>\n";
#printf SF "Last Data Received: &nbsp &nbsp OBT %s <BR>\n", $obt;
printf SF "Last Data Received: &nbsp &nbsp OBT %s \n", $obt;
printf SF "&nbsp &nbsp &nbsp &nbsp Contact: &nbsp <%s>%s <\/%s><BR>\n", $contact[1], $contact[0], $contact[1];
#printf SF "OBT %17.2f <BR>\n", $ltime;
printf SF "<BR>\n";
printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>Safemode</FONT></TR>";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUB     </FONT></TD>\n", ${$h{CIUB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUB}}[2], ${$h{CIUB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUTMPRD </FONT></TD>\n", ${$h{CTUTMPRD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CTUTMPRD}}[2], ${$h{CTUTMPRD}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCARH </FONT></TD>\n", ${$h{CIUBCARH}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUBCARH}}[2], ${$h{CIUBCARH}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUCALIN </FONT></TD>\n", ${$h{CIUCALIN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUCALIN}}[2], ${$h{CIUCALIN}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUCBLIN </FONT></TD>\n", ${$h{CIUCBLIN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUCBLIN}}[2], ${$h{CIUCBLIN}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQOBBP </FONT></TD>\n", ${$h{C1SQOBBP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQOBBP}}[2], ${$h{C1SQOBBP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQOBBP </FONT></TD>\n", ${$h{C2SQOBBP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQOBBP}}[2], ${$h{C2SQOBBP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ACPEB2X  </FONT></TD>\n", ${$h{ACPEB2X}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ACPEB2X}}[2], ${$h{ACPEB2X}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AIOESWD4 </FONT></TD>\n", ${$h{AIOESWD4}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AIOESWD4}}[2], ${$h{AIOESWD4}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>CCDM</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUFMTSL </FONT></TD>\n", ${$h{CTUFMTSL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CTUFMTSL}}[2], ${$h{CTUFMTSL}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CONLHTBT </FONT></TD>\n", ${$h{CONLHTBT}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CONLHTBT}}[2], ${$h{CONLHTBT}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COFLHTBT </FONT></TD>\n", ${$h{COFLHTBT}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{COFLHTBT}}[2], ${$h{COFLHTBT}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUCALIN </FONT></TD>\n", ${$h{CIUCALIN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUCALIN}}[2], ${$h{CIUCALIN}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUCBLIN </FONT></TD>\n", ${$h{CIUCBLIN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUCBLIN}}[2], ${$h{CIUCBLIN}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACARH </FONT></TD>\n", ${$h{CIUACARH}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUACARH}}[2], ${$h{CIUACARH}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACBRH </FONT></TD>\n", ${$h{CIUACBRH}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUACBRH}}[2], ${$h{CIUACBRH}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACARH </FONT></TD>\n", ${$h{CIUACARH}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUACBRH}}[2], ${$h{CIUACBRH}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUA     </FONT></TD>\n", ${$h{CIUA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUA}}[2], ${$h{CIUA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUB     </FONT></TD>\n", ${$h{CIUB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUB}}[2], ${$h{CIUB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUTMPPR </FONT></TD>\n", ${$h{CTUTMPPR}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CTUTMPPR}}[2], ${$h{CTUTMPPR}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUTMPRD </FONT></TD>\n", ${$h{CTUTMPRD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CTUTMPRD}}[2], ${$h{CTUTMPRD}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CEPTLMA  </FONT></TD>\n", ${$h{CEPTLMA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CEPTLMA}}[2], ${$h{CEPTLMA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CEPTLMB  </FONT></TD>\n", ${$h{CEPTLMB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CEPTLMB}}[2], ${$h{CEPTLMB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCTLMA  </FONT></TD>\n", ${$h{CPCTLMA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CPCTLMA}}[2], ${$h{CPCTLMA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCTLMB  </FONT></TD>\n", ${$h{CPCTLMB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CPCTLMB}}[2], ${$h{CPCTLMB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSITLMA  </FONT></TD>\n", ${$h{CSITLMA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CSITLMA}}[2], ${$h{CSITLMA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSITLMB  </FONT></TD>\n", ${$h{CSITLMB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CSITLMB}}[2], ${$h{CSITLMB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSTLMA  </FONT></TD>\n", ${$h{CTSTLMA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CTSTLMA}}[2], ${$h{CTSTLMA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSTLMB  </FONT></TD>\n", ${$h{CTSTLMB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CTSTLMB}}[2], ${$h{CTSTLMB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COERRCN  </FONT></TD>\n", ${$h{COERRCN}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%2.0f </FONT></TD>\n", ${$h{COERRCN}}[2], ${$h{COERRCN}}[1];
printf SF "</TABLE>\n";

printf SF "<TD><TABLE BORDER=0><TR><TD><FONT SIZE=2>\&nbsp</TR></TABLE>\n";

printf SF "<TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>EPS</FONT></TR>\n";
#printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ELBI     </FONT></TD>\n", ${$h{ELBI}}[2];
#printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.2f </FONT></TD>\n", ${$h{ELBI}}[2], ${$h{ELBI}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ELBV     </FONT></TD>\n", ${$h{ELBV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.2f </FONT></TD>\n", ${$h{ELBV}}[2], ${$h{ELBV}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>POWER    </FONT></TD>\n", ${$h{POWER}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.2f </FONT></TD>\n", ${$h{POWER}}[2], ${$h{POWER}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ELDBCRNG </FONT></TD>\n", ${$h{ELDBCRNG}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ELDBCRNG}}[2], ${$h{ELDBCRNG}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ELBI_LOW </FONT></TD>\n", ${$h{ELBI_LOW}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.2f </FONT></TD>\n", ${$h{ELBI_LOW}}[2], ${$h{ELBI_LOW}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EPSTATE  </FONT></TD>\n", ${$h{EPSTATE}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EPSTATE}}[2], ${$h{EPSTATE}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSUNPRS </FONT></TD>\n", ${$h{AOSUNPRS}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOSUNPRS}}[2], ${$h{AOSUNPRS}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSAILLM </FONT></TD>\n", ${$h{AOSAILLM}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOSAILLM}}[2], ${$h{AOSAILLM}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ESAMYI   </FONT></TD>\n", ${$h{ESAMYI}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.3f </FONT></TD>\n", ${$h{ESAMYI}}[2], ${$h{ESAMYI}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ESAPYI   </FONT></TD>\n", ${$h{ESAPYI}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.3f </FONT></TD>\n", ${$h{ESAPYI}}[2], ${$h{ESAPYI}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1K1    </FONT></TD>\n", ${$h{EB1K1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB1K1}}[2], ${$h{EB1K1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1K2    </FONT></TD>\n", ${$h{EB1K2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB1K2}}[2], ${$h{EB1K2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2K1    </FONT></TD>\n", ${$h{EB2K1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB2K1}}[2], ${$h{EB2K1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2K2    </FONT></TD>\n", ${$h{EB2K2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB2K2}}[2], ${$h{EB2K2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3K1    </FONT></TD>\n", ${$h{EB3K1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB3K1}}[2], ${$h{EB3K1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3K2    </FONT></TD>\n", ${$h{EB3K2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB3K2}}[2], ${$h{EB3K2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1UV    </FONT></TD>\n", ${$h{EB1UV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB1UV}}[2], ${$h{EB1UV}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2UV    </FONT></TD>\n", ${$h{EB2UV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB2UV}}[2], ${$h{EB2UV}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3UV    </FONT></TD>\n", ${$h{EB3UV}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB3UV}}[2], ${$h{EB3UV}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>THERMAL</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4OTCPEN     </FONT></TD>\n", ${$h{"4OTCPEN"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{"4OTCPEN"}}[2], ${$h{"4OTCPEN"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4OACOBAH    </FONT></TD>\n", ${$h{"4OACOBAH"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{"4OACOBAH"}}[2], ${$h{"4OACOBAH"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4OACHRMH    </FONT></TD>\n", ${$h{"4OACHRMH"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{"4OACHRMH"}}[2], ${$h{"4OACHRMH"}}[1];
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "</TABLE>\n";

printf SF "<TD><TABLE BORDER=0><TR><TD><FONT SIZE=2>\&nbsp</TR></TABLE>\n";

printf SF "<TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>PCAD</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOATTER1_DEG </FONT></TD>\n", ${$h{AOATTER1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%8.6f </FONT></TD>\n", ${$h{AOATTER1}}[2], ${$h{AOATTER1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOATTER2_DEG </FONT></TD>\n", ${$h{AOATTER2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%8.6f </FONT></TD>\n", ${$h{AOATTER2}}[2], ${$h{AOATTER2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOATTER3_DEG </FONT></TD>\n", ${$h{AOATTER3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%8.6f </FONT></TD>\n", ${$h{AOATTER3}}[2], ${$h{AOATTER3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORATE1_DEG/SEC  </FONT></TD>\n", ${$h{AORATE1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%8.6f </FONT></TD>\n", ${$h{AORATE1}}[2], ${$h{AORATE1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORATE2_DEG/SEC  </FONT></TD>\n", ${$h{AORATE2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%8.6f </FONT></TD>\n", ${$h{AORATE2}}[2], ${$h{AORATE2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORATE3_DEG/SEC  </FONT></TD>\n", ${$h{AORATE3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%8.6f </FONT></TD>\n", ${$h{AORATE3}}[2], ${$h{AORATE3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWSPD1_RPM </FONT></TD>\n", ${$h{AORWSPD1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%9.3f </FONT></TD>\n", ${$h{AORWSPD1}}[2], ${$h{AORWSPD1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWSPD2_RPM </FONT></TD>\n", ${$h{AORWSPD2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%9.3f </FONT></TD>\n", ${$h{AORWSPD2}}[2], ${$h{AORWSPD2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWSPD3_RPM </FONT></TD>\n", ${$h{AORWSPD3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%9.3f </FONT></TD>\n", ${$h{AORWSPD3}}[2], ${$h{AORWSPD3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWSPD4_RPM </FONT></TD>\n", ${$h{AORWSPD4}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%9.3f </FONT></TD>\n", ${$h{AORWSPD4}}[2], ${$h{AORWSPD4}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWSPD5_RPM </FONT></TD>\n", ${$h{AORWSPD5}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%9.3f </FONT></TD>\n", ${$h{AORWSPD5}}[2], ${$h{AORWSPD5}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWSPD6_RPM </FONT></TD>\n", ${$h{AORWSPD6}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%9.3f </FONT></TD>\n", ${$h{AORWSPD6}}[2], ${$h{AORWSPD6}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOPCADMD </FONT></TD>\n", ${$h{AOPCADMD}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOPCADMD}}[2], ${$h{AOPCADMD}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AIRU1R1Y </FONT></TD>\n", ${$h{AIRU1R1Y}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AIRU1R1Y}}[2], ${$h{AIRU1R1Y}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AIRU1R1X </FONT></TD>\n", ${$h{AIRU1R1X}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AIRU1R1X}}[2], ${$h{AIRU1R1X}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>MOMENTUM </FONT></TD>\n", ${$h{MOMENTUM}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.3f </FONT></TD>\n", ${$h{MOMENTUM}}[2], ${$h{MOMENTUM}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOMANMON </FONT></TD>\n", ${$h{AOMANMON}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOMANMON}}[2], ${$h{AOMANMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSUNMON </FONT></TD>\n", ${$h{AOSUNMON}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOSUNMON}}[2], ${$h{AOSUNMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOIRUMON </FONT></TD>\n", ${$h{AOIRUMON}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOIRUMON}}[2], ${$h{AOIRUMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOATTMON </FONT></TD>\n", ${$h{AOATTMON}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOATTMON}}[2], ${$h{AOATTMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWMON1 </FONT></TD>\n", ${$h{AORWMON1}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AORWMON1}}[2], ${$h{AORWMON1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWMON2 </FONT></TD>\n", ${$h{AORWMON2}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AORWMON2}}[2], ${$h{AORWMON2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWMON3 </FONT></TD>\n", ${$h{AORWMON3}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AORWMON3}}[2], ${$h{AORWMON3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWMON4 </FONT></TD>\n", ${$h{AORWMON4}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AORWMON4}}[2], ${$h{AORWMON4}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWMON5 </FONT></TD>\n", ${$h{AORWMON5}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AORWMON5}}[2], ${$h{AORWMON5}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWMON6 </FONT></TD>\n", ${$h{AORWMON6}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AORWMON6}}[2], ${$h{AORWMON6}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOMOMMON </FONT></TD>\n", ${$h{AOMOMMON}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOMOMMON}}[2], ${$h{AOMOMMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOULMON  </FONT></TD>\n", ${$h{AOULMON}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOULMON}}[2], ${$h{AOULMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSAPMON </FONT></TD>\n", ${$h{AOSAPMON}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOSAPMON}}[2], ${$h{AOSAPMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSATMON </FONT></TD>\n", ${$h{AOSATMON}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOSATMON}}[2], ${$h{AOSATMON}}[1];
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "</TABLE>\n";

printf SF "<TD><TABLE BORDER=0><TR><TD><FONT SIZE=2>\&nbsp</FONT></TR></TABLE>\n";

printf SF "<TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>Safing</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ACPEAHB  </FONT></TD>\n", ${$h{ACPEAHB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ACPEAHB}}[2], ${$h{ACPEAHB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOCPESTL </FONT></TD>\n", ${$h{AOCPESTL}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOCPESTL}}[2], ${$h{AOCPESTL}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOCPESTC </FONT></TD>\n", ${$h{AOCPESTC}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%6.1f </FONT></TD>\n", ${$h{AOCPESTC}}[2], ${$h{AOCPESTC}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOCPESTG </FONT></TD>\n", ${$h{AOCPESTG}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%2.0f </FONT></TD>\n", ${$h{AOCPESTG}}[2], ${$h{AOCPESTG}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ACPAALCK </FONT></TD>\n", ${$h{ACPAALCK}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ACPAALCK}}[2], ${$h{ACPAALCK}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ACPACKSM </FONT></TD>\n", ${$h{ACPACKSM}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ACPACKSM}}[2], ${$h{ACPACKSM}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COFLCXSM </FONT></TD>\n", ${$h{COFLCXSM}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{COFLCXSM}}[2], ${$h{COFLCXSM}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AFSSAFLG </FONT></TD>\n", ${$h{AFSSAFLG}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AFSSAFLG}}[2], ${$h{AFSSAFLG}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AFSSBFLG </FONT></TD>\n", ${$h{AFSSBFLG}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AFSSBFLG}}[2], ${$h{AFSSBFLG}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ARCSFLGA </FONT></TD>\n", ${$h{ARCSFLGA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ARCSFLGA}}[2], ${$h{ARCSFLGA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ARCSFLGB </FONT></TD>\n", ${$h{ARCSFLGB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ARCSFLGB}}[2], ${$h{ARCSFLGB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAPIU </FONT></TD>\n", ${$h{C1SQAPIU}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQAPIU}}[2], ${$h{C1SQAPIU}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAPIU </FONT></TD>\n", ${$h{C2SQAPIU}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQAPIU}}[2], ${$h{C2SQAPIU}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAPO  </FONT></TD>\n", ${$h{C1SQAPO}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQAPO}}[2], ${$h{C1SQAPO}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAPO  </FONT></TD>\n", ${$h{C2SQAPO}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQAPO}}[2], ${$h{C2SQAPO}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAPPP </FONT></TD>\n", ${$h{C1SQAPPP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQAPPP}}[2], ${$h{C1SQAPPP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAPPP </FONT></TD>\n", ${$h{C2SQAPPP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQAPPP}}[2], ${$h{C2SQAPPP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQOBBP </FONT></TD>\n", ${$h{C1SQOBBP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQOBBP}}[2], ${$h{C1SQOBBP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQOBBP </FONT></TD>\n", ${$h{C2SQOBBP}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQOBBP}}[2], ${$h{C2SQOBBP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAX   </FONT></TD>\n", ${$h{C1SQAX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQAX}}[2], ${$h{C1SQAX}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAX   </FONT></TD>\n", ${$h{C2SQAX}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQAX}}[2], ${$h{C2SQAX}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAPCT </FONT></TD>\n", ${$h{C1SQAPCT}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQAPCT}}[2], ${$h{C1SQAPCT}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAPCT </FONT></TD>\n", ${$h{C2SQAPCT}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQAPCT}}[2], ${$h{C2SQAPCT}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG1SELA  </FONT></TD>\n", ${$h{AG1SELA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG1SELA}}[2], ${$h{AG1SELA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG1SELB  </FONT></TD>\n", ${$h{AG1SELB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG1SELB}}[2], ${$h{AG1SELB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG2SELA  </FONT></TD>\n", ${$h{AG2SELA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG2SELA}}[2], ${$h{AG2SELA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG2SELB  </FONT></TD>\n", ${$h{AG2SELB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG2SELB}}[2], ${$h{AG2SELB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG3SELA  </FONT></TD>\n", ${$h{AG3SELA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG3SELA}}[2], ${$h{AG3SELA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG3SELB  </FONT></TD>\n", ${$h{AG3SELB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG3SELB}}[2], ${$h{AG3SELB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG4SELA  </FONT></TD>\n", ${$h{AG4SELA}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG4SELA}}[2], ${$h{AG4SELA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG4SELB  </FONT></TD>\n", ${$h{AG4SELB}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG4SELB}}[2], ${$h{AG4SELB}}[1];
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "</TABLE>\n";
printf SF "</TABLE>\n";
printf SF "<BR>\n";
printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/Config/soh-config.html\">[S/C Config]</A>\n";
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

      # unchecked
      if ($chk[1] == 0) {
        $color = $BLU;
      }

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
        if ($chk[2] ne '-' && $val <= $chk[2]) {$color = $YLW;}
        if ($chk[3] ne '-' && $val >= $chk[3]) {$color = $YLW;}
        if ($chk[4] ne '-' && $val <= $chk[4]) {$color = $RED;}
        if ($chk[5] ne '-' && $val >= $chk[5]) {$color = $RED;}
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
      if ($chk[1] == 4) {
        $funcall = $chk[2];
        $funcall =~ s/^\s+//;
        $funcall =~ s/\s+$//;
        $color = &$funcall("$val");
      }

      $hash{$chk[0]} = [${$hash{"$chk[0]"}}[0], $val, $color];
    }

    return %hash;
}

########################################################################
#   User defined functions for mode 4
########################################################################

sub ctufmtsl {
  my $val = $_[0];
  my $color = $RED;
  if ($val eq 'FMT1' || $val eq 'FMT2') { $color = $GRN;}
  if ($val eq 'FMT3' || $val eq 'FMT4' || $val eq 'FMT6') { $color = $GRN;}
  return $color;
}

sub aopcadmd {
  my $val = $_[0];
  my $color = $RED;
  if ($val eq 'NPNT' || $val eq 'NMAN') { $color = $GRN;}
  return $color;
}

sub atterr {
  my $val = $_[0];
  my $color = $RED;
  my $mode = ${$h{AOPCADMD}}[1];
  if ($mode eq 'NMAN') {
    # radians
    #if ($val >= -0.00145 && $val <= 0.00145) { $color = $GRN;}
    # degrees
    if ($val >= -0.0833 && $val <= 0.0833) { $color = $GRN;}
  }
  if ($mode eq 'NPNT') {
    # radians
    #if ($val >= -0.00004848 && $val <= 0.00004848) { $color = $GRN;}
    # degrees
    if ($val >= -0.0028 && $val <= 0.0028) { $color = $GRN;}
  }
  if ($mode ne 'NMAN' && $mode ne 'NPNT') { $color = $BLU;}

  return $color;
}

sub aorate {
  my $val = $_[0];
  my $color = $RED;
  my $mode = ${$h{AOPCADMD}}[1];
  if ($mode eq 'NMAN') {
    # radians/sec
    #if ($val >= -0.001745 && $val <= 0.001745) { $color = $GRN;}
    # degrees/sec
    if ($val >= -0.1 && $val <= 0.1) { $color = $GRN;}
  }
  if ($mode eq 'NPNT') {
    # radians/sec
    #if ($val >= -0.00004848 && $val <= 0.00004848) { $color = $GRN;}
    # degrees/sec
    if ($val >= -0.0028 && $val <= 0.0028) { $color = $GRN;}
  }
  if ($mode ne 'NMAN' && $mode ne 'NPNT') { $color = $BLU;}

  return $color;
}

sub aocpestg {
  my $val = $_[0];
  my $color = $RED;
  if ($val == 0 || $val == 5 || $val == 13) { $color = $GRN;}
  return $color;
}

sub acpacksm {
  my $val = $_[0];
  my $color = $RED;
  if ($val ne 'FAIL') { $color = $GRN;}
  return $color;
}

sub aosunprs {
  my $val = $_[0];
  my $color = $RED;
  if ($val eq 'SUN') { $color = $GRN;}
  if ($val eq 'NSUN') { $color = $YLW;}
  return $color;
}
# ******************************************************************
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
