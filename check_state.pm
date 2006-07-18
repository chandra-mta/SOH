########################################################################
sub check_state {
########################################################################

    my $parfile = shift @_;
    %hash = @_;

    $BLU = "#00EECC";
    $GRN = "#33CC00";
    $YLW = "#FFFF00";
    $RED = "#FF0000";
    
    # Define variables to check
    my @checks;
    open KEY, $parfile;
    while (<KEY>) {
      if ($_ =~ /^#/) {}
      else { push @checks, $_; }
    }
    close KEY;

    # Now do the checking, and adjust color of text accordingly
    foreach $check (@checks) {
      @chk = split(/\t+/, $check);
      #print "$check\n"; #debug
      #print "$chk[0]\n"; #debug
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
        #print "$chk[0] $color CONSTANT\n";
      }

      # use a function
      if ($chk[1] == 4) {
        $funcall = $chk[2];
        $funcall =~ s/^\s+//;
        $funcall =~ s/\s+$//;
        $color = &$funcall("$val");
      }

      $hash{"$chk[0]"}[3] = $color;
    }

    #print "$chk[0], $color\n"; # debug
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
  my $mode = ${$hash{AOPCADMD}}[1];
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
  my $mode = ${$hash{AOPCADMD}}[1];
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
1;
