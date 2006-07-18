#!/proj/axaf/bin/perl
##!/opt/local/bin/perl

# produce a Chandra status snapshot

# define the working directory for the snapshots

$work_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH/Mech";
$tl_dir = "/proj/ascwww/AXAF/extra/science/cgi-gen/mta/SOH";
$sohf = "$work_dir/soh-mech.html";


## read the ACORN tracelog files - SOH

@tlfiles = <$tl_dir/mech*.tl>;
push @tlfiles, <$tl_dir/configMISC*.tl>;
foreach $f (@tlfiles) {
    open (TLF, $f) or next;
    @msids = split ' ', <TLF>;
    shift @msids;                 # exclude time
    <TLF>;                        # skip second line
    my $v; my @vals;       # initialize values
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
if ($time0 == 0) { $time0 = $ltime; }
die "Exit because of stale data! Data timespan: $time0 to $ltime\n" if ($ltime - $time0) > 100000;

# do some computations

$t1998 = 883612800.0;
($sec,$min,$hr,$dummy,$dummy,$y,$dummy,$yday,$dummy) = gmtime($ltime+$t1998);
$obt = sprintf "%4d:%3.3d:%2.2d:%2.2d:%2.2d",$y+1900,$yday+1,$hr,$min,$sec;

%h = check_state(%h);

$utc = `date -u +"%Y:%j:%T (%b%e)"`;
($dummy,$dummy,$dummy,$dummy,$dummy,$y,$dummy,$yday,$dummy) = gmtime();
chomp $utc;

# determine LOS or AOS
@contact = chk_contact($utc);

# write out state of health snapshot
open(SF, ">$sohf") or die "Cannot open $sohf\n";
print SF "<HTML><HEAD><TITLE>Chandra State of Health - Mechanisms</TITLE></HEAD>\n";
print SF "<BODY BGCOLOR=\"#000000\" TEXT=\"#EEEEEE\" LINK=\"#DDDDDD\" ALINK=\"#DDDDDD\" VLINK=\"#DDDDDD\">\n";
printf SF "<H1>CHANDRA STATE OF HEALTH - MECHANISMS</H1>\n";

printf SF "Last Updated: &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp UTC %s <BR>\n", $utc;
printf SF "<BR>\n";
printf SF "Last Data Received: &nbsp &nbsp OBT %s \n", $obt;
printf SF "&nbsp &nbsp &nbsp &nbsp Contact: &nbsp <%s>%s <\/%s><BR>\n", $contact[1], $contact[0], $contact[1];
#printf SF "OBT %17.2f <BR>\n", $ltime;
printf SF "<BR>\n";

printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=3><FONT SIZE=4>SIM</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3SEAPENA</FONT></TD>\n", ${$h{"3SEAPENA"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>SEA Power Enable Flag</FONT></TD>\n", ${$h{"3SEAPENA"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3SEAPENA"}}[2], ${$h{"3SEAPENA"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3SEAPSMA</FONT></TD>\n", ${$h{"3SEAPSMA"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>SEA Power ON Flag</FONT></TD>\n", ${$h{"3SEAPSMA"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3SEAPSMA"}}[2], ${$h{"3SEAPSMA"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3MTRAEN</FONT></TD>\n", ${$h{"3MTRAEN"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Motor/Brake Enable</FONT></TD>\n", ${$h{"3MTRAEN"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3MTRAEN"}}[2], ${$h{"3MTRAEN"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3SEATMUP</FONT></TD>\n", ${$h{"3SEATMUP"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Heartbeat</FONT></TD>\n", ${$h{"3SEATMUP"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3SEATMUP"}}[2], ${$h{"3SEATMUP"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3SEAID</FONT></TD>\n", ${$h{"3SEAID"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>SEA ID</FONT></TD>\n", ${$h{"3SEAID"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3SEAID"}}[2], ${$h{"3SEAID"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3TSCPOS</FONT></TD>\n", ${$h{"3TSCPOS"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Translation Position</FONT></TD>\n", ${$h{"3TSCPOS"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%d</FONT></TD>\n", ${$h{"3TSCPOS"}}[2], ${$h{"3TSCPOS"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3FAPOS</FONT></TD>\n", ${$h{"3FAPOS"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Focus Position</FONT></TD>\n", ${$h{"3FAPOS"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%d</FONT></TD>\n", ${$h{"3FAPOS"}}[2], ${$h{"3FAPOS"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3TSCMOVE</FONT></TD>\n", ${$h{"3TSCMOVE"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TSC Moving Flag</FONT></TD>\n", ${$h{"3TSCMOVE"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3TSCMOVE"}}[2], ${$h{"3TSCMOVE"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3FAMOVE</FONT></TD>\n", ${$h{"3FAMOVE"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>FA Moving Flag</FONT></TD>\n", ${$h{"3FAMOVE"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3FAMOVE"}}[2], ${$h{"3FAMOVE"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3SEAINCM</FONT></TD>\n", ${$h{"3SEAINCM"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Invalid Command Flag</FONT></TD>\n", ${$h{"3SEAINCM"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3SEAINCM"}}[2], ${$h{"3SEAINCM"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3SEARSET</FONT></TD>\n", ${$h{"3SEARSET"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Reset Flag</FONT></TD>\n", ${$h{"3SEARSET"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3SEARSET"}}[2], ${$h{"3SEARSET"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3SEAROMF</FONT></TD>\n", ${$h{"3SEAROMF"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ROM Fail Flag</FONT></TD>\n", ${$h{"3SEAROMF"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3SEAROMF"}}[2], ${$h{"3SEAROMF"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3SEARAMF</FONT></TD>\n", ${$h{"3SEARAMF"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>RAM Fail Flag</FONT></TD>\n", ${$h{"3SEARAMF"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3SEARAMF"}}[2], ${$h{"3SEARAMF"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3MRMMXMV</FONT></TD>\n", ${$h{"3MRMMXMV"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>MAX PWM Level</FONT></TD>\n", ${$h{"3MRMMXMV"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%d</FONT></TD>\n", ${$h{"3MRMMXMV"}}[2], ${$h{"3MRMMXMV"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3SMOTOC</FONT></TD>\n", ${$h{"3SMOTOC"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Motor Overcurrent Cntr</FONT></TD>\n", ${$h{"3SMOTOC"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%d</FONT></TD>\n", ${$h{"3SMOTOC"}}[2], ${$h{"3SMOTOC"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3SMOTSTL</FONT></TD>\n", ${$h{"3SMOTSTL"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Motor Stall Cntr</FONT></TD>\n", ${$h{"3SMOTSTL"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%d</FONT></TD>\n", ${$h{"3SMOTSTL"}}[2], ${$h{"3SMOTSTL"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3LDRTMEK</FONT></TD>\n", ${$h{"3LDRTMEK"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Last Tab Detect Flag</FONT></TD>\n", ${$h{"3LDRTMEK"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3LDRTMEK"}}[2], ${$h{"3LDRTMEK"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3LDRTNO</FONT></TD>\n", ${$h{"3LDRTNO"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Last Tab Number</FONT></TD>\n", ${$h{"3LDRTNO"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3LDRTNO"}}[2], ${$h{"3LDRTNO"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3STAB2EN</FONT></TD>\n", ${$h{"3STAB2EN"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Tab 2 Auto-Update Enable</FONT></TD>\n", ${$h{"3STAB2EN"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3STAB2EN"}}[2], ${$h{"3STAB2EN"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3LDRTPOS</FONT></TD>\n", ${$h{"3LDRTPOS"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Last Tab Update Value</FONT></TD>\n", ${$h{"3LDRTPOS"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%d</FONT></TD>\n", ${$h{"3LDRTPOS"}}[2], ${$h{"3LDRTPOS"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3SMOTPEN</FONT></TD>\n", ${$h{"3SMOTPEN"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Motor Power Flag</FONT></TD>\n", ${$h{"3SMOTPEN"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3SMOTPEN"}}[2], ${$h{"3SMOTPEN"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3SMOTSEL</FONT></TD>\n", ${$h{"3SMOTSEL"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>Motor Select Flag</FONT></TD>\n", ${$h{"3SMOTSEL"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s</FONT></TD>\n", ${$h{"3SMOTSEL"}}[2], ${$h{"3SMOTSEL"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3TRMTRAT</FONT></TD>\n", ${$h{"3TRMTRAT"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TSC Motor Temp</FONT></TD>\n", ${$h{"3TRMTRAT"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{"3TRMTRAT"}}[2], ${$h{"3TRMTRAT"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3FAMTRAT</FONT></TD>\n", ${$h{"3FAMTRAT"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>FA Motor Temp</FONT></TD>\n", ${$h{"3FAMTRAT"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{"3FAMTRAT"}}[2], ${$h{"3FAMTRAT"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3FAPSAT</FONT></TD>\n", ${$h{"3FAPSAT"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>SEA PS Temp</FONT></TD>\n", ${$h{"3FAPSAT"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{"3FAPSAT"}}[2], ${$h{"3FAPSAT"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3FASEAAT</FONT></TD>\n", ${$h{"3FASEAAT"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>SEA Box Temp</FONT></TD>\n", ${$h{"3FASEAAT"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{"3FASEAAT"}}[2], ${$h{"3FASEAAT"}}[1];
printf SF "</TABLE>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TD>\n";
printf SF "<TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>OTG</FONT></TR>";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4HPOSARO</FONT></TD>\n", ${$h{"4HPOSARO"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{"4HPOSARO"}}[2], ${$h{"4HPOSARO"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4HPOSBRO</FONT></TD>\n", ${$h{"4HPOSBRO"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{"4HPOSBRO"}}[2], ${$h{"4HPOSBRO"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4LPOSARO</FONT></TD>\n", ${$h{"4LPOSARO"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{"4LPOSARO"}}[2], ${$h{"4LPOSARO"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4LPOSBRO</FONT></TD>\n", ${$h{"4LPOSBRO"}}[2];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%.3f</FONT></TD>\n", ${$h{"4LPOSBRO"}}[2], ${$h{"4LPOSBRO"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "</TABLE>\n";
printf SF "</TABLE>\n";

printf SF "<BR>\n";
printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/soh.html\">[Top Level]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/Config/soh-config.html\">[S/C Config]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/PCAD/soh-pcad.html\">[PCAD]</A>\n";
printf SF "<TD><A HREF=\"http://asc.harvard.edu/cgi-gen/mta/SOH/CCDM/soh-ccdm.html\">[CCDM]</A>\n";
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
    $parfile = "$work_dir/mech.par";
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
        @test = split("", $val);
        $color = $GRN;
        if ($val <= $chk[2] && $chk[2] ne '-') {$color = $YLW;}
        if ($val >= $chk[3] && $chk[3] ne '-') {$color = $YLW;}
        if ($val <= $chk[4] && $chk[4] ne '-') {$color = $RED;}
        if ($val >= $chk[5] && $chk[5] ne '-') {$color = $RED;}
        #if ($test[1] =~ /\D/ ) {$color = $RED;}
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
