
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

    "open-iscsi", "lsscsi",  "sg3-utils",  "multipath-tools", "scsitools",

    "nfs-common",
    "xfsprogs",
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
        source = "deb https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /"
        key    = <<EOT
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2.0.15 (GNU/Linux)

mQENBGMHoXcBCADukGOEQyleViOgtkMVa7hKifP6POCTh+98xNW4TfHK/nBJN2sm
u4XaiUmtB9UuGt9jl8VxQg4hOMRf40coIwHsNwtSrc2R9v5Kgpvcv537QVIigVHH
WMNvXeoZkkoDIUljvbCEDWaEhS9R5OMYKd4AaJ+f1c8OELhEcV2dAQLLyjtnEaF/
qmREN+3Y9+5VcRZvQHeyBxCG+hdUGE740ixgnY2gSqZ/J4YeQntQ6pMUEhT6pbaE
10q2HUierj/im0V+ZUdCh46Lk/Rdfa5ZKlqYOiA2iN1coDPIdyqKavcdfPqSraKF
Lan2KLcZcgTxP+0+HfzKefvGEnZa11civbe9ABEBAAG0PmlzdjprdWJlcm5ldGVz
IE9CUyBQcm9qZWN0IDxpc3Y6a3ViZXJuZXRlc0BidWlsZC5vcGVuc3VzZS5vcmc+
iQE+BBMBCAAoBQJjB6F3AhsDBQkEHrAABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIX
gAAKCRAjRlTamilkNhnRCADud9iv+2CUtJGyZhhdzzd55wRKvHGmSY4eIAEKChmf
1+BHwFnzBzbdNtnglY2xSATqKIWikzXI1stAwi8qR0dK32CS+ofMS6OUklm26Yd1
jBWFg4LCCh8S21GLcuudHtW9QNCCjlByS4gyEJ+eYTOo2dWp88NWEzVXIKRtfLHV
myHJnt2QLmWOeYTgmCzpeT8onl2Lp19bryRGla+Ms0AmlCltPn8j+hPeADDtR2bv
7cTLDi/nA46u3SLV1P6yjC1ejOOswtgxppTxvLgYniS22aSnoqm47l111zZiZKJ5
bCm1Th6qJFJwOrGEOu3aV1iKaQmN2k4G2DixsHFAU3ZeiQIcBBMBAgAGBQJjB6F3
AAoJEM8Lkoze1k873TQP/0t2F/jltLRQMG7VCLw7+ps5JCW5FIqu/S2i9gSdNA0E
42u+LyxjG3YxmVoVRMsxeu4kErxr8bLcA4p71W/nKeqwF9VLuXKirsBC7z2syFiL
Ndl0ARnC3ENwuMVlSCwJO0MM5NiJuLOqOGYyD1XzSfnCzkXN0JGA/bfPRS5mPfoW
0OHIRZFhqE7ED6wyWpHIKT8rXkESFwszUwW/D7o1HagX7+duLt8WkrohGbxTJ215
YanOKSqyKd+6YGzDNUoGuMNPZJ5wTrThOkTzEFZ4HjmQ16w5xmcUISnCZd4nhsbS
qN/UyV9Vu3lnkautS15E4CcjP1RRzSkT0jka62vPtAzw+PiGryM1F7svuRaEnJD5
GXzj9RCUaR6vtFVvqqo4fvbA99k4XXj+dFAXW0TRZ/g2QMePW9cdWielcr+vHF4Z
2EnsAmdvF7r5e2JCOU3N8OUodebU6ws4VgRVG9gptQgfMR0vciBbNDG2Xuk1WDk1
qtscbfm5FVL36o7dkjA0x+TYCtqZIr4x3mmfAYFUqzxpfyXbSHqUJR2CoWxlyz72
XnJ7UEo/0UbgzGzscxLPDyJHMM5Dn/Ni9FVTVKlALHnFOYYSTluoYACF1DMt7NJ3
oyA0MELL0JQzEinixqxpZ1taOmVR/8pQVrqstqwqsp3RABaeZ80JbigUC29zJUVf
=F4EX
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