package WWW::Mechanize;
# Dummy package to find out what is being called

sub new {
        my ($class, %opts) = @_;
        my $new = {};
        $new->{options_hash} = \%opts;
        bless $new, $class;
}

sub content { "called_content_via_www_mechanize" }

my $success = 0;
sub set_success { shift; $success = shift; }
sub success { $success }

1;
