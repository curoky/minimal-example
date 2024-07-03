#
# Copyright (c) 2018-2024 curoky(cccuroky@gmail.com).
#
# This file is part of minimal-example.
# See https://github.com/curoky/minimal-example for further info.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This formula tracks 1.0.2 branch of OpenSSL, not the 1.1.0 branch. Due to
# significant breaking API changes in 1.1.0 other formulae will be migrated
# across slowly, so core will ship `openssl` & `openssl@1.1` for foreseeable.
class OpensslAT102u < Formula
  desc 'SSL/TLS cryptography library'
  homepage 'https://openssl.org/'
  url 'https://github.com/openssl/openssl/archive/OpenSSL_1_0_2u.tar.gz'
  sha256 '82fa58e3f273c53128c6fe7e3635ec8cda1319a10ce1ad50a987c3df0deeef05'

  keg_only :versioned_formula

  depends_on :linux
  depends_on 'gcc@11' => :build
  depends_on 'xz'

  def install
    ENV['CC'] = Formula['gcc@11'].opt_bin / 'gcc-11'
    ENV['CXX'] = Formula['gcc@11'].opt_bin / 'g++-11'
    # OpenSSL will prefer the PERL environment variable if set over $PATH
    # which can cause some odd edge cases & isn't intended. Unset for safety,
    # along with perl modules in PERL5LIB.
    ENV.delete('PERL')
    ENV.delete('PERL5LIB')
    ENV.append 'LDFLAGS', "-L#{buildpath}"

    ENV.deparallelize
    args = %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      shared zlib
    ]

    system './config', *args
    system 'make'
    system 'make', 'install', "MANDIR=#{man}", 'MANSUFFIX=ssl'
  end

  def openssldir
    etc / 'openssl'
  end

  def caveats
    <<~EOS
      A CA file has been bootstrapped using certificates from the SystemRoots
      keychain. To add additional certificates (e.g. the certificates added in
      the System keychain), place .pem files in
        #{openssldir}/certs
      and run
        #{opt_bin}/c_rehash
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate HOMEBREW_PREFIX / 'etc/openssl/openssl.cnf', :exist?,
                     'OpenSSL requires the .cnf file for some functionality'

    # Check OpenSSL itself functions as expected.
    (testpath / 'testfile.txt').write('This is a test file')
    expected_checksum = 'e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249'
    system "#{bin}/openssl", 'dgst', '-sha256', '-out', 'checksum.txt', 'testfile.txt'
    open('checksum.txt') do |f|
      checksum = f.read(100).split('=').last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
