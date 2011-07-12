#!/proj/axaf/bin/perl
##!/opt/local/bin/perl

open (IN, "xx");
open (OUT, ">form.out");
while (<IN>) { 
  $v = $_ ;
  chomp $v;
  print "$v\n";
  print OUT "printf SF \"<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=\%s>$v</FONT></TD>\\n\", \${\$h{$v}}[2]\;\n";
  print OUT "printf SF \"<TD ALIGN=LEFT><FONT SIZE=2 COLOR=\%s>\%s</FONT></TD>\\n\", \${\$h{$v}}[2], \${\$h{$v}}[1]\;\n";
}
close OUT;
close IN;
