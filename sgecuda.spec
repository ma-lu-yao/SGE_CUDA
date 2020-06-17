Name:           sgecuda
Version:        0.6
Release:        1%{?dist}
Summary:        Gridengine Database check for CUDA_DEVICES
Group:          Applications/Engineering
License:        GPLv3
URL:            http://www.huanglab.org.cn
Source0:        %{name}-%{version}.tar.gz
Requires:	gridengine
BuildArch:	noarch
BuildRoot:      %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

%description
Setting and Checking CUDA_INVISIBLE_DEVICE  environment variable for gridengine system

%package execd
Summary:        Gridengine Database check for CUDA_DEVICES (Gridegine Exec host Version)
Group:          Applications/Engineering
Requires:	elinks, gridengine-execd
%description execd
Sgecuda on gridengine exec host

%package qmaster
Summary:        Gridengine Database check for CUDA_DEVICES(Gridegine Master host Version)
Group:          Applications/Engineering
Requires:	mariadb-server, mariadb, httpd, php, php-mysql gridengine-qmaster
%description qmaster
Setting and Checking CUDA_INVISIBLE_DEVICE  environment variable for gridengine system

%prep
%setup -q

%build
echo nothing to do

%install
%{__mkdir} -p $RPM_BUILD_ROOT/run/sgecuda
%{__mkdir} -p $RPM_BUILD_ROOT%{_unitdir}
%{__mkdir} -p $RPM_BUILD_ROOT%{_sysconfdir}/sysconfig
%{__mkdir} -p $RPM_BUILD_ROOT%{_bindir}
%{__mkdir} -p $RPM_BUILD_ROOT%{_datadir}/%{name}/html
%{__mkdir} -p $RPM_BUILD_ROOT%{_sbindir}
%{__mkdir} -p $RPM_BUILD_ROOT%{_sysconfdir}/httpd/conf.d

install -m 0755 startcuda.sh    $RPM_BUILD_ROOT%{_bindir}
install -m 0755 end_cuda.sh     $RPM_BUILD_ROOT%{_bindir}
install -m 0750 sgecuda.sh      $RPM_BUILD_ROOT%{_sbindir}
#install -m 0755 filldata.sh     $RPM_BUILD_ROOT%{_datadir}/%{name}
install -m 0755 generate_SQL.sh $RPM_BUILD_ROOT%{_datadir}/%{name}
install -m 0640 index.php       $RPM_BUILD_ROOT%{_datadir}/%{name}
install -m 0644 %{name}.conf    $RPM_BUILD_ROOT%{_sysconfdir}/httpd/conf.d
install -m 0644 sgecuda.service $RPM_BUILD_ROOT%{_unitdir}


%files execd
%defattr(-,root,root,-)
%{_bindir}/*.sh

%files qmaster
%defattr(-,root,root,-)
%config(noreplace) %{_sysconfdir}/httpd/conf.d/sgecuda.conf
%{_sbindir}/sgecuda.sh
%dir /run/sgecuda
%doc README.txt
%{_datadir}/%{name}/*
%attr(0640,apache,apache) %{_datadir}/%{name}/index.php
%{_unitdir}/*


