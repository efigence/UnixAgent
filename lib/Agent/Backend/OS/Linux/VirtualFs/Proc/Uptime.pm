package Ocsinventory::Agent::Backend::OS::Linux::VirtualFs::Proc::Uptime;
use strict;

sub check {
	foreach (`mount`) {
		return 1 if (/type\ proc/);
	}
	return;
}

sub run {
	my $h = shift;

        # Uptime
        open UPTIME, "/proc/uptime";
        my $uptime = <UPTIME>;
        $uptime =~ s/^(.+)\s+.+/$1/;
        close UPTIME;

        # Uptime conversion
        my ($UYEAR, $UMONTH , $UDAY, $UHOUR, $UMIN, $USEC) = (gmtime ($uptime))[5,4,3,2,1,0];

        # Write in ISO format
        $uptime=sprintf "%02d-%02d-%02d %02d:%02d:%02d", ($UYEAR-70), $UMONTH, ($UDAY-1), $UHOUR, $UMIN, $USEC;

	chomp(my $DeviceType =`uname -m`);
	$h->{'CONTENT'}{'HARDWARE'}{'DESCRIPTION'} = [ "$DeviceType/$uptime" ];
}

1
