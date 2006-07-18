
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
