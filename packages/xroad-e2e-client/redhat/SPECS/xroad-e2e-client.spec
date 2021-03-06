# produce .elX dist tag on both centos and redhat
%define dist %(/usr/lib/rpm/redhat/dist.sh)

Name:               xroad-e2e-client
Version:            %{xroad_e2e_client_version}
Release:            %{rel}%{?snapshot}%{?dist}
Summary:            X-Road Simple e2e testing client
Group:              Applications/Internet
License:            MIT
Requires:           systemd, cronie, cronie-anacron, cpan, perl, perl(LWP::UserAgent), perl(HTTP::Request::Common), perl(Scalar::Util), perl(MIME::Lite), perl(GD::Graph::bars), perl(GD::Graph::Data)
Requires(post):     systemd
Requires(preun):    systemd
Requires(postun):   systemd
Provides: perl(.::randomXML.pl), perl(.::helloXML.pl), perl(XML::Parser::Lite::Tree), perl(Config::Simple)

%define src %{_topdir}/../../..
%define conf /usr/share/xroad/xroad-e2e-client
%define target /usr/share/xroad/xroad-e2e-client

%description
X-Road Simple e2e testing client

%prep

%build

%install
mkdir -p %{buildroot}%{conf}
mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/etc/cron.d
mkdir -p %{buildroot}/opt/xroad-e2e-client
cp -p %{src}/report.ini %{buildroot}%{conf}
cp -p %{src}/monitor.ini %{buildroot}%{conf}
cp -p %{src}/randomXML.pl %{buildroot}%{conf}
cp -p %{src}/helloXML.pl %{buildroot}%{conf}
cp -p %{src}/simple_monitor.pl %{buildroot}%{target}
cp -p %{src}/report.pl %{buildroot}%{target}
cp -p %{src}/LICENSE %{buildroot}%{target}
cp -p %{src}/README.md %{buildroot}%{target}
cp -p %{_topdir}/SOURCES/%{name}.cron %{buildroot}/etc/cron.d/%{name}


%clean
rm -rf %{buildroot}

%files
%defattr(644,xroad,xroad,-)
%config(noreplace) %{conf}/report.ini
%config(noreplace) %{conf}/monitor.ini
%config(noreplace) %{conf}/randomXML.pl
%config(noreplace) %{conf}/helloXML.pl

%attr(755,root,root) /etc/cron.d/%{name}
%attr(555,root,root) %{target}/simple_monitor.pl
%attr(555,root,root) %{target}/report.pl
%attr(444,root,root) %{target}/LICENSE
%attr(444,root,root) %{target}/README.md

%pre

%post
cpan Config::Simple
cpan XML::Parser::Lite::Tree

%changelog

