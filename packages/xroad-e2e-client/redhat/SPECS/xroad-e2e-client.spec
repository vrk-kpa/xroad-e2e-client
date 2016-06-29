# produce .elX dist tag on both centos and redhat
%define dist %(/usr/lib/rpm/redhat/dist.sh)

Name:               xroad-e2e-client
Version:            %{xroad_e2e_client_version}
Release:            %{rel}%{?snapshot}%{?dist}
Summary:            X-Road Simple e2e testing client
Group:              Applications/Internet
License:            MIT
Requires:           systemd, cronie, cronie-anacron, liblwp-mediatypes-perl liblwp-protocol-https-perl libxml-parser-lite-tree-perl libscalar-util-numeric-perl libmime-lite-perl libconfig-simple-perl libgd-graph-perl
Requires(post):     systemd
Requires(preun):    systemd
Requires(postun):   systemd

%define src %{_topdir}
%define conf /usr/share/xroad/xroad-e2e-client

%description
X-Road Simple e2e testing client

%prep

%build

%install
mkdir -p %{buildroot}%{conf}
mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/etc/cron.d
mkdir -p %{buildroot}/opt/xroad-e2e-client
cp -p %{src}/../../../build/resources/main/report.ini %{buildroot}%{conf}
cp -p %{src}/../../../build/resources/main/monitor.ini %{buildroot}%{conf}
cp -p %{src}/../../../build/resources/main/randomXML.pl %{buildroot}%{conf}
cp -p %{src}/../../../build/resources/main/helloXML.pl %{buildroot}%{conf}
cp -p %{src}/SOURCES/%{name}.cron %{buildroot}/etc/cron.d/%{name}
cp -p %{src}/SOURCES/* %{buildroot}/usr/share/xroad/xroad-e2e-client


%clean
rm -rf %{buildroot}

%files
%defattr(600,xroad,xroad,-)
%config(noreplace) %{conf}/report.ini
%config(noreplace) %{conf}/monitor.ini
%config(noreplace) %{conf}/randomXML.pl
%config(noreplace) %{conf}/helloXML.pl

%attr(755,root,root) /etc/cron.d/%{name}
%attr(644,root,root) %{_unitdir}/%{name}.service
%attr(744,xroad,xroad) %{jlib}/%{name}.jar
%attr(744,xroad-catalog,xroad-catalog) /usr/share/xroad/xroad-e2e-client/simple_monitor.pl
%attr(744,xroad-catalog,xroad-catalog) /usr/share/xroad/xroad-e2e-client/report.pl
%attr(644,xroad-catalog,xroad-catalog) /usr/share/xroad/xroad-e2e-client/LICENSE
%attr(644,xroad-catalog,xroad-catalog) /usr/share/xroad/xroad-e2e-client/README.md

%pre

%post

%changelog

