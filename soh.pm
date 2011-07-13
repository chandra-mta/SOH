# utilities for chandra snapshot
# BDS May 2001

sub get_data {
  my %h;
  # read the ACORN tracelog files
  #my @ftype = qw(ACA CCDM EPHIN EPS PCAD SIM-OTG SI TEL);
  #my $data_dir = '/data/mta/www/MIRROR/Snap/Test';
  my $data_dir = shift(@_);
  my @ftype = @_;
  for ($i = 0; $i <= $#ftype; $i++) {
    #print "new ftype $ftype[$i]\n"; # debug
    my %keep;
    @tlfiles = <$data_dir/*$ftype[$i]_*.tl>;
    my $time = 1;
    my $last_time = 0;
    $curr_time = time_now();
  
    foreach $f (@tlfiles) {
      #print "Reading $f\n"; #debug
      open (TLF, $f) or next;
      @msids = split /\t/, <TLF>;
      shift @msids;                 # exclude time
      <TLF>;                        # skip second line
  
      while (<TLF>) {
        @vals = split /\t/,$_;
        #map { s/^\s+(.+)\s+$/$1/ } @vals;
        map { s/^\s+// } @vals;
        map { s/\s+$// } @vals;
        $time = shift @vals;
        if ($time >= $last_time && $time <= $curr_time) { 
          $last_time = $time;
          foreach (@msids) { 
            $val = shift @vals;
            if ($val ne "") {
              $h{"$_"} = [$time, $val, "", "#00EEFF"];
              #print "$_ ${$h{$_}}[0] ${$h{$_}}[1] ${$h{$_}}[2]\n"; #debug
              # different msids may have valid value in different files
              $keep{$_} = $f;
            }
          }
        }
      }
    }
    #print "starting delete\n"; #debug
    # delete old tlfiles
    #  keep latest file and file where value used came from
    #   (usually the same file)
    if ($#tlfiles > 0) {
      pop @tlfiles;
      #print "popped\n"; #debug
      foreach $f (@tlfiles) {
        #print "checking $f for delete\n"; #debug
        my $keep = 0;
        # different msids may have valid value in different files
        foreach $keeper (values %keep) {
          if ($f eq $keeper) { 
            $keep = 1;
            last;
          }
        }
        if ($keep eq 0) { 
          #print "Deleting $f\n"; #debug
          unlink $f; 
        }
      }
    }
  }
  #print "returning data\n"; #debug
  return %h;
}

sub set_status {
  my $stale_time = 900; #data more than this many seconds old is called stale 
  my %inh = @_;
  #my $ref_time = time_now();
  my $ref_time = $inh{OBT}[0];
  foreach $key (keys(%inh)) {
    if ($ref_time - $inh{$key}[0] > $stale_time) {
      $inh{"$key"}[2] = "S";
      $inh{"$key"}[3] = "#996677";
    }
  }
  # current data uses current time for reference
  my $ref_time = $inh{UTC}[0];
  my @curr_msids = qw(FLUXACE FLUACE KP EPHEM_ALT EPHEM_LEG);
  foreach $key (@curr_msids) {
    if (defined $inh{$key}) {
      if ($ref_time - $inh{$key}[0] > $stale_time) {
        $inh{"$key"}[2] = "S";
        $inh{"$key"}[3] = "#996677";
      }
    }
  }
  # also check for bad data
  #  invalid data 
  # these msids are only valid in eps subformat
  if (defined $inh{COTLRDSF}) {
    my @eps_data = qw(COSCS107S COSCS128S COSCS129S COSCS130S);

    # !! OK, but if get_data works right the eps_data WAS valid at its time
    #    so may now be stale but not invalid
    #   To do: must compare scs and subformat times.
    #    (and of course, same for norm below)
  
    if ($inh{COTLRDSF}[1] ne 'EPS') {
      foreach (@eps_data) {
        if (defined $inh{$_}) {
          $inh{$_}[2] = "I";
          $inh{$_}[3] = "#996677";
        }
      }
    }
    # these msids are only valid in norm subformat
    my @norm_data = qw(AOCPESTL);
    if ($inh{COTLRDSF}[1] ne 'NORM') {
      foreach (@norm_data) {
        if (defined $inh{$_}) {
          $inh{$_}[2] = "I";
          $inh{$_}[3] = "#996677";
        }
      }
    }
  }
  return %inh;
}
    
sub time_now {
  use Time::TST_Local;
  my $t1998 = 883612800.0;
  my @now = gmtime();
  return (timegm(@now) - $t1998);
}

sub get_curr {
  # collect current ephemeris, ace, kp, data
  # return current data hash table
  my %h;

  # read the ephemeris file
  @ephem = split ' ',<EF> if open (EF, '/home/mta/Snap/gephem.dat');
  $h{EPHEM_ALT} = [$ephem[2], $ephem[0], "", "white"];
  $h{EPHEM_LEG} = [$ephem[2], $ephem[1], "", "white"];
  
  # read the ACE flux
  
  $fluf = "/home/mta/Snap/fluace.dat";
  if (open FF, $fluf) {
      @ff = <FF>;
      @fl = split ' ',$ff[-3];
      #$fluxace = $fl[11];
      close FF;
  } else { print STDERR "$fluf not found!\n" };

  $h{FLUXACE} = [date2secs($fl[0], $fl[1], $fl[2], $fl[3]), $fl[11], "", "white"];
  
  # read the ACIS fluence
  
  $fluf = "/home/mta/Snap/ACIS-FLUENCE.dat";
  if (open FF, $fluf) {
      @ff = <FF>;
      @fl = split ' ',$ff[-1];
      #$fluace = $fl[9];
      close FF;
  } else { print STDERR "$fluf not found!\n" };
  
  $h{FLUACE} = [date2secs($fl[0], $fl[1], $fl[2], $fl[3]), $fl[9], "", "white"];

  # read the CRM fluence - replaces F_ACE in snapshot May 2001
  $fluf = "/home/mta/Snap/CRMsummary.dat";
  if (open FF, $fluf) {
      @ff = <FF>;
      @fl = split ' ',$ff[-1];
      #$flucrm = $fl[-1];
      close FF;
  } else { print STDERR "$fluf not found!\n" };

  # don't know time here, assume same fluace for now
  $h{CRM} = [$h{FLUACE}[0], $fl[-1], "", "white"];

  # read the ACE Kp file
  
  $kpf = "/home/mta/Snap/kp.dat";
  if (open KPF, $kpf) {
      while (<KPF>) { $kp = $_ };
  } else { print STDERR "Cannot read $kpf\n" };
  @kp = split /\s+/, $kp;

  $h{KP} = [date2secs($kp[0], $kp[1], $kp[2], $kp[3]), $kp[9], "", "white"];
  
  return %h;
}

sub date2secs {
  my $t1998 = 883612800.0;
  my ($yr, $mo, $day, $time) = @_;
  my $hr = substr($time, 0, 2);
  my $mn = substr($time, 2, 2);
  return timegm(0, $mn, $hr, $day, $mo-1, $yr-1900) - $t1998;
}

sub numerically { $a <=> $b };

sub time_now {
  use Time::TST_Local;
  my $t1998 = 883612800.0;
  my @now = gmtime();
  return (timegm(@now) - $t1998);
}

sub get_times {
  my %h = @_;
  $t1998 = 883612800.0;
  my @times;
  foreach $key (keys(%h)) {
    push @times, ${$h{$key}}[0];
  }
  @stimes = sort numerically @times;
  $ltime = pop @stimes;
  $time0 = shift @stimes;
  #die "Exit because of stale data! Data timespan: $time0 to $ltime\n" if ($ltime - $time0) > 100000;

  ($sec,$min,$hr,$dummy,$dummy,$y,$dummy,$yday,$dummy) = gmtime($ltime+$t1998);
  $obt = sprintf "%4d:%3.3d:%2.2d:%2.2d:%2.2d",$y+1900,$yday+1,$hr,$min,$sec;
  $h{OBT} = [$ltime, $obt, 0, "white"];

  $utc = `date -u +"%Y:%j:%T (%b%e)"`;
  chomp $utc;
  $h{UTC} = [time_now(), $utc, "", "white"];
  #print "Hello utc $utc\n"; #debug

  return %h;
}

sub chk_contact {
  my @time = split(/:/, $_[0]);
  my $times = (31536000*($time[0]-1998))+(86400*($time[1]-1))+(3600*$time[2])+(60*$time[3])+$time[4];
  my $leap = 2000;
  while ($time[0] > $leap) { # add leap years
    $times += 86400;
    $leap += 4;
  }
  @time = split(/:/, $_[1]);
  my $ltimes = (31536000*($time[0]-1998))+(86400*($time[1]-1))+(3600*$time[2])+(60*$time[3])+$time[4];
  my $leap = 2000;
  while ($time[0] > $leap) { # add leap years
    $ltimes += 86400;
    $leap += 4;
  }
  my @contact;
  if (abs($times - $ltimes) < 61) {
    @contact = ("AOS", "BLINK");
  } else {
    @contact = ("LOS", "B");
  }
  return @contact;
}

sub print_head {
  my $fname = shift @_;
  my $title = shift @_;
  my %h = @_;
  my $utc = ${$h{"UTC"}}[1];
  my $obt = ${$h{"OBT"}}[1];
  # determine LOS or AOS
  my @contact = chk_contact($utc, $obt);

  # write out state of health snapshot
  #print "$fname\n"; #debug
  open(SF, ">$fname") or die "Cannot open $fname\n";
  print SF "<HTML><HEAD><TITLE>Chandra State of Health $title</TITLE></HEAD>\n";
  print SF "<BODY BGCOLOR=\"#000000\" TEXT=\"#EEEEEE\" LINK=\"#DDDDDD\" ALINK=\"#DDDDDD\" VLINK=\"#DDDDDD\">\n";
  printf SF "<div id=\"overDiv\" style=\"position:absolute; visibility:hidden; z-index:1000;\"></div>\n";
  #printf SF "<script language=\"JavaScript\" src=\"../OVERLIB/overlib.js\"><!--overLIB (c) Erik Bosrup --></script>\n";
  printf SF "<script language=\"JavaScript\" src=\"\/mta\/overlib.js\"><!--overLIB (c) Erik Bosrup --></script>\n";

  printf SF "<H1>CHANDRA STATE OF HEALTH - $title</H1>\n";

  printf SF "Last Updated: &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp UTC %s <BR>\n", $utc;
  printf SF "<BR>\n";
  printf SF "Last Data Received: &nbsp &nbsp OBT %s \n", $obt;
  #printf SF "&nbsp &nbsp &nbsp &nbsp Contact: &nbsp <%s>%s <\/%s>\n", $contact[1], $contact[0], $contact[1];
  printf SF "&nbsp &nbsp &nbsp %s_%-4s<BR>\n", ${$h{"CCSDSTMF"}}[1], ${$h{"COTLRDSF"}}[1];
  printf SF "<BR>\n";
  printf SF "AOPCADMD &nbsp %s &nbsp &nbsp &nbsp\n", ${$h{"AOPCADMD"}}[1];
  printf SF "CCSDSVCD &nbsp %d &nbsp &nbsp &nbsp\n", ${$h{"CCSDSVCD"}}[1];
  printf SF "COBSRQID &nbsp %d &nbsp &nbsp &nbsp\n", ${$h{"COBSRQID"}}[1];
  printf SF "<BR>\n";
  printf SF "<HR>\n";
  printf SF "<BR>\n";
  close SF;
  return 1;
}

sub print_links {
  my $fname = $_[0];
  open (SF, ">>$fname");
  #my $root = "cxc.harvard.edu/mta/SOH";
  my $root = "..";
  my %links;
  $links{"Top_Level"} = "/data/mta4/www/SOH/soh.html";
  $links{"PCAD"} = "/data/mta4/www/SOH/PCAD/soh-pcad.html";
  $links{"CCDM"} = "/data/mta4/www/SOH/CCDM/soh-ccdm.html";
  $links{"Mechanisms"} = "/data/mta4/www/SOH/Mech/soh-mech.html";
  $links{"Thermal"} = "/data/mta4/www/SOH/Therm/soh-therm.html";
  $links{"Propulsion"} = "/data/mta4/www/SOH/Prop/soh-prop.html";
  $links{"S/C_Config"} = "/data/mta4/www/SOH/Config/soh-config.html";
  $links{"EPS"} = "/data/mta4/www/SOH/EPS/soh-eps.html";
  $links{"Safe_mode"} = "/data/mta4/www/SOH/Smode/soh-smode.html";
  $links{"Load_rev"} = "/data/mta4/www/SOH/Load/soh-load-rev.html";

  # hash isn't perfect, because I want this order
  my @order = qw(Top_Level PCAD CCDM S/C_Config Mechanisms Thermal Propulsion EPS Safe_mode Load_rev);
  printf SF "<TABLE BORDER=0>\n";
  foreach $key (@order) {
    if ($fname ne $links{$key}) {
      $path = substr($links{$key}, index($links{$key}, "SOH/")+4);

      #printf SF "<TD><A HREF=\"http://cxc.harvard.edu/mta/$path\">[$key]</A>\n";
      if ($fname eq $links{"Top_Level"}) {
        printf SF "<TD><A HREF=\"$path\">[$key]</A>\n";
      } else {
        printf SF "<TD><A HREF=\"../$path\">[$key]</A>\n";
      }
    }
  }
  printf SF "</TABLE>\n";
  printf SF "<br>Popups by <a href=\"http://www.bosrup.com/web/overlib/\">overLIB</a>\n";

  close SF;
}

sub numerically { $a <=> $b };

1;
