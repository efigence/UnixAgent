package Ocsinventory::Agent::Backend::OS::Generic::Packaging::BSDpkg;

sub check {can_run("pkg_info") || can_run("pkg")}

sub run {
    my $params = shift;
    my $common = $params->{common};

    if (can_run("pkg_info")) {
        foreach(`pkg_info`){
            /^(\S+)-(\d+\S*)\s+(.*)/;
            my $name = $1;
            my $version = $2;
            my $comments = $3;
      
            $common->addSoftware({
                'COMMENTS' => $comments,
                'NAME' => $name,
                'VERSION' => $version
            });
        }
    } elsif (can_run("pkg")) {
        foreach(`pkg info`){
            /^(\S+)-(\d+\S*)\s+(.*)/;
            my $name = $1;
            my $version = $2;
            my $comments = $3;
      
            $common->addSoftware({
                'COMMENTS' => $comments,
                'NAME' => $name,
                'VERSION' => $version
            });
        }
    }
}

1;
