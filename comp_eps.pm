sub do_comps {
  %h = @_;
  my @time = sort numerically (${$h{ELBI_LOW}}[0], ${$h{ELBV}}[0]);
  my $ltime = shift @time;
  $h{"POWER"} = [$ltime, ${$h{ELBI_LOW}}[1]*${$h{ELBV}}[1], "", "#00EECC"];
  return %h;
}
1;
