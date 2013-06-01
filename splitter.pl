# cert-split-batch.pl
# Version 0.1
# Author: Ben Tyger (btyger@syferlock.com)
# License: Lesser GPL 2.0
#
# Description:
# Splits a certficate bundle file with multiple entries
# up into one certificate perl file and automatically
# generates a file safe filename based on the subject
# line of the certificate.
#
# WARNING: If a file of the same generated name exists
# it WILL be overwritten.
#
# This version is heavily based off of Nick Burch's
# cert-split.pl at http://gagravarr.org/code/cert-split.pl
#

my $filename = shift;
unless($filename) {
  die("Usage:\n  cert-split-batch.pl <certificate-file>\n");
}

open INP, "<$filename" or die("Unable to load \"$filename\"\n");

my $ifile = "";
my $thisfile = "";
while(<INP>) {
   $ifile .= $_;
   $thisfile .= $_;
   if($_ =~ /^\-+END(\s\w+)?\sCERTIFICATE\-+$/) {
      print "Found a complete certificate:\n";
      print `echo "$thisfile" | openssl x509 -noout -issuer -subject`;
      $subjectDump = `echo "$thisfile" | openssl x509 -noout -subject`;
   if ($subjectDump =~ m/.*\/O=.*/) {
    $ORegex = $subjectDump;
    $ORegex =~ s/.*\/O=(.*?)($|\/.*)/$1/;
    #print "O:".$ORegex."\n";
    $genFileName = $ORegex;
   }
   if ($subjectDump =~ m/.*\/OU=.*/) {
    $OURegex = $subjectDump;
    $OURegex =~ s/.*\/OU=(.*?)($|\/.*)/$1/;
    #print "OU:".$OURegex."\n";
    $genFileName .= "-".$OURegex;
   }
   if ($subjectDump =~ m/.*\/CN=.*/) {
    $CNRegex = $subjectDump;
    $CNRegex =~ s/.*\/CN=(.*?)($|\/.*)/$1/;
    #print "CN:".$CNRegex."\n";
    $genFileName .= "-".$CNRegex;
   }
   $genFileName =~ s/[\(\).,\[\]<>\{\}\s\'\"\:\;\&\n]//g;
      #print $genFileName."\n";
      $genFileName =~ s/[^\d\w_-]/_/g;
      #print $genFileName."\n";
   $genFileName =~ s/(.*?)_$/$1/g;
      #print $genFileName."\n";
      $genFileName .= '.crt';
      #print $genFileName."\n";

      print "Saving certificate files as ".$genFileName."\n";
      my $fname = $genFileName;

      open CERT, ">$fname";
      print CERT $thisfile;
      close CERT;

      $thisfile = "";

      print "Certificate saved\n\n";
   }
}
close INP;

print "Completed\n";
