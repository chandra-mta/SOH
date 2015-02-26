sub load_format {
  my $outfile = shift @_;
  my %h = @_;
  print_head("$outfile","Load Review", %h);

open (SF, ">>$outfile");

printf SF "<TABLE BORDER=0>\n";
printf SF "<TD><TABLE BORDER=0>\n";
#printf SF "<TR><TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>PCAD LOAD REVIEW PARAMETERS</FONT></TR>";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>TARGET QUATERNION</FONT></TR>";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOTARQT1     </FONT></TD>\n", ${$h{AOTARQT1}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%10.6f </FONT></TD>\n", ${$h{AOTARQT1}}[3], ${$h{AOTARQT1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOTARQT2     </FONT></TD>\n", ${$h{AOTARQT2}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%10.6f </FONT></TD>\n", ${$h{AOTARQT2}}[3], ${$h{AOTARQT2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOTARQT3     </FONT></TD>\n", ${$h{AOTARQT3}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%10.6f </FONT></TD>\n", ${$h{AOTARQT3}}[3], ${$h{AOTARQT3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOTARQT4     </FONT></TD>\n", ${$h{AOATTQT4}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%10.6f </FONT></TD>\n", ${$h{AOATTQT4}}[3], ${$h{AOATTQT4}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>MOMENTUM</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSYMOM1 </FONT></TD>\n", ${$h{AOSYMOM1}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%10.6f </FONT></TD>\n", ${$h{AOSYMOM1}}[3], ${$h{AOSYMOM1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSYMOM2 </FONT></TD>\n", ${$h{AOSYMOM2}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%10.6f </FONT></TD>\n", ${$h{AOSYMOM2}}[3], ${$h{AOSYMOM2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSYMOM3 </FONT></TD>\n", ${$h{AOSYMOM3}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%10.6f </FONT></TD>\n", ${$h{AOSYMOM3}}[3], ${$h{AOSYMOM3}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>MINUS-Z MODEL TEMPERATURES</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TEPHIN </FONT></TD>\n", ${$h{TEPHIN}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{TEPHIN}}[3], ${$h{TEPHIN}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TCYLAFT6 </FONT></TD>\n", ${$h{TCYLAFT6}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{TCYLAFT6}}[3], ${$h{TCYLAFT6}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TMZP_MY </FONT></TD>\n", ${$h{TMZP_MY}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{TMZP_MY}}[3], ${$h{TMZP_MY}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TCYLFMZM </FONT></TD>\n", ${$h{TCYLFMZM}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{TCYLFMZM}}[3], ${$h{TCYLFMZM}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>TFSSBKT1 </FONT></TD>\n", ${$h{TFSSBKT1}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{TFSSBKT1}}[3], ${$h{TFSSBKT1}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>MUPS VALVE MODEL TEMPERATURES</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>PM1THV1T </FONT></TD>\n", ${$h{PM1THV1T}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{PM1THV1T}}[3], ${$h{PM1THV1T}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>PM2THV1T </FONT></TD>\n", ${$h{PM2THV1T}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{PM2THV1T}}[3], ${$h{PM2THV1T}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>FUEL AND MUPS TANK TEMPERATURES</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>PFTANK2T </FONT></TD>\n", ${$h{PFTANK2T}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{PFTANK2T}}[3], ${$h{PFTANK2T}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>PMTANK3T </FONT></TD>\n", ${$h{PMTANK3T}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{PMTANK3T}}[3], ${$h{PMTANK3T}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>OBA FORWARD BULKHEAD TEMPERATURES</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4RT700T </FONT></TD>\n", ${$h{"4RT700T"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{"4RT700T"}}[3], ${$h{"4RT700T"}}[1];
printf SF "</TABLE>\n";

printf SF "<TD><TABLE BORDER=0><TR><TD><FONT SIZE=2>\&nbsp</TR></TABLE>\n";

printf SF "<TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>SPACECRAFT CONFIGURATION</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>TIME</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>OBC VCDU     </FONT></TD>\n", ${$h{CCSDSVCD}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%i </FONT></TD>\n", ${$h{CCSDSVCD}}[3], ${$h{CCSDSVCD}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EPHEM TIME     </FONT></TD>\n", ${$h{AOETIMEX}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%i </FONT></TD>\n", ${$h{AOETIMEX}}[3], ${$h{AOETIMEX}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>PCAD STATE</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOPCADMD     </FONT></TD>\n", ${$h{"AOPCADMD"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{"AOPCADMD"}}[3], ${$h{"AOPCADMD"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOFATTMD     </FONT></TD>\n", ${$h{"AOFATTMD"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{"AOFATTMD"}}[3], ${$h{"AOFATTMD"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AODITHEN     </FONT></TD>\n", ${$h{"AODITHEN"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{"AODITHEN"}}[3], ${$h{"AODITHEN"}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>SOLAR ARRAY ANGLE</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSARES2     </FONT></TD>\n", ${$h{"AOSARES2"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{"AOSARES2"}}[3], ${$h{"AOSARES2"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSARES1     </FONT></TD>\n", ${$h{"AOSARES1"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{"AOSARES1"}}[3], ${$h{"AOSARES1"}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>SIM POSITION</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>3TSCPOS     </FONT></TD>\n", ${$h{"3TSCPOS"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%i </FONT></TD>\n", ${$h{"3TSCPOS"}}[3], ${$h{"3TSCPOS"}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>PSMC MODEL TEMPERATURES</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>1PDEAAT </FONT></TD>\n", ${$h{"1PDEAAT"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{"1PDEAAT"}}[3], ${$h{"1PDEAAT"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>1PIN1AT </FONT></TD>\n", ${$h{"1PIN1AT"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{"1PIN1AT"}}[3], ${$h{"1PIN1AT"}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>DPA MODEL TEMPERATURE</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>1DPAMZT </FONT></TD>\n", ${$h{"1DPAMZT"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{"1DPAMZT"}}[3], ${$h{"1DPAMZT"}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>ACA MODEL TEMPERATURE</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AACCCDPT_C </FONT></TD>\n", ${$h{"AACCCDPT"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%7.2f </FONT></TD>\n", ${$h{"AACCCDPT"}}[3], ${$h{"AACCCDPT"}}[1];
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";

printf SF "</TABLE>\n";

printf SF "</TABLE>\n";
printf SF "<BR>\n";
close SF;

print_links("$outfile");
open (SF,">>$outfile");
print SF "</BODY></HTML>\n";
close SF;
}
1;
