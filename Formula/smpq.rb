class Smpq < Formula
  desc "StormLib MPQ archiving utility"
  homepage "https://launchpad.net/smpq"
  url "https://launchpad.net/smpq/trunk/1.6/+download/smpq_1.6.orig.tar.gz"
  sha256 "b5d2dc8a5de8629b71ee5d3612b6e84d88418b86c5cd39ba315e9eb0462f18cb"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?smpq[._-](\d+(?:\.\d+)+)[._-]orig/i)
  end

  depends_on "cmake" => :build
  depends_on "stormlib"

  # Patch to allow compilation on macOS
  patch :p1, <<~EOS
    From 9b8bec8729c0651b2ef20e33bd1972ae00b832e0 Mon Sep 17 00:00:00 2001
    From: Kreeblah <kreeblah@gmail.com>
    Date: Sat, 15 Jan 2022 13:50:35 -0800
    Subject: [PATCH] Patch to build on macOS

    ---
     common.h | 4 ++++
     remove.c | 4 ++++
     2 files changed, 8 insertions(+)

    diff --git a/common.h b/common.h
    index f8ef79294ca80f488094c8d5f19416e86b675d2b..840938d7fb776020029411645b754a423f455720 100644
    --- a/common.h
    +++ b/common.h
    @@ -26,6 +26,10 @@
     #define inline __inline__
     #endif

    +#if defined(__APPLE__) && defined(__MACH__)
    +#include <stdio.h>
    +#endif
    +
     /*********
      * Flags *
      *********/
    diff --git a/remove.c b/remove.c
    index 4fcc1142657e1468d774b1fcd2a7f86a93169285..303ae02836837c32e79d35498d9044d72e53c014 100644
    --- a/remove.c
    +++ b/remove.c
    @@ -19,6 +19,10 @@

     #include <StormLib.h>

    +#if defined(__APPLE__) && defined(__MACH__)
    +#include <string.h>
    +#endif
    +
     #include "common.h"

     int smpq_remove(const char * archive, const char * const files[], unsigned int flags, const char * listfile, unsigned int locale) {
  EOS

  def install
    system "cmake", "-S", ".", "-B", "builddir",
                      "-DWITH_KDE=OFF",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    output_smpq = shell_output("#{bin}/smpq --help 2>&1")
    assert_match "StormLib MPQ archiving utility, version #{version}", output_smpq
  end
end