# typed: false
# frozen_string_literal: true

# Written by the daemon release workflow. Don't edit: the next release replaces it.
class Handybox < Formula
  desc "Connect a Linux server to Handybox as your own box"
  homepage "https://handybox.cloud"
  version "0.2.1"
  license :cannot_represent

  PUBLIC_KEY = "RWSHAPpzFuRqT8HiJahooV0GMPeedA6SyRANSdPOHyMVAM/x6ZtEU9OT".freeze

  depends_on "minisign" => :build
  depends_on :linux

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.2.1/handybox-daemon-linux-arm64"
      sha256 "8dff41cc704bd614e2ff24bbda2777e83ff541bcd9c7a716bfc24d84996b7d44"
    else
      url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.2.1/handybox-daemon-linux-amd64"
      sha256 "f5b2a825a5d025c54edcdf39eeea4f86c33618e5542a60caec2033ab8ea7d4e1"
    end
  end

  resource "signature-amd64" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.2.1/handybox-daemon-linux-amd64.minisig"
    sha256 "62351bfd6e60c2c64aeace3b9c1890aadc80a9e1f9226eed87440af3b9754762"
  end

  resource "signature-arm64" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.2.1/handybox-daemon-linux-arm64.minisig"
    sha256 "3d66f8ea37543d6e96729cd314857e8de9db3f44685239d37e7bd47c5cff94c1"
  end

  resource "installer" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.2.1/install.sh"
    sha256 "85f9d90d1205075f96f1904da65ae0811fed2504988bf482a153eb2cb64216db"
  end

  resource "installer-signature" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.2.1/install.sh.minisig"
    sha256 "57a1638648ecf44b9cbebb5767df91f8b16d7782d2ff4ad7487d41391841d534"
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    binary = "handybox-daemon-linux-#{arch}"
    resource("signature-#{arch}").stage { buildpath.install "#{binary}.minisig" }
    resource("installer").stage { buildpath.install "install.sh" }
    resource("installer-signature").stage { buildpath.install "install.sh.minisig" }
    minisign = Formula["minisign"].opt_bin/"minisign"
    system minisign, "-V", "-q", "-P", PUBLIC_KEY, "-m", binary, "-x", "#{binary}.minisig"
    system minisign, "-V", "-q", "-P", PUBLIC_KEY, "-m", "install.sh", "-x", "install.sh.minisig"
    chmod 0755, [binary, "install.sh"]
    inreplace "install.sh", /^BUNDLED_BINARY=.*$/, "BUNDLED_BINARY='#{opt_libexec}/handybox-daemon'"
    libexec.install binary => "handybox-daemon"
    bin.install "install.sh" => "handybox"
  end

  test do
    assert_match "handybox #{version}", shell_output("#{bin}/handybox --version")
  end
end
