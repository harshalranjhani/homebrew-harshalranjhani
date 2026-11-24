# typed: false
# frozen_string_literal: true

# Written by the daemon release workflow. Don't edit: the next release replaces it.
class Handybox < Formula
  desc "Connect a Linux server to Handybox as your own box"
  homepage "https://handybox.cloud"
  version "0.1.0"
  license :cannot_represent

  PUBLIC_KEY = "RWSHAPpzFuRqT8HiJahooV0GMPeedA6SyRANSdPOHyMVAM/x6ZtEU9OT".freeze

  depends_on "minisign" => :build
  depends_on :linux

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.1.0/handybox-daemon-linux-arm64"
      sha256 "698b15adc3f79bf7df338c1f26da498098f8f3bb875fc5ee13cc799ca73be910"
    else
      url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.1.0/handybox-daemon-linux-amd64"
      sha256 "e71ec5dc31efeaaee16cb284c15c47a08624b2c086b06095336a609177e95a01"
    end
  end

  resource "signature-amd64" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.1.0/handybox-daemon-linux-amd64.minisig"
    sha256 "524396ce4742bf4a53f6031e6fc00c752140cb5cd00a36959e9c453c596053db"
  end

  resource "signature-arm64" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.1.0/handybox-daemon-linux-arm64.minisig"
    sha256 "0c357322be5971f5280582d2cacdd031e8fe6c104e3a29ad95be493c43b6b3af"
  end

  resource "installer" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.1.0/install.sh"
    sha256 "c600420bd7c486e03dfe9fa435d0c7a06503993d282748a86709af5811d06bb0"
  end

  resource "installer-signature" do
    url "https://github.com/harshalranjhani/handybox-releases/releases/download/daemon-v0.1.0/install.sh.minisig"
    sha256 "25f3639f944f43a0d25a7e79f7e0bc756ff7f8070d3558660afa2d9913f3a439"
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
