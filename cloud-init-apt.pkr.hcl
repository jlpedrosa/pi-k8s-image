
locals {
  packages = [
    "apt-transport-https",
    "ca-certificates",
    "curl",
    "gnupg",
    "lsb-release",

    "libraspberrypi-bin",
    "linux-headers-raspi",
    "linux-image-raspi",
    "linux-firmware-raspi",
    "linux-raspi",
    "linux-modules-extra-raspi",
    "linux-tools-raspi",
    "pibootctl",
    "raspi-config",
    "rpiboot",
    "rpi-eeprom",
    "ubuntu-raspi-settings",
    "ubuntu-server-raspi",
    "u-boot-rpi",
  ]
}

locals {
  apt = {
    conf = <<EOT
APT {
  Get {
    Assume-Yes "true";
    Fix-Broken "true";
  };
};
EOT
    sources = {
      "kubernetes.list" = {
        source = "deb https://apt.kubernetes.io/ kubernetes-xenial main"
        key    = <<EOT
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
=UL8X
-----END PGP PUBLIC KEY BLOCK-----
EOT
      }
      "libcontainers.list" = {
        source = "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_22.04/ /"
        key    = <<EOT
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.5 (GNU/Linux)

mQENBFtkV0cBCADStSTCG5qgYtzmWfymHZqxxhfwfS6fdHJcbGUeXsI5dxjeCWhs
XarZm6rWZOd5WfSmpXhbKOyM6Ll+6bpSl5ICHLa6fcpizYWEPa8fpg9EGl0cF12G
GgVLnnOZ6NIbsoW0LHt2YN0jn8xKVwyPp7KLHB2paZh+KuURERG406GXY/DgCxUx
Ffgdelym/gfmt3DSq6GAQRRGHyucMvPYm53r+jVcKsf2Bp6E1XAfqBrD5r0maaCU
Wvd7bi0B2Q0hIX0rfDCBpl4rFqvyaMPgn+Bkl6IW37zCkWIXqf1E5eDm/XzP881s
+yAvi+JfDwt7AE+Hd2dSf273o3WUdYJGRwyZABEBAAG0OGRldmVsOmt1YmljIE9C
UyBQcm9qZWN0IDxkZXZlbDprdWJpY0BidWlsZC5vcGVuc3VzZS5vcmc+iQE+BBMB
CAAoBQJjkECIAhsDBQkMSplBBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRBN
ZDkDdQYKpPVfCACZNU7GNUKkTWQMsnefRe3x8xq7MXKYO8DC5rt1fVKQEbRl41Jo
bMGMUyfCM4piB6feo8pENmSGLwSltZfXj4iWfwaOvk3vRGzLs2LJn2u9qIp9m9pK
Dl7DqfOXFWv/7gnjKsZM0faioGZB75hQKFlD11KJNm20wo1jlP+Km8aaT/wVhN6i
5ilLh9L7E5iTskCYTBGwmxJV6LlXkGPytVQ+86bmMWVMPJ1yZCb9scIPGxDNoLxx
eefYEeaj4L4GoY28LiYPDjPT8crmBKJyV6EHaa5XijaQFRGqov9CWch4lctGMEvY
TU2bkgXxhfhvJnOzdDDQEPIOc8R3DVeyL8dxiEYEExECAAYFAltkV0cACgkQOzAR
t2udZSOoswCdF44NTN09DwhPFbNYhEMb9juP5ykAn0bcELvuKmgDwEwZMrPQkG8t
Pu9n
=YclD
-----END PGP PUBLIC KEY BLOCK-----
EOT
      }
      "libcontainers.crio.list" = {
        source = "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.27/xUbuntu_22.04/ /"
        key    = <<EOT
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.5 (GNU/Linux)

mQENBFtkV0cBCADStSTCG5qgYtzmWfymHZqxxhfwfS6fdHJcbGUeXsI5dxjeCWhs
XarZm6rWZOd5WfSmpXhbKOyM6Ll+6bpSl5ICHLa6fcpizYWEPa8fpg9EGl0cF12G
GgVLnnOZ6NIbsoW0LHt2YN0jn8xKVwyPp7KLHB2paZh+KuURERG406GXY/DgCxUx
Ffgdelym/gfmt3DSq6GAQRRGHyucMvPYm53r+jVcKsf2Bp6E1XAfqBrD5r0maaCU
Wvd7bi0B2Q0hIX0rfDCBpl4rFqvyaMPgn+Bkl6IW37zCkWIXqf1E5eDm/XzP881s
+yAvi+JfDwt7AE+Hd2dSf273o3WUdYJGRwyZABEBAAG0OGRldmVsOmt1YmljIE9C
UyBQcm9qZWN0IDxkZXZlbDprdWJpY0BidWlsZC5vcGVuc3VzZS5vcmc+iQE+BBMB
CAAoBQJjkECIAhsDBQkMSplBBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRBN
ZDkDdQYKpPVfCACZNU7GNUKkTWQMsnefRe3x8xq7MXKYO8DC5rt1fVKQEbRl41Jo
bMGMUyfCM4piB6feo8pENmSGLwSltZfXj4iWfwaOvk3vRGzLs2LJn2u9qIp9m9pK
Dl7DqfOXFWv/7gnjKsZM0faioGZB75hQKFlD11KJNm20wo1jlP+Km8aaT/wVhN6i
5ilLh9L7E5iTskCYTBGwmxJV6LlXkGPytVQ+86bmMWVMPJ1yZCb9scIPGxDNoLxx
eefYEeaj4L4GoY28LiYPDjPT8crmBKJyV6EHaa5XijaQFRGqov9CWch4lctGMEvY
TU2bkgXxhfhvJnOzdDDQEPIOc8R3DVeyL8dxiEYEExECAAYFAltkV0cACgkQOzAR
t2udZSOoswCdF44NTN09DwhPFbNYhEMb9juP5ykAn0bcELvuKmgDwEwZMrPQkG8t
Pu9n
=YclD
-----END PGP PUBLIC KEY BLOCK-----
EOT
      }
      "helm.list" = {
        source = "deb [arch=arm64] https://baltocdn.com/helm/stable/debian/ all main"
        key    = <<EOT
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQINBF6yP7IBEADWk4aijQ7Vhj7wn2oz+8asnfzsD0+257qjWy1m+cN4RP6T2NBG
S2M5+vzbsKNmGAja8jOpo46pHo/SCdc8Bwv+QHH+JbuBbDNEHwIBGV5p+ZRETiHq
l8UsyUAPCWinKR6evZrANCBEzXtOEVJ4thuPoBuZkteKNTdPlOg9MBqD5zz+4iQX
2CJJNW7+1sxAAVozHJxjJbu6c84yPvNFAiCAct+x5WJZFJWuO+l55vl6va8cV7tw
DgHomk+1Q7w00Z0gh28Pe1yfvvw3N+pCSYn88mSgZtdP3wz3pABkMe4wMobNWuyX
bIjGMuFDs7vGBY6UCL6alI/VC7rrSZqJZjntuoNI0Xlfc3BjUHWzinlbA7UFk5Lv
qZO61V439Wm4x2n1V+4Kj/nPwtgBrNghaeDjxWLlgqaqynltSpXYnv2qGWYLRUb9
WFymbYCJ0piqRdNVNNI8Ht9nFaya6qjDcIxFwFMF9QcrECG1HCK1M5JjdJpzr6Jq
Z27/2ZG7DhabArSR5aoyBqhCylJfXugneDhitmilJiQd5EzefjiDO29EuBSMwkAs
+IKg9jxGyI47m3+ITWhMDWTFTYBF/O69iKXfFvf4zrbfGMcf2w8vIOEBU3eTSYoY
RhHXROedwcYpaVGJmsaT38QTSMqWTn12zlvmW5f6mEI5LQq398gN9eiWDwARAQAB
tERIZWxtIGhvc3RlZCBieSBCYWx0byAoUmVwb3NpdG9yeSBzaWduaW5nKSA8Z3Bn
c2VjdXJpdHlAZ2V0YmFsdG8uY29tPokCVAQTAQoAPhYhBIG/gy4vGc0qoEcZWSlK
xIJ8GhaKBQJesj+yAhsvBQkSzAMABQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJ
EClKxIJ8GhaKPHEP/RRzvYCetoLeIj5FtedbeumGcWaJj97L4R1j7iK0dc0uvg0T
5JeMDttAt69dFPHyB0kR1BLSwgJBhYCtvwalvD/g7DmL5l5HIM7o/VrkXDay1Pee
wkCclA18y2wNM5EXKAuoFX5FMkRpTtSQhMMllbKsNNSvwvEZWvqMQlwJ/2HgNoVl
2NtfY65UXHvIV2nTTmCVDq4OYBlHoUX5rRE7fOgFZ+u6Su7yopTYy13yY8ZVDNf/
qNUWqA41gRYnwYtSq1DogHq1dcyr/SW/pFsn4n4LjG+38CIkSjFKOeusg2KPybZx
l/z0/l0Yv4pTaa91rh1hGWqhvYDbLr2XqvI1wpcsIRPpU8lasycyQ8EeI4B5FVel
ea2Z6rvGtMG92wVNCZ6YMYzpvRA9iRgve4J4ztlCwr0Tm78vY/vZfU5jkPW1VOXJ
6nW/RJuc2mecuj8YpJtioNVPbfxE/CjCCnGEnqn511ZYqKGd+BctqoFlWeSihHst
tuSqJoqjOmt75MuN6zUJ0s3Ao+tzCmYkQzn2LUwnYisioyTW4gMtlh/wsU6Rmims
s5doyG2Mcc0QfstXLMthVkrBpbW4XT+Q6aTGUMlMv1BhKycDUmewI2AMNth5Hood
iEt18+X26+Q2exojaMHOCdkUJ+C44XPDy6EvG4RyO4bILHz5obD/9QZO/lzK
=BFdd
-----END PGP PUBLIC KEY BLOCK-----
EOT
      }
    }
  }
}