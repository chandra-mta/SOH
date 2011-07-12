sub soh_format {
  my $outfile = shift @_;
  my %h = @_;
  print_head("$outfile","Top Level", %h);

open (SF, ">>$outfile");

printf SF "<TABLE BORDER=0>\n";
printf SF "<TR><TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>Safemode</FONT></TR>";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUB     </FONT></TD>\n", ${$h{CIUB}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUB}}[3], ${$h{CIUB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUTMPRD </FONT></TD>\n", ${$h{CTUTMPRD}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CTUTMPRD}}[3], ${$h{CTUTMPRD}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUBCARH </FONT></TD>\n", ${$h{CIUBCARH}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUBCARH}}[3], ${$h{CIUBCARH}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUCALIN </FONT></TD>\n", ${$h{CIUCALIN}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUCALIN}}[3], ${$h{CIUCALIN}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUCBLIN </FONT></TD>\n", ${$h{CIUCBLIN}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUCBLIN}}[3], ${$h{CIUCBLIN}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQOBBP </FONT></TD>\n", ${$h{C1SQOBBP}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQOBBP}}[3], ${$h{C1SQOBBP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQOBBP </FONT></TD>\n", ${$h{C2SQOBBP}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQOBBP}}[3], ${$h{C2SQOBBP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ACPEB2X  </FONT></TD>\n", ${$h{ACPEB2X}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ACPEB2X}}[3], ${$h{ACPEB2X}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AIOESWD4 </FONT></TD>\n", ${$h{AIOESWD4}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AIOESWD4}}[3], ${$h{AIOESWD4}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>CCDM</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUFMTSL </FONT></TD>\n", ${$h{CTUFMTSL}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CTUFMTSL}}[3], ${$h{CTUFMTSL}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CONLHTBT </FONT></TD>\n", ${$h{CONLHTBT}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CONLHTBT}}[3], ${$h{CONLHTBT}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COFLHTBT </FONT></TD>\n", ${$h{COFLHTBT}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{COFLHTBT}}[3], ${$h{COFLHTBT}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUCALIN </FONT></TD>\n", ${$h{CIUCALIN}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUCALIN}}[3], ${$h{CIUCALIN}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUCBLIN </FONT></TD>\n", ${$h{CIUCBLIN}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUCBLIN}}[3], ${$h{CIUCBLIN}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACARH </FONT></TD>\n", ${$h{CIUACARH}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUACARH}}[3], ${$h{CIUACARH}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACBRH </FONT></TD>\n", ${$h{CIUACBRH}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUACBRH}}[3], ${$h{CIUACBRH}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUACARH </FONT></TD>\n", ${$h{CIUACARH}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUACBRH}}[3], ${$h{CIUACBRH}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUA     </FONT></TD>\n", ${$h{CIUA}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUA}}[3], ${$h{CIUA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CIUB     </FONT></TD>\n", ${$h{CIUB}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CIUB}}[3], ${$h{CIUB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUTMPPR </FONT></TD>\n", ${$h{CTUTMPPR}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CTUTMPPR}}[3], ${$h{CTUTMPPR}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTUTMPRD </FONT></TD>\n", ${$h{CTUTMPRD}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CTUTMPRD}}[3], ${$h{CTUTMPRD}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CEPTLMA  </FONT></TD>\n", ${$h{CEPTLMA}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CEPTLMA}}[3], ${$h{CEPTLMA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CEPTLMB  </FONT></TD>\n", ${$h{CEPTLMB}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CEPTLMB}}[3], ${$h{CEPTLMB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCTLMA  </FONT></TD>\n", ${$h{CPCTLMA}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CPCTLMA}}[3], ${$h{CPCTLMA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CPCTLMB  </FONT></TD>\n", ${$h{CPCTLMB}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CPCTLMB}}[3], ${$h{CPCTLMB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSITLMA  </FONT></TD>\n", ${$h{CSITLMA}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CSITLMA}}[3], ${$h{CSITLMA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CSITLMB  </FONT></TD>\n", ${$h{CSITLMB}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CSITLMB}}[3], ${$h{CSITLMB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSTLMA  </FONT></TD>\n", ${$h{CTSTLMA}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CTSTLMA}}[3], ${$h{CTSTLMA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>CTSTLMB  </FONT></TD>\n", ${$h{CTSTLMB}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{CTSTLMB}}[3], ${$h{CTSTLMB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COERRCN  </FONT></TD>\n", ${$h{COERRCN}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%2.0f </FONT></TD>\n", ${$h{COERRCN}}[3], ${$h{COERRCN}}[1];
printf SF "</TABLE>\n";

printf SF "<TD><TABLE BORDER=0><TR><TD><FONT SIZE=2>\&nbsp</TR></TABLE>\n";

printf SF "<TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>EPS</FONT></TR>\n";
#printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ELBI     </FONT></TD>\n", ${$h{ELBI}}[3];
#printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.2f </FONT></TD>\n", ${$h{ELBI}}[3], ${$h{ELBI}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ELBV     </FONT></TD>\n", ${$h{ELBV}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.2f </FONT></TD>\n", ${$h{ELBV}}[3], ${$h{ELBV}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>POWER    </FONT></TD>\n", ${$h{POWER}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.2f </FONT></TD>\n", ${$h{POWER}}[3], ${$h{POWER}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ELDBCRNG </FONT></TD>\n", ${$h{ELDBCRNG}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ELDBCRNG}}[3], ${$h{ELDBCRNG}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ELBI_LOW </FONT></TD>\n", ${$h{ELBI_LOW}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.2f </FONT></TD>\n", ${$h{ELBI_LOW}}[3], ${$h{ELBI_LOW}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EPSTATE  </FONT></TD>\n", ${$h{EPSTATE}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EPSTATE}}[3], ${$h{EPSTATE}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSUNPRS </FONT></TD>\n", ${$h{AOSUNPRS}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOSUNPRS}}[3], ${$h{AOSUNPRS}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSAILLM </FONT></TD>\n", ${$h{AOSAILLM}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOSAILLM}}[3], ${$h{AOSAILLM}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ESAMYI   </FONT></TD>\n", ${$h{ESAMYI}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.3f </FONT></TD>\n", ${$h{ESAMYI}}[3], ${$h{ESAMYI}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ESAPYI   </FONT></TD>\n", ${$h{ESAPYI}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.3f </FONT></TD>\n", ${$h{ESAPYI}}[3], ${$h{ESAPYI}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1K1    </FONT></TD>\n", ${$h{EB1K1}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB1K1}}[3], ${$h{EB1K1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1K2    </FONT></TD>\n", ${$h{EB1K2}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB1K2}}[3], ${$h{EB1K2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2K1    </FONT></TD>\n", ${$h{EB2K1}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB2K1}}[3], ${$h{EB2K1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2K2    </FONT></TD>\n", ${$h{EB2K2}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB2K2}}[3], ${$h{EB2K2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3K1    </FONT></TD>\n", ${$h{EB3K1}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB3K1}}[3], ${$h{EB3K1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3K2    </FONT></TD>\n", ${$h{EB3K2}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB3K2}}[3], ${$h{EB3K2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB1UV    </FONT></TD>\n", ${$h{EB1UV}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB1UV}}[3], ${$h{EB1UV}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB2UV    </FONT></TD>\n", ${$h{EB2UV}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB2UV}}[3], ${$h{EB2UV}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>EB3UV    </FONT></TD>\n", ${$h{EB3UV}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{EB3UV}}[3], ${$h{EB3UV}}[1];

printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT></TR>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>THERMAL</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4OTCPEN     </FONT></TD>\n", ${$h{"4OTCPEN"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{"4OTCPEN"}}[3], ${$h{"4OTCPEN"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4OACOBAH    </FONT></TD>\n", ${$h{"4OACOBAH"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{"4OACOBAH"}}[3], ${$h{"4OACOBAH"}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>4OACHRMH    </FONT></TD>\n", ${$h{"4OACHRMH"}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{"4OACHRMH"}}[3], ${$h{"4OACHRMH"}}[1];
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
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOATTER1_DEG </FONT></TD>\n", ${$h{AOATTER1}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%8.6f </FONT></TD>\n", ${$h{AOATTER1}}[3], ${$h{AOATTER1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOATTER2_DEG </FONT></TD>\n", ${$h{AOATTER2}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%8.6f </FONT></TD>\n", ${$h{AOATTER2}}[3], ${$h{AOATTER2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOATTER3_DEG </FONT></TD>\n", ${$h{AOATTER3}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%8.6f </FONT></TD>\n", ${$h{AOATTER3}}[3], ${$h{AOATTER3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORATE1_DEG/SEC  </FONT></TD>\n", ${$h{AORATE1}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%8.6f </FONT></TD>\n", ${$h{AORATE1}}[3], ${$h{AORATE1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORATE2_DEG/SEC  </FONT></TD>\n", ${$h{AORATE2}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%8.6f </FONT></TD>\n", ${$h{AORATE2}}[3], ${$h{AORATE2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORATE3_DEG/SEC  </FONT></TD>\n", ${$h{AORATE3}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%8.6f </FONT></TD>\n", ${$h{AORATE3}}[3], ${$h{AORATE3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWSPD1_RPM </FONT></TD>\n", ${$h{AORWSPD1}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%9.3f </FONT></TD>\n", ${$h{AORWSPD1}}[3], ${$h{AORWSPD1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWSPD2_RPM </FONT></TD>\n", ${$h{AORWSPD2}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%9.3f </FONT></TD>\n", ${$h{AORWSPD2}}[3], ${$h{AORWSPD2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWSPD3_RPM </FONT></TD>\n", ${$h{AORWSPD3}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%9.3f </FONT></TD>\n", ${$h{AORWSPD3}}[3], ${$h{AORWSPD3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWSPD4_RPM </FONT></TD>\n", ${$h{AORWSPD4}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%9.3f </FONT></TD>\n", ${$h{AORWSPD4}}[3], ${$h{AORWSPD4}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWSPD5_RPM </FONT></TD>\n", ${$h{AORWSPD5}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%9.3f </FONT></TD>\n", ${$h{AORWSPD5}}[3], ${$h{AORWSPD5}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWSPD6_RPM </FONT></TD>\n", ${$h{AORWSPD6}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%9.3f </FONT></TD>\n", ${$h{AORWSPD6}}[3], ${$h{AORWSPD6}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOPCADMD </FONT></TD>\n", ${$h{AOPCADMD}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOPCADMD}}[3], ${$h{AOPCADMD}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AIRU1R1Y </FONT></TD>\n", ${$h{AIRU1R1Y}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AIRU1R1Y}}[3], ${$h{AIRU1R1Y}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AIRU1R1X </FONT></TD>\n", ${$h{AIRU1R1X}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AIRU1R1X}}[3], ${$h{AIRU1R1X}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>MOMENTUM </FONT></TD>\n", ${$h{MOMENTUM}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%5.3f </FONT></TD>\n", ${$h{MOMENTUM}}[3], ${$h{MOMENTUM}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOMANMON </FONT></TD>\n", ${$h{AOMANMON}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOMANMON}}[3], ${$h{AOMANMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSUNMON </FONT></TD>\n", ${$h{AOSUNMON}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOSUNMON}}[3], ${$h{AOSUNMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOIRUMON </FONT></TD>\n", ${$h{AOIRUMON}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOIRUMON}}[3], ${$h{AOIRUMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOATTMON </FONT></TD>\n", ${$h{AOATTMON}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOATTMON}}[3], ${$h{AOATTMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWMON1 </FONT></TD>\n", ${$h{AORWMON1}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AORWMON1}}[3], ${$h{AORWMON1}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWMON2 </FONT></TD>\n", ${$h{AORWMON2}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AORWMON2}}[3], ${$h{AORWMON2}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWMON3 </FONT></TD>\n", ${$h{AORWMON3}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AORWMON3}}[3], ${$h{AORWMON3}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWMON4 </FONT></TD>\n", ${$h{AORWMON4}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AORWMON4}}[3], ${$h{AORWMON4}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWMON5 </FONT></TD>\n", ${$h{AORWMON5}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AORWMON5}}[3], ${$h{AORWMON5}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AORWMON6 </FONT></TD>\n", ${$h{AORWMON6}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AORWMON6}}[3], ${$h{AORWMON6}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOMOMMON </FONT></TD>\n", ${$h{AOMOMMON}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOMOMMON}}[3], ${$h{AOMOMMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOULMON  </FONT></TD>\n", ${$h{AOULMON}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOULMON}}[3], ${$h{AOULMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSAPMON </FONT></TD>\n", ${$h{AOSAPMON}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOSAPMON}}[3], ${$h{AOSAPMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOSATMON </FONT></TD>\n", ${$h{AOSATMON}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOSATMON}}[3], ${$h{AOSATMON}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOLAEMON </FONT></TD>\n", ${$h{AOLAEMON}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOLAEMON}}[3], ${$h{AOLAEMON}}[1];
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "<TR><TD><FONT SIZE=2>&nbsp</FONT></TR>\n";
printf SF "</TABLE>\n";

printf SF "<TD><TABLE BORDER=0><TR><TD><FONT SIZE=2>\&nbsp</FONT></TR></TABLE>\n";

printf SF "<TD><TABLE BORDER=0>\n";
printf SF "<TR><TD ALIGN=CENTER COLSPAN=2><FONT SIZE=4>Safing</FONT></TR>\n";
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ACPEAHB  </FONT></TD>\n", ${$h{ACPEAHB}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ACPEAHB}}[3], ${$h{ACPEAHB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOCPESTL </FONT></TD>\n", ${$h{AOCPESTL}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AOCPESTL}}[3], ${$h{AOCPESTL}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOCPESTC </FONT></TD>\n", ${$h{AOCPESTC}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%6.1f </FONT></TD>\n", ${$h{AOCPESTC}}[3], ${$h{AOCPESTC}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AOCPESTG </FONT></TD>\n", ${$h{AOCPESTG}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%2.0f </FONT></TD>\n", ${$h{AOCPESTG}}[3], ${$h{AOCPESTG}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ACPAALCK </FONT></TD>\n", ${$h{ACPAALCK}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ACPAALCK}}[3], ${$h{ACPAALCK}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ACPACKSM </FONT></TD>\n", ${$h{ACPACKSM}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ACPACKSM}}[3], ${$h{ACPACKSM}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>COFLCXSM </FONT></TD>\n", ${$h{COFLCXSM}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{COFLCXSM}}[3], ${$h{COFLCXSM}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AFSSAFLG </FONT></TD>\n", ${$h{AFSSAFLG}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AFSSAFLG}}[3], ${$h{AFSSAFLG}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AFSSBFLG </FONT></TD>\n", ${$h{AFSSBFLG}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AFSSBFLG}}[3], ${$h{AFSSBFLG}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ARCSFLGA </FONT></TD>\n", ${$h{ARCSFLGA}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ARCSFLGA}}[3], ${$h{ARCSFLGA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>ARCSFLGB </FONT></TD>\n", ${$h{ARCSFLGB}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{ARCSFLGB}}[3], ${$h{ARCSFLGB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAPIU </FONT></TD>\n", ${$h{C1SQAPIU}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQAPIU}}[3], ${$h{C1SQAPIU}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAPIU </FONT></TD>\n", ${$h{C2SQAPIU}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQAPIU}}[3], ${$h{C2SQAPIU}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAPO  </FONT></TD>\n", ${$h{C1SQAPO}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQAPO}}[3], ${$h{C1SQAPO}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAPO  </FONT></TD>\n", ${$h{C2SQAPO}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQAPO}}[3], ${$h{C2SQAPO}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAPPP </FONT></TD>\n", ${$h{C1SQAPPP}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQAPPP}}[3], ${$h{C1SQAPPP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAPPP </FONT></TD>\n", ${$h{C2SQAPPP}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQAPPP}}[3], ${$h{C2SQAPPP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQOBBP </FONT></TD>\n", ${$h{C1SQOBBP}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQOBBP}}[3], ${$h{C1SQOBBP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQOBBP </FONT></TD>\n", ${$h{C2SQOBBP}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQOBBP}}[3], ${$h{C2SQOBBP}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAX   </FONT></TD>\n", ${$h{C1SQAX}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQAX}}[3], ${$h{C1SQAX}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAX   </FONT></TD>\n", ${$h{C2SQAX}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQAX}}[3], ${$h{C2SQAX}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C1SQAPCT </FONT></TD>\n", ${$h{C1SQAPCT}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C1SQAPCT}}[3], ${$h{C1SQAPCT}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>C2SQAPCT </FONT></TD>\n", ${$h{C2SQAPCT}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{C2SQAPCT}}[3], ${$h{C2SQAPCT}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG1SELA  </FONT></TD>\n", ${$h{AG1SELA}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG1SELA}}[3], ${$h{AG1SELA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG1SELB  </FONT></TD>\n", ${$h{AG1SELB}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG1SELB}}[3], ${$h{AG1SELB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG2SELA  </FONT></TD>\n", ${$h{AG2SELA}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG2SELA}}[3], ${$h{AG2SELA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG2SELB  </FONT></TD>\n", ${$h{AG2SELB}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG2SELB}}[3], ${$h{AG2SELB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG3SELA  </FONT></TD>\n", ${$h{AG3SELA}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG3SELA}}[3], ${$h{AG3SELA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG3SELB  </FONT></TD>\n", ${$h{AG3SELB}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG3SELB}}[3], ${$h{AG3SELB}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG4SELA  </FONT></TD>\n", ${$h{AG4SELA}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG4SELA}}[3], ${$h{AG4SELA}}[1];
printf SF "<TR><TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>AG4SELB  </FONT></TD>\n", ${$h{AG4SELB}}[3];
printf SF "<TD ALIGN=LEFT><FONT SIZE=2 COLOR=%s>%s </FONT></TD>\n", ${$h{AG4SELB}}[3], ${$h{AG4SELB}}[1];
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
