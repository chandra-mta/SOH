#!/opt/local/bin/perl

@tlfiles = <*.txt>;
open (OUT, ">sedscr");
foreach $f (@tlfiles) {
    open (TLF, $f) or next;
    while (<TLF>) {
      @v = split ' ', $_;
      for $i (1 .. $#v) {
        if ($v[$i] =~ /\./) {
          #print OUT "\/$v[$i-1]\/s\/COLOR=\%s>\%s\/COLOR=\%s>\%\\\.3f\/\n";
          print OUT "$v[$i-1] $v[$i]\n";
        }
      }
    }
}
