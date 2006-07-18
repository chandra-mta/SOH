#!/proj/axaf/bin/perl

@tlfiles = <*.txt>;
open (SF, ">xout");
foreach $f (@tlfiles) {
    open (TLF, $f) or next;
    while (<TLF>) { $v = $_ ;
    @vals = split ' ',$v;
    foreach (@vals) { print SF "$_\n"};
}
}

