sub do_comps {
  my %h = @_;

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
  $h{'AACCCDPT'}[1] = (${$h{AACCCDPT}}[1] - 32)*5/9;
  if (${$h{COFLCXSM}}[1] == -1330) {
    $h{'COFLCXSM'} = [${$h{COFLCXSM}}[0], 'FACE', ${$h{COFLCXSM}}[2]];
  }

  return %h;
}

1;
