Summary: AAA PKSC11 libraries
Name: aaa-pkcs11
Version: 1.0.0
Release: 1%{?dist}
License: MIT
Group: Applications/System
Source0: /opt/aaa/lib/engines/pkcs11.so
BuildArch: noarch
BuildRoot: /opt/aaa
Packager: OpenAAA
%define optdir /opt/aaa/lib/engines
%description AAA PKCS11 libraries
%prep

%build

%install
install -d ${RPM_BUILD_ROOT}%{optdir}
install -m 644 %{SOURCE0} ${RPM_BUILD_ROOT}%{optdir}

%clean
rm -rf $RPM_BUILD_ROOT

%post

%files
%{optdir}/pkcs11.so
